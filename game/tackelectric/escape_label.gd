extends RichTextLabel

@onready var timer = $EscapeTimer

var menu : PackedScene = preload("res://UI/menus/menu_list.tscn")
var options : PackedScene = preload("res://UI/menus/options_list.tscn")
var levels : PackedScene = preload("res://UI/menus/level_list.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("escape"):
		timer.start()
		visible = true
	if event.is_action_released("escape"):
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
