function p = configDynamicTest
p.nCap = 12;
p.fftLen = 1024; % fft频点个数
p.mismatchStd = 0.05;
p.adcResolution = 12;
p.vRef = 1;
p.sampleRate = 1e6;
p.nCycle = 127; % 测试正弦波的周期数
p.inputAmplitudeDbfs = -1; % 测试正弦波的幅度，单位为dBFS
end
