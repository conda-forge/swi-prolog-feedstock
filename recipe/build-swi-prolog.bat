@echo on

set BUILD_SH=build-swi-prolog-win.sh

copy "%RECIPE_DIR%\%BUILD_SH%" "%SRC_DIR%\%BUILD_SH%" ^
    || exit 2

set "PREFIX=%PREFIX:\=/%"
set "SRC_DIR=%SRC_DIR:\=/%"
set "MSYSTEM=MINGW%ARCH%"
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1

FOR /F "delims=" %%i IN ('cygpath.exe -u -p "%PATH%"') DO set "PATH_OVERRIDE=%%i"

bash -lc "./%BUILD_SH%" ^
    || exit 10
