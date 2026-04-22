# Cleaning
- IPA works ok
- Ethanol works better
- Mean Green is a good budget option among various "degreaser" comparisons

Mercury X Wash and Cure Bundle
- Typically wash and cure each for 5-6min. Increase for higher print complexity, possibly moving/flipping in the cure station every 2-3min
- Filter out and cure waste after 30 uses.

# Calibration
Cones of Calibration, by Tabletop Foundry
- youtu.be/o2ySL-Sw8QI
- https://www.tableflipfoundry.com/_files/archives/dba9ae_79fdc9c846f44461979f9b0bca9986ae.zip?dn=The%20Cones%20of%20Calibration.zip
- Increment exposure time DOWN if the FAILURE side is printing the top cones
- Increment exposure time UP if the SUCCESS side is failing to print top cones
- Increment by 0.1s, or 0.05s as you get closer

# Lychee Miniature Workflow

# 3d Printer
- Add New Resin
- Add specific resin
  - Elegoo ABS-Like Grey is my most common

## Layout
- Drag model into window
- Move > Click On Platform
- Rotate > Angle the model backwards 40-50 degrees, so the parts you want to see most are not suported (e.g. faces)
  - Sometimes tipping a bit more, less, to the left or right is helpful.

## Prepare
- Select the model
- Layout
  - Rotate back 10-40deg so face is on looking up
- Prepare
  - Click Light
  - Click Auto
    - Change Supports density to Ultra
    - Change Serach for Ground to the maximum
    - Dropdown by Generate Automatic Supports > Supports On Gorund Only
  - Click Island
    - Set Accuracy to Real
    - Click Search Selected
      - Cllick Add supports to all islands
      - If any spots fail, add new "Light" or "Mini Supports" where the red dots show up
  - REMOVE supports as needed.
    - Most supports on areas NOT marked as an overhand.
    - NOTE that if removing a support causes the overhang highlighting to disappear, you've just removed a support on an island. Just use the Island button to readd it.
  - Add supports as needed
    - Try to attach to existing bases if able (hold ALT on the model, then the support base)
    - Only make a support "mini" if
      - ... it's in a tiny spot and you need the support but don't intend to remove it (well hidden)
      - ... after making a Light support, the angles are so wonky that it makes no sense and should be converted to mini to simplify
  - Click Medium
    - Add Medium supports all the way around the mini's base, in a circle near the edge  
  - Click Raft 
    - Select Shape Wall

## Back to Layout
Only if you want multiple copies in one print 
- Select a model
- Copy > Set Number of (Extra) Copies
- Click Duplicate Selection

## Saving
- Save each model as its own .lys file
- When you prepare to print, import these models into a "plate print" file


## Export
- Export Slices to File (.ctb for Elegoo Saturn 2)

