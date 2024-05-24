class_name MapParams

extends Node

var map_id : int
var map_pic : CompressedTexture2D
var map_name : String
var map_file : PackedScene

func _init(id : int, m_name : String, file : PackedScene,  pic : CompressedTexture2D = null):
	map_id = id
	map_pic = pic
	map_name = m_name
	map_file = file
	
