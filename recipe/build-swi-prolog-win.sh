#!/usr/bin/env bash
set -eux

BUILD_TYPE=Release

mkdir build

pushd build
    cmake \
        -GNinja \
        -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DINSTALL_TESTS=ON \
        -DSWIPL_PACKAGES_QT=OFF \
        -DSWIPL_PACKAGES_X=OFF \
        "${SRC_DIR}"

    cmake --build . \
        -j "${CPU_COUNT}" \
        --config "${BUILD_TYPE}"

    cmake --build . \
        -j "${CPU_COUNT}"  \
        --config "${BUILD_TYPE}" \
        --target install
popd

pushd packages/swipy
    "${PYTHON}" -m pip install . \
        ${PIP_OPTS:+${PIP_OPTS}}
popd

pushd packages/mqi/python
    "${PYTHON}" -m pip install . \
        ${PIP_OPTS:+${PIP_OPTS}}
popd
