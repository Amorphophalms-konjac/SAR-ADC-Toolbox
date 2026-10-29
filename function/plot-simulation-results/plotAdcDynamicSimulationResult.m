function figureHandle = plotAdcDynamicSimulationResult( p, adc )

%% Prepare the logarithmic power spectral density
powerDensity = adc.psd.powerDensity( : );
% ‘realmin’ is the smallest positive normalized double-precision
% floating-point number in MATLAB. It prevents zero-power bins
% from producing -Inf when taking the logarithm
powerDensityDb = 10 * log10( max( powerDensity, realmin ) );
inputFrequency = p.nCycle * p.sampleRate / p.fftLen;

%% Plot the single-sided output PSD
figureHandle = figure( 'Color', 'w', ...
  'Name', 'ADC Dynamic Simulation', 'NumberTitle', 'off' );
axesHandle = axes( 'Parent', figureHandle );
plot( axesHandle, adc.psd.frequency( : ), powerDensityDb, ...
  'b', 'LineWidth', 2.5 );
set( axesHandle, 'Color', 'w', 'XColor', 'k', 'YColor', 'k' );
grid( axesHandle, 'on' );
xlabel( axesHandle, 'Frequency (kHz)', 'Color', 'k' );
ylabel( axesHandle, 'PSD (dB re 1 V^2/Hz)', 'Color', 'k' );
title( axesHandle, { 'ADC Output Power Spectral Density'; ...
  sprintf( 'SNDR = %.2f dB | ENOB = %.3f bit | f_{in} = %.3f Hz', ...
  adc.sndr, adc.enob, inputFrequency ) }, ...
  'Color', 'k' );

%% Set limits with no horizontal whitespace and vertical headroom
xlim( axesHandle, [ 0, p.sampleRate / 2 ] );
% Keep frequency data in Hz and display tick labels in kHz.
axesHandle.XAxis.Exponent = 0;
xticklabels( axesHandle, compose( '%g', xticks( axesHandle ) / 1e3 ) );
% Exclude zero-power bins when choosing the visible vertical range.
positivePowerDb = powerDensityDb( powerDensity > 0 );
lowerLimit = 10 * floor( min( positivePowerDb ) / 10 ) - 5;
upperLimit = 10 * ceil( max( positivePowerDb ) / 10 ) + 5;
ylim( axesHandle, [ lowerLimit, upperLimit ] );
end
