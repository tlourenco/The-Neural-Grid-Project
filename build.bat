docker run --privileged --rm tonistiigi/binfmt --install all
docker build --platform linux/amd64 -t cross-compiler .
docker run --platform linux/amd64 --rm -v "%cd%":/work --entrypoint "" cross-compiler /bin/bash -c "^
    # Clean up previous builds^
    rm -rf build_arm build_arm64 build^
^
    # Compile for ARM (Raspberry Pi)^
    mkdir -p build_arm^
    cd build_arm^
    cmake -DCMAKE_TOOLCHAIN_FILE=../arm-linux-gnueabihf.cmake -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++ ..^
    make^
    cd ..^
^
    # Compile for ARM64 (RK3566)^
    mkdir -p build_arm64^
    cd build_arm64^
    cmake -DCMAKE_TOOLCHAIN_FILE=../aarch64-linux-gnu.cmake -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ ..^
    make^
    cd ..^
^
    # Create the final build directory and move executables^
    mkdir -p build^
    # Assuming the executable name is 'TheNeuralGrid' or similar, adjust if needed^
    find build_arm -name "TheNeuralGridProject" -exec mv {} build/TheNeuralGrid_arm \;^
    find build_arm64 -name "TheNeuralGridProject" -exec mv {} build/TheNeuralGrid_arm64 \;^
"

if exist build\TheNeuralGrid_arm if exist build\TheNeuralGrid_arm64 (
    echo Cross-compilation successful!
    echo Binaries created in the 'build' folder: build\TheNeuralGrid_arm, build\TheNeuralGrid_arm64
) else (echo Cross-compilation failed! Check logs for details.)
