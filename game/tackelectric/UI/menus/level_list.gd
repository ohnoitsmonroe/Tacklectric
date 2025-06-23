extends VBoxContainer

@export var levels:Array[PackedScene]
@export var listButton: PackedScene = null
var levelDict = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level in levels:
		var button = listButton.instantiate()
		add_child(button)
		button.setLabel("Level " + str(levels.find(level) + 1))
		levelDict[button] =  level
		button.pressed.connect(on_button_pressed.bind(button))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_button_pressed(button: Button):
	g.game.loadLevel(levelDict[button])
	
