function adc = processAdcData( p, conversionResult )
% process ADC output data to compute PSD, SNDR and ENOB

%% Reconstruct voltages with an ideal DAC and remove DC
vReconstructed = idealDAC( p, conversionResult( : ) );
vReconstructedAC = vReconstructed - p.vRef / 2;

%% FFT and compute single-sided power spectral density
fftResult = fft( vReconstructedAC ) / p.fftLen;
% Double paired frequency powers; leave DC and Nyquist unchanged.
singleSidedPower = [ abs( fftResult( 1 ) ) .^ 2; ...
  2 * abs( fftResult( 2 : p.fftLen / 2 ) ) .^ 2; ...
  abs( fftResult( p.fftLen / 2 + 1 ) ) .^ 2 ];
frequencyResolution = p.sampleRate / p.fftLen;
adc.psd.frequency = ( 0 : p.fftLen / 2 ).' * frequencyResolution;
adc.psd.powerDensity = singleSidedPower / frequencyResolution;

%% Compute Dynamic Performance Metrics
% separate the signal power from the noise and distortion power
signalIndex = p.nCycle + 1;
signalPower = singleSidedPower( signalIndex );
noiseDistortionMask = true( size( singleSidedPower ) );
noiseDistortionMask( 1 ) = false;
noiseDistortionMask( signalIndex ) = false;
noiseDistortionPower = sum( singleSidedPower( noiseDistortionMask ) );
% compute SNDR and ENOB
adc.sndr = 10 * log10( signalPower / noiseDistortionPower );
adc.enob = ( adc.sndr - 1.76 ) / 6.02;
end
