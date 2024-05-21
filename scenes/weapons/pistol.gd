extends Weapon

@onready var cooldown_timer : Timer = $CooldownTimer
@onready var muzzle_flash : GPUParticles2D = $BulletSpawn/MuzzleFlash
@onready var lightning : Sprite2D = $GunSprite/Coil

@export var bullet_sound : AudioStreamWAV

var can_shoot : bool = true

func shoot(mouse_pos : Vector2):
	if !can_shoot:
		return
	var new_bullet : Bullet = bullet.instantiate()
	new_bullet.direction = (mouse_pos - $BulletSpawn.global_position).normalized()
	new_bullet.velocity = 600.0
	new_bullet.global_position = $BulletSpawn.global_position
	cooldown_timer.start(cooldown)
	can_shoot = false
	owner.owner.add_child(new_bullet)
	var sound = AudioStreamPlayer2D.new()
	muzzle_flash.emitting = true
	lightning.show()
	sound.stream = bullet_sound
	sound.finished.connect(sound.queue_free)
	add_child(sound)
	sound.play()
	return


func _on_cooldown_timer_timeout():
	can_shoot = true
	pass # Replace with function body.
