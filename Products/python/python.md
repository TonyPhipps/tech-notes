# Install Python
- https://www.python.org/downloads/

# Pip
- Download Pip (https://bootstrap.pypa.io/get-pip.py)
- Install via `python get-pip.py`
- Check via `pip -V` (capital V)
- Upgrade via `python -m pip install --upgrade pip`

# venv
"Virtual Environment"

- It is recommended to build a 'venv' folder nearby the script/folder the venv is for to help track/maintian smoothly.

Commands
- Create via: `python -m venv env`
- Activate/enter the virtual env (Windows): `.\env\Scripts\activate.bat`
- Activate/enter the virtual env (Linux): `.\env\Scripts\activate`
- Install any dependencies: `python -m pip install -r requirements.txt`
- Deactivate/Exit the current virtual env: `deactivate`


# Regular Expression
Search a string with a regex including a group, then return the full match and the first group matched.
```
import re
string = '    3aJ51CCn7bRFG71Cna2BUopLFqEbW1T0Pw4WzhW'
regex = '[^\w]((bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39})'
matches = re.search(regex, string)
print(matches.group(0)) # full match, including subgroups
print(matches.group(1)) # first group matched
```


Quick HTTP Server
```
python -m http.server --directory D:\wwwroot 8000
```