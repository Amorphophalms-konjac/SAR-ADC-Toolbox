function samples = genSamples( p )
  if( p.randomFreqOn )
    samples.toneBin = genToneBin( p.fftLen );
  else
    samples.toneBin = p.freq;
  end
  samples.data = genSineWave( p.fftLen, samples.toneBin, p.nSamples, p.vRef, p.vCM );
end