extends MultiplayerSpawner

@export var SB : PackedScene
@export var acid : PackedScene
@export var coil : PackedScene
@export var flame : PackedScene
@export var disc : PackedScene

func _ready():
	spawn_function = spawn_bullet
	
var bullets = {}

func spawn_bullet(bullet):
	var b : Node2D
	match bullet.type:
		Bullet.SB:
			b = SB.instantiate()
		Bullet.ACID:
			b = acid.instantiate()
		Bullet.COILGUN:
			b = coil.instantiate()
		Bullet.FLAME:
			b = flame.instantiate()
		Bullet.DISC:
			b = disc.instantiate()
			b.target_position = bullet.target_position
			b.return_position = bullet.return_position
			b.player = bullet.player
			b.connect("returned_to_player", Callable(b.player.get_child(0), "_on_discus_returned"))
	b.global_position = bullet.global_position
	b.direction = bullet.direction
	b.velocity = bullet.velocity
	bullets[bullet.name] = b
	print(bullet.position)
	return b

func remove_bullet(bullet):
	print(bullets)
	#bullets[bullet.name].queue_free()
	#bullets.erase(bullet.name)
	
