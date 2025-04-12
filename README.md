# Fishquest
Fishquest is an arcade inspired fishing game created over the course of a semester for Introduction to Technological Systems at Simon Fraser University. The goal of Fishquest is to control a crane like fishing apparatus to catch magnetic fish and score points using physical sensors. Additionally, bonus points can be obtained by catching fish with the correct colour.

### Code
Fishquest was built using Processing and Arduino. The processing application makes up the bulk of the codebase, receiving and interpreting the data sent by the microcontroller in order to implement visuals, UI, and make the game element of fishquest function. The Arduino code takes in input from sensors and controls the physical outputs as well as the state of the system and processing application with game-states and the microcontroller's internal clock.

> [!NOTE]
> The processing application only receives data and interprets it, it does not send any data to the microcontroller

The core files in the processing application are the checkBuffer file which handles all the reading and interpreting the incoming data from the microcontroller from serial, the main fishquest file which is the main loop of the system and some other more important methods, and the Game_Logic file which contains the actual logic for the different states of the game. Most of the other files relate to visuals or were used for debugging and development.

### Components
Fishquest was made using the following sensors and actuators:
- 1 Rotation sensor
	- Controls the left/right rotation of the fishing rod
- 1 Slide senor
	- Controls the up/down rotation of the fishing rod
- 1 Button
	- Used for general input and to reel in/out the fishing line
- 1 DC motor
	- reels in and out the fishing line
- 3 High torque servo motors
	- Two of the three rotate the fishing rod up and down while the third rotates it left and right
- 1 Light sensor
	- Reads the light of the room to change between day and night
- 1 Colour sensor
	- Used for reading the colour of colour of caught fish for scoring
