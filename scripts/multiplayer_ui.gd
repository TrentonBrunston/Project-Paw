extends Node

signal connect_server;
signal connect_client;
signal disconnect_multiplayer;

@onready var isHost: bool = false;

func _ready() -> void:
	pass


func _on_host_btn_pressed() -> void:
	isHost = true;
	DisplayHostMenu();
	connect_server.emit();


func _on_join_btn_pressed() -> void:
	DisplayJoinMenu();
	

func _on_host_back_btn_pressed() -> void:
	isHost = false;
	DisplayMainMenu();
	disconnect_multiplayer.emit();


func _on_join_join_btn_pressed() -> void:
	DisplayUpdateScreen();
	connect_client.emit();


func _on_join_back_btn_pressed() -> void:
	DisplayMainMenu();


func _on_update_back_btn_pressed() -> void:
	if isHost:
		DisplayHostMenu();
	else:
		DisplayJoinMenu();
	
	disconnect_multiplayer.emit();


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
	
