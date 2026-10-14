

% This function decodes the recieved message using Viterbi algortihm.
    
function decoded_msg = viterbi_decoder(r)
    
    num_time_steps = length(r) / 2;

    % Column 1 = Input 0, Column 2 = Input 1
    next_state = zeros(8, 2);
    
   
    expected_out_c1 = zeros(8, 2);
    expected_out_c2 = zeros(8, 2);
    
    for state = 0:7
        
        D1 = bitget(state, 3); 
        D2 = bitget(state, 2);
        D3 = bitget(state, 1); 
        
        for input_bit = 0:1
           
            c1 = mod(input_bit + D1 + D3, 2);
            c2 = mod(input_bit + D2 + D3, 2);
            
           
            n_state_val = input_bit * 4 + D1 * 2 + D2 * 1;
            
            % Input and state are written with +1 due to matlab indexing
            next_state(state + 1, input_bit + 1) = n_state_val;
            expected_out_c1(state + 1, input_bit + 1) = c1;
            expected_out_c2(state + 1, input_bit + 1) = c2;
        end
    end
    
    % First state is 0 and the rest is inifinity since it is impossible to
    % start there.
    path_metrics = [0, inf, inf, inf, inf, inf, inf, inf];
    survivor_states = zeros(8, num_time_steps);
    survivor_inputs = zeros(8, num_time_steps);

    for t = 1:num_time_steps
        next_path_metrics = [inf, inf, inf, inf, inf, inf, inf, inf];
        r1 = r(2*t - 1);
        r2 = r(2*t);
        

        for state = 0:7
            if path_metrics(state + 1) ~= inf
               for input_bit = 0:1
    
                exp_c1 = expected_out_c1(state + 1, input_bit + 1);
                exp_c2 = expected_out_c2(state + 1, input_bit + 1);
                
                % Hamming Distance
           
                h_d = 0;
                if r1 ~= exp_c1
                    h_d = h_d + 1;
                end
                if r2 ~= exp_c2
                    h_d = h_d + 1;
                end
                
                total_dist = path_metrics(state + 1) + h_d;
                n_state = next_state(state + 1, input_bit + 1);
                if total_dist < next_path_metrics(n_state + 1)
                    next_path_metrics(n_state + 1) = total_dist; 
                    survivor_states(n_state + 1, t) = state;
                    survivor_inputs(n_state + 1, t) = input_bit;
                end
                end
            end
        end
        path_metrics = next_path_metrics;
    end

   % Started from 0 as the encoder had 3 zeros added to the end of the
   % message.
    current_state = 0;
    
    full_decoded_msg = zeros(1, num_time_steps);
    
   
    for t = num_time_steps:-1:1
        
        prev_input = survivor_inputs(current_state + 1, t);
     
        prev_state = survivor_states(current_state + 1, t);
        
        full_decoded_msg(t) = prev_input;

        current_state = prev_state;
    end
    
  %Removing the added 3 zeros.
    decoded_msg = full_decoded_msg(1:end-3);

end