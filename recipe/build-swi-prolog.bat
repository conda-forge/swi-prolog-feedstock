@echo on

set BUILD_TYPE=Release

md build

pushd build
    cmake %CMAKE_ARGS% ^
        -G "NMake Makefiles" ^
        -DUSE_GMP=OFF ^
        -DCMAKE_BUILD_TYPE=Release ^
        "-DCMAKE_PREFIX_PATH=%PREFIX%" ^
        "-DCMAKE_INSTALL_PREFIX=%PREFIX%" ^
        -DINSTALL_TESTS=ON ^
        "%SRC_DIR%" ^
        || exit 2

    cmake --build . ^
        -j "%CPU_COUNT%" ^
        --config "%BUILD_TYPE%" ^
        || exit 3

    cmake --build . ^
        --target install ^
        --config "%BUILD_TYPE%" ^
        || exit 4
popd

set "PIP_OPTS=-vv --no-deps --no-build-isolation"

pushd packages\swipy
    "%PYTHON%" -m pip install . ^
        %PIP_OPTS% ^
        || exit 5
popd


pushd packages\mqi\python
    "%PYTHON%" -m pip install . ^
        %PIP_OPTS% ^
        || exit 6
popd
