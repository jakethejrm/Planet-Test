extends CharacterBody2D

@export var grav_source : GravObject

const SPEED = 300.0
const JUMP_VELOCITY = 400

var gravity_velocity : Vector2 = Vector2.ZERO
var direction_velocity: Vector2 = Vector2.ZERO
var jump_velocity: Vector2 = Vector2.ZERO

var on_ground : bool = false
var jumping : bool = false

@onready var sprite : AnimatedSprite2D = $Sprite2D
@onready var ground_check : RayCast2D = $GroundChecker
@onready var grav_check : RayCast2D = $GravityChecker

@onready var arm_f : Sprite2D = $Node2D/Torso/Arm_F
@onready var arm_b : Sprite2D = $Node2D/Torso/Arm_B
@onready var weapon_spot : Marker2D = $Node2D/Torso/Arm_F/WeaponHolder

var dir = 1

func _ready():
	#RenderingServer.global_shader_parameter_set("player_location", position)
	pass

func _physics_process(delta):
	
	# Get the gravity from the grav_source
	_gravity(delta)
	_direction()
	
	_jump()
	
	# set player velocity
	velocity = gravity_velocity + direction_velocity
	
	on_ground = ground_check.is_colliding()
	
	# move player
	move_and_slide()
	
	# handle animations
	_anim_handler(delta)
	
	# set player location for grass shaders (and other shaders too)a
	RenderingServer.global_shader_parameter_set("player_location", position)

func _gravity(delta : float):
	if not grav_source:
		gravity_velocity += Vector2(0,980) * delta
		return
	var gravity = grav_source.gravity_force(self)
	
	if not is_on_floor():
		gravity_velocity += gravity * delta
	else:
		gravity_velocity = Vector2(0,0)
		
func _direction():
	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		direction_velocity = Vector2(direction, 0).rotated(up_direction.angle() + PI/2) * SPEED
	else:
		direction_velocity = direction_velocity.move_toward(Vector2.ZERO, SPEED)
		pass

func _jump():
	
	if Input.is_action_just_pressed("jump") and on_ground :
		jumping = true
		gravity_velocity = up_direction * JUMP_VELOCITY
	elif on_ground:
		jumping = false

func _anim_handler(delta):
	
	var global_mouse_pos : Vector2 = get_global_mouse_position()
	var rotation_amt = arm_f.global_position.angle_to_point(global_mouse_pos) - (PI/2)
	
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var viewport_dims : Vector2 = get_viewport().get_visible_rect().size
	
	
	
	dir = sign(mouse_pos.x - viewport_dims.x / 2)
	if dir == -1:
		rotation_amt += PI
	arm_f.global_rotation = rotation_amt
	arm_b.global_rotation = rotation_amt
	
	scale.x = scale.y * dir

	if grav_source and grav_source.gravity_type == GravObject.GravityType.PLANETOID:
		up_direction = (position - grav_source.position).normalized()
		var up = up_direction.angle() + PI/2
		if dir == -1:
			up += PI
		rotation = up
	else:
		if dir == -1:
			rotation = up_direction.angle() + PI/2 - PI
		else:
			rotation = up_direction.angle() + PI/2
	
	if not on_ground:
		$Node2D/Legs.animation = "jump"
	elif !direction_velocity.is_zero_approx():
		$Node2D/Legs.animation = "running"
	else:
		$Node2D/Legs.animation = "idle"
