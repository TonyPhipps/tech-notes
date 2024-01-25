# Prusa Mini+
## Magic Number
Uses a 1.8 degree stepper with a leadscrew with 4mm lead. This makes the distance corresponding to a full step 4/200 = 0.02mm. Your layer height should be a multiple of this.
Source: https://github.com/prusa3d/Original-Prusa-MINI/blob/master/DOCUMENTATION/ELECTRONICS/mini-motor-kit.pdf

# Beep When Done Printing
Printer Settings > Custom G-code > End G-Code
Add this to the end

```
M300 S1000 P500 ;First beep
M300 S0 P500 ;Wait
M300 S1000 P1000 ;Second beep
M300 S0 P500 ;Wait
M300 S1000 P1500 ;Third beep
```

# Printer Calibration
Perform these steps whenever you set up a new printer or make a major change, including swapping out the nozzle.

Start with a "Generic profile"

## Clean Bed
Should not require major adjustments between different filaments.
- Dawn dish soap and hot water, then isopropyl alcohol 90%+

## Level Bed
Should not require major adjustments between different filaments.
- Goal - Good first-layer adhesion throughout bed surface
- https://www.printables.com/model/45752-3x3-bed-level-calibration

## Set Initial Nozzle Height
Should not require major adjustments between different filaments.
- Set Nozzle Temp to lowest suggested temp by filament manufacturer
- Set Bed Temp to lowest suggested temp by filament manufacturer
- Print a Z calibration test
  - [First layer test 60x60 mm square / Z calibration](https://www.printables.com/model/9838-first-layer-test-60x60-mm-square-z-calibration)
- Alternate model:
  - [Calibration Strip for simple Live Z/First Layer calibration ](https://www.printables.com/model/105404-calibration-strip-for-simple-live-zfirst-layer-cal)
- Live-adjust Nozzle Distance until you can no longer see gaps between the lines
  - Hold the print up to light and inpect it. It should have no gaps
  - Peeling apart is too high of a Z offset
  - Smushed to the point its causing peaks between lines is too low of a Z offset
  - Repeat until satisfied


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

## Adjust Bed Temp
Should not require major adjustments between different filaments.
- Go up 1-5deg if pieces lift off on edges
- Slightly higher temp for first layers (usually 5deg higher).
- Consider using a glue like Elmer's purple gluestick if maximum temp doesn't help

## E-Steps
- https://teachingtechyt.github.io/calibration.html#esteps
- Go to Settings and long press over HW Setup until you hear the beep. That will bring you to the experimental menu where you can adjust e-steps. 


# Filament Calibration
Assuming your printer is already calibrated, it's recommended some settings be tuned specifically to each filament vendor/type/feature/color variation. Details are provided after this quick summary.

- Extrusion Multiplier / Flow ([Visual Cube](https://cdn.help.prusa3d.com/wp-content/uploads/2021/04/visual-method-cube.zip) or [Precision Cube](https://help.prusa3d.com/wp-content/uploads/2021/04/cube-40-40-40.zip))
- Linear Advance / Pressure Advance ([model](https://www.printables.com/model/90640-prusa-mini-linear-advance-for-prusament-pla-and-pe))
  - Adjust Extrusion Multiplier in G-code file first
  - Set final result in Filament's "Custom G-code"
- Temperature ([model](https://www.printables.com/model/514058-5-tier-temp-tower))
- Retraction ([model](https://www.printables.com/model/408609-prusa-mini-retraction-tower-pla-petg))
  - Set M900 to Linear Advancce in G-Code
  - Set M104 and M109 to Nozzle Temp in G-Code
- Max Volumetric speed ([model](https://www.printables.com/model/342075-extrusion-test-structure))

## Extrusion Multiplier / Flow

### Precise Method
Download the 40mm [cube](https://help.prusa3d.com/wp-content/uploads/2021/04/cube-40-40-40.zip).
- Slice it using the Vase Mode and your most-often used layer height and print it. You can find Vase mode (Print Settings →  Layers and perimeters →  Spiral vase).
- Make three or more measurements in the middle of each wall and calculate the overall average thickness.
- Calculate the extrusion multiplier using the following formula: Extrusion multiplier = (Current Extrusion width (0.45) / Average measured wall thickness).
- Adjust the Extrusion Multiplier in Filament Settings → Filament
- Re-print the cube with new settings and repeat these steps if necessary.

### Imprecise Method
Print a [cube](https://cdn.help.prusa3d.com/wp-content/uploads/2021/04/visual-method-cube.zip).
- Adjust the Extrusion Multiplier accordingly by 1-2%:
  - If there is too much material near the perimeters, decrease the Extrusion Multiplier value.
  - If there are visible gaps between layer lines, increase the Extrusion Multiplier value. (Microscopic gaps near the perimeters are OK.)

## Linear Advance/Pressure Advance 
- https://www.printables.com/model/90640-prusa-mini-linear-advance-for-prusament-pla-and-pe
- https://teachingtechyt.github.io/calibration.html#linadv
- This should be set per filament. In Prusaslicer: Filament Settings > Custom G-Code > Start G-Code

## Temperature
- Go up by 1-5deg if extruder block is clicking, indicating the filament is too solid to advance
- Consider using a temp tower (https://www.printables.com/model/39810-improved-all-in-one-temperature-and-bridging-tower)

## Retraction Settings
Goal - Eliminate stringing when moving without extracting

Print this and adjust settings
 - https://www.printables.com/model/105989-fast-stringing-retraction-tests/
 
### Retraction Distance / Length
- PETG - Direct Drive: 2 - 4mm
- PETG - Bowden: 5-7mm. Print a retraction tower at 5, 6, and 7. If you like, go down to .5 increments to find the best length/distance.
- It's too low if stringing occurs.
- If you get blobs, but minimal stringing, move on to Retraction Speed.
- DO NOT exceed the overall length of the nozzle (from the tip to the big opening the filament enters at) or you may cause jams

### Retraction Z-Lift


### Retraction Amount Before Wipe

### Retraction Speed
Determines how quickly retraction is carried out.
- PETG - Start at 20mm/s and go up by 1-5mm/s increments until oozing/stringing goes away
- PETG - Retraction Speed is more important than Length/Distance, but Retraction Length/Distance being too high can show similar symptoms.

### Deretraction Speed (or Restart Speed)
Determines how quickly filament is fed after a retraction.
- PETG - Start at 0 (or same as Retraction) and reduce speed if blank spots form, especially visible when retracting for each layer.

### Minimum Travel after Retraction
Controls how frequently retraction occurs in a specific area.
- PETG - 1-2mm. Start at 2mm and reduce by 0.1mm increments

## Travel Speed
- PETG - First layer speed 15-25mm
- set to 999 and let printer go as fast as possible when not printing
- Higher is typically better to avoid ooze/drip

## Max Volumetric Speed
- ([model](https://www.printables.com/model/342075-extrusion-test-structure))
- Using calipers or a ruler, measure the height of the print at that point.
- Use the following calculation to determine the correct max flow value: 
```start + (height-measured * step)```

For example, if the print quality began to suffer at 19mm measured from the bottom, the calculation would be: ```5 + (19 * 0.5)`````` , or 13mm³/s. Enter your number into the "Max volumetric speed" value in the filament settings.

## Final Test
Consider revisiting the tests to ensure absolute perfection. For example, it's likely worth redoing Extrusion testing again at this point to ensure accuracy, if that's needed.

https://www.printables.com/model/61996-nano-all-in-one-3d-printer-test

Great calibration guide alternatives that may provide useful tips/clarifications
- https://teachingtechyt.github.io/calibration.html
- https://github.com/SoftFever/OrcaSlicer/wiki/Calibration


# Cold Pull
- Unload Filament
- Purge once
- Ensure Hotend is in position to reduce stress on arm (e.g. right side of Mini+)
- Expose top of Hotend by removing any hardware (e.g. 10mm top nut on Mini+)
- Set Nozzle Temperature to 270c
- Insert the filament into the hotend feed hole. Make sure that the filament tip is cut to make inserting it easier.
- Set Nozzle Temperature to 0
- While the hotend is cooling down, continuously push the filament down so that it extrudes from the nozzle. Do so until it cools down to the point where you can’t gently push anymore through (around 160c - 170c).
- When the temperature is near 90c (for PLA) or 150c for PETG, hold the X-axis arm to support it, and pull the filament straight up using your hands or pliers, out of the Extruder. Pull it firmly and steadily.
- Repeat one more time.


# Layer Height
Layer height should not exceed 80% of the width of hte nozzle
- .25mm nozzle max layer height = .2mm
- .40mm nozzle max layer height = .32mm

# Troubleshooting

## Overhangs Warp Upward
- Reduce Nozzle Temp
- Reduce Speed
- Increase fan speed

## Clicking extruder
- Could also be wet or oily filament.
- Could be partial nozzle block.
- Could be printing so fast that hotend can't keep up with melting.
- Could be extruder wheel (idler) is not tight enough.
- Could be worn extruder gear.

## Clogged Nozzle
Symptoms of a clog (usually burned up bits)
- Usually occurs after some sort of print failure, where the filament ends up "stuck" in the nozzle too long and burns into hardened chunks.
- May have issue with first layer sticking to build plate
- May have issue with 2nd layer sticking to first layer
- May notice filament sticking to nozzle more due to partial clog redirecting the stream of molten filament to one side as it extrudes.
- May notice clicking sounds in stepper motor. This is the sound of skipping, since less filament moved forward than calculated due to the nozzle clog.

to fix...
- Unload the filament and do a couple cold pulls.
- Remove the section of filament (usually up to a foot) that may be damaged from the stepper motor grinding.
- You can try these again, but if they don't work, you may simply have a damaged nozzle that needs replaced. A bur can cause a permanent clog, which has most of the same symptoms as a clog.

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

## Gaps after Deretraction
- Likely due to loss of pressure. Add "Extra Length on Restart" in .2mm increments.
- See "Clicking Extruder"

## Small Parts Detaching Mid-Print
Like miniature figures with small surface area touching the bed... going 
- Ensure bed is clean. Initial adhesion could have been poor due to dust.
- Ensure bed is not too hot for the filament. PLA 55c-65c, PETG 80c-90cc
- Right-click the object and "Add part" a slab.
  - Resize the slab to be as tall as a single layer, 1mm wide, and as long as needed to either connect to a nearby object for support or make another thin circle to attach it to.
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

## Second Layer Peels Away Like "Gills"
- Reduce Z Offset a bit. It may be too smashed, causing layer 2 to not reach and stick very well.

## Something's Just Off
- Consider toggling the following
  - Print Settings > Layers and Perimeters > Detect Thin Walls
  - Print Settings > Layers and Perimeters > Thick Bridges
  - Print Settings > Layers and Perimeters > Fill Gaps
  - Print Settings > Layers and Perimeters > Perimeter Generation between Classic and Arachne
  - Filament - Filament Override > Wipe While Retracting (and amount %)

# Matte and Silk Filament
You can typically print the same normal/satin filament as matte by reducing the temperature, or silk by increasing the temperature. As such, you should print filaments specifically designed as matte with lower temps, and silk as higher temps.

# Custom G-Code

## PETG Overhangs
- ```M106 S125``` sets fan to 50% (on Prusa Mini)
- ```M107```  Disables fan
- ```M220 S100``` - Sets speed to 100%
- ```M220 S50``` - Sets speed to 50%