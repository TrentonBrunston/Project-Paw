using Godot;
using System;


public partial class MultiplayerUI : Node
{
	public int MaxPlayers { get; private set; }
	public int Port { get; private set; }
	
	private ENetMultiplayerPeer peer;
	private string ipAddress = "127.0.0.1";
	
	public MultiplayerUI()
	{
		Port = GenerateRandomPort();
		Peer = new ENetMultiplayerPeer();
	}
	
	private void OnHostBtnPressed()
	{
		
	}
	
	private void OnJoinBtnPressed()
	{
		
	}
	
	private void OnHostBackBtnPressed()
	{
		
	}
	
	private void OnJoinJoinBtnPressed()
	{
		
	}
	
	private void OnJoinBackBtnPressed()
	{
		
	}
	
	private void OnUpdateBackBtnPressed()
	{
		
	}
	
	private void OnEnterPortTextEditTextChanged()
	{
		
	}
	
	private void StartGame()
	{
		
	}
	
	private void OnPlayerConnected()
	{
		
	}
	
	private void OnPlayerDisconnected()
	{
		
	}
	
	// called from client side only
	private void OnServerConnected()
	{
		
	}
	
	// called from client side only
	private void OnServerDisconnected()
	{
		
	}
	
	// called from client side only
	private void OnServerConnectFailed()
	{
		
	}
	
	private void DisplayMainMenu()
	{
		
	}
	
	private void DisplayHostMenu()
	{
		
	}
	
	private void DisplayJoinMenu()
	{
		
	}
	
	private void DisplayUpdateScreen()
	{
		
	}
	
	private int GenerateRandomPort()
	{
		Random rand = new Random();
		return rand.Next(65536);
	}
	
	private void AddPlayerToList(int id)
	{
		
	}
	
	private void RemovePlayerFromList(int index)
	{
		
	}
	
	private void IndexOfPlayer(int id)
	{
		
	}
}
