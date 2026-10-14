# Concatenated Error-Correction & Custom Viterbi Decoder in MATLAB

## 📌 Overview
This project simulates a complete digital communication pipeline in MATLAB to test how well different Forward Error Correction (FEC) methods protect data against channel noise. 

All encoders and decoders in this repository are **built from scratch** without using MATLAB's Communications Toolbox. The system compares three different architectures:
1. **Hamming (7,4) Block Code Only** (Outer Code)
2. **Rate-1/2 Convolutional Code Only** (Inner Code)
3. **Concatenated System** (Hamming outer code combined with a Convolutional inner code)

---

##  System Architecture

In the concatenated configuration, data passes through two layers of protection to handle both random single-bit errors and localized burst errors:

`Raw Data` -> **Hamming (7,4) Encoder** -> **Convolutional Encoder** -> **Noisy Channel (BSC)** -> **Viterbi Decoder** -> **Hamming Decoder** -> `Recovered Data`

### Key Technical Features
* **Hardware-Accurate Viterbi Decoder:** Implemented from the ground up (`viterbi_decoder.m`) using pre-computed state-transition lookup tables (8x2 matrices for 8 states and 2 inputs), hard-decision Hamming distance metrics, Add-Compare-Select (ACS) survivor path filtering, and zero-flushed trellis traceback.
* **Convolutional Encoder:** Rate-1/2 encoder with constraint length K = 4 (3 memory registers, 8 states) using generator polynomials g1 = (1, 1, 0, 1) and g2 = (1, 0, 1, 1).
* **Hamming (7,4) Codec:** Maps 4-bit data blocks into 7-bit codewords using parity generation and corrects single-bit errors via syndrome decoding.
* **Repeatable Noise Simulation:** Models a Binary Symmetric Channel (`bsc_channel.m`) using controlled random seeds so that all three architectures are tested against identical noise patterns.

---

##  Repository Structure

### Core Modules
* `hamming_encoder.m` & `hamming_decoder.m` — Encodes 4-bit blocks into 7-bit codewords and performs single-error correction using syndrome lookups.
* `conv_encoder.m` — Rate-1/2 convolutional encoder with 3 tail bits (zero-padding) to reset the shift register to State `000`.
* `viterbi_decoder.m` — Custom hard-decision Viterbi algorithm utilizing ACS logic and traceback memory matrices.
* `bsc_channel.m` — Simulates a Binary Symmetric Channel that flips bits based on a target Bit Error Rate (BER) and random seed.

### Testing & Simulation Scripts
* `hamming_test.m` & `conv_test.m` — Unit test scripts that verify the encoders and decoders against manual single-bit and burst errors.
* `driver_script.m` — Runs an end-to-end diagnostic test on a binary data stream at a single BER, printing out error bit locations and Viterbi trellis failure windows.
* `simulation.m` — Automated Monte Carlo script that tests all 3 configurations across **5 BER levels** (`0.001` to `0.15`) and **3 noise seeds** (45 total runs), storing the results in 3D matrices.
* `result_plots.m` — Processes the Monte Carlo data and plots the logarithmic BER waterfall curves comparing individual seeds and statistical averages.

---

## Key Results & Performance Analysis

### Summary of Findings
* Low-to-Moderate Noise (BER = 0.001 to 0.05): Both the Convolutional-only and Concatenated systems achieve 0% Output BER (Perfect Decoding) at 0.001 and 0.01 BER across all tested seeds, while the standalone Hamming (7,4) code begins failing early whenever 2 or more bit flips land inside the same 7-bit block
* The Viterbi Breakdown Threshold (BER = 0.10 to 0.15): When channel noise becomes severe and exceeds the free distance bound ($d_{\text{free}} = 6$) of the convolutional code, the Viterbi decoder diverges onto incorrect survivor paths. This causes localized burst errors, pushing the Convolutional and Concatenated error rates higher than standalone Hamming at extreme noise levels.
* Concatenated Advantage: Even during severe noise (BER = 0.15), the Concatenated system consistently outperforms the standalone Convolutional code (~24% vs. ~30% Output BER) because the outer Hamming (7,4) decoder successfully catches and repairs isolated single-bit errors left behind by the Viterbi decoder.

<img width="560" height="420" alt="ber_results" src="https://github.com/user-attachments/assets/03fa3797-911b-41f2-bc7a-e1d3fb9ad567" />

---

  Author: Erhan Dursun
