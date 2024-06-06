extends Weapon

@onready var currentScene : Sprite2D = $GunSprite
@onready var cooldown_timer: Timer = $CooldownTimer

@export var bullet_sound : AudioStreamWAV
@export var discusBullet_scene : PackedScene = preload("res://scenes/weapons/bullets/discusBullet.tscn")

var can_shoot : bool = true
var returned : bool = true

func shoot():
	if !can_shoot or !returned:
		return
	currentScene.hide()
	var mouse_pos : Vector2 = get_global_mouse_position()
	var new_bullet : Bullet = bullet.instantiate()
	var player = get_parent() as Node2D
	new_bullet.global_position = $BulletSpawn.global_position
	new_bullet.target_position = mouse_pos
	new_bullet.return_position = $BulletSpawn.global_position
	new_bullet.player = player
	cooldown_timer.start(cooldown)
	returned = false
	
	# Connect the returned_to_player signal to reset can_shoot
	new_bullet.connect("returned_to_player", Callable(self, "_on_discus_returned"))
	
	new_bullet.direction = (mouse_pos - $BulletSpawn.global_position).normalized()
	new_bullet.velocity = 600.0
	new_bullet.global_position = $BulletSpawn.global_position
	can_shoot = false
	get_tree().root.add_child(new_bullet)
	var sound = AudioStreamPlayer2D.new()
	sound.stream = bullet_sound
	sound.finished.connect(sound.queue_free)
	add_child(sound)
	sound.play()
	return


func _on_discus_returned():
	currentScene.show()
	returned = true
	pass # Replace with function body.


func _on_cooldown_timer_timeout():
	can_shoot = true
	pass # Replace with function body.
