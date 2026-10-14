
% Hamming Code Test
% To test the code, no error, single error and double error conditions will be applied.

msg = [1, 0, 0, 1];

codeword = hamming_encoder(msg);

disp(codeword);


% No error condition
disp(' Test 1: No Errors');
received_1 = codeword;
[decoded_1, error_detected_1] = hamming_decoder(received_1);
disp('Decoded Message of Test 1:');
disp(decoded_1);



% Single bit error condition, third bit is flipped.
disp('Test 2: Single Error in Bit 3');
received_2 = codeword;

received_2(3) = 1 - received_2(3);

[decoded_2, error_detected_2] = hamming_decoder(received_2);
disp('Decoded Message of Test 2:');
disp(decoded_2);


% Double bit error condition, first and fifth bits are flipped.
disp('Test Case C: Double Error in Bits 1 and 5');
received_C = codeword;

received_C(1) = 1 - received_C(1);
received_C(5) = 1 - received_C(5);




[decoded_C, error_detected_C] = hamming_decoder(received_C);
disp('Decoded Message of Test 3:');
disp(decoded_C);