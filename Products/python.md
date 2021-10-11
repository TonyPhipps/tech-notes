# Pip
- Download Pip (https://bootstrap.pypa.io/get-pip.py)
- Install via `python get-pip.py`
- Check via `pip -v`
- Upgrade via `python -m pip install --upgrade pip`

# venv
"Virtual Environment"
- https://virtualenv.pypa.io/en/latest/
- https://mothergeo-py.readthedocs.io/en/latest/development/how-to/venv-win.html

- It is recommended to build a 'venv' folder nearby the script/folder the venv is for to help track/maintian smoothly.

Commands
- Create via: `python -m venv env`
- Activate/enter the virtual env (Windows): `.\env\Scripts\activate.bat`
- Activate/enter the virtual env (Linux): `.\env\Scripts\activate`
- Install any dependencies: `python -m pip install -r requirements.txt`
- Deactivate/Exit the current virtual env: `deactivate`