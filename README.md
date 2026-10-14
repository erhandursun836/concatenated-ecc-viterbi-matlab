\# Concatenated Error-Correction \& Custom Viterbi Decoder in MATLAB



\## 📌 Overview

This project simulates a complete digital communication pipeline in MATLAB to test how well different Forward Error Correction (FEC) methods protect data against channel noise. 



All encoders and decoders in this repository are \*\*built from scratch\*\* without using MATLAB's Communications Toolbox. The system compares three different architectures:

1\. \*\*Hamming (7,4) Block Code Only\*\* (Outer Code)

2\. \*\*Rate-1/2 Convolutional Code Only\*\* (Inner Code)

3\. \*\*Concatenated System\*\* (Hamming outer code combined with a Convolutional inner code)



\---



\## ⚙️ System Architecture



In the concatenated configuration, data passes through two layers of protection to handle both random single-bit errors and localized burst errors:



`Raw Data` $\\rightarrow$ \*\*Hamming (7,4) Encoder\*\* $\\rightarrow$ \*\*Convolutional Encoder\*\* $\\rightarrow$ \*\*Noisy Channel (BSC)\*\* $\\rightarrow$ \*\*Viterbi Decoder\*\* $\\rightarrow$ \*\*Hamming Decoder\*\* $\\rightarrow$ `Recovered Data`



\### Key Technical Features

\* \*\*Hardware-Accurate Viterbi Decoder:\*\* Implemented from the ground up (`viterbi\_decoder.m`) using pre-computed state-transition lookup tables ($8 \\times 2$ matrices for 8 states and 2 inputs), hard-decision Hamming distance metrics, Add-Compare-Select (ACS) survivor path filtering, and zero-flushed trellis traceback.

\* \*\*Convolutional Encoder:\*\* Rate-1/2 encoder with constraint length $K = 4$ (3 memory registers, 8 states) using generator polynomials $g\_1 = (1, 1, 0, 1)$ and $g\_2 = (1, 0, 1, 1)$.

\* \*\*Hamming (7,4) Codec:\*\* Maps 4-bit data blocks into 7-bit codewords using parity generation and corrects single-bit errors via syndrome decoding.

\* \*\*Repeatable Noise Simulation:\*\* Models a Binary Symmetric Channel (`bsc\_channel.m`) using controlled random seeds so that all three architectures are tested against identical noise patterns.



\---



\## 📂 Repository Structure



\### Core Modules

\* `hamming\_encoder.m` \& `hamming\_decoder.m` — Encodes 4-bit blocks into 7-bit codewords and performs single-error correction using syndrome lookups.

\* `conv\_encoder.m` — Rate-1/2 convolutional encoder with 3 tail bits (zero-padding) to reset the shift register to State `000`.

\* `viterbi\_decoder.m` — Custom hard-decision Viterbi algorithm utilizing ACS logic and traceback memory matrices.

\* `bsc\_channel.m` — Simulates a Binary Symmetric Channel that flips bits based on a target Bit Error Rate (BER) and random seed.



\### Testing \& Simulation Scripts

\* `hamming\_test.m` \& `conv\_test.m` — Unit test scripts that verify the encoders and decoders against manual single-bit and burst errors.

\* `driver\_script.m` — Runs an end-to-end diagnostic test on a binary data stream at a single BER, printing out error bit locations and Viterbi trellis failure windows.

\* `simulation.m` — Automated Monte Carlo script that tests all 3 configurations across \*\*5 BER levels\*\* (`0.001` to `0.15`) and \*\*3 noise seeds\*\* (45 total runs), storing the results in 3D matrices.

\* `result\_plots.m` — Processes the Monte Carlo data and plots the logarithmic BER waterfall curves comparing individual seeds and statistical averages.



\---



