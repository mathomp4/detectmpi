# detectmpi

This is a test repo containing CMake code for detecting MPI stack

At the moment can detect:

- Intel MPI
- Open MPI
- HPE MPT
- MPICH
- MVAPICH

## Variables Provided

- `MPI_STACK`: The detected MPI stack. The variables set are:
  - `intelmpi`
  - `openmpi`
  - `mpt`
  - `mpich`
  - `mvapich`

- `MPI_STACK_VERSION`
  - NOTE: This is not the version of MPI standard the stack supports, but the version of the stack itself.
    For the MPI Standard supported use `MPI_C_VERSION` and `MPI_Fortran_VERSION` provided by `FindMPI` module.
