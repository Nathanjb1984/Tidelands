# conflict_screen.gd — Full UI for the Conflict Vertical-Slice Prototype
# TIDELINES: Cedar, Sea & Legacy
#
# Builds the entire conflict UI programmatically, connects to the
# ConflictFlowController, and handles player input.  Attach to the
# root Control node of the conflict_prototype scene.

extends Control

# ============================================================
# PALETTE  (SNES-era warm palette)
# ============================================================

const COL_BG          := Color(0.04, 0.04, 0.10)     # deep-night blue
const COL_PANEL       := Color(0.07, 0.07, 0.16)     # slightly lighter panel
const COL_TEXT        := Color(0.91, 0.86, 0.78)      # warm parchment
const COL_DIM         := Color(0.50, 0.48, 0.44)      # faded text
const COL_GOLD        := Color(0.77, 0.63, 0.0)       # phase-header gold
const COL_CEDAR       := Color(0.55, 0.15, 0.0)       # cedar-red accent
const COL_BTN         := Color(0.10, 0.23, 0.23)      # dark teal button
const COL_BTN_HOVER   := Color(0.14, 0.34, 0.34)      # hover
const COL_BTN_TEXT    := Color(0.85, 0.82, 0.75)      # button label
const COL_DEBUG       := Color(0.0, 0.80, 0.40)       # green terminal
const COL_DAMAGE      := Color(0.80, 0.20, 0.0)       # damage red-orange
const COL_VICTORY     := Color(0.25, 0.75, 0.15)      # victory green
const COL_DEFEAT      := Color(0.75, 0.15, 0.10)      # defeat red

# ============================================================
# NODE REFERENCES (built in _ready)
# ============================================================

var flow: ConflictFlowController
var debug_panel: Control  # src/ui/debug_panel.gd instance
var legacy_log: Control   # src/ui/legacy_log.gd instance

# UI pieces
var _title_label: Label
var _status_bar: HBoxContainer
var _morale_label: Label
var _crew_label: Label
var _canoe_label: Label
var _phase_label: Label
var _phase_title: Label
var _narrative_scroll: ScrollContainer
var _narrative_vbox: VBoxContainer
var _choice_prompt: Label
var _choice_scroll: ScrollContainer
var _choice_vbox: VBoxContainer
var _continue_btn: Button
var _flow_selector: VBoxContainer
var _content_split: HSplitContainer
var _left_panel: VBoxContainer
var _right_panel: VBoxContainer
var _debug_toggle_btn: Button

# ============================================================
# SETUP
# ============================================================

func _ready() -> void:
	# Build entire UI tree
	_build_ui()

	# Create flow controller as a child node
	flow = ConflictFlowController.new()
	flow.name = "FlowController"
	add_child(flow)

	# Connect signals
	flow.phase_started.connect(_on_phase_started)
	flow.narrative_shown.connect(_on_narrative)
	flow.choices_ready.connect(_on_choices)
	flow.sub_choice_ready.connect(_on_sub_choice)
	flow.intel_report.connect(_on_intel)
	flow.intimidation_report.connect(_on_intimidation)
	flow.round_narrated.connect(_on_round)
	flow.outcome_announced.connect(_on_outcome)
	flow.aftermath_report.connect(_on_aftermath)
	flow.flow_complete.connect(_on_complete)
	flow.debug_snapshot.connect(_on_debug)
	flow.status_changed.connect(_on_status)

	# Show the flow selector
	_show_flow_selector()

# ============================================================
# UI CONSTRUCTION
# ============================================================

