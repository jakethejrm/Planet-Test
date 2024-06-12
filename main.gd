extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()
@onready var ms = $Level/MultiplayerSpawner

func _ready():
	
	#Steam.lobby_joined.connect()
	
	
	ms.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	$MainMenu.host.connect(_on_main_menu_host)
	#CameraSettings.change_camera.connect(on_switch_camera)
	#CameraSettings.update_hp.connect(on_update_hp)
	#CameraSettings.update_fuel.connect(on_update_fuel)
	

func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a

func _on_main_menu_join_lobby(id):
	peer.connect_lobby(id)
	lobby_id = id
	multiplayer.multiplayer_peer = peer
	$MainMenu.hide()
	$MainMenu/Camera.enabled = false
	$LoadingScreen.hide()
	$LoadingScreen/Camera.enabled = false
	$Level.show()
	pass # Replace with function body.


func _on_main_menu_host():
	print("hi4")
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	ms.spawn("res://scenes/levels/Earth 1.tscn")
	$MainMenu.hide()
	$MainMenu/Camera.enabled = false
	$Level.show()
	
func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str("hi"))
		Steam.setLobbyData(lobby_id, "gravity_gunners", "true")
		Steam.setLobbyJoinable(lobby_id, true)

	pass # Replace with function body.


#func on_switch_camera(node :Node2D):
	#$Level/Camera.player = node
	#$Level/Camera.enabled = true
	#
#func on_update_hp(new_hp, max_hp):
	#$Level/Camera/Hud._on_player_update_hp(new_hp, max_hp)
	#
#func on_update_fuel(new_fuel, max_fuel):
	#$Level/Camera/Hud._on_player_update_fuel(new_fuel, max_fuel)
