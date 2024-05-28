function [EMG_1, EMG_2, task_param] = simulate_emg_data(N, noise_level, relationship_type)
    if nargin < 2
        noise_level = 0.1; % Default noise level
    end
    if nargin < 3
        error('You must specify the relationship type as: redundant, synergistic, or independent.');
    end

    % Generate a binary task parameter
    y = randi([0, 1], N, 1);

    switch relationship_type
        case 'redundant'
            EMG_1 = y + noise_level * randn(N, 1); %Make two signals that encode the stimuli in a similar way
            EMG_2 = y + noise_level * randn(N, 1); 
            task_param = y;
        case 'synergistic'
            EMG_1 = y + noise_level * randn(N, 1); 
            EMG_2 = (1 - y) + noise_level * randn(N, 1); % Make EMG_2 the complement of EMG_1
            task_param = double((EMG_1 > 0) & (EMG_2 > 0)); %Generate a conditional relationship in the task parameter
        case 'independent'
            EMG_1 = noise_level * randn(N, 1); %Make one signal that encodes the stimuli and one that doesn't
            EMG_2 = y + noise_level * randn(N, 1); 
            task_param = y;
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

function normalized_emg = normalize_emg(emg_signal)
    % Normalize EMG signals to the range [0, 1]
    min_val = min(emg_signal);
    max_val = max(emg_signal);
    normalized_emg = (emg_signal - min_val) / (max_val - min_val);
end