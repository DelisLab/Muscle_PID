function [EMG_1, EMG_2, task_param] = simulate_emg_data(N, noise_level, relationship_type, frequencies)
    if nargin < 2
        noise_level = 0.1; % Default noise level
    end
    if nargin < 3
        error('You must specify the relationship type as: redundant, synergistic, or independent.');
    end
    if nargin < 4
        frequencies = [30, 70, 150]; % Default frequencies
    end

    % Generate a binary task parameter
    y = randi([0, 1], N, 1);
    
    % Generate synthetic EMG signals
    synthetic_emg = generate_synthetic_emg(N, frequencies)';

    switch relationship_type
        case 'redundant'
            EMG_1 = (synthetic_emg + noise_level * randn(N, 1)).* y; % Make two signals that encode the stimuli in a similar way
            EMG_2 = (synthetic_emg + noise_level * randn(N, 1)).* y; 
            task_param = double((EMG_2>0 | EMG_1>0 & y==1)); % Generate a conditional relationship
        case 'synergistic'
            EMG_1 = (synthetic_emg + noise_level * randn(N, 1)).* y; 
            EMG_2 = (synthetic_emg + noise_level * randn(N, 1)).* (1 - y); % Make EMG_2 the functional complement of EMG_1
            task_param = double((EMG_2>0 | EMG_1>0 & y==1)); % Generate a conditional relationship
          
        case 'independent'
            EMG_1 = (synthetic_emg + noise_level * randn(N, 1)).* y; %'when My is active in a specific way' (see fig.2 of manuscript)
            EMG_2 = (synthetic_emg + noise_level * randn(N, 1)).* (1 - y); % Make EMG_2 the complement of EMG_1
            task_param = double((EMG_2 < EMG_1) & y==1); % Generate a conditional relationship between the muscles and the task
        otherwise
            error('Unknown relationship type. Choose from: redundant, synergistic, or independent.');
    end

    % Normalize EMG signals
    EMG_1 = normalize_emg(EMG_1);
    EMG_2 = normalize_emg(EMG_2);

    % Plot the results
    figure;
    
    subplot(1, 2, 1);
    plot(EMG_1);
    title([relationship_type, ': EMG 1']);
    
    subplot(1, 2, 2);
    plot(EMG_2);
    title([relationship_type, ': EMG 2']);

    % Output the simulated signals and task parameter
    disp('Simulated EMG signals and task parameter:');
    disp('EMG_1:');
    disp(EMG_1);
    disp('EMG_2:');
    disp(EMG_2);
    disp('Task parameter:');
    disp(task_param);
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
    normalized_emg = (emg_signal - min_val) / (max_val - min_val);
end
