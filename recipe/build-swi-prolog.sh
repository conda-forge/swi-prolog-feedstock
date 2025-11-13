#!/usr/bin/env bash
set -eux

CONDA_PY=$("${PYTHON}" -c 'import sys; v = sys.version_info; print(f"{v[0]}.{v[1]}")')

PYTHON_INCLUDE_DIR="${PREFIX}/include/python${CONDA_PY}"
PYTHON_LIBRARY="${PREFIX}/lib/libpython${CONDA_PY}${SHLIB_EXT}"

ls "${PYTHON_INCLUDE_DIR}"

ls "${PYTHON_LIBRARY}"

mkdir build

pushd build
    cmake \
        -GNinja \
        ${CMAKE_ARGS:+ ${CMAKE_ARGS}} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DPython_EXECUTABLE="${PYTHON}" \
        -DPython_INCLUDE_DIR:PATH="${PYTHON_INCLUDE_DIR}" \
        -DPython_LIBRARY:PATH="${PYTHON_LIBRARY}" \
        "${SRC_DIR}"

    ninja

    ctest -j "${CPU_COUNT}"

    ninja install
popd

pushd packages/swipy
    "${PYTHON}" -m pip install . --no-deps --no-build-isolation --disable-pip-version-check
popd

pushd packages/mqi/python
    "${PYTHON}" -m pip install . --no-deps --no-build-isolation --disable-pip-version-check
popd
