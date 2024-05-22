@tool
extends PanelContainer

@export var name_label : Label
@export var host_label : Label
@export var map_label : Label
@export var player_count_label : Label
@export var join_button : Button

@export var server_name : String : set = _set_server_name
@export var server_host : String : set = _set_server_host
@export var server_map : String : set = _set_server_map
@export var curr_player_count : int : set = _set_curr_player_count
@export var max_player_count : int : set = _set_max_player_count
@export var joinable : bool : set = _set_joinable
@export var disabled_text_color : Color = Color("787878")
@export var enabled_text_color : Color = Color("dfdfdf")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# setters
func _set_server_name(new_name : String):
	server_name = new_name
	name_label.text = new_name
	
func _set_server_host(new_host : String):
	server_host = new_host
	host_label.text = new_host
	
func _set_server_map(new_map : String):
	server_map = new_map
	map_label.text = new_map
	
func _set_curr_player_count(new_count : int):
	curr_player_count = new_count
	player_count_label.text = str(curr_player_count) + "/" + str(max_player_count)
	
func _set_max_player_count(new_count : int):
	max_player_count = new_count
	player_count_label.text = str(curr_player_count) + "/" + str(max_player_count)
	
func _set_joinable(new_val : bool):
	joinable = new_val
	join_button.disabled = !joinable
	for child : Control in $Margins/Row.get_children():
		child.modulate = enabled_text_color if joinable else disabled_text_color
	pass
