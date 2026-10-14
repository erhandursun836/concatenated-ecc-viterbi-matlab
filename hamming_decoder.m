
%Phase 2 - Hamming Syndrome Decoder

function [Ms, error_detected] = hamming_decoder(r)

    H = [1 1 0 1 1 0 0;
         1 1 1 0 0 1 0;
         0 1 1 1 0 0 1];

    %Syndrome
    S = mod(r * H', 2); 
    
    error_pos = 0; 
    error_detected = false;
    
   if S(1) == 0 && S(2) == 0 && S(3) == 0
        error_pos = 0;
        error_detected = false;

    elseif S(1) == 1 && S(2) == 1 && S(3) == 0
        error_pos = 1;
        error_detected = true;

    elseif S(1) == 1 && S(2) == 1 && S(3) == 1
        error_pos = 2;
        error_detected = true;

    elseif S(1) == 0 && S(2) == 1 && S(3) == 1
        error_pos = 3; 
        error_detected = true;
  
    elseif S(1) == 1 && S(2) == 0 && S(3) == 1
        error_pos = 4; 
        error_detected = true;

    elseif S(1) == 1 && S(2) == 0 && S(3) == 0
        error_pos = 5; 
        error_detected = true;

    elseif S(1) == 0 && S(2) == 1 && S(3) == 0
        error_pos = 6;
        error_detected = true;

    elseif S(1) == 0 && S(2) == 0 && S(3) == 1
        error_pos = 7;
        error_detected = true;
    end

  
    if error_pos > 0
       
        if r(error_pos) == 0
            r(error_pos) = 1;
        else
            r(error_pos) = 0;
        end
    end


    Ms = [r(1), r(2), r(3), r(4)];
end