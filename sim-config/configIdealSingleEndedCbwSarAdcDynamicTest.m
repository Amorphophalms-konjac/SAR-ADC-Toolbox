function p = configIdealSingleEndedCbwSarAdcDynamicTest
  % p.nCap = 12;
  p.fftLen = 1024; % fft频点个数
  % p.mismatchStd = 0.05;
  p.adcResolution = 12;
  p.vRef = 1;
  p.sampleRate = 1e6;
  p.vCM = 0.5;
  p.nSamples = 1024;
  p.inputType = 'single-ended';
  p.randomFreqOn = true;
end
