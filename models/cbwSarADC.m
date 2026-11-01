function digitalCode = cbwSarADC( sample, p, cdac )
  % a CBW SAR ADC function (now is an ideal single-ended implementation)

  cdac.switchArray = zeros( 1, p.adcResolution );
  for iBit = 1 : p.adcResolution
    cdac.switchArray( iBit ) = 1;
    vDacOut = p.vRef * sum( cdac.capArray( 1 : end - 1 ) .* cdac.switchArray ) / sum( cdac.capArray );
    decision = idealComparator( sample, vDacOut );
    if ~decision
      cdac.switchArray( iBit ) = 0;
    end
  end
  digitalCode = sum( cdac.switchArray .* 2 .^ ( p.adcResolution - 1 : -1 : 0 ) );

  % TODO: add other SAR ADC topologies.
end