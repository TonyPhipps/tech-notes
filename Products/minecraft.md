- Install Minecraft
- Install 7zip
- Install GIMP
- %appdata%\.minecraft\versions\1.19.3
- Extract 1.19.3.jar to a folder. Use this folder as your "originals"
- Make a new folder for your mod.
- Make a new text file, then rename it to pack.mcmeta. Put the following in it

```
{
  "pack": {
    "pack_format": 12,
    "description": "[Any description you want to give your pack]"
  }
}
```

- Next to your pack.mcmeta file, make a  folder named 1.19.3
- Inside 1.19.3, replicate the folder and file structure for any files you wish to overwrite with your mod.
  - For example, make folders for \assets\minecraft\textures\block\, then copy/paste the grass_block_side.png in the block folder.
- For each texture/file you want to change, copy it into a matching folder structure

----------------

- EXIT MINECRAFT

- In NovaSkin (https://minecraft.novaskin.me/)
  - Save
  - Download tab
  - Right click the picutre > Save Image As
  - Referencing the URL bar, save the .png in the same path with the same name in your mod folder.
    - You may need to create folders first
    - If you are replacing or updating one, click the old file to overwrite it

- Go back up to where to where you can see the assets folder and the pack.mcmeta file.
- Select both files
- Add to a zip
- Rename the zip to your mod name
- Copy or move the mod .zip to %appdatat%\.minecraft\resourcepacks
- Open the game and turn on the mod via Options > Resource Packs

 