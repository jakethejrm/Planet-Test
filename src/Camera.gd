extends Camera2D

@export var player : Node2D
@export var mouse_adjust : float = 0.1
@export var lerp_weight : float = 0.2

var camera_x_offset : float = 0.0
var camera_y_offset : float = 0.0

var camera_position: Vector2; 
var overshoot: Vector2 = Vector2(0.3, 0.3);

func lerp_overshoot(origin: float, target: float, weight: float, overshoot_amt: float) -> float: 
	var distance: float = (target - origin) * weight;
	if is_equal_approx(distance, 0.0):
		return target;
	var distanceSign := signf(distance);
	var lerpValue: float = lerp(origin, target + (overshoot_amt * distanceSign), weight);
	if distanceSign == 1.0:
		lerpValue = min(lerpValue, target);
	elif distanceSign == -1.0:
		lerpValue = max(lerpValue, target);
	return lerpValue;
	
func lerp_overshoot_v(from: Vector2, to: Vector2, weight: float) -> Vector2: 
	var x = lerp_overshoot(from.x, to.x, weight, overshoot.x); 
	var y = lerp_overshoot(from.y, to.y, weight, overshoot.y);
	return Vector2(x,y);

func _physics_process(_delta): 
	if !is_multiplayer_authority():
		return
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var viewport_dims : Vector2 = get_viewport().get_visible_rect().size
	camera_x_offset = (mouse_pos.x - (viewport_dims.x / 2)) * mouse_adjust
	camera_y_offset = (mouse_pos.y - (viewport_dims.y / 2)) * mouse_adjust
	var to = player.position + Vector2(camera_x_offset, camera_y_offset)
	var new_pos = self.lerp_overshoot_v(self.position, to, lerp_weight);
	self.position = Vector2(new_pos.x, new_pos.y)
	#self.rotation = player.rotation

func _ready():
	enabled = is_multiplayer_authority()
