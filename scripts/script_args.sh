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
i=0
for args in " " "-std=c++17" "-ffast-math -std=c++17" "-ffast-math -std=c++17 -lmpi" "-ffast-math -std=c++17 -lmpi -O2"; do
  for src in "${sources[@]}"; do
    # Nom de l'exécutable correspondant
    exe_name=$(basename "$src" .cxx)

    # Compilation
    mpicxx -o "$EXE_DIR/${exe_name}_args_${i}" -ffast-math -std=c++17 -lmpi -O2 "$CPP_DIR/$src" &&

    # Exécution de l'exécutable avec enregistrement des logs
    mpirun --hostfile all_hosts -n 160 "$EXE_DIR/${exe_name}_args_${i}" "$param1" 1000000 > "$LOG_DIR/output_${exe_name}_args_${i}.txt" &&
  i=i+1 
  done
done
