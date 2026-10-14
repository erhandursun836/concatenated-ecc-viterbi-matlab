

function c = conv_encoder(m)
    
    % g1 = 13 (octal) -> 1011 = x + D1 + D3
    % g2 = 15 (octal) -> 1101 = x + D2 + D3

    %Trellis
    % K = 4, therefore added 3 zeros.
    m_pad = [m, 0, 0, 0];
    
    %Initialized output array and registers.
    c = [];
   
    D1 = 0;
    D2 = 0;
    D3 = 0;
    
    
    for i = 1:length(m_pad)

        x = m_pad(i);
        
        % Calculated c1 using g1 = 1011
        c1 = mod(x + D1 + D3, 2);
        
        % Calculated output c2 using g2 = 1101
        c2 = mod(x + D2 + D3, 2);
       
        c = [c, c1, c2];
        
        
        D3 = D2;
        D2 = D1;
        D1 = x;
    end
end