extends VBoxContainer

@export var levels:Array[PackedScene]
@export var listButton: PackedScene = null
var levelDict = {}
var currentLevel : PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level in levels:
		var button = listButton.instantiate()
		add_child(button)
		button.setLabel("Level " + str(levels.find(level) + 1))
		levelDict[button] = level
		button.pressed.connect(on_button_pressed.bind(button))
		
	g.levelDict = levelDict


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_button_pressed(button: Button):
	g.currentScene = g.levelDict[button]
	g.game.loadLevel(g.currentScene)
	
