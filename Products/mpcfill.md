# Setup
- Install Chrome
- Make an account at https://www.makeplayingcards.com/
- Go to https://github.com/chilli-axe/mpc-autofill/releases/
- Download autofill-windows.exe

# Create the XML 
https://www.mpcfill.com/

- Search Settings
  -  Click Disable All Drives
  - Enable RustyShackleford (for close-to-original and MDFC)
  - Enable WillieTanner
  - Drag RustyShackleford above WillieTanner
  - Click Save Changes
- Upload card list as text (or whatever)
- Set Cardback
  - 26/424 is an textless version the standard Magic cardback

- Click Select All
- Click Download > XML 
- File should be under 50kb (it doesnt download the images)

# Use the XML with autofill-windows.exe
- Put the cards.xml file in the same directory as autofill-windows.exe
- Rename cards.xml to something else. The project will automatically be named after this on your MakePlayingCards account
- Run autofill-windows.exe
- Say NO to post-processing images
- When automation begins, it will navigate to https://www.makeplayingcards.com/ and request that you log in
- After logging in, the software will create a new project and begin downloading/inserting files into the project
- This can easily take 5-10 seconds PER CARD.


# Verify and Complete Order
- The Cart indicator should show one more item
- Change to a different browser window (one not controlled by the automation script) and complete the purchase.