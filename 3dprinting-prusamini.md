# Magic Number
Uses a 1.8 degree stepper with a leadscrew with 4mm lead. This makes the distance corresponding to a full step 4/200 = 0.02mm. Your layer height should be a multiple of this.
Source: https://github.com/prusa3d/Original-Prusa-MINI/blob/master/DOCUMENTATION/ELECTRONICS/mini-motor-kit.pdf


# Belt Tension
Recommended belt tension:
- 92Hz for the lower (Y-axis) belt
- 85Hz for the X-axis belt.

The Android app Spectroid is a good tool for this.


# Cold Pull
- Ensure Hotend is pushed all the way to the right side of the arm to reduce stresses.
- Use a 10mm to remove the top nut on the extruder.


# Changing Nozzle
Reference 
https://help.prusa3d.com/article/changing-replacing-the-nozzle-mini_134235


## Prep
- 16mm wrench/spanner, or an adjustable wrench to secure the heater block
  - A very large spanner or an adjustable wrench can quickly drain heat from the heater block and may cause a Thermal runaway error, depending on how it grips the block.
- A pair of pliers or a 7mm socket to unscrew the nozzle
- Non-flammable surface to place the used hot nozzle on (i.e. plate or aluminum foil).
- Unload the filament. Optionally, do a coldpull.


## Steps
- Preheat to 230c
- Clean the heat block and nozzle as necessary (brass brush)
- Preheat to 270-280c
- Move Z axis up to max
- Hold Heat Block with wrench to prevent twisting
- Use 7mm socket to unscrew the HOT nozzle and place in tray
- Insert new nozzle and screw until it stops moving (not excessive)
- Ensure a small gap between nozzle top and heat block after installing (~.5mm)
- Clean the print bed
- Perform first layer calibration

