extends CharacterBody2D


@export var speed : float = 200.0


@export var wall_jump_velocity : float = -300
@export var fast_fall_velocity : float = 2500
@export var friction_value : float = 800


@onready var sprite2d : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall = fast_fall_velocity
var has_double_jumped : bool = false
var has_wall_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var friction : float = 0
var delta_cancel_bool : bool = false
var delta_cancel : float = 1
var has_combat_roll : bool = false

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Input direction that will update the direction
	get_input_directions()
	
	# A combat roll that will deacivate the hurtbox while rolling
	combat_roll()
	
	# All the characters jumps and conditions to jump
	#player_jump()
	
	# A function to check if the player has jumped from a specific point
	# Will come back to revamp this
	check_player_jumps()
	
	# Adds the project gravity. And also works as the "main" velocity equation
	character_gravity(delta)
	
	# Fast fall mechanic
	player_fast_fall()
	
	# Horizontal movement
	movement()
	
	# Flips the sprite according to the direction.x
	# Most of our current animations will not use the flip.H function
	# because our character has an asymmetrical design
	#update_facing_direction()
	
	# Changes animation states. Idle or running currently
	update_animation()
	
	# Makes the character do the cha cha slide
	move_and_slide()


func get_input_directions():
	direction = Input.get_vector("right", "left", "down", "up")

func combat_roll():
	if Input.is_action_just_pressed("shift"):
		#Insert a deactivation of hurtbox
		#change animation
		#give a velocity
		has_combat_roll = true
		#give cooldown


#func player_jump():
	#if Input.is_action_just_pressed("up"):
		#if is_on_floor():
			## Normal Jump from floor
			#pass
		#elif not has_double_jumped and not is_on_wall():
			## Double Jump
			#pass
		#elif not has_wall_jumped and is_on_wall():
			## Wall Jump
			#velocity.y = wall_jump_velocity
			#has_wall_jumped = true


func check_player_jumps():
	if not is_on_floor() and has_double_jumped == true:
		has_double_jumped = true
	else:
		has_double_jumped = false
	if is_on_wall() and has_wall_jumped == true:
		has_wall_jumped = true
	else:
		has_wall_jumped = false


func character_gravity(delta):
		if not is_on_floor():
			add_friction(delta)
			velocity.y += (gravity + fast_fall - friction) * delta / delta_cancel


func update_animation():
	animation_tree.set("parameters/Move/blend_position", direction.x)
	
	#if not animation_locked:
		#if direction.x != 0:
			#sprite2d.play("run")
		#else:
			#sprite2d.play("idle")


#func update_facing_direction():
	#if direction.x > 0:
		#sprite2d.flip_h = false
	#elif direction.x < 0:
		#sprite2d.flip_h = true


func player_fast_fall():
	if Input.is_action_pressed("down"):
		fast_fall = fast_fall_velocity
	else:
		fast_fall = 0


func movement():
	if direction.x != 0 && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


func add_friction(delta):
	if is_on_wall() and velocity.y > 0:
		add_delta_cancel(delta)
		friction = friction_value
	else:
		friction = 0


func add_delta_cancel(delta):
	if delta_cancel_bool == true:
		delta_cancel = delta
	else:
		delta_cancel = 1
