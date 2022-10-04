
##  Contents
* **[Installation](#installation)**
 * **[Prerequisites](#prerequisites)**
 *  **[Una-tantum procedure](#una-tantum-procedure)**
* **[How to generate model](#how-to-generate-models)**
 *  **[What you need](#what-you-need)**
 *  **[How to use it](##how-to-use-it)**

## Installation

### Prerequisites
- Matlab
- [**iDynTree**](https://github.com/robotology/idyntree): a library of robots dynamics algorithms for control, estimation and simulation.

### Una-tantum procedure
- Install the robotology-superbuild. 
  ```
  git clone https://github.com/robotology/robotology-superbuild.git
  mkdir build
  cd build
  ```
  Follow installation instructions [here](https://github.com/robotology/robotology-superbuild#installation).  The required library iDynTree will be automatically install via the superbuild.
- Enable the Matlab bindings for iDynTree.
  ```
  cd robotology-superbuild/build/src/iDynTree
  cmake ..
  ccmake .
      ROBOTOLOGY_ENABLE_MATLAB    ON
      IDYNTREE_USES_MATLAB        ON
      Matlab_ROOT_DIR             root-to-your-application-Matlab
  make install
  ```
  - In your `.bashrc` add ```export Matlab_ROOT_DIR="root-to-your-application-Matlab"```.
  - Open Matlab and browse to the folder ```your-path/robotology-superbuild/build```.
  - Run the script `Startup-robotology-superbuild.m`.

## How to generate models

### What you need
- A data folder (e.g., `data`) containing your dataset, per each subject (e.g., `S00X`) with
  - a `.mvnx` file for the human whole-body acquisition.
  - a `.mat` file with markers acquisition for the hand (if you wantto build the model with articulated hands)
- The folder [`templates`](https://github.com/dic-iit/human-model-generator/tree/master/templates) containig human templates for URDF models.

### How to use it
- Move to the folder where you clone the repo.
- Run the script `computeHumanURDF.m`
- Fill the dialog box with required info.

   <p align="center"><img src="https://user-images.githubusercontent.com/10923418/129881033-4b926fa2-993c-4b92-b4af-f1f768940d56.png" alt=""/></p>

- If you **do not want to include** the articulad model of the hand into the URDF, insert 'n'. This means that the hand will be represented only by a unique rigid box in the URDF.
- If you **want to include** the articulad model of the hand into the URDF, insert 'y'. This will open another dialog box, as follows:

 <p align="center"><img src="https://user-images.githubusercontent.com/10923418/130245652-7642ed9a-f1d7-4473-8a40-ed71da823e6f.png" alt=""/></p>

- With the second dialog box you can choose if building
  - an **anthropometric model** of the hand. This model does not require the markers acquisition, but only the `.mvnx`.
  - a **marker-driven model** of the hand.  This model also requires an acquisition of markers properly positioned on top of the hand with a standard optical cameras tracking (e.g., Vicon).

### Examples
Given

- the subject number (e.g., 1)
- the subject mass (e.g., 60)
- the subject height (e.g.,1.80)

|   OPT |   48 DOF| 66 DOF | ANTHROPOMETRIC HAND| MARKER-DRIVEN HAND| GENERATED URDF|
:------:|:-------:|:------:|:------------------:|:-----------------:|:-------------:|
1|✔️|  |  |  |![1](https://user-images.githubusercontent.com/10923418/130096375-593a0c98-281a-4cd8-b64d-0d93e94e016b.png)
2|  |✔️|  |  |![2](https://user-images.githubusercontent.com/10923418/130097622-77af39ac-8873-4273-b89e-c86a159e178e.png)
3|✔️|  |✔️|  |![3](https://user-images.githubusercontent.com/10923418/130098132-f35b8381-7878-492a-ad20-04506238b62f.png)
4|✔️|  |  |✔️|![4](https://user-images.githubusercontent.com/10923418/130098291-6f4c4099-4894-4669-856d-717fc7791576.png)
