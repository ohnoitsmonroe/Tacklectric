extends VBoxContainer

var MiltonOne : PackedScene = preload("res://Tacklebox/milton levels/tacklebox_milton_002.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_milton_one_pressed() -> void:
	g.game.loadScene(MiltonOne, $"../../../..")
	g.game.unloadScene($".")
