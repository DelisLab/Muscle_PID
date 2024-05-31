This repository provides Matlab code to implement the computational framework described in:

Quantifying the diverse contributions of hierarchical muscle interactions to motor function
(https://www.biorxiv.org/content/10.1101/2023.11.30.569159v2)

The the main scripts to implement the framework include: \
Gaussian_PID.m = Calculates Partial information decomposition following a gaussian copula normalisation [1,2]. \
Link_Consensus.m = Specifies the number of components to extract usig a link-based community detection [3]. \
opnmf.m = Implements orthogonal projective non-negative matrix factorisation [4].

Alongside these codes, we have provided an example implementation of this framework in 'example_code.m' and demonstration of how to replicate Fig.5 of the manuscript in \
'Fig_5_data_visualisation.m'. The data illustrated in Fig.5 has been made opensource on figshare here: https://figshare.com/articles/dataset/Dataset_1/25942699. \

To provide intuition and prove the usecase for this approach in recovering the actual functional relationships of muscles, \
we have provided code for a toy simulation of each interaction type in the 'Simulation' folder: 
- simulate_emg_data is a function to simulate a pair of EMG signals and a corresponding binary task parameter. 
- The PID_simulation script can be simply ran to provide an output of such a simulation with several adjustable parameters including: 
    - Muscle interaction type
    - option to include realistic frequency range for simulated EMGs 
    - Noise level 
    - Number of samples \
The simulated EMGs are tested using our approach and significant interactions are determined using a permutation-testing method.




The framework can be successfully executed using these codes alone however, credit is given for important features of this code directly adapted from: \
https://github.com/robince/partial-info-decomp \
https://github.com/robince/gcmi \
https://github.com/CarloNicolini/communityalg \
https://github.com/brainlife/BCT \
https://github.com/asotiras/brainparts \

References \
[1] Ince RA. Measuring multivariate redundant information with pointwise common change in surprisal. Entropy. 2017 Jun 29;19(7):318. \
[2] Ince RA, Giordano BL, Kayser C, Rousselet GA, Gross J, Schyns PG. A statistical framework for neuroimaging data analysis based on mutual information estimated via a gaussian copula. Human brain mapping. 2017 Mar;38(3):1541-73. \
[3] Ahn YY, Bagrow JP, Lehmann S. Link communities reveal multiscale complexity in networks. nature. 2010 Aug 5;466(7307):761-4. \
[4] Yang Z, Oja E. Linear and nonlinear projective nonnegative matrix factorization. IEEE Transactions on Neural Networks. 2010 Mar 25;21(5):734-49.
