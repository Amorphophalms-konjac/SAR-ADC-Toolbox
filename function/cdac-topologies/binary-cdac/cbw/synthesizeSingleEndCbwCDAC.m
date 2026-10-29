function dac = synthesizeSingleEndCbwCDAC( p )
% use simulation config to sythesize a single-ended CBW CDAC

adcResolution = p.adcResolution;

dac = @singleEndDAC;

% TODO: add non-ideal effects, eg: mismatch, parasitics

  function vDacOut = singleEndDAC( code, vRef )
    vDacOut = vRef * double( code ) / 2 ^ adcResolution;
  end
end
