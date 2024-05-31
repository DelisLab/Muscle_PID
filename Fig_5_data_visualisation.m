%%This code carries out the analysis illustrated in Fig.5 of the paper. Download the data from this application here:
        %https://figshare.com/articles/dataset/Dataset_1/25942699
% Note: set all folders in this repository and the downloaded data on the
% path to run the code successfully

load('Data.mat');
EMG=Data.EMG;
Task=Data.Kinematics; %Combine the kinematics into a single 

combos=nchoosek(1:size(EMG,2),2); %All pairwise combinations of EMG channels
Rs=[];Ss=[];UYs=[];UZs=[]; %Initialise variables to collect information values
for i=1:length(combos)
    y=EMG(:,combos(i,1));
    z=EMG(:,combos(i,2));

    [R,S,UY,UZ]=Gaussian_PID(y,z,Task); %PID
    Rs=[Rs;R];Ss=[Ss;S];
    UYs=[UYs;UY];UZs=[UZs;UZ];
end

JMI=sum([Rs,Ss,UYs,UZs],2);
net_JMI=squareform(JMI);
imagesc(net_JMI);colorbar;


Rs_norm=Rs./JMI;Ss_norm=Ss./JMI;UYs_norm=UYs./JMI;UZs_norm=UZs./JMI;

net_R=squareform(Rs_norm);net_S=squareform(Ss_norm);net_UY=squareform(UYs_norm);net_UZ=squareform(UZs_norm); %reshape into adjacency matrices

%sparsify networks
[threshold] = modified_percolation_analysis(net_R);net_R(net_R<threshold)=0;
[threshold] = modified_percolation_analysis(net_S);net_S(net_S<threshold)=0;
[threshold] = modified_percolation_analysis(net_UY);net_UY(net_UY<threshold)=0;
[threshold] = modified_percolation_analysis(net_UZ);net_UZ(net_UZ<threshold)=0;

figure;imagesc(net_R);colorbar;
figure;imagesc(net_S);colorbar;
figure;
uyz=[[UYs_norm;UZs_norm],[combos(:,1);combos(:,2)]];
barh(mean(uyz(uyz(:,2)==1,1)));
hold on;box off;
for i=2:size(EMG,2)
    barh(i,mean(uyz(uyz(:,2)==i,1)));
end

%Plotting human body models
[M,Q]=community_louvain(net_); %Determine the submodular structure (M) and the Modularity maximising statistic (Q)

Eta=sum(communicability_wu(net_)); %Detemine the centrality of each muscle in the network

Ap=threshold_proportional(net_,0.1); %For visualisation purposes only, sparsify the network to highlight most prominent connections

plotMuscleNetwork(Ap,Eta,M); %Plot the network over a human body model [Note: Eta may need to be multiplied/divided by a factor to make it visually interpretable.]
