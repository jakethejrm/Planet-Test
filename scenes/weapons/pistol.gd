extends Weapon


@onready var cooldown_timer : Timer = $CooldownTimer
@onready var muzzle_flash : GPUParticles2D = $BulletSpawn/MuzzleFlash

@export var bullet_sound : AudioStreamWAV
var can_shoot : bool = true

@export var type : int

func shoot():
	if !can_shoot:
		return
	var mouse_pos : Vector2 = get_global_mouse_position()
	var new_bullet1 : Bullet = bullet.instantiate()
	new_bullet1.direction = (mouse_pos - $BulletSpawn.global_position).normalized()
	new_bullet1.velocity = 600.0
	new_bullet1.global_position = $BulletSpawn.global_position
	new_bullet1.type = type
	var new_bullet2 : Bullet = bullet.instantiate()
	new_bullet2.direction = (mouse_pos - $BulletSpawn.global_position).normalized()
	new_bullet2.velocity = 600.0
	new_bullet2.global_position = $BulletSpawn.global_position
	new_bullet2.type = type
	var new_bullet3 : Bullet = bullet.instantiate()
	new_bullet3.direction = (mouse_pos - $BulletSpawn.global_position).normalized()
	new_bullet3.velocity = 600.0
	new_bullet3.global_position = $BulletSpawn.global_position
	new_bullet3.type = type
	cooldown_timer.start(cooldown)
	can_shoot = false
	get_tree().current_scene.get_child(0).get_child(1).get_child(0).get_child(0).spawn(new_bullet1)
	if(type == Bullet.ACID):
		get_tree().current_scene.get_child(0).get_child(1).get_child(0).get_child(0).spawn(new_bullet2)
		get_tree().current_scene.get_child(0).get_child(1).get_child(0).get_child(0).spawn(new_bullet3)
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
