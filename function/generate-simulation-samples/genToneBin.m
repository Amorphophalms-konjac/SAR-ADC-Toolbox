function toneBin = genToneBin( fftLen )
  % Randomly generate a coherent tone bin below the Nyquist frequency.
  toneBinPool = primes( fftLen / 2 );
  % Remove 2 from primes
  toneBinPool( 1 ) = [];
  toneBin = datasample( toneBinPool, 1 );
end