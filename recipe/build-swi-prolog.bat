@echo on

set BUILD_TYPE=Release

set "GMP_INCLUDE_DIRS=%PREFIX%\Library\include"
set "GMP_LIB_DIRS=%PREFIX%\Library\lib"

set "PIP_OPTS=-vv --no-deps --no-build-isolation"

md build

pushd build
    cmake %CMAKE_ARGS% ^
        -G "NMake Makefiles" ^
        -DCMAKE_BUILD_TYPE=Release ^
        -DCMAKE_CXX_STANDARD=17 ^
        -DINSTALL_TESTS=ON ^
        -DUSE_GMP=OFF ^
        "-DCMAKE_INSTALL_PREFIX=%PREFIX%" ^
        "-DCMAKE_PREFIX_PATH=%PREFIX%" ^
        "%SRC_DIR%" ^
        || exit 2

    cmake --build . ^
        --config "%BUILD_TYPE%" ^
        || exit 3

    cmake --build . ^
        --target install ^
        --config "%BUILD_TYPE%" ^
        || exit 4
popd

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
