%% simulation preparation
clear
close all
clc
format long g

%% load project paths relative to this script
projectFolder = fileparts( fileparts( mfilename( 'fullpath' ) ) );
addpath( fullfile( projectFolder, 'sim-config' ), '-begin' );
addpath( fullfile( projectFolder, 'models' ), '-begin' );
addpath( genpath( fullfile( projectFolder, 'function' ) ), '-begin' );

%% load simulation configuration and parameters
p = configDynamicTest;

%% allocate storage for simulation data

conversionResult = nan( p.fftLen, 1 );
%% generate samples

samples = genSamples( p );

%% generate dac
dac = synthesizeCDAC( p );

%% run simulation
for iSample = 1 : p.fftLen
  sample = samples.data( iSample );
  conversionResult( iSample ) = cbwSarADC(sample, p, dac);
end

%% process simulation data

% adcDynamicPerformanceMetrics = processAdcData(p, samples, conversionResult);
adcDynamicPerformanceMetrics = processAdcData( p, conversionResult );

%% print simulation parameters and dynamic performance
printAdcDynamicSimulationResult( p, adcDynamicPerformanceMetrics );

%% plot simulation results

figure = plotAdcDynamicSimulationResult( p, adcDynamicPerformanceMetrics );

%% export plots

filename = fullfile( fileparts( mfilename( 'fullpath' ) ), 'adc-dynamic-result.png' );
exportgraphics( figure, filename );
fprintf( 'Plot saved to: %s\n', filename );
