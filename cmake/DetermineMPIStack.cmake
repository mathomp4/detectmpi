# This code will try and determine the MPI stack being used and set the MPI_STACK variable

include(CMakePrintHelpers)

set(ALLOWED_MPI_STACKS "intelmpi;mvapich;mpt;mpich;openmpi")

if (MPI_STACK)
  if (NOT MPI_STACK IN_LIST ALLOWED_MPI_STACKS)
    message(FATAL_ERROR "MPI_STACK must be one of the following: ${ALLOWED_MPI_STACKS}")
  endif()
else ()
  if (MPI_STACK MATCHES "mpiuni")
    message(FATAL_ERROR "You cannot build with BUILD_MPI=ON and MPI_STACK=mpiuni")
  endif ()

  message(STATUS "MPI_STACK not specified. Attempting to autodetect MPI stack...")
  cmake_print_variables(MPI_Fortran_LIBRARY_VERSION_STRING)

  string(REPLACE " " ";" MPI_Fortran_LIBRARY_VERSION_LIST ${MPI_Fortran_LIBRARY_VERSION_STRING})
  cmake_print_variables(MPI_Fortran_LIBRARY_VERSION_LIST)
  list(GET MPI_Fortran_LIBRARY_VERSION_LIST 0 MPI_Fortran_LIBRARY_VERSION_FIRSTWORD)
  cmake_print_variables(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD)

  if(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "Intel")
    set(MPI_STACK intelmpi)
      list(GET MPI_Fortran_LIBRARY_VERSION_LIST 3 DETECTED_MPI_VERSION_STRING)
  elseif(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "MVAPICH2")
    set(MPI_STACK mvapich)
      list(GET MPI_Fortran_LIBRARY_VERSION_LIST 3 DETECTED_MPI_VERSION_STRING)
  elseif(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "HPE")
    set(MPI_STACK mpt)
      list(GET MPI_Fortran_LIBRARY_VERSION_LIST 2 DETECTED_MPI_VERSION_STRING)
  elseif(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "MPICH")
    set(MPI_STACK mpich)
      list(GET MPI_Fortran_LIBRARY_VERSION_LIST 1 DETECTED_MPI_VERSION_STRING_WITH_EXTRA_SPACES)
      # MPICH has a weird output. Need to make it a list in an ugly way...
      string(REGEX REPLACE "[ \t\r\n]" ";" DETECTED_MPI_VERSION_STRING_LIST ${DETECTED_MPI_VERSION_STRING_WITH_EXTRA_SPACES})
      # Then grab the second field
      list(GET DETECTED_MPI_VERSION_STRING_LIST 1 DETECTED_MPI_VERSION_STRING)
  elseif(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "Open")
    set(MPI_STACK openmpi)
      list(GET MPI_Fortran_LIBRARY_VERSION_LIST 2 DETECTED_MPI_VERSION_STRING_WITH_COMMA)
      string(REPLACE "," "" DETECTED_MPI_VERSION_STRING_WITH_V ${DETECTED_MPI_VERSION_STRING_WITH_COMMA})
      string(REPLACE "v" "" DETECTED_MPI_VERSION_STRING        ${DETECTED_MPI_VERSION_STRING_WITH_V})
  else()
    message (FATAL_ERROR "ERROR: MPI_STACK autodetection failed. Must specify a value for MPI_STACK with cmake ... -DMPI_STACK=<mpistack>. The acceptable values are: intelmpi, mvapich, mpt, mpich, openmpi")
  endif()
endif()

message(STATUS "Using MPI_STACK: ${MPI_STACK}")
set(MPI_STACK "${MPI_STACK}" CACHE STRING "MPI_STACK Value")
cmake_print_variables(DETECTED_MPI_VERSION_STRING)
