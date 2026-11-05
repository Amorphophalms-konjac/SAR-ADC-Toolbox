function figureHandle = plotAdcDynamicSimulationResult( p, samples, adc )

  %% Convert bin power to dBFS
  fullScalePower = p.vRef ^ 2 / 8;
  spectrumDbfs = 10 * log10( max( adc.spectrum.binPower / fullScalePower, realmin ) );
  inputFrequency = samples.toneBin * p.sampleRate / p.fftLen;

  %% Plot the single-sided spectrum
  figureHandle = figure( 'Color', 'w', 'Name', 'ADC Dynamic Simulation', 'NumberTitle', 'off' );
  axesHandle = axes( 'Parent', figureHandle );
  plot( axesHandle, adc.spectrum.frequency, spectrumDbfs, 'b', 'LineWidth', 2.5 );
  set( axesHandle, 'Color', 'w', 'XColor', 'k', 'YColor', 'k' );
  grid( axesHandle, 'on' );
  xlabel( axesHandle, 'Frequency (kHz)', 'Color', 'k' );
  ylabel( axesHandle, 'Power (dBFS)', 'Color', 'k' );
  title( axesHandle, 'ADC Output Spectrum', 'Color', 'k' );
  resultText = sprintf( 'SNDR = %.2f dB\nENOB = %.3f\nf_{in} = %.3f kHz', adc.sndr, adc.enob, inputFrequency / 1e3 );
  text( axesHandle, 0.03, 0.95, resultText, 'Units', 'normalized', 'VerticalAlignment', 'top', 'FontSize', 12, 'Color', 'k', 'BackgroundColor', 'w' );

  %% Set limits with no horizontal whitespace and vertical headroom
  xlim( axesHandle, [ 0, p.sampleRate / 2 ] );
  % Keep frequency data in Hz and display tick labels in kHz.
  axesHandle.XAxis.Exponent = 0;
  xticklabels( axesHandle, compose( '%g', xticks( axesHandle ) / 1e3 ) );
  % Estimate the average per-bin quantization noise floor.
  idealSNR = 6.02 * p.adcResolution + 1.76;
  fftProcessGain = 10 * log10( p.fftLen / 2 );
  noiseFloorDbfs = -idealSNR - fftProcessGain;
  % Round down to leave room below the theoretical noise floor.
  lowerLimit = 5 * floor( noiseFloorDbfs / 5 );
  upperLimit = 5;
  ylim( axesHandle, [ lowerLimit, upperLimit ] );
end
