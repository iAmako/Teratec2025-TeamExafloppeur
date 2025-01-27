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
#sources=(
#    "BSM.cxx"
#    "BSM-MPI+BOOST.cxx"
#)

# Compilation
mpicxx -o "$EXE_DIR/BSM_original_nocompil" "$CPP_DIR/BSM.cxx" && # version de base
mpicxx -o "$EXE_DIR/BSM_original_compil" -ffast-math -std=c++17 -lmpi -O2 "$CPP_DIR/BSM-MPI+BOOST.cxx" && # version de base avec options de compilation 
mpicxx -o "$EXE_DIR/BSM-MPI+BOOST_nocompil" "$CPP_DIR/BSM-MPI+BOOST.cxx" && # BSM MPI + BOOST
mpicxx -o "$EXE_DIR/BSM-MPI+BOOST_compil" -ffast-math -std=c++17 -lmpi -O2 "$CPP_DIR/BSM-MPI+BOOST.cxx" && # BSM MPI + BOOST + compil 


# Exécution de maqao sur chaque exécutable selon les fichiers de configuration
$MAQAO_EXE oneview -R1 -dx=MAQAO_OUT_DIR/BSM_original_nocompil --config=$MAQAO_CONFIG_DIR/config_original_nocompil.json &&
$MAQAO_EXE oneview -R1 -dx=MAQAO_OUT_DIR/BSM_original_compil --config=$MAQAO_CONFIG_DIR/config_original_compil.json &&
$MAQAO_EXE oneview -R1 -dx=MAQAO_OUT_DIR/BSM-MPI+BOOST_original_nocompil --config=$MAQAO_CONFIG_DIR/config_mpi+boost_nocompil.json &&
$MAQAO_EXE oneview -R1 -dx=MAQAO_OUT_DIR/BSM-MPI+BOOST_original_compil --config=$MAQAO_CONFIG_DIR/config_mpi+boost_compil.json