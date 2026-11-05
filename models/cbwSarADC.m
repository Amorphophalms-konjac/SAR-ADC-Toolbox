function conversionResult = cbwSarADC( sample, p, cdac )
  % a CBW SAR ADC function (now is an ideal single-ended implementation)

  cdac.switchArray = zeros( 1, p.adcResolution );
  for iBit = 1 : p.adcResolution
    cdac.switchArray( iBit ) = 1;
    aOut = binaryCDAC( cdac.capArray, p, sample, cdac.switchArray );
    decision = idealComparator( p.vCM, aOut );
    if ~decision
      cdac.switchArray( iBit ) = 0;
    end
  end
  conversionResult = cdac.switchArray;

  % TODO: add other SAR ADC topologies.
end