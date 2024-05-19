class_name GravObject
extends Node2D

enum GravityType {PLANETOID, PLATFORM}

@export var gravity_amount : float = 980
@export var gravity_type : GravityType = GravityType.PLANETOID

func gravity_force(player : Node2D) -> Vector2:
	return Vector2.ZERO
