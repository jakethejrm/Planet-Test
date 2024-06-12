class_name Bullet
extends Area2D

@export var damage : float = 1
@export var trail : PackedScene = preload("res://scenes/weapons/bullets/trails/smoketrail.tscn")
@export var explosion : PackedScene = preload("res://scenes/weapons/bullets/explosions/standard_explosion.tscn")

@export var velocity : float = 1.0
@export var direction : Vector2 = Vector2.ZERO

@export var lifespan : float = 5.0


func _process(delta):
	for area in self.get_overlapping_areas():
		if(area.name == "Hurtbox" && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			area.get_parent().flame_damage(self)
