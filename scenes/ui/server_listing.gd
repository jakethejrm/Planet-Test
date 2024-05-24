extends PanelContainer

@export var name_label : Label
@export var host_label : Label
@export var map_label : Label
@export var player_count_label : Label
@export var join_button : Button

@export var lobby_id : int : set = _set_lobby_id
@export var server_name : String : set = _set_server_name
@export var server_host : String : set = _set_server_host
@export var server_map : String : set = _set_server_map
@export var curr_player_count : int : set = _set_curr_player_count
@export var max_player_count : int : set = _set_max_player_count
@export var joinable : bool : set = _set_joinable
@export var disabled_text_color : Color = Color("787878")
@export var enabled_text_color : Color = Color("dfdfdf")

signal join_lobby(lobby_id : int)

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

func _set_lobby_id(new_id : int):
	lobby_id = new_id
	server_name = Steam.getLobbyData(lobby_id, "name")
	curr_player_count = Steam.getNumLobbyMembers(lobby_id)
	max_player_count = Steam.getLobbyMemberLimit(lobby_id)
	server_host = Steam.getLobbyData(lobby_id, "username")
	server_map = Steam.getLobbyData(lobby_id, "map")
	joinable = curr_player_count < max_player_count
	pass


func _on_join_button_pressed():
	join_lobby.emit(lobby_id)
	pass # Replace with function body.
