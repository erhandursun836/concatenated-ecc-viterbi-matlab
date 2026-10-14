


% This is the test code to verify the convolutional encoder and Viterbi decoder.

msg = [1, 0, 1, 1, 0];
disp('Message:')
disp(msg);


encoded = conv_encoder(msg);
disp('Encoded:');
disp(encoded);

% Test Case 1: No Noise
disp('Test Case 1: No Noise');
decoded_1 = viterbi_decoder(encoded);
disp('Decoded Message 1:');
disp(decoded_1);

% Test Case 2: Single Bit Error at bit 3

disp('Test Case 2: Single Error at Bit 3');
received_2 = encoded;
received_2(3) = 1 - received_2(3); 

decoded_2 = viterbi_decoder(received_2);
disp('Decoded Message 2:');
disp(decoded_2);

% Test Case 3: Double Error at bit 2 and 9
disp('Test Case 3: Double Error (Bits 2 and 9)');
received_3 = encoded;
received_3(2) = 1 - received_3(2);
received_3(9) = 1 - received_3(9);
decoded_3 = viterbi_decoder(received_3);
disp('Decoded Message 3:');
disp(decoded_3);

% Test Case 4: Two errors next to each other.
disp(' Test Case 4: Burst Error (Bits 6 and 7)');
received_4 = encoded;
received_4(6) = 1 - received_4(6);
received_4(7) = 1 - received_4(7);
decoded_4 = viterbi_decoder(received_4);
disp('Decoded Message 4:');
disp(decoded_4);