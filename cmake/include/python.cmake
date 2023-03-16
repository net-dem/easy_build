message(STATUS "Configuring python ...")

if(PYTHON_INCLUDED)
  return()
endif()
set(PYTHON_INCLUDED TRUE)

if(USE_INTERNAL_PYTHON)
  message(SEND_ERROR "use internal python not implemented.")
else()
  # get_directory_property(_vars_before VARIABLES)
  # find_package(Python COMPONENTS Development)
  # get_directory_property(_vars VARIABLES)

  # list(REMOVE_ITEM _vars _vars_before ${_vars_before})
  # foreach(_var IN LISTS _vars)
  #   message(STATUS "${_var} = ${${_var}}")
  # endforeach()

  find_package(Python COMPONENTS Development Interpreter)
  if(NOT Python_FOUND)
    message(SEND_ERROR "Can't find system python package.")
  endif()
  set(PYTHON_INCLUDE_DIRS ${Python_INCLUDE_DIRS})
  set(PYTHON_LIBRARIES ${Python_LIBRARIES})
  set(PYTHON_LIBRARY_DIRS ${Python_LIBRARY_DIRS})
endif()

message(STATUS "Using PYTHON_INCLUDE_DIRS=${PYTHON_INCLUDE_DIRS}")
message(STATUS "Using PYTHON_LIBRARIES=${PYTHON_LIBRARIES}")
message(STATUS "Using PYTHON_LIBRARY_DIRS=${PYTHON_LIBRARY_DIRS}")