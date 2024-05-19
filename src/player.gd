extends CharacterBody2D

@export var grav_source : GravObject
@export var weapon : Weapon

const SPEED = 300.0
const JUMP_VELOCITY = 400

var gravity_velocity : Vector2 = Vector2.ZERO
var direction_velocity: Vector2 = Vector2.ZERO
var jump_velocity: Vector2 = Vector2.ZERO

var on_ground : bool = false
var jumping : bool = false

@onready var ground_check : RayCast2D = $GroundChecker
@onready var grav_check : RayCast2D = $GravityChecker

@onready var body : Node2D = $Body
@onready var arm_f : Sprite2D = $Body/Torso/Arm_F
@onready var arm_b : Sprite2D = $Body/Torso/Arm_B
@onready var weapon_spot : Marker2D = $Body/Torso/Arm_F/WeaponHolder

var walk_dir = 1
var dir = 1

func _ready():
	#RenderingServer.global_shader_parameter_set("player_location", position)
	pass

func _physics_process(delta):
	
	# Get the gravity from the grav_source
	_gravity(delta)
	_direction()
	_jump()
	
	if Input.is_action_pressed("shoot"):
		weapon_spot.get_child(0).shoot(get_global_mouse_position())
	
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
	walk_dir = Input.get_axis("walk_left", "walk_right")
	if walk_dir:
		direction_velocity = Vector2(walk_dir, 0).rotated(up_direction.angle() + PI/2) * SPEED
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
	
	
	var char_to_mouse_vec = global_mouse_pos - global_position
	var rotated_vec = char_to_mouse_vec.rotated(-global_rotation)
	if rotated_vec.x > 0:
		# Mouse cursor is to the right of the character
		dir = 1
	else:
		# Mouse cursor is to the left of the character
		dir = -1
	
	if dir == -1:
		rotation_amt += PI
	arm_f.global_rotation = lerp_angle(arm_f.global_rotation, rotation_amt, delta * 20)
	arm_b.global_rotation = lerp_angle(arm_b.global_rotation, rotation_amt, delta * 20)
	
	body.scale.x = dir

	if grav_source and grav_source.gravity_type == GravObject.GravityType.PLANETOID:
		up_direction = (position - grav_source.position).normalized()
		var up = up_direction.angle() + PI/2
		rotation = lerp_angle(rotation, up, delta * 20)
	else:
		rotation = lerp_angle(rotation, up_direction.angle() + PI/2, delta * 20)
	
	if not on_ground:
		$Body/Legs.animation = "jump"
	elif !direction_velocity.is_zero_approx():
		if walk_dir == dir:
			$Body/Legs.animation = "running"
		else:
			$Body/Legs.animation = "running_backwards"
	else:
		$Body/Legs.animation = "idle"
