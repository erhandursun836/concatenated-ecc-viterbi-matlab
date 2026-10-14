

%This is the driver script to test the codes as required: Hamming only,
%convolutional only, concatenated.


message = [1, 0, 1, 0];
disp('Message:');
disp(message);

% Hamming
hamming_enc = hamming_encoder(message);
disp('Hamming Encoded:');
disp(hamming_enc);

% Convolutional
conv_enc = conv_encoder(hamming_enc);
disp('Convolutional Encoded:');
disp(conv_enc);

% The Channel (BSC)
ber = 0.05;
seed = 5341;
received_seq = bsc_channel(conv_enc, ber, seed);
disp('Received from BSC:');
disp(received_seq);

% Viterbi Decoder
viterbi_dec = viterbi_decoder(received_seq);
disp('Viterbi Decoded:');
disp(viterbi_dec);

% Hamming Decoder
[final_msg, error_detected] = hamming_decoder(viterbi_dec);
disp('Final Decoded Message:');
disp(final_msg);

