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

## Overlays Buttom (Top Right)
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

## External Addons
- CAD Transform for blender
  - https://bit.ly/CADmoveBlender

# Hotkeys and Shortcuts
Camera
- Numpad .	    	Camera to Object
- Numpad 1-9	  	Snap Camera
- Control+Middle	Zoom
- SHIFT+Middle  	Pan Camera
- SHIFT+C			    Center Scene and cursor

Interface
- N               Open side bar


3d Cursor
- SHIFT + S       Origin Menu popup
- SHIFT + A       Add Menu popup
- SHIFT + RCLICK  Snap onto an object
- SHIFT + RCLICK  (and hold) Drag cursor around

Modes
- TAB             Toggles EDIT mode, when an object is selected

Edit Mode
- 1               Vertex Select
- 2               Edge Select
- 3               Face Select
- ALT+Z           Toggle x-ray

Tools
- W               Select Tool (press again to toggle between tool subtypes)
- C               Circle selection tool

Selection Tool
- SHIFT           Inrease selection
- CONTROL         Decrease selection
- A               Select everything in the scene
- CONTROL + NUM+  Grow selection
- CONTROL + L     Select entire mesh linked to selection
- CONTROL + I     Invert selection
- CONTROL + D     Duplicate selection
- X               Popup the delete menu based on selection and mode
- Z               (or X or Z) Constrain object movement to the specificed axis
- SHIFT + Z       (or X or Z) Constrain object movement to the remaining two axis (X,Y in this case)
- F9              Popup original creation quick menu

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


## Resources
- https://blenderartists.org