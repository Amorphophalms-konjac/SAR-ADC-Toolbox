function cdac = synthesizeCDAC( p )
  % use simulation config to sythesize CDAC
  switch(p.inputType)
    case 'single-ended'
      cdac.capArray = [ 2 .^ ( p.adcResolution - 1 : -1 : 0 ), 1 ];
      cdac.switchArray = nan( 1, p.adcResolution );
    case 'differential'
      cdac.capArray = repmat( [ 2 .^ ( p.adcResolution - 1 : -1 : 0 ), 1 ], 2, 1 );
      cdac.switchArray = nan( 2, p.adcResolution );
    otherwise
      error('Unsupported input type: %s', p.inputType);
  end


  % TODO: add other CDAC topologies.
end