func _build_ui() -> void:
	# Root sizing
	anchor_right = 1.0
	anchor_bottom = 1.0

	# Background
	var bg := ColorRect.new()
	bg.color = COL_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Main margin
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var main_vbox := VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(main_vbox)

	# ---- TITLE BAR ----
	var title_bar := HBoxContainer.new()
	title_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(title_bar)

	_title_label = _make_label("TIDELINES — Conflict Prototype", 20, COL_GOLD)
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_bar.add_child(_title_label)

	_debug_toggle_btn = _make_button("☰ Debug", COL_BTN, COL_BTN_TEXT)
	_debug_toggle_btn.custom_minimum_size.x = 100
	_debug_toggle_btn.pressed.connect(_toggle_debug)
	title_bar.add_child(_debug_toggle_btn)

	# ---- STATUS BAR ----
	_status_bar = HBoxContainer.new()
	_status_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_status_bar.add_theme_constant_override("separation", 24)
	main_vbox.add_child(_status_bar)

	var sep_line := HSeparator.new()
	sep_line.modulate = COL_DIM
	main_vbox.add_child(sep_line)

	_morale_label = _make_label("♥ Morale: --", 14, COL_TEXT)
	_crew_label = _make_label("⚔ Crew: --", 14, COL_TEXT)
	_canoe_label = _make_label("🛶 Canoe: --", 14, COL_TEXT)
	_phase_label = _make_label("Phase: —", 14, COL_GOLD)
	_status_bar.add_child(_morale_label)
	_status_bar.add_child(_crew_label)
	_status_bar.add_child(_canoe_label)
	_status_bar.add_child(_phase_label)
	_status_bar.visible = false

	# ---- CONTENT SPLIT ----
	_content_split = HSplitContainer.new()
	_content_split.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_content_split.split_offset = -320
	main_vbox.add_child(_content_split)

	# == LEFT PANEL (narrative + choices) ==
	_left_panel = VBoxContainer.new()
	_left_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_left_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_left_panel.size_flags_stretch_ratio = 2.0
	_content_split.add_child(_left_panel)

	_phase_title = _make_label("", 18, COL_GOLD)
	_left_panel.add_child(_phase_title)

	_narrative_scroll = ScrollContainer.new()
	_narrative_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_narrative_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_narrative_scroll.size_flags_stretch_ratio = 3.0
	_left_panel.add_child(_narrative_scroll)

	_narrative_vbox = VBoxContainer.new()
	_narrative_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_narrative_scroll.add_child(_narrative_vbox)

	var choice_sep := HSeparator.new()
	choice_sep.modulate = COL_DIM
	_left_panel.add_child(choice_sep)

	_choice_prompt = _make_label("", 14, COL_DIM)
	_left_panel.add_child(_choice_prompt)

	_choice_scroll = ScrollContainer.new()
	_choice_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_choice_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_choice_scroll.size_flags_stretch_ratio = 1.0
	_left_panel.add_child(_choice_scroll)

	_choice_vbox = VBoxContainer.new()
	_choice_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_choice_vbox.add_theme_constant_override("separation", 6)
	_choice_scroll.add_child(_choice_vbox)

	_continue_btn = _make_button("▸ Continue", COL_CEDAR, COL_TEXT)
	_continue_btn.visible = false
	_continue_btn.pressed.connect(_on_continue)
	_left_panel.add_child(_continue_btn)

	# == RIGHT PANEL (debug + legacy) ==
	_right_panel = VBoxContainer.new()
	_right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_right_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_right_panel.size_flags_stretch_ratio = 1.0
	_content_split.add_child(_right_panel)

	# Instantiate debug panel
	var DebugPanelScript := preload("res://src/ui/debug_panel.gd")
	debug_panel = DebugPanelScript.new()
	debug_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	debug_panel.size_flags_stretch_ratio = 1.0
	_right_panel.add_child(debug_panel)

	# Instantiate legacy log
	var LegacyLogScript := preload("res://src/ui/legacy_log.gd")
	legacy_log = LegacyLogScript.new()
	legacy_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	legacy_log.size_flags_stretch_ratio = 1.0
	_right_panel.add_child(legacy_log)

	# ---- FLOW SELECTOR  (visible on start) ----
	_flow_selector = VBoxContainer.new()
	_flow_selector.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_flow_selector.alignment = BoxContainer.ALIGNMENT_CENTER
	_flow_selector.add_theme_constant_override("separation", 16)
	_left_panel.add_child(_flow_selector)

