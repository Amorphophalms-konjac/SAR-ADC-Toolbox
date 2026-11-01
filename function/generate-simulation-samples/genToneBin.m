function toneBin = genToneBin( fftLen )
  % Randomly generate a coherent tone bin below the Nyquist frequency.
  toneBin = 2 * randi( fftLen / 4 ) - 1;
end