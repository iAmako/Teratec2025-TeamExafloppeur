#!/bin/bash
mpirun --hostfile all_hosts -n 160 BSM2_BOOST_O0 1000000 1000000 > output_O0_mpi.txt &&
mpirun --hostfile all_hosts -n 160 BSM2_BOOST_O1 1000000 1000000 > output_O1_mpi.txt &&
mpirun --hostfile all_hosts -n 160 BSM2_BOOST_O2 1000000 1000000 > output_O2_mpi.txt &&
mpirun --hostfile all_hosts -n 160 BSM2_BOOST_O3 1000000 1000000 > output_O3_mpi.txt &&
mpirun --hostfile all_hosts -n 160 BSM2_BOOST_Ofast 1000000 1000000 > output_Ofast
