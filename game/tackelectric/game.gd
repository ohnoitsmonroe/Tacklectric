extends Node

@export var mainMenu : PackedScene = null
@export var options : PackedScene = null
@export var levelList : PackedScene = null
@onready var menuParent = $Menu/MarginContainer/CenterContainer
@onready var root = $"."
var currentScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	g.game = self
	loadScene(mainMenu, menuParent)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func loadScene(scene, location) -> void:
	currentScene = scene.instantiate()
	location.add_child(currentScene)
	
func unloadScene(scene) -> void:
	scene.queue_free()
	
func loadMainMenu() -> void:
	unloadScene(currentScene)
	loadScene(mainMenu, menuParent)
	
func loadOptions() -> void:
	unloadScene(currentScene)
	loadScene(options, menuParent)
	
func loadLevelList() -> void:
	unloadScene(currentScene)
	loadScene(levelList, menuParent)
	
func loadLevel(level) -> void:
	unloadScene(currentScene)
	loadScene(level, root)
