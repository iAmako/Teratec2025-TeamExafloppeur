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

# Fichier csv de regroupement des logs pour comparaisons
touch $LOG_DIR/compiled_output.csv

# Liste des fichiers sources
sources=(
    "BSM-MPI+BOOST.cxx"
    "BSM-MPI.cxx"
)

# Boucle pour chaque fichier source
for param1 in 10000 100000 1000000 1000000; do
  for src in "${sources[@]}"; do
    # Nom de l'exécutable correspondant
    exe_name=$(basename "$src" .cxx)

    # Compilation
    mpicxx -o "$EXE_DIR/$exe_name" -ffast-math -std=c++17 -lmpi -O2 "$CPP_DIR/$src" &&

    # Exécution de l'exécutable avec enregistrement des logs
    mpirun --hostfile all_hosts -n 160 "$EXE_DIR/$exe_name" "$param1" 1000000 > "$LOG_DIR/output_${exe_name}_${param1}.txt" &&

    # Ajout dans le fichier csv du contenu du dernier fichier log
    echo "$param1,${exe_name}" >> "$LOG_DIR/compiled_output.csv"

  done
done

# Liste des fichiers sources
sources=(
    "BSM-MPI+BOOST+OMP.cxx"
    "BSM-MPI+BOOST-OUTER.cxx"
)

# Boucle pour chaque fichier source
for src in "${sources[@]}"; do
  # Nom de l'exécutable correspondant
  exe_name=$(basename "$src" .cxx)

  # Compilation
  mpicxx -o "$EXE_DIR/$exe_name" -ffast-math -std=c++17 -lmpi -O2 "$CPP_DIR/$src" &&

  # Exécution de l'exécutable avec enregistrement des logs
  mpirun --hostfile all_hosts -n 160 "$EXE_DIR/$exe_name" "$param1" 1000000 > "$LOG_DIR/output_${exe_name}_${param1}.txt" &&

  # Ajout dans le fichier csv du contenu du dernier fichier log
  echo "$param1,${exe_name}" >> "$LOG_DIR/compiled_output.csv"

done
