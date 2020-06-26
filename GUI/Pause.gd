extends Button

var paused := false
var txt := {false : "Pause", true : "Resume"}

func _on_Pause_pressed():
	paused = !paused
	text = txt[paused]
