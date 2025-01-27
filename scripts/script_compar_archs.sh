#!/bin/bash

# Variables de path
MAQAO_EXE=../maqao.aarch64.2.21.1/bin/maqao
MAQAO_CONFIG_DIR=../maqao_configs
CPP_DIR=../cpp_files
EXE_DIR=../exe_files
LOG_DIR=../log_files
MAQAO_OUT_DIR=../maqao_outs

# Modules requis
module use /opt/arm/modulefiles
module load acfl/24.10.1
module load armpl/24.10.1

# Liste des fichiers sources
sources=(
    "BSM-MPI+BOOST.cxx"
)

# Boucle pour chaque fichier source
for src in "${sources[@]}"; do
  # Nom de l'exécutable correspondant
  exe_name=$(basename "$src" .cxx)

  # Compilation
  mpicxx -o "$EXE_DIR/$exe_name" -ffast-math -std=c++17 -lmpi -O2 "$CPP_DIR/$src" &&
  
  # Exécution de l'exécutable avec enregistrement des logs
  mpirun --hostfile c7g -n 64 "$EXE_DIR/$exe_name" 10000000 1000000 > "$LOG_DIR/output_${exe_name}_c7g_64.txt" &&
  mpirun --hostfile c8g -n 64 "$EXE_DIR/$exe_name" 10000000 1000000 > "$LOG_DIR/output_${exe_name}_c8g_64.txt" &&
  mpirun --hostfile c8g -n 96 "$EXE_DIR/$exe_name" 10000000 1000000 > "$LOG_DIR/output_${exe_name}_c8g_96.txt" &&
  mpirun --hostfile all_hosts -n 160 "$EXE_DIR/$exe_name" 10000000 1000000 > "$LOG_DIR/output_${exe_name}_all_hosts_160.txt" &&
  mpirun --hostfile all_hosts -n 128 "$EXE_DIR/$exe_name" 10000000 1000000 > "$LOG_DIR/output_${exe_name}_all_hosts_128.txt"
done
