# Toolchain, using mingw on windows
CC = $(OS:Windows_NT=x86_64-w64-mingw32-)g++
PKG_CFG = $(OS:Windows_NT=x86_64-w64-mingw32-)pkg-config

TARGET_NAME = special_functions
TARGET_STATIC = $(TARGET_NAME).a
PYLIB_EXT = $(if $(filter $(OS),Windows_NT),.pyd,.so)
TARGET_PYLIB = ../Python/$(TARGET_NAME)$(PYLIB_EXT)

SRC  = $(wildcard *.cpp)
OBJ  = $(patsubst %.cpp, %.o, $(SRC))
DEPS = $(OBJ:.o=.d)

# All the external objects that the current submodule depends on
# Those objects have to be up to date
tempo1 = $(wildcard ../Numerical_integration/*.a)
EXTERNAL_OBJ = $(tempo1)

# flags
CFLAGS = -Ofast -march=native -MMD -MP -Wall $(OS:Windows_NT=-DMS_WIN64 -D_hypot=hypot)
SHRFLAGS = -fPIC -shared
OMPFLAGS = -fopenmp -fopenmp-simd
MATHFLAGS = -lm

# Python directories
PY = $(OS:Windows_NT=/c/Anaconda2/)python

ifeq ($(USERNAME),Sous-sol)
    PY = $(OS:Windows_NT=/c/ProgramData/Anaconda2/)python
endif

# includes
PYINCL := $(shell $(PY) -m pybind11 --includes)
ifneq ($(OS),Windows_NT)
    PYINCL += -I /usr/include/python2.7/
endif

# libraries
PYLIBS = $(OS:Windows_NT=-L /c/Anaconda2/ -l python27)

ifeq ($(USERNAME),Sous-sol)
    PYLIBS = $(OS:Windows_NT=-L /c/ProgramData/Anaconda2/ -l python27)
endif

$(TARGET_PYLIB): $(OBJ)
	@ echo " "
	@ echo "---------Compile library $(TARGET_PYLIB)---------"
	$(CC) $(SHRFLAGS) -o $(TARGET_PYLIB) $(OBJ) $(EXTERNAL_OBJ) $(CFLAGS) $(MATHFLAGS) $(PYLIBS)

%.o : %.cpp
	@ echo " "
	@ echo "---------Compile object $@ from $<--------"
	$(CC) $(SHRFLAGS) -c -Wall -o $@ $< $(CFLAGS) $(OMPFLAGS) $(PYINCL)

-include $(DEPS)

clean:
	@rm -f $(TARGET) $(OBJ)

.PHONY: all clean force 