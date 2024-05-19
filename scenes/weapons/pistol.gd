extends Weapon

@onready var cooldown_timer : Timer = $CooldownTimer

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
	return


func _on_cooldown_timer_timeout():
	can_shoot = true
	pass # Replace with function body.