func _show_flow_selector() -> void:
	# Hide gameplay UI
	_phase_title.visible = false
	_narrative_scroll.visible = false
	_choice_prompt.visible = false
	_choice_scroll.visible = false
	_continue_btn.visible = false
	_status_bar.visible = false
	_flow_selector.visible = true

	# Clear old selector content
	for c in _flow_selector.get_children():
		c.queue_free()

	var header := _make_label("Choose a Conflict Flow", 22, COL_GOLD)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_flow_selector.add_child(header)

	var desc := _make_label(
		"Experience the full 6-phase conflict system.\n" +
		"Offensive: 'The Raid on Cedar Creek' — you lead a raiding party.\n" +
		"Defensive: 'The Dawn Attack' — your village is under attack.",
		14, COL_TEXT)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	_flow_selector.add_child(desc)

	var btn_row := HBoxContainer.new()
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_row.add_theme_constant_override("separation", 24)
	_flow_selector.add_child(btn_row)

	var off_btn := _make_button("⚔  Offensive Raid", COL_CEDAR, COL_TEXT)
	off_btn.custom_minimum_size = Vector2(220, 48)
	off_btn.pressed.connect(func(): _start_flow("offensive"))
	btn_row.add_child(off_btn)

	var def_btn := _make_button("🛡  Defend Village", COL_BTN, COL_TEXT)
	def_btn.custom_minimum_size = Vector2(220, 48)
	def_btn.pressed.connect(func(): _start_flow("defensive"))
	btn_row.add_child(def_btn)

func _start_flow(flow_type: String) -> void:
	_flow_selector.visible = false
	_phase_title.visible = true
	_narrative_scroll.visible = true
	_choice_prompt.visible = true
	_choice_scroll.visible = true
	_status_bar.visible = true
	_clear_narrative()
	_clear_choices()
	flow.start_flow(flow_type)

# ============================================================
# SIGNAL HANDLERS
# ============================================================

func _on_phase_started(phase_data: Dictionary, _status: Dictionary) -> void:
	var pid: String = phase_data.get("phase", "?")
	var title: String = phase_data.get("title", pid.replace("_", " ").capitalize())
	_phase_title.text = "► %s" % title
	_phase_label.text = "Phase: %s" % pid.get_slice("_", 1).capitalize() if "_" in pid else pid
	_clear_narrative()
	_clear_choices()
	_continue_btn.visible = false

func _on_narrative(text: String) -> void:
	_append_narrative(text, COL_TEXT)
	_auto_scroll_narrative()

func _on_choices(choices: Array, prompt: String) -> void:
	_clear_choices()
	_choice_prompt.text = prompt
	_choice_prompt.visible = true
	for c in choices:
		_add_choice_button(c)

func _on_sub_choice(sub_key: String, prompt: String, options: Array) -> void:
	_clear_choices()
	_choice_prompt.text = "%s (%s)" % [prompt, sub_key.replace("_", " ").capitalize()]
	_choice_prompt.visible = true
	for opt in options:
		var btn := _make_choice_button_from_sub(sub_key, opt)
		_choice_vbox.add_child(btn)

func _on_intel(intel: Dictionary) -> void:
	_append_narrative("— Intel Report —", COL_GOLD)
	for key in intel:
		_append_narrative("  %s: %s" % [key, str(intel[key])], COL_DIM)

func _on_intimidation(result: Dictionary) -> void:
	_append_narrative("— Intimidation Check —", COL_GOLD)
	_append_narrative("  Intimidation: %d  vs  Resolve: %d  (Δ %+d)" % [
		result.get("intimidation_score", 0),
		result.get("resolve_score", 0),
		result.get("delta", 0)
	], COL_DEBUG)
	var rid: String = result.get("result_id", "neutral")
	var col := COL_VICTORY if result.get("defender_fled", false) else COL_TEXT
	_append_narrative("  Result: %s" % rid.to_upper(), col)
	if result.get("defender_fled", false):
		_append_narrative("  The defenders flee!", COL_VICTORY)
	elif result.get("negotiation_offered", false):
		_append_narrative("  The defenders offer to negotiate.", COL_GOLD)

func _on_round(round_index: int, round_data: Dictionary) -> void:
	_append_narrative("", COL_TEXT)  # spacer
	var rname: String = round_data.get("name", "Round %d" % (round_index + 1))
	_append_narrative("⚔ %s" % rname, COL_GOLD)
	if round_data.has("narrative"):
		_append_narrative(round_data["narrative"], COL_TEXT)
	if round_data.has("atk") and round_data.has("def"):
		_append_narrative("  ATK: %.1f  DEF: %.1f" % [round_data["atk"], round_data["def"]], COL_DEBUG)
	if round_data.has("event"):
		var ev: Dictionary = round_data["event"]
		_append_narrative("  ✦ %s" % ev.get("text", ""), COL_CEDAR)

