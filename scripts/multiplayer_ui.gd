extends Node

#signal connect_server;
#signal connect_client;
#signal disconnect_multiplayer;

@export var maxPlayers: int;

var port: int;				   # the port number
var peer: ENetMultiplayerPeer; # what we need to set up a multiplayer connection

@onready var isHost: bool = false;
@onready var ipAddress: String = "127.0.0.1";

func _ready() -> void:
	multiplayer.peer_connected.connect(onPlayerConnected);
	multiplayer.peer_disconnected.connect(onPlayerDisconnected);
	multiplayer.connected_to_server.connect(onServerConnected);
	multiplayer.connection_failed.connect(onServerConnectionFailed);
	
	port = GenerateRandomPort();
	$HostContainer/PortLabel.set_deferred("text", "Your port number is %d." % port);


func _on_host_btn_pressed() -> void:
	isHost = true;
	DisplayHostMenu();
	
	peer = ENetMultiplayerPeer.new();
	var error = peer.create_server(port, maxPlayers)
	if error != OK:
		print("Cannot host: " + error.name);
		return;
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	
	multiplayer.set_multiplayer_peer(peer);
	print("Waiting for players...");
	#connect_server.emit();


func _on_join_btn_pressed() -> void:
	DisplayJoinMenu();
	

func _on_host_back_btn_pressed() -> void:
	isHost = false;
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
	
	#disconnect_multiplayer.emit();


func _on_enter_port_text_edit_text_changed() -> void:
	port = int($JoinContainer/PortContainer/EnterPortTextEdit.text);


func onPlayerConnected(id: int) -> void:
	print("Connected player %d" % id);
	# TODO push update message to stack and update UI


func onPlayerDisconnected(id: int) -> void:
	print("Disconnected player %d" % id);
	# TODO push update message to stack and update UI
	

# called from client only
func onServerConnected() -> void:
	print("Connected to server!");
	# TODO update UI with connection message


# called from client only
func onServerConnectionFailed() -> void:
	print("Failed to connect to server!");
	# TODO update UI with connection failed message


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
