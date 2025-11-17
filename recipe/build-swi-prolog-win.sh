#!/usr/bin/env bash
set -eux

[ -n "$PATH_OVERRIDE" ] && export PATH="$PATH_OVERRIDE"

BUILD_TYPE=Release
PIP_OPTS="-vv --no-deps --no-build-isolation --ignore-installed --disable-pip-version-check"

mkdir build

pushd build
    cmake \
        -GNinja \
        -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
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