func _on_outcome(outcome: String, narrative: String) -> void:
	_append_narrative("", COL_TEXT)
	var col := COL_VICTORY if "VICTORY" in outcome else (COL_DEFEAT if "DEFEAT" in outcome else COL_GOLD)
	_append_narrative("════════════════════════════════", col)
	_append_narrative("  OUTCOME: %s" % outcome, col)
	_append_narrative("════════════════════════════════", col)
	if narrative != "":
		_append_narrative(narrative, COL_TEXT)

func _on_aftermath(aftermath: Dictionary) -> void:
	_append_narrative("", COL_TEXT)
	_append_narrative("— Aftermath —", COL_GOLD)
	var cas: Dictionary = aftermath.get("casualties", {})
	if cas.size() > 0:
		_append_narrative("  ☠ Killed: %d   Wounded: %d   Captured: %d" % [
			cas.get("killed", 0), cas.get("wounded", 0), cas.get("captured", 0)
		], COL_DAMAGE)
		if cas.get("canoe_damage", 0.0) > 0.1:
			_append_narrative("  🛶 Canoe damage: %d%%" % int(cas["canoe_damage"] * 100), COL_DAMAGE)
	if aftermath.get("spoils", []).size() > 0:
		var spoils_text := "  Spoils: "
		for s in aftermath["spoils"]:
			spoils_text += "%s ×%d  " % [s.get("resource", "?"), s.get("amount", 0)]
		_append_narrative(spoils_text, COL_VICTORY)
	_append_narrative("  Prestige: %+d" % aftermath.get("prestige_change", 0), COL_TEXT)
	_append_narrative("  Morale Δ: %+d" % aftermath.get("morale_delta", 0), COL_TEXT)
	if aftermath.get("song_created", false):
		_append_narrative("  ♫ A battle song was composed.", COL_GOLD)
	if aftermath.get("pole_opportunity", "") != "":
		_append_narrative("  🏔 Pole opportunity: %s" % aftermath["pole_opportunity"], COL_GOLD)
	if aftermath.get("retaliation_turns", 0) > 0:
		_append_narrative("  ⏳ Expect retaliation in %d turns." % aftermath["retaliation_turns"], COL_DAMAGE)

func _on_complete(final_state: Dictionary) -> void:
	_clear_choices()
	_choice_prompt.visible = false
	_append_narrative("", COL_TEXT)
	_append_narrative("══════════════════════════════════════", COL_GOLD)
	_append_narrative("       CONFLICT COMPLETE", COL_GOLD)
	_append_narrative("══════════════════════════════════════", COL_GOLD)

	# Log to legacy
	var entry: String = final_state.get("legacy_entry", "")
	if entry != "" and legacy_log.has_method("add_entry"):
		legacy_log.add_entry(entry)

	# Show return button
	_continue_btn.text = "▸ Return to Flow Selection"
	_continue_btn.visible = true
	_continue_btn.pressed.disconnect(_on_continue)
	_continue_btn.pressed.connect(_return_to_selector)

func _on_debug(data: Dictionary) -> void:
	if debug_panel and debug_panel.has_method("update_data"):
		debug_panel.update_data(data)

func _on_status(status: Dictionary) -> void:
	_morale_label.text = "♥ Morale: %d" % status.get("morale", 0)
	_crew_label.text = "⚔ Crew: %d" % status.get("crew_alive", 0)
	var dmg_pct := int(status.get("canoe_damage", 0.0) * 100)
	_canoe_label.text = "🛶 Canoe: %s" % ("OK" if dmg_pct < 10 else "%d%% damaged" % dmg_pct)
	if status.get("outcome", "") != "":
		_phase_label.text = "Outcome: %s" % status["outcome"]

	# Colour-code morale
	var m: int = status.get("morale", 50)
	if m <= 20:
		_morale_label.add_theme_color_override("font_color", COL_DAMAGE)
	elif m >= 70:
		_morale_label.add_theme_color_override("font_color", COL_VICTORY)
	else:
		_morale_label.add_theme_color_override("font_color", COL_TEXT)

# ============================================================
# CHOICE BUTTON BUILDERS
# ============================================================

