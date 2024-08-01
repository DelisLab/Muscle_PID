function [EMG_1, EMG_2, task_param] = simulate_emg_data(N,noise_correlation, frequencies,trials)
 
   %Simulate two signals across multiple trials
    synthetic_emg_1=[];synthetic_emg_2=[];
    for i=1:trials
        synthetic_emg_1 = [synthetic_emg_1;generate_synthetic_emg(N, frequencies)'];
        synthetic_emg_2 = [synthetic_emg_2;generate_synthetic_emg(N, frequencies)'];
    end
    
    %Normalize the range of each signal
    synthetic_emg_1=normalize_emg(synthetic_emg_1);
    synthetic_emg_2=normalize_emg(synthetic_emg_2);

    % Step 2: Generate (anti-) correlated noise
    mu = [0 0];  % Mean of the noise
    sigma = [1 noise_correlation; noise_correlation 1];  % Covariance matrix
    R = chol(sigma);  % Cholesky decomposition

    % Generate the noise
    noise1 = [];
    noise2 = [];
    for i = 1:trials
        uncorrelatedNoise = randn(N, 2);  % Generate uncorrelated noise
        correlatedNoise = uncorrelatedNoise * R;  % adjust correlational structure of the noise
        noise1 = [noise1;correlatedNoise(:, 1)];
        noise2 = [noise2;correlatedNoise(:, 2)];
    end

    y=repmat([repelem(0,N)';repelem(1,N)'],trials);y=y(1:N*trials,1);% Generate a binary task parameter
    EMG_1 = (synthetic_emg_1.* y)+ noise1; % Make two signals that encode this stimulus
    EMG_2 = (synthetic_emg_2 .* y)+ noise2;
    task_param = y; % Task parameter is y


    % % % Plot the results
    % figure;
    % 
    % subplot(1, 2, 1);
    % plot(EMG_1);
    % title([relationship_type, ': EMG 1']);
    % 
    % subplot(1, 2, 2);
    % plot(EMG_2);
    % title([relationship_type, ': EMG 2']);
    % 
    % % Output the simulated signals and task parameter
    % disp('Simulated EMG signals and task parameter:');
    % disp('EMG_1:');
    % disp(EMG_1);
    % disp('EMG_2:');
    % disp(EMG_2);
    % disp('Task parameter:');
    % disp(task_param);
end

function synthetic_emg = generate_synthetic_emg(N, frequencies)
    sampling_rate = 1000; % Sampling rate in Hz
    t = (0:N-1) / sampling_rate;

    % Generate the synthetic EMG signal by summing sinusoids of different frequencies
    synthetic_emg = zeros(1, N);
    for i = 1:length(frequencies)
        freq = frequencies(i);
        synthetic_emg = synthetic_emg + sin(2 * pi * freq * t);
    end
end

function normalized_emg = normalize_emg(emg_signal)
    % Normalize EMG signals to the range [0, 1]
    min_val = min(emg_signal);
    max_val = max(emg_signal);
    normalized_emg = (emg_signal - min_val) ./ (max_val - min_val);
end
