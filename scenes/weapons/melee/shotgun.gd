extends Weapon

@onready var cooldown_timer : Timer = $CooldownTimer
@onready var muzzle_flash : GPUParticles2D = $BulletSpawn/MuzzleFlash

@export var bullet_sound : AudioStreamWAV
@export var kickback_strength : float = 30.0

var can_shoot : bool = true
@export var bullet_spread : float = 0.1
@export var number_of_bullets : int = 3 

func shoot():
	if !can_shoot:
		return

	var mouse_pos : Vector2 = get_global_mouse_position()
	var base_direction : Vector2 = (mouse_pos - $BulletSpawn.global_position).normalized()
	var directions : Array = get_spread_directions(base_direction, bullet_spread, number_of_bullets)

	for direction in directions:
		var new_bullet : Bullet = bullet.instantiate()
		new_bullet.direction = direction
		new_bullet.velocity = 600.0
		new_bullet.global_position = $BulletSpawn.global_position
		get_tree().root.add_child(new_bullet)

	print("Applying kickback")
	apply_kickback(base_direction)

	cooldown_timer.start(cooldown)
	can_shoot = false
	play_shotgun_sound_and_effects()
	return

func get_spread_directions(base_direction : Vector2, spread : float, count : int) -> Array:
	var directions : Array = []
	var angle_step : float = spread / (count - 1)
	for i in range(count):
		var angle : float = -spread / 2 + angle_step * i
		var spread_direction : Vector2 = base_direction.rotated(angle)
		directions.append(spread_direction)
	return directions

func apply_kickback(direction : Vector2):
	var player = get_parent() 
	while player and not (player is CharacterBody2D):
		player = player.get_parent()

	if player and player.has_node("Body"):
		
		print("Applying force to player body")
		player.global_position += -direction * kickback_strength

func play_shotgun_sound_and_effects():
	var sound = AudioStreamPlayer2D.new()
	muzzle_flash.emitting = true
	sound.stream = bullet_sound
	sound.finished.connect(sound.queue_free)
	add_child(sound)
	sound.play()

func _on_cooldown_timer_timeout():
	can_shoot = true
	pass # Replace with function body.
