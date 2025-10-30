# Cross-Compiler for The Neural Grid Project

This project provides a Docker-based solution for cross-compiling the C and C++ applications within `The-Neural-Grid-Project` for ARM processors, specifically targeting Raspberry Pi (ARMv7) and RK3566 (ARMv8/AArch64) architectures.

## Files in this Project

-   **`Dockerfile`**: This file defines the Docker image. It sets up a Debian-based environment and installs the necessary cross-compilation toolchains (`gcc-arm-linux-gnueabihf` for ARMv7 and `gcc-aarch64-linux-gnu` for AArch64), along with `build-essential`, `cmake`, and `git`.

-   **`CMakeLists.txt`**: The CMake build configuration file for `The-Neural-Grid-Project`.

-   **`build.sh`**: A Bash script for macOS and Linux users. This script automates the process of building the Docker image and then uses it to cross-compile `The-Neural-Grid-Project` for both target architectures using CMake.

-   **`build.bat`**: A Batch script for Windows users. This script performs the same actions as `build.sh`, but is adapted for the Windows command-line environment.

## How to Run the Cross-Compiler

To use this cross-compiler, you will need Docker installed and running on your system.

### Initial Setup (Important for macOS/Linux on ARM-based machines)

If you are running Docker on an ARM-based machine (like an Apple M-series chip), you need to enable `binfmt_misc` to allow Docker to run `linux/amd64` images and executables. The `build.sh` and `build.bat` scripts automatically handle this by running the `tonistiigi/binfmt` container. This step ensures that the `linux/amd64` based cross-compilers within the Docker image can execute correctly.

### On macOS or Linux

1.  Make the `build.sh` script executable:
    ```bash
    chmod +x build.sh
    ```
2.  Run the build process:
    ```bash
    ./build.sh
    ```

### On Windows

1.  Open a Command Prompt or PowerShell window in the project directory.
2.  Run the build process:
    ```cmd
    build.bat
    ```

### What the Scripts Do

Both `build.sh` and `build.bat` perform the following steps:

1.  **Install `binfmt_misc` handlers**: This allows your Docker daemon to run images for different architectures.
2.  **Build the Docker Image**: It builds a Docker image named `cross-compiler` from the `Dockerfile`, specifically targeting the `linux/amd64` platform to ensure compatibility with the installed cross-compilers.
3.  **Cross-Compile `The-Neural-Grid-Project`**: It runs a Docker container from the `cross-compiler` image, mounts the current directory, and executes the CMake-based build process for `The-Neural-Grid-Project`.
    -   `TheNeuralGrid_arm`: Compiled for Raspberry Pi (ARMv7).
    -   `TheNeuralGrid_arm64`: Compiled for RK3566 (AArch64).
4.  **Verify Compilation**: It checks for the existence of the `TheNeuralGrid_arm` and `TheNeuralGrid_arm64` binaries to confirm successful cross-compilation.

After successful execution, you will find `TheNeuralGrid_arm` for RPI and `TheNeuralGrid_arm64` for RK3566 binaries in the newly created `build` directory within your project folder, ready to be deployed to their respective ARM target devices.
