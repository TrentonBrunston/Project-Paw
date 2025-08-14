extends Node

#signal connect_server;
#signal connect_client;
#signal disconnect_multiplayer;

@export var maxPlayers: int;

var port: int;				   # the port number
var peer: ENetMultiplayerPeer; # what we need to set up a multiplayer connection

@onready var isHost: bool = false;
@onready var ipAddress: String = "127.0.0.1";
@onready var messageStack: Array[Control] = [];

func _ready() -> void:
	multiplayer.peer_connected.connect(onPlayerConnected);
	multiplayer.peer_disconnected.connect(onPlayerDisconnected);
	
	multiplayer.connected_to_server.connect(onServerConnected);
	multiplayer.connection_failed.connect(onServerConnectionFailed);
	multiplayer.server_disconnected.connect(onServerDisconnected);
	
	port = GenerateRandomPort();
	$HostContainer/PortLabel.set_deferred("text", "Your port number is %d." % port);


func _on_host_btn_pressed() -> void:
	isHost = true;
	DisplayHostMenu();
	
	peer = ENetMultiplayerPeer.new();
	var error = peer.create_server(port, maxPlayers)
	if error != OK:
		print("Cannot host: %d" % error);
		return;
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	
	multiplayer.set_multiplayer_peer(peer);
	print("Waiting for players...");
	#connect_server.emit();


func _on_join_btn_pressed() -> void:
	DisplayJoinMenu();
	

func _on_host_back_btn_pressed() -> void:
	isHost = false;
	
	peer = multiplayer.get_multiplayer_peer();
	peer.disconnect_peer(1);
	peer.close();
	
	port = GenerateRandomPort();
	$HostContainer/PortLabel.set_deferred("text", "Your port number is %d." % port);
	DisplayMainMenu();
	#disconnect_multiplayer.emit();


func _on_join_join_btn_pressed() -> void:
	DisplayUpdateScreen();
	
	peer = ENetMultiplayerPeer.new();
	peer.create_client(ipAddress, port);
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	multiplayer.set_multiplayer_peer(peer);
	#connect_client.emit();


func _on_join_back_btn_pressed() -> void:
	DisplayMainMenu();


func _on_update_back_btn_pressed() -> void:
	if isHost:
		DisplayHostMenu();
	else:
		DisplayJoinMenu();
	
	var peerId = multiplayer.multiplayer_peer.get_unique_id();
	multiplayer.multiplayer_peer.disconnect_peer(peerId);
	#disconnect_multiplayer.emit();


func _on_enter_port_text_edit_text_changed() -> void:
	port = int($JoinContainer/PortContainer/EnterPortTextEdit.text);


@rpc("any_peer", "call_local")
func StartGame() -> void:
	pass
	# TODO load the main game scene


func onPlayerConnected(id: int) -> void:
	print("Connected player %d" % id);
	AddPlayerToList(id);


func onPlayerDisconnected(id: int) -> void:
	print("Disconnected player %d" % id);
	RemovePlayerFromList(IndexOfPlayer(id));
	

# called from client only
func onServerConnected() -> void:
	print("Connected to server!");
	$UpdateContainer/UpdateLabel.text = "Session Found!";


# called from client only
func onServerConnectionFailed() -> void:
	print("Failed to connect to server!");
	$UpdateContainer/UpdateLabel.text = "Failed to join session!";


# called from client only?
func onServerDisconnected() -> void:
	print("Disconnected from server!");
	$UpdateContainer/UpdateLabel.text = "Disconnected from session!";


func DisplayMainMenu() -> void:
	$MainContainer.visible = true;
	$HostContainer.visible = false;
	$JoinContainer.visible = false;
	$UpdateContainer.visible = false;


func DisplayHostMenu() -> void:
	$MainContainer.visible = false;
	$HostContainer.visible = true;
	$JoinContainer.visible = false;
	$UpdateContainer.visible = false;


func DisplayJoinMenu() -> void:
	$MainContainer.visible = false;
	$HostContainer.visible = false;
	$JoinContainer.visible = true;
	$UpdateContainer.visible = false;


func DisplayUpdateScreen() -> void:
	$MainContainer.visible = false;
	$HostContainer.visible = false;
	$JoinContainer.visible = false;
	$UpdateContainer.visible = true;


func GenerateRandomPort() -> int:
	return randi_range(0, 65536);


func AddPlayerToList(id: int) -> void:
	var offsetY = 20 * (messageStack.size() + 1); # Offset the new label to prevent overlapping
	var playerLabel = $HostContainer/SpaceBuffer2.duplicate();
	playerLabel.text = "Player %d has joined!" % id;
	playerLabel.name = "Player%dLabel" % id;
	playerLabel.position = Vector2($HostContainer/SpaceBuffer2.position.x, $HostContainer/SpaceBuffer2.position.y - offsetY);
	$HostContainer.add_child(playerLabel);
	messageStack.append(playerLabel);


func RemovePlayerFromList(index: int) -> void:
	if index == -1:
		return;
		
	$HostContainer.remove_child(messageStack[index]);
	messageStack.remove_at(index);


func IndexOfPlayer(id: int) -> int:
	for i in range(messageStack.size()):
		if messageStack[i].name == "Player%dLabel" % id:
			return i;
	return -1;
