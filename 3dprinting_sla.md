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
  - Rotate back 40deg so face is on looking up
- Prepare
  - Click Light
  - Click Auto
    - Change Supports density to Ultra
    - Generate Automatic Supports
  - Click Island
    - Set Accuracy to Real
    - Click Search Selected
      - Cllick Add supports to all islands
      - If any spots fail, add new "Light" or "Mini Supports" where the red dots show up
  - REMOVE supports as needed. Tiny supports that don't make any sense often occur.
  - Add supports as needed
    - Remember you can hold ALT to force connection points when creating a support
    - Remember you can make a "normal" support then check the box for "Mini Support"
  - Click Medium
    - Add Medium supports all the way around the mini's base, in a circle near the edge  
  - Click Raft 
    - Select Shape Wall
  - Click Manual
    - Bracings
    

## Back to Layout
Only if you want multiple copies in one print 
- Select a model
- Copy > Set Number of (Extra) Copies
- Click Duplicate Selection

## Export
- Export Slices to File (.ctb for Elegoo Saturn 2)