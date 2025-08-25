# musiGAIT

**Real‑time EMG sonification to support gait training with children.**

---

## 1) Requirements

* **OS:** Windows 11 (tested). **Live Delsys hardware/SDK are Windows-only.**
  * macOS is fine for Max UI and offline testing (no live sensors).
* **Python:** ≥ 3.9
* **Conda:** for the server env (**env name: `neurobio`**)
* **CMake:** ≥ 3.20 + C++ compiler
  * Windows: Visual Studio Build Tools 2022 (Desktop development with C++)
* **Max 8** (no license required)
* **TouchDesigner** (no license required)
* **Hardware:** Delsys Trigno base + EMG/Goniometer sensors _(Windows only)_

---

## 2) Install

### A. Clone

```bash
git clone https://github.com/LabNNL/musiGAIT.git
cd musiGAIT
```

### B.1 Backend server — Windows (PowerShell)

```bash
cd external/neurobiomech_software/backend
conda env create -n neurobio -f environment.yml
conda activate neurobio

mkdir build; cd build
cmake -S .. -B . -DBUILD_BINARIES=ON -DCMAKE_INSTALL_PREFIX="$env:CONDA_PREFIX"
cmake --build . --config Release
```

### B.2 Backend server — macOS (bash/zsh)

```bash
cd external/neurobiomech_software/backend
conda env create -n neurobio -f environment.yml
conda activate neurobio

mkdir -p build && cd build
cmake -S .. -B . -DBUILD_BINARIES=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$CONDA_PREFIX"
make
```

### C. Max

1. Install **Max 8**
	* https://downloads.cdn.cycling74.com/max8/Max865_241008.zip
2. Open **Package Manager** and install:
	* **Fluid Corpus Manipulation**
	* **grainflow**
	* **sigmund\~** (64‑bit)
3. Install the **shell** external manually
	* Download the latest release from: https://github.com/jeremybernstein/shell/releases
	* Unzip the archive. Inside you’ll find the shell.mxo (macOS) or shell.mxe64 (Windows) external.
	* Copy this file into your Max externals path:
		* **macOS:** ~/Documents/Max 8/Library/
		* **Windows:** /Documents/Max 8/Library/

### D. TouchDesigner

Install TouchDesigner (Non‑Commercial). No extra setup required.
https://derivative.ca/download

---

## 3) Run

1. Power and pair **Delsys Trigno** sensors (Windows)
2. Launch **Max 8** and open `00_MUSIGAIT.maxpat`
3. **Server:** click **Start Server**
4. **Sensors/Analyzers:** choose sensors and enable analyzers
5. **Audio tab:** capture **MIN** (idle) and **MAX**
6. **Logging (optional):** enable to write CSVs under `./logs/`.
