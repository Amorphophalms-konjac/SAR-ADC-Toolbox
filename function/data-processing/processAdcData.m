function adc = processAdcData( p, samples, conversionResult )
  %% Reconstruct voltages and remove DC
  vReconstructed = idealDAC( p, conversionResult );

  %% Compute PSD, SNDR, and ENOB
  % [ adc.psd.powerDensity, adc.psd.frequency ] = periodogram( vReconstructed, [], p.fftLen, p.sampleRate, 'onesided' );
  fftResult = fft( vReconstructed );
  binPower = abs( fftResult( 1 : p.fftLen / 2 + 1 ) / p.fftLen ) .^ 2 .* [ 0 ; 2 * ones( p.fftLen / 2 - 1, 1 ) ; 1 ];
  adc.spectrum.binPower = binPower;
  adc.spectrum.frequency = ( 0 : p.fftLen / 2 )' * p.sampleRate / p.fftLen;
  adc.sndr = calculateSNR( sqrt( adc.spectrum.binPower( 2 : end ) ), samples.toneBin - 1, 0 );
  adc.enob = ( adc.sndr - 1.76 ) / 6.02;
end
