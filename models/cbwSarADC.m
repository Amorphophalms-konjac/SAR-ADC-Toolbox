function digitalCode = cbwSarADC( sample, p, dac )
% a CBW SAR ADC function (now is an ideal single-ended implementation)

code = 0;
for iBit = p.adcResolution - 1 : -1 : 0
    code = code + 2 ^ iBit;
    vDacOut = dac( code, p.vRef );
    decision = idealComparator( sample, vDacOut );
    if decision == 1
        % keep the bit set
    else
        % clear the bit
        code = code - 2 ^ iBit;
    end
end
digitalCode = code;
end