# FRA371_Kinematics_Workshop_Lab2

![Course](https://img.shields.io/badge/Course-FRA371-blue)
![Workshop](https://img.shields.io/badge/Workshop-Lab2-green)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?logo=jupyter&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10--3.12-3776AB?logo=python&logoColor=white)

## Swift Setup

Set up Swift exactly the way Lab 2 uses it, and confirm it shows a robot inside the notebook.

### Quick Setup (Automated)

You can run the one-click setup script for your platform:

**Linux / macOS (Ubuntu):**
```bash
chmod +x setup.sh
./setup.sh
```

**Windows (PowerShell):**
```powershell
.\setup.ps1
```

The script automatically creates the `.venv`, isolates `PYTHONPATH` from ROS 2 conflicts, installs all requirements, and runs `fix_swift.py`.

---

### Manual Setup (Step-by-Step)

#### 1. Create and Activate Virtual Environment (`.venv`)

**On Linux / macOS:**
```bash
python3 -m venv .venv
source .venv/bin/activate
```

**On Windows (PowerShell):**
```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```
*(If script execution is disabled on PowerShell, run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` once)*

**On Windows (Command Prompt):**
```cmd
python -m venv .venv
.venv\Scripts\activate.bat
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
python fix_swift.py
```

- `requirements.txt` pins `websockets==12.0` so Swift does not hang, and includes `xacro` / `pyyaml` for URDF parsing.
- If you use ROS 2 on Ubuntu and encounter resolver warnings during `pip install`, you can bypass ROS `PYTHONPATH` using:
  ```bash
  PYTHONPATH= pip install -r requirements.txt
  ```
- `fix_swift.py` fixes robot meshes not showing in Swift on **Windows** (safe to run on macOS/Linux).

### When to run `fix_swift.py`

`fix_swift.py` patches the Swift package installed in your Python, not this project, so:

- **Run it once, right after `pip install`**, before you open the notebook.
- **Run it with the same Python as your notebook kernel.** If you use a venv, activate it first.
- **Run it again after every reinstall of Swift**: a new venv, a new computer, or `pip install --upgrade`. Reinstalling puts the unpatched file back.
- **Restart the kernel** if the notebook was already open when you ran it.

Running it twice is fine, it prints `already patched`.

### 3. Open the practice notebook

1. Open `practice.ipynb` in VS Code and select the kernel from `.venv` (Python 3.10–3.12).
2. Run the **0 - Setup** cell. The toy arm should appear under the cell — then Swift is ready for Lab 2.
3. Run the rest top to bottom, filling in the lines marked `# edit here`.

## Target

Copy these into section 2 of `practice.ipynb`. All values are in metres.

- **`M`** is the object position reported by the camera, in the **camera frame**.
- **`T`** is the homogeneous transformation matrix of the **base frame w.r.t. the camera frame**.

```
M = [ 0.10, -0.10, 0.85 ]

    [   1.0000    0.0000    0.0000   -0.1000 ]
T = [   0.0000   -1.0000    0.0000    0.0500 ]
    [   0.0000    0.0000   -1.0000    0.9000 ]
    [   0.0000    0.0000    0.0000    1.0000 ]
```

## Robot Setup

Add your own robot from LAB1 to this project and confirm it is ready for Lab 2.

### 1. Move your robot into `my_robot/`

Your robot comes from a **URDF exporter** (your CAD tool): one `.urdf` file and a set
of `.stl` meshes.

1. Put your mesh files in `my_robot/meshes/`.
2. Save your URDF as `my_robot/robot.urdf`.

### 2. Re-path the meshes

In `my_robot/robot.urdf`, every mesh path **must** look like this:

```xml
<mesh filename="package://my_robot/meshes/YOUR_FILE.stl"/>
```

### 3. Run the check

`python check_robot.py` must print `[ok] ready for Lab 2`, then your robot opens in Swift with joint sliders.
If it prints `[FAIL]`, fix what it says and run it again. It checks that:

- the URDF is plain ASCII (a Thai comment breaks loading on Windows)
- the robot has exactly **3 movable joints**, and the joint to the end-effector is `type="fixed"`
- every joint axis is straight, only `0` and `±1` (e.g. `xyz="0 0 1"`)
- every mesh file is found
- the tip can move in x, y and z

### 4. Open it in the notebook (section 6)

Section **6 - Your own robot** of `practice.ipynb` checks that your robot shows up in Swift inside the notebook,
the same way as the Lab 2 Setup cell. Sections 1–5 always use the toy arm, not your robot.

1. Finish steps 1–3 above first: `check_robot.py` must print `[ok] ready for Lab 2`.
2. Run cell **0 - Setup** of `practice.ipynb`. It imports the libraries. You do not have to finish sections 1–5.
3. Run the first cell of section 6. It prints your robot's name, its number of joints (must be 3) and its joint limits.
   It also opens a **second Swift view** under the cell, and your robot should appear there with all its meshes.
4. In the next cell:
   - set `q_try` to one value per joint, inside the joint limits (rad for a revolute joint, m for a prismatic joint)
   - write the line that moves your robot to `q_try` (see the Syntax cell). Use **`my_robot`** and **`env2`**,
     not `robot` and `env`, which are the toy arm.
5. Run the cell. Your robot should move in the second Swift view. Compare the printed tip position with your
   MDH model from LAB1 at the same `q_try`.

## Files

- **`practice.ipynb`** — RTB practice notebook, inverse kinematics basics, shown in Swift.
- **`check_robot.py`** — `python check_robot.py`, no args. Checks your URDF for Lab 2, then opens it in Swift with joint sliders.
- **`setup.sh`**, **`setup.ps1`** — Automated one-command setup scripts for Linux/Ubuntu and Windows.
- **`toy_robot/`** — toy 2-link arm (URDF + STL meshes) used by sections 1–5 of `practice.ipynb`.
- **`my_robot/`** — put your own robot here. Used by `check_robot.py` and section 6 of `practice.ipynb`.
- **`fix_swift.py`**, **`requirements.txt`** — same install as Lab 2.

## Troubleshooting

| Problem | Fix |
|---|---|
| Swift **hangs** at `env.launch` | `pip install "websockets==12.0"`, then restart the kernel |
| `ModuleNotFoundError: No module named 'xacro'` | `pip install xacro pyyaml`, then restart the kernel |
| ROS dependency conflicts during `pip install` (Ubuntu) | run `PYTHONPATH= pip install -r requirements.txt` |
| Arm **does not show** / *"a client-side exception has occurred"* (Windows) | `python fix_swift.py`, then restart the kernel |
| `fix_swift.py` prints `target line not found` | see **Manual fix** below |
| `FileNotFoundError: toy_robot/robot.urdf` | open this project folder as the VS Code workspace |
| Section 6 prints `put your LAB1 robot in my_robot/ first` | save your URDF as `my_robot/robot.urdf` (Robot Setup, step 1) |
| Your robot **does not show** in section 6, or shows without meshes | run `python check_robot.py` and fix every `[FAIL]`, then restart the kernel |
| `ValueError: incorrect vector length` in section 6 | `q_try` needs one value per joint, and move `my_robot`, not `robot` (the toy arm has 2 joints) |

### Manual fix

Open `SwiftRoute.py` in the folder printed by `python -c "import swift, os; print(os.path.dirname(swift.__file__))"`.
Find the line with `urllib.parse.unquote(self.path[9:])` and add these two lines right after it, at the same indent:

```python
if os.name == "nt" and len(self.path) > 2 and self.path[0] == "/" and self.path[2] == ":":
    self.path = self.path[1:]  # Windows drive path fix
```
