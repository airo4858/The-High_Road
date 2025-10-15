using Godot;
using System;
using System.IO.Ports;

public partial class Arduino : Node
{
	SerialPort serialPort;
	
	//[Export] CharacterBody3D ProtoController;
	
	//Node LeftArm;
	//Node RightArm;
	private Node controller;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//LeftArm = GetNode("/root/ProtoController/LeftArm");
		//RightArm = GetNode("/root/ProtoController/RightArm");
		controller = GetNode("/root/Main/ProtoController");
		serialPort = new SerialPort("COM3",9600);
		//serialPort.PortName = "COM3";
		//serialPort.BaudRate = 9600;
		serialPort.Open();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (!serialPort.IsOpen) return;
		
		string Sensor = serialPort.ReadLine();
		string[] parts = Sensor.Split('|');
		
		int Sensor0 = int.Parse(parts[0]);
		int Sensor1 = int.Parse(parts[1]);
		int Sensor2 = int.Parse(parts[2]);
		GD.Print(Sensor0);
		GD.Print(Sensor1);
		GD.Print(Sensor2);
		
		if (Sensor2 >= 600)
			controller.Call("set_input_direction", -0.8);
		else if (Sensor2 <= 424)
			controller.Call("set_input_direction", 0.8);
		else
			controller.Call("set_input_direction", 0.0);
	}
	//public int camera_control()
	//{
		//string Sensor = serialPort.ReadLine();
		//string[] parts = Sensor.Split('|');
		//
		//int Sensor0 = int.Parse(parts[0]);
		//int Sensor1 = int.Parse(parts[1]);
		//int Sensor2 = int.Parse(parts[2]);
		////GD.Print(Sensor0);
		////GD.Print(Sensor1);
		//GD.Print(Sensor2);
		//return Sensor2;
		////if (Sensor2 >= 600)
			////controller.Call("set_input_direction", -0.8);
		////else if (Sensor2 <= 424)
			////controller.Call("set_input_direction", 0.8);
		////else
			////controller.Call("set_input_direction", 0.0);
	//}
}
