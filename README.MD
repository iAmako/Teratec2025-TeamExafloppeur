# Teratec Hackathon 2025 - Team Exafloppeur

## Team Members

- **Alexis LABILLE**
- **Kevin LAMY**
- **Kilyan SLOWINSKI**

## Project Overview

This repository contains our work for the Teratec Hackathon 2025. Our project focuses on optimizing **Viridien Code** and **Code_Aster** for high-performance computing (HPC) applications. The key goal was to improve efficiency and scalability on distributed systems.

## Repository Structure

- **`writeup.pdf`**: Detailed project report, available at the root of this repository.
- **`cpp_files/`**: Source code files for the project.
- **`exe_files/`**: Compiled executables.
- **`hostfile/`**: Hostfiles used for `mpirun`.
- **`log_files/`**: Logs generated from executables and scripts.
- **`maqao_configs/`**: Different configurations for MAQAO performance analysis.
- **`maqao_outs/`**: Outputs from MAQAO analyses.
- **`scripts/`**: Scripts designed to run and automate multiple tests.

## Usage Instructions

### Running Executables

To run an executable, use the following command on the front node:

```bash
mpirun --hostfile hostfile/all_hosts -n 160 exe_files/<filename> <first_parameter> 1000000 > log_files/<filename>
```

Replace:

- **`filename`** with the name of the executable.
- **`first_parameter`** with the desired value for the first parameter. (100 000 is a generally a good middle ground, try lower if unsure)
