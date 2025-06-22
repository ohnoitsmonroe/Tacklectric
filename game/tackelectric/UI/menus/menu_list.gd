extends VBoxContainer

@export var tacklebox : PackedScene = null
@export var options : PackedScene = null
@export var levels : PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	g.game.loadScene(levels, $"../../../..")
	g.game.unloadScene($".")


func _on_options_pressed() -> void:
	g.game.loadScene(options, $"../../../..")
	g.game.unloadScene($".")
