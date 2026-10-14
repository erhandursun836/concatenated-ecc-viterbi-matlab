
%Phase 2 - Hamming Encoder

function c = hamming_encoder(m)

    G = [1 0 0 0 1 1 0;
         0 1 0 0 1 1 1;
         0 0 1 0 0 1 1;
         0 0 0 1 1 0 1];

    c = mod(m * G, 2);
end