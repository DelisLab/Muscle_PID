

%Simulate two EMG signals ['EMG_1','EMG_2'] with additive noise that are either redundant,
%synergistic or independent with respect to a simulated binary variable
%['task_param']

N=1000; %The number of simulated samples
noise_level=0.1; %Adjustable level of Gaussian noise
type='independent'; %Relationship to be simulated between the signals, pick between 'redundant', 'synergistic' and 'independent'

[EMG_1, EMG_2, task_param] = toy_simulation(N, noise_level, type);



%Apply PID to the simulated signals with respect to the simulated quantity
[R,S,UY,UZ] =Gaussian_PID(EMG_1,EMG_2,task_param);

%Normalise the derived quantities to determine their relative contributions
%to the total shared information (i.e. the joint mutual information (JMI))
JMI=sum([R,S,UY,UZ]);
R=R/JMI;S=S/JMI;UY=UY/JMI;UZ=UZ/JMI;


%To demonstrate that the approach can effectively determine the underlying
%functional relationship between muscles, we can conduct a
%permutation-testing of the simulated EMGs

n=5000; %The number of permutations

perms=[]; %Initalise an empty array to hold the permuted PID values
for i=1:n
    e1_perm=EMG_1(randperm(N));e2_perm=EMG_2(randperm(N)); %Random permutation of both signals
    [R_perm,S_perm,UY_perm,UZ_perm] =Gaussian_PID(e1_perm,e2_perm,task_param); %Quantify PID with respect to fixed task_param values
    perms=[perms;[R_perm,S_perm,UY_perm,UZ_perm]/sum([R_perm,S_perm,UY_perm,UZ_perm])]; %As above, normalise these quantities with respect to JMI
end

%Taking the rth percentile from the distribution of permuted PID values in
%'perms', we can determine the statitical significance of the actual
%values.
r=95; %95th percentile chosen here, meaning actual values need to be >= this value to be considered significant
p=prctile(perms,r);

if p(1)<R
    display('Significant Redundant information found...')
else
    display('No significant Redundant information found...')
end

if p(2)<S
    display('Significant Synergistic information found...')
else
    display('No significant Synergistic information found...')
end

if p(3)<UY
    display('Significant Unique information (UY) found...')
else
    display('No significant Unique information (UY) found...')
end

if p(4)<UZ
    display('Significant Unique information (UZ) found...')
else
    display('No significant Unique information (UZ) found...')
end
