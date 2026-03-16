# feud_tracker.gd — Persistent Multi-Generational Feud Tracker
# TIDELINES: Cedar, Sea & Legacy

class_name FeudTracker
extends RefCounted

var feuds: Dictionary = {}   # "a:b" -> feud dict

func get_feud(community_a: String, community_b: String) -> Dictionary:
	return feuds.get(_key(community_a, community_b), {})

func get_or_create(community_a: String, community_b: String) -> Dictionary:
	var k := _key(community_a, community_b)
	if not feuds.has(k):
		feuds[k] = _new_feud(community_a, community_b)
	return feuds[k]

func escalate(community_a: String, community_b: String, amount: int, reason: String) -> Dictionary:
	var feud := get_or_create(community_a, community_b)
	feud["escalation"] += amount
	feud["history"].append({"action": reason, "change": amount, "new_esc": feud["escalation"]})
	feud["state"] = _state_for(feud["escalation"])
	EventBus.feud_state_changed.emit(_key(community_a, community_b), feud)
	return feud

func deescalate(community_a: String, community_b: String, amount: int, reason: String) -> Dictionary:
	var feud := get_or_create(community_a, community_b)
	feud["escalation"] = maxi(0, feud["escalation"] - amount)
	feud["history"].append({"action": reason, "change": -amount, "new_esc": feud["escalation"]})
	feud["state"] = _state_for(feud["escalation"])
	if feud["escalation"] <= 0:
		feud["state"] = "RESOLVED"
		EventBus.feud_resolved.emit(_key(community_a, community_b), feud)
	else:
		EventBus.feud_state_changed.emit(_key(community_a, community_b), feud)
	return feud

func apply_yearly_decay() -> void:
	for k in feuds:
		var f := feuds[k] as Dictionary
		if f.get("state", "") == "SMOULDERING":
			f["escalation"] = maxi(0, f["escalation"] - 1)
			if f["escalation"] <= 0:
				f["state"] = "RESOLVED"

func _state_for(esc: int) -> String:
	if esc <= 0: return "RESOLVED"
	if esc <= 3: return "SMOULDERING"
	if esc <= 5: return "GRIEVANCE"
	if esc <= 12: return "ACTIVE_FEUD"
	return "BLOOD_FEUD"

func _new_feud(a: String, b: String) -> Dictionary:
	return {
		"a": a, "b": b,
		"state": "GRIEVANCE",
		"escalation": 1,
		"conflict_count": 0,
		"history": [],
	}

func _key(a: String, b: String) -> String:
	var arr := [a, b]
	arr.sort()
	return arr[0] + ":" + arr[1]
