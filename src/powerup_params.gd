class_name PowerupParams
extends Node

var powerup_id : int
var powerup_pic : CompressedTexture2D
var powerup_name : String
var powerup_file : PackedScene

func _init(id : int, p_name : String, file : PackedScene,  pic : CompressedTexture2D = null):
	powerup_id = id
	powerup_pic = pic
	powerup_name = p_name
	powerup_file = file
	
