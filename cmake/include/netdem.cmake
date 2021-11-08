message(STATUS "Configuring netdem ...")

if(NETDEM_INCLUDED)
  return()
endif()
set(NETDEM_INCLUDED TRUE)

if(USE_INTERNAL_NETDEM)
  set(NETDEM_EP_ROOT ${CONTRIB_ROOT_DIR}/netdem/ep)
  set(NETDEM_SOURCE_DIR ${CONTRIB_ROOT_DIR}/netdem/src)
  set(NETDEM_BUILD_DIR ${CONTRIB_ROOT_DIR}/netdem/build)
  set(NETDEM_INSTALL_DIR ${CONTRIB_ROOT_DIR}/netdem/install)

  if(NOT EXISTS "${NETDEM_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule netdem missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    NETDEM
    PREFIX ${NETDEM_EP_ROOT}
    SOURCE_DIR ${NETDEM_SOURCE_DIR}
    BINARY_DIR ${NETDEM_BUILD_DIR}
    INSTALL_DIR ${NETDEM_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCONTRIB_ROOT_DIR=${CONTRIB_ROOT_DIR}
      -DCMAKE_BUILD_TYPE=Release -DNUM_CORES=${NUM_CORES} -DENABLE_TESTS=ON
      -DENABLE_TOOLS=ON -DENABLE_EXAMPLES=ON
      -DCMAKE_GENERATOR_FLAG=${CMAKE_GENERATOR_FLAG} -DGENERATOR=${GENERATOR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
      -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
      -DMPI_C_COMPILER=${MPI_C_COMPILER} -DMPI_CXX_COMPILER=${MPI_CXX_COMPILER}
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
      -DCMAKE_INSTALL_PREFIX=${NETDEM_INSTALL_DIR} ${NETDEM_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j2
    INSTALL_COMMAND ${GENERATOR} -j2 install)

  set(NETDEM_INCLUDE_DIRS ${NETDEM_INSTALL_DIR}/include)
  set(NETDEM_LIBRARIES netdem)
  set(NETDEM_LIBRARY_DIRS ${NETDEM_INSTALL_DIR}/lib)
else()
  find_package(NETDEM)
  if(NOT NETDEM_FOUND)
    message(SEND_ERROR "Can't find system netdem package.")
  endif()
endif()

set(NETDEM_LIBRARIES ${NETDEM_LIBRARIES})
include_directories(AFTER ${NETDEM_INCLUDE_DIRS})
link_directories(AFTER ${NETDEM_LIBRARY_DIRS})
message(STATUS "Using NETDEM_INCLUDE_DIRS=${NETDEM_INCLUDE_DIRS}")
message(STATUS "Using NETDEM_LIBRARIES=${NETDEM_LIBRARIES}")
message(STATUS "Using NETDEM_LIBRARY_DIRS=${NETDEM_LIBRARY_DIRS}")
