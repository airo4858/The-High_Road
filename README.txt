Created by Aidan Rogers with controller support by Danny Rankin

Welcome to The High Road! Do you think you have what it takes to climb all the way to the top
of the mountain and reach the tippity top that you've desired so much? Well that's too bad!
Unfortunately, you are stuck in the body of a baby, and the only way you can reach the top of
the mounatiain is by controlling your hiker buddy to get you there. But don't think it's that
easy! Other babies will try to take you down as you begin to ascend the mountain, so you'll
have to fight your way to the top! Can you take The High Road and be crowned Infant Ruler
of The Mountain Top? There's only one way to find out!

For the prefered way to play, set up your mannequin in front of you. Stand right behind it, 
and by moving the arms up and down is how you control how you punch your enemies. Tilting the
waist side to side is how you'll controll which direction you move, and squeeze the arms to bring
your hiker to a stop.
For a keyboard setup, moving forward is controlled by the up arrow, and camera movements are
controlled by A and D. Punching mechanics not yet set up.

The current Arduino code is set up so that there are 3 potentiometers set up on the Analog options
A0, A1, and A2, with camera movement being connected to A2, and the arms will be connected to 
A0 and A1. The Arduino code is available to download in the game files. It's also important to
download the System.IO.Ports from dotnet through the Godot console,
dotnet add package System.IO.Ports --version 7.0.0
