class_name Weapon
extends Node2D

enum WeaponTypes {MELEE, RANGED}

@export var weapon_name : String = ""
@export var weapon_type : WeaponTypes
@export var cooldown : float = 1.0
@export var bullet : PackedScene = preload("res://scenes/weapons/bullets/Standard_Bullet.tscn")

# this function should contain whatever logic for spawning projectiles and whatnot
func fire_weapon() -> void:
	pass
