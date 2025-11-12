#!/usr/bin/env bash
set -eux

PYTHON_INCLUDE_DIR="${PREFIX}/include/python${CONDA_PY:0:1}.${CONDA_PY:1}"
PYTHON_LIBRARY="${PREFIX}/lib/libpython${CONDA_PY:0:1}.${CONDA_PY:1}${SHLIB_EXT}"

mkdir build

cd build

cmake ${CMAKE_ARGS:+ ${CMAKE_ARGS}} "${SRC_DIR}" \
    -GNinja \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
    "-DCMAKE_INSTALL_PREFIX=${PREFIX}" \
    "-DPYTHON_PREFIX=${SP_DIR}" \
    "-DPython_EXECUTABLE=${PYTHON}" \
    "-DPython_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}" \
    "-DPython_LIBRARY:PATH=${PYTHON_LIBRARY}"

ninja

ctest -j "${CPU_COUNT}"

ninja install
