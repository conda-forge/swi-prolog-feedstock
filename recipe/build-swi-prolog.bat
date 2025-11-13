md build
cd build

set BUILD_TYPE=Release

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
    -j ^"%CPU_COUNT%" ^
    --verbose ^
    --config Release ^
    || exit 3

cmake --build . ^
    --target install ^
    --config "%BUILD_TYPE%" ^
    || exit 4

set "PIP_OPTS=-vv --no-deps --no-build-isolation"

cd "%SRC_DIR%\packages\swipy"
"%PYTHON%" -m pip install . %PIP_OPTS% ^
    || exit 5

cd "%SRC_DIR%\packages\mqi\python"
"%PYTHON%" -m pip install . %PIP_OPTS% ^
    || exit 5
