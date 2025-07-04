extends RichTextLabel

@onready var tween = get_tree().create_tween()
@onready var timer = $TutorialTimer

var didMoveTut : bool = false
var didCastTut : bool = false
var didRetryTut : bool = false

var moveTutorial : String = "[center]Click and drag the lures on the board with a wood plank underneath.
Lures without a plank cannot be moved.
You can move multiple tiles in one turn, but only in one direction.[/center]"

var castTutorial : String = "[center]Press spacebar to cast the fishing line from the top left.
It will travel the path shown by the lures. Your goal is to reach the fish on the right.
You have as many turns as there red lights on the left side of the tacklebox.[/center]"

var retryTutorial : String = "[center]Press R to restart the level at any time.
Hold ESC at any time to go back to the previous menu, or quit the game if in the main menu.[/center]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if g.sawLastTutorial == true:
		visible = false
	else:
		visible = true
	modulate.a = 0.0
	
	g.move_tutorial.connect(move_tutorial)
	g.cast_tutorial.connect(cast_tutorial)
	g.retry_tutorial.connect(retry_tutorial)
	
	if g.didMoveTutorial == false:
		set_text(moveTutorial)
		tween.tween_property(self, "modulate:a", 1.0, 5.0).set_delay(2.5)
	elif g.didCastTutorial == false:
		set_text(castTutorial)
		tween.tween_property(self, "modulate:a", 1.0, 5.0).set_delay(2.5)
	elif g.didRetryTutorial == false:
		set_text(retryTutorial)
		tween.tween_property(self, "modulate:a", 1.0, 5.0).set_delay(2.5)
	else:
		modulate.a = 1.0
		set_text("[center]Now try to reach the fish! Good luck, and thank you for playing our game.[/center]")
		tween.tween_property(self, "modulate:a", 0.0, 5.0).set_delay(2.5)
		tween.play()
		g.sawLastTutorial = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func move_tutorial() -> void:
	didMoveTut = true
	tween.play()
	set_text(castTutorial)

func cast_tutorial() -> void:
	didCastTut = true
	tween.play()
	set_text(retryTutorial)

func retry_tutorial() -> void:
	didRetryTut = true
	#tween.tween_property(self, "modulate:a", 0.0, 5.0)
	#tween.play()
