# Prusa Mini with PETG on Powdered Steel Sheet

## First Time Setup
Perform these steps with any new filament brand or type

Start with a "Generic PETG profile"

# Checkpoint 1 - Ensure bed is clean
- Dawn dish soap and hot water, then window cleaner, then IPA

# Checkpoint 2 - Calibrate temperatures and nozzle height
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

# Checkpoint 3 - Ensure bed is level
- Goal - Good first-layer adhesion throughout bed surface
- https://www.printables.com/model/45752-3x3-bed-level-calibration

# Checkpoint 4 - Test and fix retraction-related settings
Goal - Eliminate stringing when moving without extracting

- Retraction Speed
Determines how quickly retraction is carried out.
  - Start at 30mm/s and go down by 1mm/s increments until oozing/stringing/gaps when starting a new line go away
  - With PETG, retraction speed is more important than distance, but Retraction Distance being too high show similar symptoms.

- Deretraction Speed (or Restart Speed)
Determines how quickly filament is fed after a retraction.
- Start at 0 (or same as Retraction) and reduce speed if blank spots form, especially visible when retracting for each layer.

- Retraction Distance
  - Direct Drive: 2 - 4mm
  - Bowden: 5 - 7mm
  - But not greater than the height of the nozzle
  - It's too high if gaps form (due to under-extrusion).
  
- Travel Speed
  - First layer speed 15-25mm
  - set to 999 and let printer go as fast as possible when not printing
  - Higher is typically better to avoid ooze/drip

- Calibrate Retraction Minimum Travel
  Controls how frequently retraction occurs in a specific area.
  - 1-2mm
  - Start at 2mm and reduce by 0.1mm increments
- https://www.printables.com/model/105989-fast-stringing-retraction-tests/


# Checkpoint 5 - Final Test
https://www.printables.com/model/61996-nano-all-in-one-3d-printer-test

 

# Recommended Test Prints
- Bed-Level Squares
- Flat keychain
- Filament Clip


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