#!/bin/bash

#Nbr de proc passé en param
$nbr_proc=$2
$fichier_host=$1

#Chargement des modules utilisés
cd Team_Exafloppeurs
module use /opt/arm/modulefiles
module load acfl/24.10.1
module load armpl/24.10.1

#Choix du compilateur Armclang++ pour mpicxx
export CXX=armclang++
export OMPICXX=armclang++

#Compilation
mpicxx -o BCM2WOW -std=c++17 -march=native -mcpu=native -lmpi BCM2WOW.cxx

#Lancement
nohup mpirun --hostfile $fichier_host -np $nbr_proc BCM2WOW 10000000000 1000 > output_1000000000_1000_c8g.log 2>&1 &
