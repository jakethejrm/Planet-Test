extends Control

signal join_lobby(lobby_id : int)
signal back

func _on_back_button_pressed():
	back.emit()
	pass # Replace with function body.


func _on_refresh_button_pressed():
	fetch_lobbies()
	pass # Replace with function body.

func _ready():
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	pass


func fetch_lobbies():
	for child in $MarginContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer.get_children():
		child.queue_free()
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()

func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		if Steam.getLobbyData(lobby, "gravity_gunners"):
			var lobby_listing = preload("res://scenes/ui/server_listing.tscn").instantiate()
			lobby_listing.lobby_id = lobby
			lobby_listing.join_lobby.connect(on_join_lobby)
			$MarginContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer.add_child(lobby_listing)

func on_join_lobby(lobby_id : int):
	join_lobby.emit(lobby_id)
	
