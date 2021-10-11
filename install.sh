#!/bin/bash

mkdir -p build && cd build

TYPE=${TYPE:-Release}
NUM_CORES=12

TESTS=${TESTS:-ON}
TOOLS=${TOOLS:-ON}
EXAMPLES=${EXAMPLES:-ON}

# package options
PERIDIGM=${PERIDIGM:-OFF}
LIGGGHTS=${LIGGGHTS:-OFF}
NETDEM=${NETDEM:-OFF}

if hash ninja; then
  USE_NINJA=1
  CMAKE_GENERATOR_FLAG=-GNinja
  GENERATOR=$(which ninja)
else
  GENERATOR=$(which make)
fi

MPICC_COMPILER=$(which mpicc)
MPICXX_COMPILER=$(which mpicxx)
CMAKE_C_COMPILER=$(which gcc-11)
CMAKE_CXX_COMPILER=$(which g++-11)

cmake ${CMAKE_GENERATOR_FLAG} \
  -DCMAKE_BUILD_TYPE=${TYPE} -DNUM_CORES=${NUM_CORES} \
  -DENABLE_TESTS=${TESTS} -DENABLE_TOOLS=${TOOLS} -DENABLE_EXAMPLES=${EXAMPLES} \
  -DENABLE_PERIDIGM=${PERIDIGM} -DENABLE_LIGGGHTS=${LIGGGHTS} \
  -DENABLE_NETDEM=${NETDEM} \
  -DCMAKE_GENERATOR_FLAG=${CMAKE_GENERATOR_FLAG} -DGENERATOR=${GENERATOR} \
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
  -DMPICXX_COMPILER=${MPICXX_COMPILER} -DMPICC_COMPILER=${MPICC_COMPILER} \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..

if [ $USE_NINJA ]; then
  echo "Build with ninja"
  $GENERATOR -j$NUM_CORES
  # $GENERATOR -j$NUM_CORES install
else
  echo "Build with modern make"
  $GENERATOR -j$NUM_CORES
  # $GENERATOR -j$NUM_CORES install
fi
