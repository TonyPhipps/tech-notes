# Prusa Mini+
## Magic Number
Uses a 1.8 degree stepper with a leadscrew with 4mm lead. This makes the distance corresponding to a full step 4/200 = 0.02mm. Your layer height should be a multiple of this.
Source: https://github.com/prusa3d/Original-Prusa-MINI/blob/master/DOCUMENTATION/ELECTRONICS/mini-motor-kit.pdf


# Beep After First Layer
This bit of code is useful when you want to ensure the first layer adhered properly without standing there waiting for first layer to finish.

After Layer Chang G-Code:

```
;AFTER_LAYER_CHANGE
{if layer_num == 1} M300 S1000 P1500 ; beep {endif}
;[layer_z]
```


# Wait 5 Min for Plate Cooling, then Beep When Done Printing
Printer Settings > Custom G-code > End G-Code
Add this to the end

```
; Wait 5min for plate to cool
G4 S480 ;Wait

; Play DONE Beeps
M300 S1000 P1500 ;First beep
G4 P1 ;Wait
M300 S750 P1000 ;Second beep
G4 P1 ;Wait
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
  - Smushed to the point its causing peaks between lines is too low of a Z offset
  - Repeat until satisfied

# Filament Calibration
Assuming your printer is already calibrated, it's recommended some settings be tuned specifically to each filament vendor/type/feature/color variation. Details are provided after this quick summary.

- Linear Advance / Pressure Advance
  - Adjust Extrusion Multiplier in G-code file first
  - Set final result in Filament's "Custom G-code"
- Extrusion Multiplier / Flow
  - Print 30x30x3 cubes, adjusting EM in small increments until the top is smooth
- Temperature ([model](https://www.printables.com/model/514058-5-tier-temp-tower))
- Retraction ([model](https://www.printables.com/model/408609-prusa-mini-retraction-tower-pla-petg))
  - Set M900 to Linear Advancce in G-Code
  - Set M104 and M109 to Nozzle Temp in G-Code
- Max Volumetric speed ([model](https://www.printables.com/model/342075-extrusion-test-structure))

## Extrusion Multiplier / Flow
- This should be set per filament manufacturer+color.
- See https://ellis3dp.com/Print-Tuning-Guide/articles/extrusion_multiplier.html
- Print a series of cubes 30x30x3 increasing Extrusion Multiplier by 1-2% until the gaps in between infll and perimeters go away.
- Print a series of cubes 30x30x3 decreasing Extrusion Multiplier by .5% until the gaps in between infll and perimeters show up again, then pick the one without gaps.

## Linear Advance/Pressure Advance 
- This should be set per filament manufacturer+color. In Prusaslicer: Filament Settings > Custom G-Code > Start G-Code
- M221 is the Marlin firmware code for extrusion multiplier, if needed
- I like to keep multiple files, all with the same settings except the extrusion multiplier value, for quicker testing
- https://ellis3dp.com/Pressure_Linear_Advance_Tool/

## Temperature
- Go up by 1-5deg if Extruder block is clicking, indicating the filament is too solid to advance
- Consider using a temp tower (https://www.printables.com/model/39810-improved-all-in-one-temperature-and-bridging-tower)

## Retraction Settings
Goal - Eliminate stringing when moving without extracting

Print this and adjust settings
 - https://www.printables.com/model/105989-fast-stringing-retraction-tests/
 
### Retraction Distance / Length
- PETG - best to retract slower (30 mm/s) and re-prime even slower (15 mm/s)
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
- If printing smaller/skinnier parts, the infill may need to be increased or changed
- Lift Z or Z Hop - lower or disable
- Wipe While Retracting - Toggle
- Minimum Travel after Retraction: Set to 2mm or reduce down (to a lowest of 0.5)
- Retract amount before wipe: 70%

## Filament Sticks to Nozzle and Eventually Globs Fall Back on Object
- PETG printed too hot can ooze excessively. Try lowering the nozzle temperature by 5°C to reduce stringing and blobbing. Check the filament’s recommended range (usually 220-250°C).
  - Be sure to check and clean the nozzle before printing (best with nozzle heated).
  - Consider enabling Wiping when retracting.
  - Consider increasing retraction distance.
  - Consider using Seam Position: Nearest to minimize movement.
  - Consider enabling "Avoid Crossing Perimeters" with a Max Detour Length of 0.
  - Consider increasing infill percentage, and a simpler infill or 100% infill with Rectilinear.
  - Consider increasing non-print travel moves.
  - Consider increasing cooling fan percentage; ensure ducts running and are properly directing airflow.

## Seams Have Small Gap
- A divot at the seam indicates the seam gap is too large, causing under-extrusion where the nozzle starts/stops the perimeter loop. The Seam Gap Distance leaves too much space, preventing enough filament from filling the seam.
- Lower Seam Gap Distance to to reduce the gap, allowing more filament to be extruded at the seam, filling the divot and improving seam strength. You can go into the negative values if needed (like -5%).
- Location: In PrusaSlicer 2.9.2, adjust this in Print Settings > Layers and Perimeters > Advanced > External Perimeters Seam Gap. Ensure it’s set as a percentage (not mm).

## Gaps after Retraction
- Visible as under-extrusion at the start of a line.
- Raise Linear Advance (LA) value in increments of .5.
- Consider also whether the extrusion multiplier may be too high.

## Gaps after Deretraction
- Visible as under-extrusion at the start of a line.
- Lower Linear Advance (LA) value in increments of .5.
- Consider also whether the extrusion multiplier may be too low.

## Gaps or Poor Layer Adhesion at the End of Long Extrusion Moves
Likely cause: The extruder isn't pushing enough filament at the end of the move, possibly because the linear advance value is too high, causing the extruder to retract too much or not extrude enough during deceleration.

A too-high K-factor could cause under-extrusion at the start or end of the external perimeter, reducing filament flow and weakening the bond with internal perimeters.

Adjust K-factor: Reduce by 0.05 and print a single-wall test cube or calibration model to check if results improve.


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

## Z-Banding and under-extrusion in areas that have lots of quick switching between printing and retracting
- Replace bowden tube


## The outer layer of a 3D print is Delaminating
- Decrease the linear advance setting on your printer. 


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


## Temp Tower Customization
Adjust the layer numbers according to the model.

Before Layer Change G-Code
```
{if layer_num==5}M104 S250{endif} ; Layer 1
{if layer_num==55}M104 S245{endif} ; Layer 2
{if layer_num==105}M104 S240{endif} ; Layer 3
{if layer_num==155}M104 S235{endif} ; Layer 4
{if layer_num==205}M104 S230{endif} ; Layer 5
```
