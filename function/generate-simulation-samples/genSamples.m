function samples = genSamples( p )
% generate stimuli for ADC Dynamic Test

%% Define the input sine wave parameters
inputFrequency = p.nCycle * p.sampleRate / p.fftLen;
amplitude = p.vRef / 2 * 10 ^ ( p.inputAmplitudeDbfs / 20 );
offset = p.vRef / 2;

%% Generate one input voltage per completed conversion
% Exclude the endpoint so the record contains exactly fftLen samples.
samples.time = ( 0 : p.fftLen - 1 ).' / p.sampleRate;
samples.data = offset + amplitude ...
  * sin( 2 * pi * inputFrequency * samples.time);
end
