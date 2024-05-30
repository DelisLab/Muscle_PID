%% Example code for the application of the NIF framework incorporating the PID approach

EMG... %insert the EMG data in the shape [No. of Timepoints x No. of Channels]
Task...%insert the continuous task parameter that corresponds with EMG across time

combos=nchoosek(1:size(EMG,2),2); %All pairwise combinations of EMG channels
Rs=[];Ss=[];UYs=[];Uzs=[]; %Initialise variables to collect information values
for i=1:length(combos)
    y=EMG(:,combos(i,1));
    z=EMG(:,combos(i,2));

    [R,S,UY,UZ]=Gaussian_PID(y,z,Task); %PID
    Rs=[Rs;R];Ss=[Ss;S];
    UYs=[UYs;UY];UZs=[UZs;UZ];
end

net_R=squareform(Rs);net_S=squareform(Ss);net_UY=squareform(UYs);net_UZ=squareform(UZs); %reshape into adjacency matrices

%sparsify networks
[threshold] = modified_percolation_analysis(net_R);net_R(net_R<threshold)=0;
[threshold] = modified_percolation_analysis(net_S);net_S(net_S<threshold)=0;
[threshold] = modified_percolation_analysis(net_UY);net_UY(net_UY<threshold)=0;
[threshold] = modified_percolation_analysis(net_UZ);net_UZ(net_UZ<threshold)=0;

[Opt_rank,Vs,Q]=Link_Consensus(net_,1); %identify number of modules using sparified network


mask=tril(true(size(zeros(size(EMG,2),size(EMG,2)))),-1);
R_new=net_R(mask);
S_new=net_S(mask);
UYZ_new=cat(1,net_UY(mask),UZ(mask)); %include both uy and uz together

[W,H]=opnmf(_new,Opt_rank); %insert sparsified network into dimensionality reduction using derived input parameter, applicable for large-scale analyses only

%Example demonstration of how to illustrate the output
A=squareform(W(:,1)); %Configure one of the synergies as an adjacency matrix

[M,Q]=community_louvain(A); %Determine the submodular structure (M) and the Modularity maximising statistic (Q)

Eta=sum(communicability_wu(A)); %Detemine the centrality of each muscle in the network

Ap=threshold_proportional(A,0.1); %For visualisation purposes only, sparsify the network to highlight most prominent connections

plotMuscleNetwork(A,Eta,M); %Plot the network over a human body model note: Eta may need to be multiplied/divided by a factor to make it visually interpretable.]
