class_name Bullet
extends Area2D

@export var damage : float = 1
@export var trail : PackedScene = preload("res://scenes/weapons/bullets/trails/smoketrail.tscn")
@export var explosion : PackedScene = preload("res://scenes/weapons/bullets/explosions/standard_explosion.tscn")

@export var velocity : float = 1.0
@export var direction : Vector2 = Vector2.ZERO

@export var lifespan : float = 5.0
