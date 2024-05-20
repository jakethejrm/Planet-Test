extends Line2D

@export var limited_lifetime : bool = false
@export var wildness : float = 3.0

var lifetime = [1.0, 2.0]
var tick_speed : float= 0.5
var tick : float = 0.0

var max_len = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_points()
	if limited_lifetime:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, randf_range(lifetime[0], lifetime[1]))
		tween.set_trans(Tween.TRANS_CIRC)
		tween.set_ease(Tween.EASE_OUT)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_new_point(point_pos: Vector2):
	add_point(point_pos)
	if get_point_count() > max_len:
		remove_point(0)
