This repository provides Matlab code to implement the computational framework described in:

Quantifying the diverse contributions of hierarchical muscle interactions to motor function
(https://www.biorxiv.org/content/10.1101/2023.11.30.569159v2)

The the main scripts to implement the framework include: \
Gaussian_PID.m = Calculates Partial information decomposition following a gaussian copula normalisation [1,2]. \
Link_Consensus.m = Specifies the number of components to extract usig a link-based community detection [3]. \
opnmf.m = Implements orthogonal projective non-negative matrix factorisation [4]. \

Alongside these codes, we have provided an example implementation of this framework in 'example_code.m'. \

To provide intuition and prove the usecase for this approach in recovering the actual functional relationships of muscles, \
we have provided code for a toy simulation of each interaction type in the 'Simulation' folder: 
- toy_simulation is a function to simulate a pair of EMG signals and a corresponding binary task parameter. 
- The PID_simulation script can be simply ran to provide an output of such a simulation with several adjustable parameters including: 
    - Muscle interaction type 
    - Noise level 
    - Number of samples 




The framework can be successfully executed using these codes alone however, credit is given for important features of this code directly adapted from: \
https://github.com/robince/partial-info-decomp \
https://github.com/robince/gcmi \
https://github.com/CarloNicolini/communityalg \
https://github.com/brainlife/BCT \
https://github.com/asotiras/brainparts
