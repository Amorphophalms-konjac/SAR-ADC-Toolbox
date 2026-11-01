function adc = processAdcData( p, samples, conversionResult )
  %% Reconstruct voltages and remove DC
  vReconstructed = idealDAC( p, conversionResult( : ) );
  vReconstructed = vReconstructed - mean( vReconstructed );

  %% Compute PSD, SNDR, and ENOB
  [ adc.psd.powerDensity, adc.psd.frequency ] = periodogram( vReconstructed, [], p.fftLen, p.sampleRate, 'onesided' );
  adc.sndr = calculateSNR( sqrt( adc.psd.powerDensity( 2 : end ) ), samples.toneBin - 1, 0 );
  adc.enob = ( adc.sndr - 1.76 ) / 6.02;
end
