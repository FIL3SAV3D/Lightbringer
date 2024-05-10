extends CharacterBody2D

@export var speed : float = 150.0
@export var player : Node2D

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked : bool = false
var direction

func _ready():
	makepath()

func _physics_process(delta):
	direction = to_local(nav_agent.get_next_path_position()).normalized().x
	velocity.x = direction * speed
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	update_animation()
	update_facing_direction()

func makepath():
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	makepath()

func update_animation():
	if not animation_locked:
		if velocity.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")


func update_facing_direction():
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
