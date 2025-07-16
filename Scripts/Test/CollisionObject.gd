extends Sprite2D

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print("CollisionObject3D")
