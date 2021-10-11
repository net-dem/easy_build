message(STATUS "Configuring peridigm ...")

if(PERIDIGM_INCLUDED)
  return()
endif()
set(PERIDIGM_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/boost.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/trilinos.cmake)

if(USE_INTERNAL_PERIDIGM)
  set(PERIDIGM_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/peridigm/ep)
  set(PERIDIGM_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/peridigm/src)
  set(PERIDIGM_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/peridigm/build)
  set(PERIDIGM_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/peridigm/install)
  set(TMP_C_FLAGS
      "-O2 -w -pedantic -ftrapv -L${YAML_LIBRARY_DIRS} -L${OPENBLAS_LIBRARY_DIRS} -L/usr/local/Cellar/gcc/11.2.0/lib/gcc/11 -lgfortran -lopenblas"
  )
  set(TMP_CXX_FLAGS
      "-O2 -w -std=c++14 -pedantic -ftrapv -L${YAML_LIBRARY_DIRS} -L${OPENBLAS_LIBRARY_DIRS} -L/usr/local/Cellar/gcc/11.2.0/lib/gcc/11 -lgfortran -lopenblas"
  )
  set(TRILINOS_DIR ${TRILINOS_INCLUDE_DIRS}/../ ${YAML_INCLUDE_DIRS}/../)

  if(NOT EXISTS "${PERIDIGM_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule peridigm missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    PERIDIGM
    PREFIX ${PERIDIGM_EP_ROOT}
    SOURCE_DIR ${PERIDIGM_SOURCE_DIR}
    BINARY_DIR ${PERIDIGM_BUILD_DIR}
    INSTALL_DIR ${PERIDIGM_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_BUILD_TYPE=Release
      -DTRILINOS_DIR=${TRILINOS_DIR} -DBOOST_ROOT=${BOOST_ROOT}
      -DBLAS_LIBRARY_DIRS=${OPENBLAS_LIBRARY_DIRS}
      -DLAPACK_LIBRARY_DIRS=${LAPACK_LIBRARY_DIRS}
      -DCMAKE_INSTALL_PREFIX=${PERIDIGM_INSTALL_DIR}
      -DCMAKE_CXX_FLAGS=${TMP_CXX_FLAGS} -DCMAKE_C_FLAGS=${TMP_C_FLAGS}
      -DCMAKE_CXX_COMPILER=${MPICXX_COMPILER}
      -DCMAKE_C_COMPILER=${MPICC_COMPILER} ${PERIDIGM_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  if(USE_INTERNAL_TRILINOS)
    add_dependencies(PERIDIGM TRILINOS)
  endif(USE_INTERNAL_TRILINOS)

  set(PERIDIGM_INCLUDE_DIRS ${PERIDIGM_INSTALL_DIR}/include)
  set(PERIDIGM_LIBRARIES peridigm)
  set(PERIDIGM_LIBRARY_DIRS ${PERIDIGM_INSTALL_DIR}/lib)
else()
  find_package(PERIDIGM)
  if(NOT PERIDIGM_FOUND)
    message(SEND_ERROR "Can't find system peridigm package.")
  endif()
endif()

set(PERIDIGM_LIBRARIES ${PERIDIGM_LIBRARIES} ${TRILINOS_LIBRARIES}
                       ${BOOST_LIBRARIES})
include_directories(AFTER ${PERIDIGM_INCLUDE_DIRS})
link_directories(AFTER ${PERIDIGM_LIBRARY_DIRS})
message(STATUS "Using PERIDIGM_INCLUDE_DIRS=${PERIDIGM_INCLUDE_DIRS}")
message(STATUS "Using PERIDIGM_LIBRARIES=${PERIDIGM_LIBRARIES}")
message(STATUS "Using PERIDIGM_LIBRARY_DIRS=${PERIDIGM_LIBRARY_DIRS}")
