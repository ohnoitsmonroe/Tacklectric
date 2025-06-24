extends Node3D

# This will manage the turn count

@onready var lightOrigin = $lightOrigin

@export var turnLight : PackedScene = null

@export var lightSeparation := 1.2

@export var turnMax := 5
var turnCount := 0

var turnLights := {}


func _ready() -> void:
	addLights()


func increaseTurnCount():
	turnCount += 1
	
	if turnCount > turnMax:
		g.game_over()
		return
		
	updateTurnLights()


func updateTurnLights():
	for i in turnCount:
		if is_instance_valid(turnLights[i]):
			turnLights[i].setActive()
			if g.didMoveTutorial == false:
				g.didMoveTutorial = true
				g.moveTutorial()


func addLights():
	for i in turnMax:
		var newLight = turnLight.instantiate()
		lightOrigin.add_child(newLight)
		turnLights[i] = newLight
		
		newLight.position += Vector3(i * lightSeparation, 0, 0)
