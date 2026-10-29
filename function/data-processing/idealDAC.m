function vReconstructed = idealDAC( p, conversionResult )
% vectorized ideal DAC function

vReconstructed = double( conversionResult ) ...
  .* ( p.vRef / 2 ^ p.adcResolution );
end
