# Distributed learning Matlab codebase

This codebase is part of the paper by Deist et al. ([doi:10.1016/j.ctro.2016.12.004](https://doi.org/10.1016/j.ctro.2016.12.004)).
This code uses sections of code for the [alternating direction method of multipliers (ADMM)](http://stanford.edu/~boyd/admm.html) developed by Stephen P. Boyd et al. and discussed in their paper Distributed Optimization and Statistical Learning via the Alternating Direction Method of Multipliers
([doi:10.1561/2200000016](https://doi.org/10.1561/2200000016)).
This code uses the jsonlab package by Qianqian Fang available [here](https://github.com/fangq/jsonlab).

## Prerequisites

* Do **not** use Matlab 2017 or later, current dependencies (jsonlab) do not support this version
* An active Matlab license
* An active Matlab compiler license (for running in the [Varian Learning Portal](https://www.varianlearningportal.com/VarianLearningPortal/))

## Repository layout
This repository is split into four main folders:
* portal_code: the actual distributed learning code
* local_simulation: code to run a local simulation (on a single machine)
* create_user_input_file: a script to generate a configuration file, being used when running the distributed learning code.
* code_to_upload: a script to compile and sign the executables for use on the Varian Learning Portal. 

## Getting started
One way to familiarize oneself with the code for distributed linear SVM learning is to step through the code using the local simulation environment(no Matlab compiler license needed). 
For this, you first need to download a .csv with example data from https://www.cancerdata.org/id/10.5072/candat.2015.02 and run the script_create_example_data.m. This file prepares the data for the local simulation example.
The distributed learning code expects a text file with user-specified settings. This file can be generated using script_createUserInputFile.m in the folder create_user_input_file. The existing settings in script_createUserInputFile.m allows to run a local simulation.
You can then start the simulation with script_initialize_simulation.m.
This local simulation can later be used to test changes in the code. We advise to first debug code in this environment before running it on the portal.
To compile and sign the distributed learning code before uploading it to the Varian Learning Portal, use script_compile_and_sign.m in the folder code_to_upload. This requires a Matlab compiler license and the Varian File Signer.

## Compiling for use on the Varian Learning Portal

We cannot mandate that every data provider (e.g. participating hospitals) is buying Matlab licenses. Hence, we have to compile the code into an executable, and send this executable around. To compile these sets of code (site and master algorithms), there is a Matlab build project configuration available in both `portal_code\master` and `portal_code\site` folders.

Compiled versions of the master branch are available in the release tab. Note that this master branch is only writable for a few users, we are **not** providing a compiling service for all branches/users.