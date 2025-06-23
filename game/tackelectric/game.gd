extends Node

@export var mainMenu : PackedScene = null
@export var options : PackedScene = null
@export var levelList : PackedScene = null
@onready var menuParent = $Menu/MarginContainer/CenterContainer
@onready var root = $"."

var currentInstance = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	g.game = self
	g.currentScene = mainMenu
	loadScene(mainMenu, menuParent)
	
	g.game_is_won.connect(game_is_won)
	g.game_is_over.connect(game_is_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func loadScene(scene, location) -> void:
	g.currentScene = scene
	currentInstance = g.currentScene.instantiate()
	location.add_child(currentInstance)
	
func _input(event):
	if event.is_action_pressed("restart"):
		restartLevel()
		
func unloadScene(scene) -> void:
	scene.queue_free()
	
func loadMainMenu() -> void:
	unloadScene(currentInstance)
	loadScene(mainMenu, menuParent)
	
func loadOptions() -> void:
	unloadScene(currentInstance)
	loadScene(options, menuParent)
	
func loadLevelList() -> void:
	unloadScene(currentInstance)
	loadScene(levelList, menuParent)
	
func loadLevel(level) -> void:
	g.level_loaded
	await get_tree().create_timer(.8).timeout
	unloadScene(currentInstance)
	loadScene(level, root)
	
func restartLevel() -> void:
	print("Restarting level")
	loadLevel(g.currentScene)
	g.selectingCompartment = false
	
func nextLevel() -> void:
	var levelToLoad = g.levelList.find(g.currentScene) + 1

	print("Loading next level, level " + str(levelToLoad))
	print("levelList size is " + str(g.levelList.size()))

	if g.levelList.size() > levelToLoad:
		loadLevel(g.levelList[levelToLoad])
	else:
		print("At the end of the level list. There is no next level. Loading main menu.")
		loadMainMenu()
	
func game_is_won():
	nextLevel()

func game_is_over():
	await get_tree().create_timer(.8).timeout
	restartLevel()
	
