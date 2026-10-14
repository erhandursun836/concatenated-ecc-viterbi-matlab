

% This function will simulate a binary symmetric channel. It will flip the
% bits with the probability of the used ber.
function r = bsc_channel(c, ber, seed)

  
  
    rng(seed);

    
    num_bits = length(c);
    noise_vector = rand(1, num_bits);

    % Eror vector to flip the random bit.
    error_mask = zeros(1, num_bits);
    for i = 1:num_bits
        if noise_vector(i) < ber
            error_mask(i) = 1;
        end
    end

    % Applying the noise.
    r = zeros(1, num_bits);
    for i = 1:num_bits
        if error_mask(i) == 1
            
            if c(i) == 1
                r(i) = 0;
            else
                r(i) = 1;
            end
        else
          
            r(i) = c(i);
        end
    end
end