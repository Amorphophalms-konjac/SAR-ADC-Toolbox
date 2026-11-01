%% simulation preparation
clear
close all
clc
format long g

%% load simulation configuration and parameters
p = configIdealSingleEndedCbwSarAdcDynamicTest;

%% allocate storage for simulation data

conversionResult = nan( p.fftLen, 1 );
%% generate samples

samples = genSamples( p );

%% generate dac
cdac = synthesizeCDAC( p );

%% run simulation
for iSample = 1 : p.fftLen
  sample = samples.data( iSample );
  conversionResult( iSample ) = cbwSarADC(sample, p, cdac);
end

%% process simulation data

adcDynamicPerformanceMetrics = processAdcData( p, samples, conversionResult );

%% print simulation parameters and dynamic performance
printAdcDynamicSimulationResult( p, samples, adcDynamicPerformanceMetrics );

%% plot simulation results

figure = plotAdcDynamicSimulationResult( p, samples, adcDynamicPerformanceMetrics );

%% export plots

filename = fullfile( fileparts( mfilename( 'fullpath' ) ), 'adc-dynamic-result.png' );
exportgraphics( figure, filename );
fprintf( 'Plot saved to: %s\n', filename );
