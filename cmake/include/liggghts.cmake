message(STATUS "Configuring liggghts ...")

if(LIGGGHTS_INCLUDED)
  return()
endif()
set(LIGGGHTS_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/vtk.cmake)

if(USE_INTERNAL_LIGGGHTS)
  set(LIGGGHTS_EP_ROOT ${CONTRIB_ROOT_DIR}/contrib/liggghts/ep)
  set(LIGGGHTS_SOURCE_DIR ${CONTRIB_ROOT_DIR}/contrib/liggghts/src/src)
  set(LIGGGHTS_BUILD_DIR ${CONTRIB_ROOT_DIR}/contrib/liggghts/build)
  set(LIGGGHTS_INSTALL_DIR ${CONTRIB_ROOT_DIR}/contrib/liggghts/install)
  set(TMP_C_FLAGS "-fPIC -I${VTK_INCLUDE_DIRS} -L/opt/homebrew/lib")
  set(TMP_CXX_FLAGS "-fPIC -I${VTK_INCLUDE_DIRS} -L/opt/homebrew/lib")

  if(NOT EXISTS "${LIGGGHTS_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule liggghts missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    LIGGGHTS
    PREFIX ${LIGGGHTS_EP_ROOT}
    SOURCE_DIR ${LIGGGHTS_SOURCE_DIR}
    BINARY_DIR ${LIGGGHTS_BUILD_DIR}
    INSTALL_DIR ${LIGGGHTS_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG}
      -DCMAKE_PREFIX_PATH=${VTK_LIBRARY_DIRS}/cmake/vtk-9.0
      -DVTK_DIR=${VTK_LIBRARY_DIRS}/cmake/vtk-9.0
      -DCMAKE_CXX_FLAGS=${TMP_CXX_FLAGS} -DCMAKE_C_FLAGS=${TMP_C_FLAGS}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
      -DCMAKE_INSTALL_PREFIX=${LIGGGHTS_INSTALL_DIR} ${LIGGGHTS_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  if(USE_INTERNAL_VTK)
    add_dependencies(LIGGGHTS VTK)
  endif(USE_INTERNAL_VTK)

  set(LIGGGHTS_INCLUDE_DIRS ${LIGGGHTS_INSTALL_DIR}/include)
  set(LIGGGHTS_LIBRARIES liggghts)
  set(LIGGGHTS_LIBRARY_DIRS ${LIGGGHTS_INSTALL_DIR}/lib)
else()
  find_package(LIGGGHTS)
  if(NOT LIGGGHTS_FOUND)
    message(SEND_ERROR "Can't find system liggghts package.")
  endif()
endif()

set(LIGGGHTS_LIBRARIES ${LIGGGHTS_LIBRARIES})
include_directories(AFTER ${LIGGGHTS_INCLUDE_DIRS})
link_directories(AFTER ${LIGGGHTS_LIBRARY_DIRS})
message(STATUS "Using LIGGGHTS_INCLUDE_DIRS=${LIGGGHTS_INCLUDE_DIRS}")
message(STATUS "Using LIGGGHTS_LIBRARIES=${LIGGGHTS_LIBRARIES}")
message(STATUS "Using LIGGGHTS_LIBRARY_DIRS=${LIGGGHTS_LIBRARY_DIRS}")
