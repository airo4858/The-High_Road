using Godot;
using System;
using System.IO.Ports;

public partial class Arduino : Node
{
	SerialPort serialPort;
	
	private Node LeftArm;
	private Node RightArm;
	private Node controller;
	private Node Main;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		LeftArm = GetNode("/root/Main/ProtoController/LeftArm");
		RightArm = GetNode("/root/Main/ProtoController/RightArm");
		controller = GetNode("/root/Main/ProtoController");
		Main = GetNode("/root/Main");
		serialPort = new SerialPort("COM6",9600);
		serialPort.Open();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (!serialPort.IsOpen) return;
		
		string Sensor = serialPort.ReadLine();
		//Sensor = Sensor + "|0";
		string[] parts = Sensor.Split('|');
		
		int Sensor0 = int.Parse(parts[0]);
		int Sensor1 = int.Parse(parts[1]);
		int Sensor2 = int.Parse(parts[2]);
		int SensorButton = int.Parse(parts[3]);
		//GD.Print(Sensor0);
		//GD.Print(Sensor1);
		//GD.Print(Sensor2);
		//GD.Print(SensorButton);
		
		//Camera Rotation
		if (Sensor1 >= 284)
			controller.Call("set_input_direction", -0.8);
		else if (Sensor1 <= 262)
			controller.Call("set_input_direction", 0.8);
		else
			controller.Call("set_input_direction", 0.0);
		
		//Left Arm Rotation
		float leftSensor = (float)Sensor0;
		float left_degrees = leftSensor;
		controller.Call("set_left_arm_rotation", left_degrees);
		
		//Right Arm Rotation
		float rightSensor = (float)Sensor2;
		float right_degrees = rightSensor;
		controller.Call("set_right_arm_rotation", right_degrees);
		
		//Button Movement
		controller.Call("move_player", SensorButton);
		Main.Call("start_game", SensorButton);
	}
}

//float left_degrees = -0.07109375f * leftSensor - 27.2f;
