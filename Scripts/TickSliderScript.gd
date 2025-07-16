extends HSlider

@onready var gameScene=generalUtils.get_game_scene()


func _on_TickSlider_value_changed(new_value):
	gameScene.set_tick_slider(new_value)
	
