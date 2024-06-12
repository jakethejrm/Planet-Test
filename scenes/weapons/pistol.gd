extends Weapon

@onready var cooldown_timer : Timer = $CooldownTimer
@onready var muzzle_flash : GPUParticles2D = $BulletSpawn/MuzzleFlash

@export var bullet_sound : AudioStreamWAV

var can_shoot : bool = true

func shoot():
	if !can_shoot:
		return
	var mouse_pos : Vector2 = get_global_mouse_position()
	var new_bullet1 : Bullet = bullet.instantiate()
	new_bullet1.direction = (mouse_pos - $BulletSpawn.global_position).normalized()
	new_bullet1.velocity = 600.0
	new_bullet1.global_position = $BulletSpawn.global_position
	var new_bullet2 : Bullet = bullet.instantiate()
	new_bullet2.direction = (mouse_pos - $BulletSpawn.global_position).normalized()
	new_bullet2.velocity = 600.0
	new_bullet2.global_position = $BulletSpawn.global_position
	var new_bullet3 : Bullet = bullet.instantiate()
	new_bullet3.direction = (mouse_pos - $BulletSpawn.global_position).normalized()
	new_bullet3.velocity = 600.0
	new_bullet3.global_position = $BulletSpawn.global_position
	cooldown_timer.start(cooldown)
	can_shoot = false
	get_tree().root.add_child(new_bullet1)
	get_tree().root.add_child(new_bullet2)
	get_tree().root.add_child(new_bullet3)
	var sound = AudioStreamPlayer2D.new()
	muzzle_flash.emitting = true
	sound.stream = bullet_sound
	sound.finished.connect(sound.queue_free)
	add_child(sound)
	sound.play()
	return


func _on_cooldown_timer_timeout():
	can_shoot = true
	pass # Replace with function body.
