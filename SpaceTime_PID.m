function [R_spacetime,S_spacetime,UYZ_spacetime,net_R_space,net_S_space,net_UYZ_space,net_R_time,net_S_time,net_UYZ_time] = SpaceTime_PID(EMG,EEG,TASK)


%%Input:
        %EMG: Tensor [No. of timepoints x No. of Muscles x No. of trials]
        %EEG: Tensor [No. of timepoints x No. of channels x No. of trials]
        %TASK: Tensor [No. of timepoints x No. of parameters x No. of trials]

        %Note: No. of timepoints and No. of trials must be the same across all inputs

%%Output
        %R_spacetime,S_spacetime,UYZ_spacetime = Final output matrix for dimensionality reduction
        %net_R_space,net_S_space,net_UYZ_space = Spatial networks for community detection
        %net_R_time,net_S_time,net_UYZ_time = Temporal networks for community detection


combos_s=nchoosek(1:size(EMG,2),2);
combos_t=[nchoosek(1:size(EEG,1),2);[1:size(EEG,1);1:size(EEG,1)]'];

R=[];S=[];UY=[];UZ=[];
for i=1:length(combos_s)
    for ii=1:length(combos_t)
        for s=1:size(EEG,2)
            for c=1:size(TASK,2)
                eeg=EEG(combos_t(ii,1),s,:);eeg=eeg(:);

                emg_x=EMG(combos_t(ii,2),combos_s(ii,1),:);emg_y=EMG(combos_t(ii,2),combos_s(ii,2),:);
                emg_xy=[emg_x(:),emg_y(:)];
                task=TASK(combos_t(ii,2),c,:);task=task(:);
                
                try
                    [r,s,uy,uz] = Gaussian_PID(emg_xy,eeg,task);
                    R=[R;r];S=[S;s];UY=[UY;uy];UZ=[UZ;uz];
                catch message
                    R=[R;0];S=[S;0];UY=[UY;0];UZ=[UZ;0];
                end
            end
        end
    end
end
R=permute(reshape(R,[size(TASK,2),size(EEG,2),length(combos_t),length(combos_s)]),[4,3,2,1]);
S=permute(reshape(S,[size(TASK,2),size(EEG,2),length(combos_t),length(combos_s)]),[4,3,2,1]);
UY=permute(reshape(UY,[size(TASK,2),size(EEG,2),length(combos_t),length(combos_s)]),[4,3,2,1]);
UZ=permute(reshape(UZ,[size(TASK,2),size(EEG,2),length(combos_t),length(combos_s)]),[4,3,2,1]);

R_space=[];S_space=[];UY_space=[];UZ_space=[];
net_R_space={};net_S_space={};net_UYZ_space={};
mask=tril(true(size(zeros(size(EMG,2),size(EMG,2)))),-1);
for ii=1:length(combos_t)
    for s=1:size(EEG,2)
        for c=1:size(TASK,2)
            A=squareform(R(1:length(combos_s),ii,s,c));
            [threshold] = modified_percolation_analysis(A);A(A<threshold)=0;
            net_R_space=cat(2,net_R_space,A);
            R_space=cat(2,R_space,A(mask));

            A=squareform(S(1:length(combos_s),ii,s,c));
            [threshold] = modified_percolation_analysis(A);A(A<threshold)=0;
            net_S_space=cat(2,net_S_space,A);
            S_space=cat(2,S_space,A(mask));

            A=squareform(UY(1:length(combos_s),ii,s,c));
            [threshold] = modified_percolation_analysis(A);A(A<threshold)=0;
            net_UYZ_space=cat(2,net_UYZ_space,A);
            UY_space=cat(2,UY_space,A(mask));

            A=squareform(UZ(1:length(combos_s),ii,s,c));
            [threshold] = modified_percolation_analysis(A);A(A<threshold)=0;
            net_UYZ_space=cat(2,net_UYZ_space,A);
            UZ_space=cat(2,UZ_space,A(mask));
        end
    end
end
R_space=reshape(R_space,[length(combos_s),size(TASK,2),size(EEG,2),length(combos_t)]);
S_space=reshape(S_space,[length(combos_s),size(TASK,2),size(EEG,2),length(combos_t)]);
UY_space=reshape(UY_space,[length(combos_s),size(TASK,2),size(EEG,2),length(combos_t)]);
UZ_space=reshape(UZ_space,[length(combos_s),size(TASK,2),size(EEG,2),length(combos_t)]);

R_time=[];S_time=[];UY_time=[];UZ_time=[];
net_R_time={};net_S_time={};net_UYZ_time={};
mask=tril(true(size(zeros(size(EMG,1),size(EMG,1)))),-1);
for ii=1:length(combos_s)
    for s=1:size(EEG,2)
        for c=1:size(TASK,2)
            A=squareform(R(ii,1:length(combos_t)-size(EMG,1),s,c))+diag(squareform(R(ii,[length(combos_t)-size(EMG,1)]+1:end,s,c)));
            [threshold] = modified_percolation_analysis(A);A(A<threshold)=0;
            net_R_time=cat(2,net_R_time,A);
            R_time=cat(2,R_time,[A(mask);diag(A)]);

            A=squareform(S(ii,1:length(combos_t)-size(EMG,1),s,c))+diag(squareform(S(ii,[length(combos_t)-size(EMG,1)]+1:end,s,c)));
            [threshold] = modified_percolation_analysis(A);A(A<threshold)=0;
            net_S_time=cat(2,net_S_time,A);
            S_time=cat(2,S_time,[A(mask);diag(A)]);

            A=squareform(UY(ii,1:length(combos_t)-size(EMG,1),s,c))+diag(squareform(UY(ii,[length(combos_t)-size(EMG,1)]+1:end,s,c)));
            [threshold] = modified_percolation_analysis(A);A(A<threshold)=0;
            net_UYZ_time=cat(2,net_UYZ_time,A);
            UY_time=cat(2,UY_time,[A(mask);diag(A)]);

            A=squareform(UZ(ii,1:length(combos_t)-size(EMG,1),s,c))+diag(squareform(UZ(ii,[length(combos_t)-size(EMG,1)]+1:end,s,c)));
            [threshold] = modified_percolation_analysis(A);A(A<threshold)=0;
            net_UYZ_time=cat(2,net_UYZ_time,A);
            UZ_time=cat(2,UZ_time,[A(mask);diag(A)]);
        end
    end
end
R_time=reshape(R_time,[length(combos_t),size(TASK,2),size(EEG,2),length(combos_s)]);
S_time=reshape(S_time,[length(combos_t),size(TASK,2),size(EEG,2),length(combos_s)]);
UY_time=reshape(UY_time,[length(combos_t),size(TASK,2),size(EEG,2),length(combos_s)]);
UZ_time=reshape(UZ_time,[length(combos_t),size(TASK,2),size(EEG,2),length(combos_s)]);

R_spacetime=zeros([length(combos_t),length(combos_s),size(TASK,2),size(EEG,2)]);
S_spacetime=zeros([length(combos_t),length(combos_s),size(TASK,2),size(EEG,2)]);
UY_spacetime=zeros([length(combos_t),length(combos_s),size(TASK,2),size(EEG,2)]);
UZ_spacetime=zeros([length(combos_t),length(combos_s),size(TASK,2),size(EEG,2)]);
for e=1:size(EEG,2)
    for c=1:size(TASK,2)
        for i=1:length(combos_s)
            for ii=1:length(combos_t)
                if R_space(i,c,e,ii)==R_time(ii,c,e,i)
                    R_spacetime(ii,i,c,e)=R_space(i,c,e,ii);
                end
                if S_space(i,c,e,ii)==S_time(ii,c,e,i)
                    S_spacetime(ii,i,c,e)=S_space(i,c,e,ii);
                end
                if UY_space(i,c,e,ii)==UY_time(ii,c,e,i)
                    UY_spacetime(ii,i,c,e)=UY_space(i,c,e,ii);
                end
                if UZ_space(i,c,e,ii)==UZ_time(ii,c,e,i)
                    UZ_spacetime(ii,i,c,e)=UZ_space(i,c,e,ii);
                end
            end
        end
    end
end
UYZ_spacetime=cat(1,UY_spacetime,UZ_spacetime);

end
