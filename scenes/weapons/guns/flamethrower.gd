extends Weapon

@onready var cooldown_timer : Timer = $CooldownTimer
@onready var muzzle_flash : GPUParticles2D = $BulletSpawn/MuzzleFlash
@onready var bullet_spawn : Node2D = $BulletSpawn
@onready var flame_thrower : Node2D = $"."

@export var bullet_sound : AudioStreamWAV
@export var flame_scene : PackedScene

var can_shoot : bool = true
var flame_instance : Node2D = null
var sound = AudioStreamPlayer2D.new()
func shoot():
	if !can_shoot:
		return
	
	var mouse_pos : Vector2 = get_global_mouse_position()
	cooldown_timer.start(cooldown)
	can_shoot = false
	
	if flame_instance:
		flame_instance.queue_free()
	
	# Create and play the sound, and enable the muzzle flash
	
	muzzle_flash.emitting = true
	sound.stream = bullet_sound
	add_child(sound)
	sound.play()
		
	flame_instance = flame_scene.instantiate()
	add_child(flame_instance)
	flame_instance.global_position = bullet_spawn.global_position

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and flame_thrower.visible:
				shoot()
			else:
				if flame_instance:
					sound.stop()
					flame_instance.queue_free()
					flame_instance = null
					can_shoot = true

func _on_cooldown_timer_timeout():
	can_shoot = true
