extends Bullet

@onready var normal_getter : RayCast2D = $NormalGetter
@export var phase_sound : AudioStreamWAV

@export var collision_sound : AudioStreamWAV
@export var color : Color
@onready var glow : PointLight2D = $Glow

var current_trail : Line2D
var all_trails : Array = []

# New properties for target and return positions
var target_position : Vector2
var return_position : Vector2
var player : Node2D
var close_to_player : bool = false

@export var initial_scale : float = 1.0
@export var max_scale : float = 2.0
@export var scale_growth_rate : float = 0.5

# Signal to notify when the discus has returned
signal returned_to_player

var returning : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_trail = trail.instantiate()
	add_sibling(current_trail)
	rotate(direction.angle())
	all_trails.append(current_trail)
	current_trail.modulate = color
	modulate = color
	glow.color = color
	
func _process(delta):
	# Gradually increase the scale of the discus
	var new_scale = scale + Vector2(scale_growth_rate, scale_growth_rate) * delta
	if new_scale.x <= max_scale:
		scale = new_scale
		
		# Update the collision shape's radius based on the new scale
		if $CollisionShape2D:
			$CollisionShape2D.shape.set_radius($CollisionShape2D.shape.radius * (1 + scale_growth_rate * delta))
	
	if not returning:
		var to_target = target_position - global_position
		if to_target.length() <= velocity * delta:
			global_position = target_position
			returning = true
		else:
			global_position += to_target.normalized() * velocity * delta
	else:
		# Update return position to the player's current position
		if player:
			return_position = player.global_position

		var to_return = return_position - global_position
		if to_return.length() <= ((velocity * delta) + 50):
			close_to_player = true
		if to_return.length() <= velocity * delta:
			global_position = return_position
			for trails in all_trails:
				trails.queue_free()
			$CollisionShape2D.shape.set_radius(7)
			emit_signal("returned_to_player")
			queue_free()
			close_to_player = false
		else:
			global_position += to_return.normalized() * velocity * delta
		
	current_trail.add_new_point(position)

func _on_body_entered(body):
	# Create a new trail segment with a different color when the discus passes through an object
	if close_to_player == false:
		var sound = AudioStreamPlayer2D.new()
		sound.position = position
		sound.stream = phase_sound
		sound.set_volume_db(-20)
		sound.finished.connect(sound.queue_free)
		add_sibling(sound)
		sound.play()
	create_new_trail_segment(Color(1, 0, 0)) # Change new segment color to red

func _on_body_exited(body): 
	# Create a new trail segment with the original color
	create_new_trail_segment(color)

func create_new_trail_segment(trail_color: Color):
	var new_segment = trail.instantiate()
	new_segment.modulate = trail_color
	add_sibling.call_deferred(new_segment)
	all_trails.append(new_segment)
	current_trail = new_segment
