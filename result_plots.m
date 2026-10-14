
% This script generates the performance comparison plots.


raw_ber = errors_after / total_bits;


avg_ber = mean(raw_ber, 3);

seed_vec = [5341, 10645, 18139];


figure('Name', 'Performance Results', 'Color', 'w');
hold on;
grid on; grid minor;

x_anchor = ber_vec(end); 

% 1.HAMMING ONLY
for s = 1:3
 
    semilogy(ber_vec, raw_ber(1, :, s), 'r:', 'LineWidth', 1.2, 'HandleVisibility', 'off');

    y_anchor = raw_ber(1, end, s);
    text(x_anchor, y_anchor, sprintf('  Seed %d', seed_vec(s)), 'Color', 'r', 'FontSize', 9, 'FontWeight', 'bold', 'VerticalAlignment', 'middle');
end
semilogy(ber_vec, avg_ber(1, :), 'r-o', 'LineWidth', 2.5, 'MarkerSize', 6, 'DisplayName', 'Hamming (avg.)');

% 2.CONVOLUTIONAL ONLY
for s = 1:3
    semilogy(ber_vec, raw_ber(2, :, s), 'b:', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    
    y_anchor = raw_ber(2, end, s);
    text(x_anchor, y_anchor, sprintf('  Seed %d', seed_vec(s)), ...
        'Color', 'b', 'FontSize', 9, 'FontWeight', 'bold', 'VerticalAlignment', 'middle');
end
semilogy(ber_vec, avg_ber(2, :), 'b-s', 'LineWidth', 2.5, 'MarkerSize', 6, 'DisplayName', 'Convolutional (avg.)');

% 3.CONCATENATED SYSTEM
for s = 1:3
    semilogy(ber_vec, raw_ber(3, :, s), 'g:', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    
    y_anchor = raw_ber(3, end, s);
    text(x_anchor, y_anchor, sprintf('  Seed %d', seed_vec(s)), 'Color', '#008000', 'FontSize', 9, 'FontWeight', 'bold', 'VerticalAlignment', 'middle');
end
semilogy(ber_vec, avg_ber(3, :), 'g-^', 'LineWidth', 2.5, 'MarkerSize', 6, 'DisplayName', 'Concatenated (avg.)');

xlabel('Channel Bit Error Rate');
ylabel('Output Bit Error Rate');
title('Post Decoding BER vs. Channel BER');

xlim([ber_vec(1), ber_vec(end) + 0.015]); 
legend('show', 'Location', 'northwest'); 
hold off;