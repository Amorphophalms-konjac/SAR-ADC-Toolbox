function figureHandle = plotAdcDynamicSimulationResult( p, samples, adc )

  %% Convert bin power to dBFS
  binPower = adc.psd.powerDensity( : ) * p.sampleRate / p.fftLen;
  fullScalePower = p.vRef ^ 2 / 8;
  spectrumDbfs = 10 * log10( max( binPower / fullScalePower, realmin ) );
  inputFrequency = samples.toneBin * p.sampleRate / p.fftLen;

  %% Plot the single-sided spectrum
  figureHandle = figure( 'Color', 'w', 'Name', 'ADC Dynamic Simulation', 'NumberTitle', 'off' );
  axesHandle = axes( 'Parent', figureHandle );
  plot( axesHandle, adc.psd.frequency( : ), spectrumDbfs, 'b', 'LineWidth', 2.5 );
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
  % Exclude zero-power bins when choosing the visible vertical range.
  positivePowerDb = spectrumDbfs( binPower > 0 );
  lowerLimit = 10 * floor( min( positivePowerDb ) / 10 ) - 5;
  upperLimit = 10 * ceil( max( positivePowerDb ) / 10 ) + 5;
  ylim( axesHandle, [ lowerLimit, upperLimit ] );
end
