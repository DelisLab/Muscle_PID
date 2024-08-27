function [EMG_1, EMG_2, task_param] = simulate_emg_data(N,signal_correlation,noise_correlation, frequencies,trials)
 
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

    % Generate the noise and adjust correlational structure
    noise1 = [];
    noise2 = [];
    for i = 1:trials
        uncorrelatedNoise = randn(N, 2);  % Generate uncorrelated noise
        correlatedNoise = uncorrelatedNoise * R;  % adjust correlational structure of the noise
        noise1 = [noise1;correlatedNoise(:, 1)];
        noise2 = [noise2;correlatedNoise(:, 2)];
    end
    
    y1=repmat([repelem(0,N)';repelem(1,N)'],trials);y1=y1(1:N*trials,1);% Generate a binary task parameter

    y2 = zeros(size(y1));%Initalise a second binary task parameter to be simulated with respect to y1 and the specified signal correlation
    
    %Values of y2 (i.e. 1 or 0) are determined based on their likelihood
    %(specified by the signal correlation).
    for i = 1:length(y1)
        if signal_correlation > 0
            % For positive correlation, y2 is more likely to match y1
            if rand < signal_correlation
                y2(i) = y1(i);
            else
                y2(i) = 1 - y1(i);
            end
        elseif signal_correlation < 0
            % For negative correlation, y2 is more likely to be the inverse of y1
            if rand < abs(signal_correlation)
                y2(i) = 1 - y1(i);
            else
                y2(i) = y1(i);
            end
        else
            % For zero correlation, generate a random binary sequence for y2
            y2(i) = rand > 0.5;
        end
    end

    EMG_1 = (synthetic_emg_1.* y1)+ noise1; % Encode the stimulus and inject the noise
    EMG_2 = (synthetic_emg_2 .* y2)+ noise2;
    task_param = y1; % Task parameter for further analysis is y1


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
