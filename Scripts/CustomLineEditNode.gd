extends Node2D

signal text_changed


func _on_LineEdit_text_changed(new_text):
	emit_signal("text_changed",int(new_text))
