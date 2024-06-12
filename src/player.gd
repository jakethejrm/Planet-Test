extends CharacterBody2D

signal switch_camera(node : Node2D)

signal update_hp(new_hp : float, max_hp : float)
signal update_fuel(new_fuel : float, max_fuel : float)

@export var grav_source : GravObject : set = _set_grav_source
@export var weapon : Weapon
@export var max_flight : float = 100
@export var max_hp : float = 100

# Array to store references to player's weapons
var weapons: Array = []

# Index of the current weapon
var current_weapon_index: int = 0

const SPEED = 200.0
const JUMP_VELOCITY = 400
const FLY_VELOCITY = 200

var gravity_velocity : Vector2 = Vector2.ZERO
var direction_velocity: Vector2 = Vector2.ZERO
var jump_velocity: Vector2 = Vector2.ZERO

var on_ground : bool = false
var jumping : bool = false

var can_fly : bool = false
var hp : float = 100 : set = _set_hp
var curr_flight : float = 100 : set = _set_flight
var dead = false
var spawnPos = Vector2.ZERO

func _player_killed():
	dead = true
	#switch_camera.disconnect(CameraSettings._on_camera_change)
	
func _respawn():
	#Move Player back to start, reset animations
	#switch_camera.connect(CameraSettings._on_camera_change)
	#switch_camera.emit(self)
	_set_hp(100)
	position = spawnPos
	velocity = Vector2.ZERO
	dead = false
	

func _set_hp(new_hp : float):
	hp = new_hp
	update_hp.emit(hp, max_hp)
	if(new_hp <= 0):
		_player_killed()
	
func _set_flight(new_flight : float):
	curr_flight = new_flight
	update_fuel.emit(curr_flight, max_flight)

var walk_dir = 1
var dir = 1

var can_switch_grav : bool = true

@onready var ground_check : RayCast2D = $GroundChecker
@onready var planet_check : RayCast2D = $PlanetChecker
@onready var platform_check : RayCast2D = $PlatformChecker
@onready var grav_timer : Timer = $GravSwitchTimer

@onready var body : Node2D = $Body
@onready var arm_f : Sprite2D = $Body/Torso/Arm_F
@onready var arm_b : Sprite2D = $Body/Torso/Arm_B
@onready var weapon_spot : Marker2D = $Body/Torso/Arm_F/WeaponHolder

func _ready():
	if is_multiplayer_authority():
		$Stats/Name.text = SteamInit.steam_username
		#switch_camera.connect(CameraSettings._on_camera_change)
		#switch_camera.emit(self)
	weapons.append($Body/Torso/Arm_F/WeaponHolder/Discus)
	weapons.append($Body/Torso/Arm_F/WeaponHolder/Coilgun)
	weapons.append($Body/Torso/Arm_F/WeaponHolder/AcidGun)
	weapons.append($Body/Torso/Arm_F/WeaponHolder/Pistol)
	weapon = weapons[current_weapon_index]
	weapon.visible = true
	#update_hp.connect(CameraSettings._on_update_hp)
	update_hp.emit(hp, max_hp)
	#update_fuel.connect(CameraSettings._on_update_fuel)
	update_fuel.emit(curr_flight, max_flight)
	spawnPos = position

func _physics_process(delta):
	if(dead):
		velocity = Vector2.ZERO
		if(Input.is_key_pressed(KEY_SPACE)):
			_respawn()
	else:
	# return if not player character
		if !is_multiplayer_authority():
			return
	
	# Get the gravity from the grav_source
		_gravity(delta)
		_direction()
		_jump(delta)
		_fly(delta)
	
	
		if Input.is_action_pressed("shoot"):
			weapon.shoot()
		
		if Input.is_action_just_pressed("cycle_weapon"):
			cycle_weapon()
	
		# set player velocity
		velocity = gravity_velocity + direction_velocity
		on_ground = ground_check.is_colliding()
	
		# move player
		move_and_slide()
	
		# handle animations
	_anim_handler(delta)
	
		# set player location for grass shaders (and other shaders too)
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
		if on_ground:
			direction_velocity = direction_velocity.move_toward(Vector2.ZERO, SPEED)
		pass

func _jump(delta):
	if Input.is_action_just_pressed("jump") and on_ground:
		jumping = true
		gravity_velocity = up_direction * JUMP_VELOCITY

func _fly(delta):
	if on_ground:
		if curr_flight < max_flight:
			curr_flight += delta * 200
			_set_flight(curr_flight)
		can_fly = false
	elif Input.is_action_just_released("jump"):
		can_fly = true
	elif Input.is_action_pressed("jump") and can_fly and curr_flight > 0:
		gravity_velocity = up_direction * FLY_VELOCITY
		for emitter : GPUParticles2D in $Body/Legs.get_children():
			emitter.emitting = true
		curr_flight -= delta * 200
		_set_flight(curr_flight)
		if not $Boots.playing:
			$Boots.play()
	else:
		if $Boots.playing:
			$Boots.stop()

func _anim_handler(delta):
	
	$Stats.position.y = $Body/Torso/Head.position.y - 40
	$Stats.global_rotation = Vector2.UP.angle() + PI/2
	
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


func enter_grav_source(body : GravObject):
	if !can_switch_grav:
		return
	# body is the gravity source that we're leaving or entering
	# case for entering planetoid
	if body.gravity_type == GravObject.GravityType.PLANETOID:
		if !grav_source:
			grav_source = body
			return
		if grav_source.gravity_type == GravObject.GravityType.PLANETOID:
			grav_source = body
		else:
			platform_check.force_raycast_update()
			if not platform_check.is_colliding():
				grav_source = body
	
	else:
		grav_source = body
		up_direction = Vector2.UP.rotated(body.rotation)
		
func exit_grav_source(body : GravObject):
	if !can_switch_grav:
		return
	planet_check.force_raycast_update()
	platform_check.force_raycast_update()
	
	if platform_check.is_colliding():
		grav_source = platform_check.get_collider().get_parent()
		up_direction = Vector2.UP.rotated(grav_source.rotation)
	elif planet_check.is_colliding():
		grav_source = planet_check.get_collider().get_parent()
	pass
	
func cycle_weapon():
	if weapon.weapon_name == "Discus":
		if weapon.can_shoot == false:
			return
	# Get the index of the current weapon
	var current_weapon_index = weapons.find(weapon)
	weapon.visible = false
	
	# Increment the index to select the next weapon
	current_weapon_index = (current_weapon_index + 1) % weapons.size()
	
	# Set the new weapon
	weapon = weapons[current_weapon_index]
	weapon.visible = true
	
func _set_grav_source(new_grav : GravObject):
	grav_source = new_grav
	can_switch_grav = false
	grav_timer.start()


func _on_grav_switch_timer_timeout():
	can_switch_grav = true
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	if(area.has_method("_killbox")):
		_set_hp(0)
