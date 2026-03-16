# debug_panel.gd — Debug Overlay for Conflict Prototype
# TIDELINES: Cedar, Sea & Legacy
#
# Toggleable panel showing all internal calculation state:
# force scores, intimidation delta, round-by-round breakdown,
# morale tracking, feud state, trait awards.

extends PanelContainer

const COL_DEBUG  := Color(0.0, 0.80, 0.40)
const COL_HEADER := Color(0.77, 0.63, 0.0)
const COL_DIM    := Color(0.50, 0.48, 0.44)
const COL_BG     := Color(0.05, 0.05, 0.12)

var _content: RichTextLabel
var _header: Label

func _ready() -> void:
	# Panel styling
	var style := StyleBoxFlat.new()
	style.bg_color = COL_BG
	style.set_corner_radius_all(4)
	style.border_color = Color(0.15, 0.35, 0.15)
	style.set_border_width_all(1)
	style.set_content_margin_all(6)
	add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	add_child(vbox)

	_header = Label.new()
	_header.text = "⚙ DEBUG PANEL"
	_header.add_theme_color_override("font_color", COL_HEADER)
	_header.add_theme_font_size_override("font_size", 13)
	vbox.add_child(_header)

	var sep := HSeparator.new()
	sep.modulate = COL_DIM
	vbox.add_child(sep)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	_content = RichTextLabel.new()
	_content.bbcode_enabled = true
	_content.fit_content = true
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_theme_color_override("default_color", COL_DEBUG)
	_content.add_theme_font_size_override("normal_font_size", 12)
	scroll.add_child(_content)

	# Start hidden until user toggles
	visible = true

## Called by ConflictScreen when the flow controller emits debug_snapshot.
func update_data(data: Dictionary) -> void:
	if _content == null:
		return
	_content.clear()
	_content.push_color(COL_HEADER)
	_content.add_text("Phase: %s\n" % data.get("phase", "—"))
	_content.pop()

	_content.push_color(COL_DEBUG)
	_content.add_text("─── Forces ───\n")
	_content.add_text("ATK morale: %d   DEF morale: %d\n" % [
		data.get("attacker_morale", 0), data.get("defender_morale", 0)
	])
	_content.add_text("─── Modifiers ───\n")
	_content.add_text("Surprise: %.0f   Stealth: %.0f\n" % [
		data.get("surprise", 0), data.get("stealth", 0)
	])
	_content.add_text("─── Intimidation ───\n")
	_content.add_text("Score: %d   Resolve: %d   Δ: %+d\n" % [
		data.get("intim_score", 0), data.get("resolve_score", 0),
		data.get("intim_delta", 0)
	])
	_content.add_text("Result: %s\n" % data.get("intim_result", "—"))
	_content.add_text("─── Engagement ───\n")
	_content.add_text("ATK tactic: %s\n" % data.get("atk_tactic", "—"))
	_content.add_text("DEF tactic: %s\n" % data.get("def_tactic", "—"))
	_content.add_text("ATK total: %.1f  DEF total: %.1f\n" % [
		data.get("atk_total", 0), data.get("def_total", 0)
	])
	_content.add_text("Ratio: %.2f   Outcome: %s\n" % [
		data.get("ratio", 0), data.get("outcome", "—")
	])

	# Round breakdown
	var rounds: Array = data.get("rounds", [])
	if rounds.size() > 0:
		_content.add_text("─── Rounds ───\n")
		for i in range(rounds.size()):
			var r: Dictionary = rounds[i]
			_content.add_text("R%d: ATK %.1f  DEF %.1f\n" % [
				i + 1, r.get("atk", 0), r.get("def", 0)
			])
			if r.has("event"):
				_content.push_color(COL_HEADER)
				_content.add_text("   ✦ %s\n" % r["event"].get("text", ""))
				_content.pop()
				_content.push_color(COL_DEBUG)

	_content.add_text("─── Aftermath ───\n")
	_content.add_text("Feud esc: %d   Prestige: %+d\n" % [
		data.get("feud_esc", 0), data.get("prestige", 0)
	])
	var traits: Array = data.get("traits", [])
	if traits.size() > 0:
		_content.add_text("Traits: %s\n" % ", ".join(traits))
	var spoils: Array = data.get("spoils", [])
	if spoils.size() > 0:
		var sp_text := "Spoils: "
		for s in spoils:
			sp_text += "%s×%d " % [s.get("resource", "?"), s.get("amount", 0)]
		_content.add_text(sp_text + "\n")
	_content.pop()
