cmake_minimum_required(VERSION 3.10)
project(TheNeuralGridProject VERSION 0.0.0)

# Auto-init submodules
find_package(Git REQUIRED)
execute_process(
    COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Standard configuration
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
    add_compile_definitions(NOMINMAX WIN32_LEAN_AND_MEAN)
endif()

# Set paths - convert to CMake style to handle spaces
file(TO_CMAKE_PATH "${CMAKE_SOURCE_DIR}/submodules/NeuralAmpModelerCore" NAM_SRC)
file(TO_CMAKE_PATH "${CMAKE_SOURCE_DIR}/submodules/AudioDSPTools" ADT_SRC)
file(TO_CMAKE_PATH "${CMAKE_SOURCE_DIR}/src" PROJECT_SRC)

# Verify NAM directory exists
if(NOT EXISTS "${NAM_SRC}/NAM")
    message(FATAL_ERROR "NAM sources not found at: ${NAM_SRC}/NAM\nDid submodules initialise?")
endif()

# Verify dsp directory exists
if(NOT EXISTS "${ADT_SRC}/dsp")
    message(FATAL_ERROR "Audio DSP sources not found at: ${ADT_SRC}/dsp\nDid submodules initialise?")
endif()

# Source files (using GLOB_RECURSE)
file(GLOB_RECURSE PROJECT_SOURCES "${PROJECT_SRC}/*.cpp")
file(GLOB_RECURSE NAM_SOURCES 
    "${NAM_SRC}/NAM/*.cpp"
    "${NAM_SRC}/NAM/*.c"
)
file(GLOB_RECURSE ADT_SOURCES 
    "${ADT_SRC}/dsp/*.cpp"
    "${ADT_SRC}/dsp/*.c"
)

# Debug: Print found sources (remove after verification)
message(STATUS "Project sources: ${PROJECT_SOURCES}")
message(STATUS "NAM sources: ${NAM_SOURCES}")
message(STATUS "ADT sources: ${ADT_SOURCES}")

# Create executable
add_executable(TheNeuralGridProject ${PROJECT_SOURCES} ${NAM_SOURCES} ${ADT_SOURCES})

# Include directories
target_include_directories(TheNeuralGridProject PRIVATE
    ${PROJECT_SRC}
    ${NAM_SRC}
    ${NAM_SRC}/Dependencies/eigen
    ${NAM_SRC}/Dependencies/nlohmann
    ${ADT_SRC}
)

# Compiler options (keep your existing ones)
if(MSVC)
    target_compile_options(TheNeuralGridProject PRIVATE
        "$<$<CONFIG:DEBUG>:/W4>"
        "$<$<CONFIG:RELEASE>:/O2>"
    )
else()
    target_compile_options(TheNeuralGridProject PRIVATE
        -Wall -Wextra -Wpedantic
        -Wno-unused-parameter
        "$<$<CONFIG:DEBUG>:-Og -ggdb -Werror>"
        "$<$<CONFIG:RELEASE>:-Ofast>"
    )
endif()

# Disable specific warnings
if(NOT MSVC)
    set_source_files_properties(
        "${NAM_SRC}/NAM/dsp.cpp" 
        PROPERTIES COMPILE_FLAGS "-Wno-error"
    )
endif()