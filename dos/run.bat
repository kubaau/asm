if not exist build mkdir build
tasm %1 build
tlink build\%1.obj
build\%1.exe