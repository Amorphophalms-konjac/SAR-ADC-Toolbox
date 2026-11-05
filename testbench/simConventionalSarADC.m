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
rawCode = nan( p.fftLen, 1 );
for iSample = 1 : p.fftLen
  sample = samples.data( iSample );
  convRes = cbwSarADC(sample, p, cdac);
  rawCode( iSample ) = bi2de( convRes, 'left-msb' );
end

%% process simulation data
adcDynamicPerformanceMetrics = processAdcData( p, samples, rawCode );

%% print simulation parameters and dynamic performance
printAdcDynamicSimulationResult( p, samples, adcDynamicPerformanceMetrics );

%% plot simulation results

figure = plotAdcDynamicSimulationResult( p, samples, adcDynamicPerformanceMetrics );

%% export plots

projectFolder = fileparts( fileparts( mfilename( 'fullpath' ) ) );
filename = fullfile( projectFolder, 'drawing', 'adc-dynamic-result.png' );
exportgraphics( figure, filename );
fprintf( 'Plot saved to: %s\n', filename );
