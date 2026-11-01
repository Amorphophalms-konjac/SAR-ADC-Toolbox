function printAdcDynamicSimulationResult( p, samples, adc )
  % Print the simulation parameters and measured ADC dynamic performance.

  %% Print simulation parameters
  fprintf( '\nSingle-Ended CBW SAR ADC Dynamic Simulation\n' );
  fprintf( 'ADC resolution: %d bit\n', p.adcResolution );
  fprintf( 'Reference voltage: %.4f V\n', p.vRef );
  fprintf( 'Sample rate: %.6g Hz\n', p.sampleRate );
  fprintf( 'FFT length: %d samples\n', p.fftLen );
  fprintf( 'Input frequency: %.6f Hz\n', samples.toneBin * p.sampleRate / p.fftLen );

  %% Print dynamic performance metrics
  fprintf( 'SNDR: %.4f dB\n', adc.sndr );
  fprintf( 'ENOB: %.4f bit\n\n', adc.enob );
end
