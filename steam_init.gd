extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_steam()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize_steam() -> void:
	var initialize_response : Dictionary = Steam.steamInitEx(true, 480)
	print("Did Steam Initialize? : %s " % initialize_response)
	
	if initialize_response['status'] > 0:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)
		get_tree().quit()
	
	pass
