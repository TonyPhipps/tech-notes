# Prusa Mini+
## Magic Number
Uses a 1.8 degree stepper with a leadscrew with 4mm lead. This makes the distance corresponding to a full step 4/200 = 0.02mm. Your layer height should be a multiple of this.
Source: https://github.com/prusa3d/Original-Prusa-MINI/blob/master/DOCUMENTATION/ELECTRONICS/mini-motor-kit.pdf

# Filament Calibration
Perform these steps with any new filament brand or type. This is especially the case if, after changing to a different filament spool, you notice oddities like peeling off the bed surface.

Start with a "Generic profile"

## Checkpoint 1 - Ensure bed is clean
- Dawn dish soap and hot water, then window cleaner, then IPA

## Checkpoint 2 - Calibrate temperatures and nozzle height
Goal - Good first-layer adhesion

- Set Nozzle Temp to lowest suggested temp by filament manufacturer
- Set Bed Temp to lowest suggested temp by filament manufacturer  
- Print a thin square test (https://www.printables.com/model/9838-first-layer-test-60x60-mm-square-z-calibration)

- Adjust Nozzle Temp
  - Go up by 1-5deg if extruder block is clicking, indicating the filament is too solid to advance

- Adjust Nozzle Height
  - Live-adjust Nozzle Distance
  - until a solid object is produced
  - Peeling apart is too high
  - Smushed to the point its causing peaks between lines is too low

- Adjust Bed Temp
  - Go up 1-5deg if pieces lift off on edges
  - Slightly higher temp for first layers (usually 5deg higher).
  - Consider using a glue like Elmer's purple gluestick if maximum temp doesn't help

## Checkpoint 3 - Ensure bed is level
- Goal - Good first-layer adhesion throughout bed surface
- https://www.printables.com/model/45752-3x3-bed-level-calibration

## Checkpoint 4 - Test and fix retraction-related settings
Goal - Eliminate stringing when moving without extracting

- Retraction Speed
    Determines how quickly retraction is carried out.
  - PETG - Start at 30mm/s and go down by 1mm/s increments until oozing/stringing/gaps when starting a new line go away
  - PETG - retraction speed is more important than distance, but Retraction Distance being too high show similar symptoms.

- Deretraction Speed (or Restart Speed)
    Determines how quickly filament is fed after a retraction.
  - PETG - Start at 0 (or same as Retraction) and reduce speed if blank spots form, especially visible when retracting for each layer.

- Retraction Distance
  - PETG - Direct Drive: 2 - 4mm
  - PETG - Bowden: 5 - 7mm
  - But not greater than the height of the nozzle
  - It's too high if gaps form (due to under-extrusion).
  
- Travel Speed
  - PETG - First layer speed 15-25mm
  - set to 999 and let printer go as fast as possible when not printing
  - Higher is typically better to avoid ooze/drip

- Calibrate Retraction Minimum Travel
  Controls how frequently retraction occurs in a specific area.
  - PETG - 1-2mm
  - PETG - Start at 2mm and reduce by 0.1mm increments
- https://www.printables.com/model/105989-fast-stringing-retraction-tests/


## Checkpoint 5 - Final Test
https://www.printables.com/model/61996-nano-all-in-one-3d-printer-test

 

# Recommended Test Prints
- Bed-Level Squares
- Flat keychain
- Roly Poly Coin Fidget


# Cold Pull
- Unload Filament
- Purge once
- Ensure Hotend is in position to reduce stress on arm (e.g. right side of Mini+)
- Expose top of Hotend by removing any hardware (e.g. 10mm top nut on Mini+)
- Set Nozzle Temperature to 270deg C
- Insert the filament into the hotend feed hole. Make sure that the filament tip is cut to make inserting it easier.
- Set Nozzle Temperature to 0
- While the hotend is cooling down, continuously push the filament down so that it extrudes from the nozzle. Do so until it cools down to the point where you can’t push anymore through (around 160 - 170 °C).
- When the temperature is near 90 °C, hold the X-axis arm to support it, and pull the filament straight up using your hands or pliers, out of the Extruder. Pull it firmly and steadily.
- Repeat one more time.

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


# Layer Height
Layer height should not exceed 80% of the width of hte nozzle
- .25mm nozzle max layer height = .2mm
- .40mm nozzle max layer height = .32mm

# Troubleshooting

## Stringing/Pulling Tweaks
Sometimes the next layer or neighboring line sticks, causing stringing, pulling, or sticking to the nozzle and wreaking havoc. These settings may help.
- Lift Z or Z Hop - lower or disable
- Wipe While Retracting - Toggle
- Minimum Travel after Retraction: Set to 2mm or reduce down to lowest 0.5
- Retract amount before wipe: 70%

## Gaps after Retraction
- Slow down Deretraction/Restart Speed. Often this is half as much as Retraction Speed
- Add Extra Length on Restart
- Retract on Layer Change - Toggle

## Small Parts Detaching Mid-Print
Like miniature figures with small surface area touching the bed... going 
- Ensure bed is clean. Initial adhesion could have been poor due to dust.
- Ensure bed is not too hot for the filament. PLA can't take much more than 60deg celsius.
- Consider adding a brim

## Warping
To avoid warping with PLA...
- The print bed should be properly leveled
- The distance between nozzle and print bed should not be too far
- The print bed temperature should be high enough (60+ for PLA)
- The print bed adhesion should be good enough (clean bed, glue, etc.)
- The ambient temperature should be as homogeneous as possible (block gusts)
- Too many bottom layers may cause warping.
- Fan being too high, too soon may cause warping. Consider increase number of layers without fan and/or how many layers spent stepping up to max fan speed.

# Second Layer Peels Away Like "Gills"
- Reduce Z Offset a bit. It may be too smashed, causing layer 2 to not reach and stick very well.

# Matte and Silk Filament
You can typically print the same normal/satin filament as matte by reducing the temperature, or silk by increasing the temperature. As such, you should print filaments specifically designed as matte with lower temps, and silk as higher temps.