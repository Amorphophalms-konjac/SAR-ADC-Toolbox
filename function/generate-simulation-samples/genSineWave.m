function sineWave = genSineWave( fftLen, toneBin, nSamples, vRef, vCM )
  if(nargin < 2)
    error('Too fe input arguments!');
  elseif(nargin == 3)
    vRef = 1;
    vCM = vRef / 2;
  else
  end % end of if

  sineFreq = toneBin / fftLen;
  sineWave = vCM + 0.5 * vRef * sin( 2 * pi * sineFreq * ( 0 : nSamples - 1 ) + pi / 2 );
end