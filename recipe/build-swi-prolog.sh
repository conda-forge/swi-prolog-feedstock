#!/usr/bin/env bash
set -eux

_UNAME=$(uname)

BUILD_TYPE=Release
CMAKE_OPTS=""

CONDA_PY=$("${PYTHON}" -c 'import sys; v = sys.version_info; print(f"{v[0]}.{v[1]}")')
PYTHON_INCLUDE_DIR="${PREFIX}/include/python${CONDA_PY}"
PYTHON_LIBRARY="${PREFIX}/lib/libpython${CONDA_PY}${SHLIB_EXT}"

if [[ "${_UNAME}" == "Linux" ]]; then
    BUILD_TYPE=PGO
elif [[ "${_UNAME}" == "Darwin" ]]; then
    CMAKE_OPTS="${CMAKE_OPTS} -DUSE_GMP=OFF -DSWIPL_PACKAGES_BDB=OFF"
fi

mkdir build

pushd build
    cmake \
        -GNinja \
        ${CMAKE_ARGS:+ ${CMAKE_ARGS}} \
        -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
        -DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}" \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DCPYTHON_VERSION="${CONDA_PY};EXACT" \
        -DINSTALL_TESTS=ON \
        -DMACOSX_DEPENDENCIES_FROM="${PREFIX}" \
        -DPython_EXECUTABLE="${PYTHON}" \
        -DPython_INCLUDE_DIR:PATH="${PYTHON_INCLUDE_DIR}" \
        -DPython_LIBRARY:PATH="${PYTHON_LIBRARY}" \
        -DSWIPL_PACKAGES_QT=OFF \
        "${SRC_DIR}"

    cmake --build . \
        -j "${CPU_COUNT}" \
        --config "${BUILD_TYPE}"

    cmake --build . \
        -j "${CPU_COUNT}"  \
        --config "${BUILD_TYPE}" \
        --target install
popd

PIP_OPTS="-vv --no-deps --no-build-isolation --ignore-installed --disable-pip-version-check"

pushd packages/swipy
    "${PYTHON}" -m pip install . ${PIP_OPTS:+${PIP_OPTS}}
popd

pushd packages/mqi/python
    "${PYTHON}" -m pip install . ${PIP_OPTS:+${PIP_OPTS}}
popd
