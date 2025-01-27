#!/bin/bash

#exécution du script entier dans un screen pour assurer son exécution après la déconnexion
screen -dmS script_full

cd /Team_ExaFloppeurs/scripts

#Varibles de path
MAQAO_EXE=../zropigrjiozrgjzriogzrjigzoij
MAQAO_CONFIG_DIR=../oiezgvjgrijigrgzroizrgojizgrjizrgjio
CPP_DIR=../cpp_files
EXE_DIR=../exe_files
LOG_DIR=../log_files
MAQAO_OUT_DIR=../ezfjiopzfejizfeiozfeojiozfejizefiojfzeio

## Build de tous les fichiers exécutables
module use 
module load 
module load 
mpicxx 

## Fichier csv de regroupement des logs pour comparaisons
touch $LOG_DIR/compiled_output.csv

## Exécutions des exécutables, enregistrement des logs dans le dossier dédié
mpirun
