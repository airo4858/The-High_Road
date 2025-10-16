using Godot;
using System;
using System.IO.Ports;

public partial class Arduino : Node
{
	SerialPort serialPort;
	
	private Node LeftArm;
	private Node RightArm;
	private Node controller;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		LeftArm = GetNode("/root/Main/ProtoController/LeftArm");
		RightArm = GetNode("/root/Main/ProtoController/RightArm");
		controller = GetNode("/root/Main/ProtoController");
		serialPort = new SerialPort("COM3",9600);
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
		int SensorButton = int.Parse(parts[3]);
		GD.Print(Sensor0);
		GD.Print(Sensor1);
		GD.Print(Sensor2);
		GD.Print(SensorButton);
		
		//Camera Rotation
		if (Sensor2 >= 600)
			controller.Call("set_input_direction", -0.8);
		else if (Sensor2 <= 424)
			controller.Call("set_input_direction", 0.8);
		else
			controller.Call("set_input_direction", 0.0);
		
		//Left Arm Rotation
		float leftSensor = (float)Sensor1;
		float left_degrees = -0.07109375f * leftSensor - 27.2f;
		controller.Call("set_left_arm_rotation", left_degrees);
		
		//Right Arm Rotation
		float rightSensor = (float)Sensor0;
		float right_degrees = -0.07109375f * rightSensor - 27.2f;
		controller.Call("set_right_arm_rotation", right_degrees);
	}
}
