## KineticSet
###### v1.0.0.1

Moves the selected fixture according to Incoming or Internal Art-Net

[Youtube Link](https://www.youtube.com/watch?v=iBeWw8SVQKE)

[![In Action](https://img.youtube.com/vi/iBeWw8SVQKE/0.jpg)](https://www.youtube.com/watch?v=iBeWw8SVQKE)

### Notes:

The code for this plugin will remain private until official API Documents are available.

### Usage:

#### Calling the Plugin
`Call Plugin "<PluginName>" "[Stop|Start,<FID>, <Speed Pos Z>[, <Speed Pos Y>, <Speed Pos X>, <Speed Rot Z>, <Speed Rot Y>, <Speed Rot X>, <Scale Pos Z>, <Scale Pos X>, <Scale Pos Y>]]"`

- Stop Stops the Plugin from listening to incoming DMX
- Start Starts the plugin using the following configuration options:
  - **FID** - The fixture to move
  - **Speed Pos (X, Y, Z)** - The speed in meters/minute to move the selected axis, if set to 0 this axis will be ignored
  - **Speed Rot (X, Y, Z)** - The speed in Degrees/minute to move the selected rotation, if set to 0 axis will be ignored.
  - **Scale Pos (X, Y, Z)** - The number in meters to move, Z = 0 to Z, X and Y = -(X,Y)/2 to +(X,Y)/2


Each plugin is responsible for positioning and rotating a single object, that object can have sub objects for example, move the truss and make the fixtures sub objects of the truss

##### Example
`Call Plugin 1 "Start,1001,8.5,0,0,20,0,0,10,0,0"`

Sets up Plugin 1 to move FID 1001 on the Z axis 8.5m/minute between 0m and 10m, also rotate around Z(?) at 20 degrees/minute.

  
#### Configuring the DMX input

Each plugin can be controlled via a DMX remote. to setup the remote:

- Go to Menu > In & Out > DMX Remotes
- Enable Input
- Target - select the plugin to move for the desired object
- Fader
    - Master = Position Z
    - X = Position X
    - XA = Position Y
    - XB = Rotation Z
    - Temp = Rotation X
    - Rate = Rotation Y
- Address - Universe.Address
![Input Example](https://github.com/hossimo/GMA3Plugins/blob/feature-kineticset-upload/Images/KeneticDMXRemoteSetup.png)

Things to-do:

- Add Distance Scale for Position X, Y, Z (Just need to code it up)
- Add `Call Plugin x "Store"` to Store the current positions in UserVars
- Add `Call Plugin x "Racall"` to put the fixtures back in their original position/rotations.
- Change Start and Stop to UserVars to avoid conflicting plugins being out of sync.
- Fix BUGS!

### Releases:

- 1.0.0.1 - Initial Release
