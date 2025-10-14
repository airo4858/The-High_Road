using Godot;
using System;
using System.IO.Ports;

public partial class Arduino : Node
{
	SerialPort serialPort;
	
	Area3D LeftArm;
	Area3D RightArm;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		LeftArm = GetNode<Area3D>("Area3D");
		RightArm = GetNode<Area3D>("Area3D");
		serialPort = new SerialPort();
		serialPort.PortName = "COM3";
		serialPort.BaudRate = 9600;
		serialPort.Open();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (!serialPort.IsOpen) return;
		
		int Sensor = serialPort.readLine()
		
		
	}
}
