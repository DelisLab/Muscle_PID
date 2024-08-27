
%%%Run this code to generate Fig.2(B.1-2)

%%%Fig.2 (B.1)
clear all;close all;clc;
N=100; %The number of simulated samples
noise_correlation=[0.8;0;-0.8;0.5;0;-0.5;0.8;0;-0.8];
signal_correlation=[-0.8;-0.5;-0.8;0;0;0;0.8;0.5;0.8];
frequencies=[20:150]; %Select a realistic range of frequencies to effectively simulate EMGs
trials=100;% The number of trial each with N samples

figure;
for i=1:9
    subplot(3,3,i);
    [EMG_1, EMG_2, task_param] = simulate_emg_data(N,signal_correlation(i), noise_correlation(i), frequencies,trials);

    tuning_e1=[];tuning_e2=[];
    for i=1:N:(N*trials)
        tuning_e1=[tuning_e1;[mean(EMG_1(i:(i+N)-1)),mean(task_param(i:(i+N)-1,1))]];
        tuning_e2=[tuning_e2;[mean(EMG_2(i:(i+N)-1)),mean(task_param(i:(i+N)-1,1))]];
    end
    data_1=[tuning_e1(tuning_e1(:,2)==0,1),tuning_e2(tuning_e2(:,2)==0,1)];
    mu_1 = mean(data_1);
    % Calculate the covariance matrix
    covariance = cov(data_1);

    % Get the eigenvalues and eigenvectors of the covariance matrix
    [eig_vec, eig_val] = eig(covariance);

    % Eigenvalues (axis lengths)
    axis_lengths = sqrt(diag(eig_val));

    % Angle of the ellipse
    theta = linspace(0, 2*pi, 100);

    % Ellipse in the standard position
    ellipse_x = axis_lengths(1) * cos(theta);
    ellipse_y = axis_lengths(2) * sin(theta);

    % Rotate the ellipse to align with the eigenvectors
    ellipse_1 = eig_vec * [ellipse_x; ellipse_y];

    data_2=[tuning_e1(tuning_e1(:,2)==1,1),tuning_e2(tuning_e2(:,2)==1,1)];% Calculate the mean of the data
    mu_2 = mean(data_2);

    % Calculate the covariance matrix
    covariance = cov(data_2);

    % Get the eigenvalues and eigenvectors of the covariance matrix
    [eig_vec, eig_val] = eig(covariance);

    % Eigenvalues (axis lengths)
    axis_lengths = sqrt(diag(eig_val));

    % Angle of the ellipse
    theta = linspace(0, 2*pi, 100);

    % Ellipse in the standard position
    ellipse_x = axis_lengths(1) * cos(theta);
    ellipse_y = axis_lengths(2) * sin(theta);

    % Rotate the ellipse to align with the eigenvectors
    ellipse_2 = eig_vec * [ellipse_x; ellipse_y];
    
    % Plot the data points
    scatter(data_1(:,1), data_1(:,2), 'filled');
    hold on;

    % Plot the ellipse
    plot(ellipse_1(1, :) + mu_1(1), ellipse_1(2, :) + mu_1(2), 'r-', 'LineWidth', 2);% Plot the data points

    scatter(data_2(:,1), data_2(:,2), 'filled');
    hold on;

    % Plot the ellipse
    plot(ellipse_2(1, :) + mu_2(1), ellipse_2(2, :) + mu_2(2), 'r-', 'LineWidth', 2);% Plot the data points
    xticklabels({});yticklabels({});
end



%%%%Fig.2(B.2)

Rs=[];Ss=[];UYs=[];UZs=[];
for scorr=-1:0.1:1
    signal_correlation=scorr;
    for ncorr=-0.9:0.1:0.9 %iterative over a range of noise correlation values
        r=[];s=[];uy=[];uz=[];
        noise_correlation=ncorr;
        for K=1:100 %simulate K fold simulations of the EMG signals
            [EMG_1, EMG_2, task_param] = simulate_emg_data(N,signal_correlation, noise_correlation, frequencies,trials);
            [R1,S1,UY1,UZ1] =Gaussian_PID(EMG_1,EMG_2,task_param);%Apply PID to the simulated signals with respect to the simulated task parameter
            %Normalise the derived quantities to determine their relative
            %contributions to the total shared information (i.e. the joint mutual information (JMI))
            JMI1=sum([R1,S1,UY1,UZ1]);
            r=[r;[R1/JMI1]];
            s=[s;[S1/JMI1]];
            uy=[uy;[UY1/JMI1]];
            uz=[uz;[UZ1/JMI1]];
        end
        %Extract the average of each quantity to summarise the output at each
        %correlation level
        Rs=[Rs;[mean(r)]];
        Ss=[Ss;[mean(s)]];
        UYs=[UYs;[mean(uy)]];
        UZs=[UZs;[mean(uz)]];
    end

end
%Plot figure with averages of each step
Rs=reshape(Rs,[length([-0.9:0.1:0.9]),length([-1:0.1:1])]);
Ss=reshape(Ss,[length([-0.9:0.1:0.9]),length([-1:0.1:1])]);
UYZs=mean(cat(3,reshape(UYs(:,1),[length([-0.9:0.1:0.9]),length([-1:0.1:1])]),reshape(UZs(:,1),[length([-0.9:0.1:0.9]),length([-1:0.1:1])])),3);

figure;
imagesc(Rs);
yticks(1:19);
xticks(1:21);
xtickangle(90);
yticks([-0.9:0.1:0.9]);
yticks(-0.9:0.1:0.9);
yticks(1:19);
yticklabels(-0.9:0.1:0.9);
ylabel('Noise correlation');
xticklabels(-1:0.1:1);
title('Redundancy');
xlabel('Signal correlation');
colorbar;

figure;
imagesc(Ss);
yticks(1:19);
xticks(1:21);
xtickangle(90);
yticks([-0.9:0.1:0.9]);
yticks(-0.9:0.1:0.9);
yticks(1:19);
yticklabels(-0.9:0.1:0.9);
ylabel('Noise correlation');
xticklabels(-1:0.1:1);
title('Synergy');
xlabel('Signal correlation');
colorbar;


figure;
imagesc(UYZs);
yticks(1:19);
xticks(1:21);
xtickangle(90);
yticks([-0.9:0.1:0.9]);
yticks(-0.9:0.1:0.9);
yticks(1:19);
yticklabels(-0.9:0.1:0.9);
ylabel('Noise correlation');
xticklabels(-1:0.1:1);
title('Unique');
xlabel('Signal correlation');
colorbar;


