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

mpicxx --show
mpicxx -o "$EXE_DIR/BSM-MPI+BOOST_gcc" -ffast-math -std=c++17 -lmpi -O2 "$CPP_DIR/BSM-MPI+BOOST.cxx" && # sous g++ 
export CXX=armclang++
export OMPI_CXX=armclang++

mpicxx --show
mpicxx -o "$EXE_DIR/BSM-MPI+BOOST_armclang" -ffast-math -std=c++17 -lmpi -O2 "$CPP_DIR/BSM-MPI+BOOST.cxx" && # sous armclang++
export CXX=g++
export OMPI_CXX=g++


$EXE_DIR/BSM-MPI+BOOST_gcc 100000 100000 > "$LOG_DIR/output_BSM-MPI+BOOST_gcc.txt" &&
$EXE_DIR/BSM-MPI+BOOST_armclang 100000 100000 > "$LOG_DIR/output_BSM-MPI+BOOST_armclang.txt" 