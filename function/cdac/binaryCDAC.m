function aOut = binaryCDAC( capArray, p, sample, switchArray )
  cTot = sum( capArray );
  qSample = - cTot * sample;
  qCDAC = capArray( 1 : end-1 ) * switchArray.' * p.vRef;
  aOut = p.vCM + ( qSample + qCDAC ) / cTot;
end