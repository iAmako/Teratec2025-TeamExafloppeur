#!/bin/bash
screen -dmS mpi_session bash -c " \
mpirun --hostfile all_hosts -n 160 BSM2_BOOST 100000 1000000    > output1_mpi.txt && \
mpirun --hostfile all_hosts -n 160 BSM2_BOOST 1000000 1000000   > output2_mpi.txt && \
mpirun --hostfile all_hosts -n 160 BSM2_BOOST 10000000 1000000  > output3_mpi.txt && \
mpirun --hostfile all_hosts -n 160 BSM2_BOOST 100000000 1000000 > output4_mpi.txt && \
mpirun --hostfile all_hosts -n 160 BSM2_BOOST 1000000000 1000000 > output5_mpi.txt \
"
