# Notes
- You can expect to pay 20c - 30c per card. Obviously some cards you may as well just buy.
- There is a step that can be lengthy and require a few minutes if you have a lot of cards to order.
- MakePlayingCards charges per 100 cards, so keep your count near one of those increments.
- MakePlayingCards will truncate your order to 612 if you go above that.

# Setup
- Make/have an account at https://www.makeplayingcards.com/
- Install/have Chrome
- Go to https://github.com/chilli-axe/mpc-autofill/releases/
- Download autofill-windows.exe


# Create the XML 
https://www.mpcfill.com/

- I like to Add Cards > From Text and import the MTGO Export from a Moxfield Package
- Search Settings
  -  Click Disable All Drives
  - Enable RustyShackleford (for close-to-original and MDFC)
  - Enable WillieTanner
  - Drag RustyShackleford above WillieTanner
  - Click Save Changes
- Upload card list as text (or whatever)
- Set Cardback
  - 24/424 is an textless version the standard Magic cardback

- Click Select All
- Click Download > XML 
- File should be under 50kb (it doesnt download the images)

# Use the XML with autofill-windows.exe
- Put the cards.xml file in the same directory as autofill-windows.exe
- Rename cards.xml to something else. The project will automatically be named after this on your MakePlayingCards account
- Run autofill-windows.exe
- When automation begins, it will navigate to https://www.makeplayingcards.com/ and request that you log in
- After logging in, the software will create a new project and begin downloading/inserting files into the project
- This can easily take 5-10 seconds PER CARD.


# Verify and Complete Order
- When autofill-windows.exe is done, it will display
  - ```State: Paging to Review, Action: N/A```
- The Cart indicator should show one more item
- Change to a different browser window (one not controlled by the automation script) and log in to https://www.makeplayingcards.com/
- Go to Saved Projects
- Find the one you made, it will be named after your cards.xml file
- Add to Cart (or review first if you need to)