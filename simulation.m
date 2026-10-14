


% This script runs the driver script for all 5 different BERs and 3
% different error seeds, then it keeps the record of errors to plot later.

personal_str = 'ECC2026-S03C';
ber_vec = [0.001, 0.01, 0.05, 0.10, 0.15];
seed_vec = [5341, 10645, 18139];

char_array = dec2bin(personal_str, 8);
original_stream = str2num(char_array(:))';
total_bits = length(original_stream);
num_blocks = total_bits / 4;

% Dimensions: (Configiration, BER Index, Seed Index)
errors_before  = zeros(3, 5, 3);
errors_after   = zeros(3, 5, 3);
perfect_decode = zeros(3, 5, 3);


for b = 1:length(ber_vec)
    current_ber = ber_vec(b);
    
    for s = 1:length(seed_vec)
        current_seed = seed_vec(s);
        
        % HAMMING ONLY
        hamming_only_tx = zeros(1, num_blocks * 7);
        in_pointer = 1; out_pointer = 1;

        for p = 1:num_blocks
            block = original_stream(in_pointer : in_pointer + 3);
            hamming_only_tx(out_pointer : out_pointer + 6) = hamming_encoder(block);
            in_pointer = in_pointer + 4; out_pointer = out_pointer + 7;
        end
        
        hamming_only_rx = bsc_channel(hamming_only_tx, current_ber, current_seed);
        
        hamming_only_decoded = zeros(1, total_bits);
        in_pointer = 1; out_pointer = 1;

        for p = 1:num_blocks
            o_block = hamming_only_rx(out_pointer : out_pointer + 6);
            [dec_block, ~] = hamming_decoder(o_block);
            hamming_only_decoded(in_pointer : in_pointer + 3) = dec_block;
            in_pointer = in_pointer + 4; out_pointer = out_pointer + 7;
        end
        
        errors_before(1, b, s)  = sum(hamming_only_tx ~= hamming_only_rx);
        errors_after(1, b, s)   = sum(original_stream ~= hamming_only_decoded);
        perfect_decode(1, b, s) = (errors_after(1, b, s) == 0);
        

        % CONVOLUTIONAL ONLY
        conv_only_tx = conv_encoder(original_stream);
        conv_only_rx = bsc_channel(conv_only_tx, current_ber, current_seed);
        conv_only_decoded = viterbi_decoder(conv_only_rx);
        
        errors_before(2, b, s)  = sum(conv_only_tx ~= conv_only_rx);
        errors_after(2, b, s)   = sum(original_stream ~= conv_only_decoded);
        perfect_decode(2, b, s) = (errors_after(2, b, s) == 0);
        

        % CONCATENATED
        concat_tx = conv_encoder(hamming_only_tx);
        concat_rx = bsc_channel(concat_tx, current_ber, current_seed);
        concat_viterbi_dec = viterbi_decoder(concat_rx);
        
        concat_final_decoded = zeros(1, total_bits);
        in_pointer = 1; out_pointer = 1;
        for p = 1:num_blocks
            block = concat_viterbi_dec(out_pointer : out_pointer + 6);
            [dec_block, ~] = hamming_decoder(block);
            concat_final_decoded(in_pointer : in_pointer + 3) = dec_block;
            in_pointer = in_pointer + 4; out_pointer = out_pointer + 7;
        end
        
        errors_before(3, b, s)  = sum(concat_tx ~= concat_rx);
        errors_after(3, b, s)   = sum(original_stream ~= concat_final_decoded);
        perfect_decode(3, b, s) = (errors_after(3, b, s) == 0);
        
    end
end


fprintf('                            SIMULATION ERROR RATES FOR ALL CASES                    \n');

fprintf('%-4s %-20s %-10s %-8s %-16s %-15s %-10s\n','Run', 'Configuration', 'BER', 'Seed', 'Errors Before', 'Errors After', 'Perfect Decoding');
fprintf('\n')

run_counter = 1;
config_labels = {'Hamming Only', 'Convolutional Only', 'Concatenated System'};

for b = 1:length(ber_vec)
    for s = 1:length(seed_vec)
        for config_idx = 1:3
            
           
            err_bef = errors_before(config_idx, b, s);
            err_aft = errors_after(config_idx, b, s);
            
            if perfect_decode(config_idx, b, s) == 1
                perf_status = 'YES';
            else
                perf_status = 'NO';
            end
            

            fprintf('%-4d %-20s %-10.3f %-8d %-16d %-15d %-10s\n',run_counter, config_labels{config_idx}, ber_vec(b), seed_vec(s), err_bef, err_aft, perf_status);
            
            run_counter = run_counter + 1;
        end
    end
end