#!/usr/bin/env bash
set -eux

mkdir build
cd build
cmake "-DCMAKE_INSTALL_PREFIX=${PREFIX}" -G Ninja ..
ninja
ctest -j "${CPU_COUNT}"
ninja install
