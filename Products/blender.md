# Setup for 3D Print Modeling


## Edit > Preferences


### Interface
- Resolution Scale: 1.25
- Line Width: Thick


### Themes
- 3d Viewport > Wire Edit: [a bright blue]
- 3d Viewport > Vertex Size: 4px


### Addons
- Edit > Preferences > Addons
- 3D View: MeasureIt
- 3D View: Stored Views
- Add Mesh: BoltFactory
- Add Mesh: Extra Objects
- Import-Export: Autocad DXF Format
- Mesh: 3D-Print Toolbox
- Mesh: F2
- Mesh: tinyCAD Mesh tools
- Object: Align Tools
- Object: Bool Tool
- Interface: Modifier Tools


### Keymap
- Preferences > Spacebar Action: Search


### System
- Undo Steps: 256

Hamburger Icon > Save Preferences


## Scene (bottom right)


### Units
- Unit Scale: 0.001
- Length: Millimeters


## Viewport Overlays Button (Top Right in Viewport)
- Scale: 0.001
- Statistics: Check


## Status Bar > (Right Click)
- Scene Statistics: Check
- System Memory: Check
- Video Memory: Check


## Side Menu (n key)


### View
- Clip Start: 0.1
- End: 100000


### Tool Tab
- Click the tab so we can save it as the default tab.


## Clear Scene
- Select all objects in the scene and delete


## Save Startup File
File > Defaults > Save Startup File


# External Addons
Recommended
- CAD Transform for blender
  - https://blender-archipack.gumroad.com/l/nQVcS
- Outline to SVG
  - https://makertales.gumroad.com/l/O2SVG
- Create ISOCam
  - https://makertales.gumroad.com/l/iqfad
Install
Edit > Preferences > Add-Ons > Install...


# Hotkeys and Shortcuts
Camera
- Numpad .	    	  Camera to Object
- Numpad 1-9	  	  Snap Camera
- Control + Middle	Zoom
- SHIFT + Middle  	Pan Camera
- SHIFT + C			    Center Scene and cursor


Interface
- N               Open side bar


3d Cursor (the red and white circle with crosshair)
- SHIFT + S       Origin Menu popup
- SHIFT + RCLICK  Snap onto an object
- SHIFT + RCLICK  (and hold) Drag cursor around
  - Swap to CTRL  While still holding mouse click to snap to selected "Snap to"
- SHIFT + C       Center 3d cursor to original point in center of scene


Modes
- TAB             Toggles EDIT mode, when an object is selected


Object Mode
- SHIFT + A       Add Menu popup
- SHIFT + D       Duplicate selected object
  - XYZ           Constrain to # Axis
  - SHIFT + XYZ   Constrain to the OTHER two axes\
  - \# (a Number) Snap to that number on the selected plane
  - ENTER         Confirm final placement of duplicate
- G               Grab an object
  - R             Begin rotating the grabbed object
    - XYZ         Constrain rotation to the selected axis
    - R (again)   Rotate on Local Axes
  - S             Start scaling the grabbed object
    - S (again)   Scale on Local Axes
    - XYZ         Constrain scaling to the selected axis
  - XYZ           Start dragging the grabbed object on the chosen axis
    - XYZ (again) Move on Local Axes
  - /#            Used after any of the above modes to perform that action by the number(s) pressed

Edit Mode
- 1               Vertex Select
- 2               Edge Select
- 3               Face Select
- ALT+Z           Toggle x-ray
- P               Separate the meshes within an object into separate objects
- F2              Rename selected object


Tools
- W               Select Tool (press again to toggle between tool subtypes)
- C               Circle selection tool
- G               Grab an object to MOVE it


Selection Tool
- SHIFT           Inrease selection
- CONTROL         Decrease selection
- A               Select everything in the scene
- CONTROL + NUM+  Grow selection
- CONTROL + L     Select entire mesh linked to current selection
- CONTROL + I     Invert selection
- CONTROL + D     Duplicate selection
- X               Popup the delete menu based on selection and mode
- Z               (or X or Z) Constrain object movement to the specificed axis
- SHIFT + Z       (or X or Z) Constrain object movement to the remaining two axis (X,Y in this case)
- F9              Popup original creation quick menu


# Snap One Object to Another
- Determine corner/face that will snap to another object, then set it as the first object's Origin
  - Object mode > Select object
  - Set the origin 
  - SHIFT + Right Click to set 3d Cursor (hold control to snap to vertex/face)
  - Right click > Set Origin > Origin to 3d Cursor
- Determine the corner/face that the first object should snap/move its Origin to, then set the 3d Cursor there, then snap
  - SHIFT + Right Click to set 3d Cursor (hold control to snap to vertex/face)
  - SHIFT + S > Selection to Cursor


# Split Two Meshes to Two Objects
- Enter Edit mode
- Select one object's random vertex
- Push L to extend to all linked vertices
- Push P to split
- By Selection


# Merge Two Objects
- Select both via SHIFT + Click
  - Select the PRIMARY object last, as this will be the object whose details are retained
- CONTROL + J


# Change Dimensions (Safely) Of an Object
- Object Mode
- Select the object
- Press N > Item tab
- Set Dimensions
- CONTROL + A to bring up Apply menu
- Select Scale


# Make Text 3d
- Enter Object Mode
- Shift+A > Text
- TAB > Type in the text you want
- Navigate in bottom right to Data (letter a)
- Transform > Set Size
- Font > Select Font
- Geometry > set Extrusion
- Export as .STL


# STL Import Tips
- After import, Press [x] then Limited Dissolve
- Set Max Angle to 0.1 or similar


# CAD Transforms Addon
- Right click icon, set hotkey to ALT + C
- G to grab and go into "move" mode
  - XYZ to set axis
    - click any other point to set the plane of rotation
      - XYZ (same one again) to go to Global
  - Spacebar to clear snaps. You can then use the below on both initial click and 2nd click
    - E to snap to edges
    - F to snap to faces
    - V to snap to vertices
    - Shift and any of the above to use CENTER of that edge/face/vertice
    - A to move to the halfway point between the first and 2nd points
  - R to go into rotate mode
    - XYZ to set axis
    - click any other point to set the plane of rotation
      - - XYZ (same one again) to go to Global
  - S to go into scaling mode
    - XYZ to set axis
    - click any other point to set the plane of rotation
      - XYZ (same one again) to go to Global
    - Click "from"
    - Click "to" and scaling begins in the direction between those two points
    - Tab to enable two-dimensional scaling
      - Tab to enable three-dimensional scaling


# Backup Your Settings



## Resources
- https://blenderartists.org