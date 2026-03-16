# legacy_log.gd — Persistent Legacy Log for Conflict Prototype
# TIDELINES: Cedar, Sea & Legacy
#
# Scrolling log that accumulates legacy entry strings across
# multiple conflict resolutions within a single play session.

extends PanelContainer

const COL_HEADER := Color(0.77, 0.63, 0.0)
const COL_TEXT   := Color(0.91, 0.86, 0.78)
const COL_DIM    := Color(0.50, 0.48, 0.44)
const COL_BG     := Color(0.06, 0.04, 0.08)

var _content: RichTextLabel
var _header: Label
var _entries: Array[String] = []
var _entry_count: int = 0

func _ready() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = COL_BG
	style.set_corner_radius_all(4)
	style.border_color = Color(0.30, 0.20, 0.05)
	style.set_border_width_all(1)
	style.set_content_margin_all(6)
	add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	add_child(vbox)

	_header = Label.new()
	_header.text = "📜 LEGACY LOG"
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
	_content.add_theme_color_override("default_color", COL_TEXT)
	_content.add_theme_font_size_override("normal_font_size", 12)
	scroll.add_child(_content)

	# Show placeholder
	_refresh()

## Add a legacy entry to the log.
func add_entry(text: String) -> void:
	_entry_count += 1
	_entries.append(text)
	_refresh()

## Get all entries.
func get_entries() -> Array[String]:
	return _entries

func _refresh() -> void:
	if _content == null:
		return
	_content.clear()
	if _entries.size() == 0:
		_content.push_color(COL_DIM)
		_content.add_text("No legacy entries yet.\nComplete a conflict to record history.")
		_content.pop()
		return

	for i in range(_entries.size()):
		_content.push_color(COL_HEADER)
		_content.add_text("Entry %d:\n" % (i + 1))
		_content.pop()
		_content.push_color(COL_TEXT)
		_content.add_text(_entries[i])
		_content.pop()
		_content.add_text("\n\n")