func _add_choice_button(choice: Dictionary) -> void:
	var cid: String = choice.get("id", "")
	var label_text: String = choice.get("label", choice.get("id", "?"))
	var desc: String = choice.get("description", "")
	var risk: String = choice.get("risk", "")

	var btn := _make_button(label_text, COL_BTN, COL_BTN_TEXT)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.custom_minimum_size.y = 40
	btn.tooltip_text = desc if desc != "" else ""
	btn.pressed.connect(func(): _on_player_choice(cid))

	var row := VBoxContainer.new()
	row.add_child(btn)
	if desc != "":
		var d := _make_label("  " + desc, 12, COL_DIM)
		d.autowrap_mode = TextServer.AUTOWRAP_WORD
		row.add_child(d)
	if risk != "":
		var r := _make_label("  Risk: " + risk, 11, COL_DAMAGE)
		row.add_child(r)
	_choice_vbox.add_child(row)

func _make_choice_button_from_sub(sub_key: String, opt: Dictionary) -> VBoxContainer:
	var oid: String = opt.get("id", "")
	var label_text: String = opt.get("label", opt.get("id", "?"))
	var narr: String = opt.get("narrative", "")

	var btn := _make_button(label_text, COL_BTN, COL_BTN_TEXT)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.custom_minimum_size.y = 40
	btn.pressed.connect(func(): _on_player_sub_choice(sub_key, oid))

	var row := VBoxContainer.new()
	row.add_child(btn)
	if narr != "":
		var d := _make_label("  " + narr, 12, COL_DIM)
		d.autowrap_mode = TextServer.AUTOWRAP_WORD
		row.add_child(d)
	return row

# ============================================================
# INPUT HANDLERS
# ============================================================

func _on_player_choice(choice_id: String) -> void:
	_clear_choices()
	_choice_prompt.visible = false
	flow.select_choice(choice_id)

func _on_player_sub_choice(sub_key: String, option_id: String) -> void:
	_clear_choices()
	flow.select_sub_choice(sub_key, option_id)

func _on_continue() -> void:
	_continue_btn.visible = false
	flow.advance_phase()

func _return_to_selector() -> void:
	# Disconnect old handler and reconnect continue
	if _continue_btn.pressed.is_connected(_return_to_selector):
		_continue_btn.pressed.disconnect(_return_to_selector)
	if not _continue_btn.pressed.is_connected(_on_continue):
		_continue_btn.pressed.connect(_on_continue)
	_show_flow_selector()

func _toggle_debug() -> void:
	if debug_panel:
		debug_panel.visible = not debug_panel.visible

# ============================================================
# NARRATIVE HELPERS
# ============================================================

func _append_narrative(text: String, color: Color) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_color_override("font_color", color)
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_narrative_vbox.add_child(lbl)

func _clear_narrative() -> void:
	for c in _narrative_vbox.get_children():
		c.queue_free()

func _clear_choices() -> void:
	for c in _choice_vbox.get_children():
		c.queue_free()

func _auto_scroll_narrative() -> void:
	# Scroll to bottom on next frame
	await get_tree().process_frame
	_narrative_scroll.scroll_vertical = int(_narrative_scroll.get_v_scroll_bar().max_value)

# ============================================================
# WIDGET FACTORIES
# ============================================================

func _make_label(text: String, size: int, color: Color) -> Label:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_color_override("font_color", color)
	lbl.add_theme_font_size_override("font_size", size)
	return lbl

func _make_button(text: String, bg_color: Color, text_color: Color) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.add_theme_color_override("font_color", text_color)
	btn.add_theme_color_override("font_hover_color", Color.WHITE)

	# Style normal
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.set_corner_radius_all(4)
	style.set_content_margin_all(8)
	btn.add_theme_stylebox_override("normal", style)

	# Style hover
	var hover := StyleBoxFlat.new()
	hover.bg_color = bg_color.lightened(0.15)
	hover.set_corner_radius_all(4)
	hover.set_content_margin_all(8)
	btn.add_theme_stylebox_override("hover", hover)

	# Style pressed
	var pressed := StyleBoxFlat.new()
	pressed.bg_color = bg_color.darkened(0.15)
	pressed.set_corner_radius_all(4)
	pressed.set_content_margin_all(8)
	btn.add_theme_stylebox_override("pressed", pressed)

	return btn
