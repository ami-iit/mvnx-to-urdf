
##  Contents
* **[Installation](#installation)**
*   **[Prerequisites](#prerequisites)**
*   **[Una-tantum procedure](#una-tantum-procedure)**
* **[How to generate model](#how-to-generate-models)**
*   **[What you need](#what-you-need)**
*   **[How to use it](##how-to-use-it)**

## Installation

#### Prerequisites
- Matlab
- [**iDynTree**](https://github.com/robotology/idyntree): a library of robots dynamics algorithms for control, estimation and simulation.

#### Una-tantum procedure
- Install the robotology-superbuild. 
  ```
  git clone https://github.com/robotology/robotology-superbuild.git
  mkdir build
  cd build
  ```
  Follow installation instructions [here](https://github.com/robotology/robotology-superbuild#installation).  The required library iDynTree will be automatically install via the superbuild.
- Enable the Matlab bindings for iDynTree.
  ```
  cd robotology-superbuild/build/robotology/iDynTree
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

#### What you need
- A data folder (e.g., `data`) containing your own dataset, per each subject (e.g., `Subj-0X`).
- The folder `templates` containig human templates for URDF models.

#### How to use it
- Run the script `computeHumanURDF.m` from `/human_23links/` folder.
- Fill the dialog box with required info.


