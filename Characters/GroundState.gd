extends State

class_name GroundState

@export var jump_velocity : float = -350.0
@export var air_state : State
@export var jump_animation : String = "Jump"

func state_input(event : InputEvent):
	if(event.is_action_pressed("up")):
		jump()

func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation)
