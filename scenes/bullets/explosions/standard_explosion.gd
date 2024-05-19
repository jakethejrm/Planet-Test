extends Node2D

@export var lifetime : float = 1.0

@onready var timer : Timer = $LifetimeTimer
@onready var particles : GPUParticles2D = $Particles
@onready var particles2 : GPUParticles2D = $Particles2
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(lifetime)
	pass # Replace with function body.

func _on_lifetime_timer_timeout():
	particles.emitting = false
	particles2.emitting = false
	pass # Replace with function body.


func _on_particles_finished():
	queue_free()
	pass # Replace with function body.
