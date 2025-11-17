@echo on

copy "%RECIPE_DIR%/build-swi-prolog-win.sh" . ^
    || exit 2

set "PREFIX=%PREFIX:\=/%"
set "SRC_DIR=%SRC_DIR:\=/%"
set "MSYSTEM=MINGW%ARCH%"
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1

bash -lc "./build-swi-prolog-win.sh" ^
    || exit 10
