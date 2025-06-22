extends Node

@export var menu : PackedScene = null
var currentScene = null
@onready var menuParent = $Menu/MarginContainer/CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	g.game = self
	loadScene(menu, menuParent)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func loadScene(scene, location) -> void:
	var sceneToLoad = scene.instantiate()
	location.add_child(sceneToLoad)
	currentScene = sceneToLoad
	
func unloadScene(scene) -> void:
	scene.queue_free()
	
func loadUI() -> void:
	pass
