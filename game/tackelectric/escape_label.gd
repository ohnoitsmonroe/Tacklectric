extends RichTextLabel

@onready var timer = $EscapeTimer

@onready var menu : PackedScene = preload("res://UI/menus/menu_list.tscn")
@onready var options : PackedScene = preload("res://UI/menus/options_list.tscn")
@onready var levels : PackedScene = preload("res://UI/menus/level_list.tscn")

#var tween = null

@onready var tween = get_tree().create_tween()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	modulate.a = 0.0
	tween.tween_property(self, "modulate:a", 1.0, 3.0)
	tween.stop()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	match g.currentScene:
		menu:
			set_text("[center]keep holding escape to go to quit[/center]")
		options:
			set_text("[center]keep holding escape to go back to the main menu[/center]")
		levels:
			set_text("[center]keep holding escape to go back to the main menu[/center]")
		_:
			set_text("[center]keep holding escape to go back to the level list[/center]")
	if event.is_action_pressed("escape"):
		visible = true
		tween.play()
		timer.start()
	if event.is_action_released("escape"):
		tween.stop()
		modulate.a = 0.0
		timer.stop()
		visible = false


func _on_escape_timer_timeout() -> void:
	match g.currentScene:
		menu:
			get_tree().quit()
		options:
			g.game.loadMainMenu()
		levels:
			g.game.loadMainMenu()
		_:
			g.game.loadLevelList()
	
	visible = false
	modulate.a = 0.0
	tween.stop()
