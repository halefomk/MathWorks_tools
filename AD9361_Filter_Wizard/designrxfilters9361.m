% Inputs (structure containing the following fields)
% ============================================
% Fout       = Output sample data rate (in Hz)
% FIR_interp = FIR decimation factor
% HB_interp  = half band filters decimation factor
% PLL_mult   = PLL multiplication
% Fpass      = passband frequency (in Hz)
% Fstop      = stopband frequency (in Hz)
% dBripple   = max ripple allowed in passband (in dB)
% dBstop     = min attenuation in stopband (in dB)
% dBstop_FIR = min rejection that TFIR is required to have (in dB)
% phEQ       = Phase Equalization on (not -1)/off (-1)
% int_FIR    = Use AD9361 FIR on (1)/off (0)
% wnom       = analog cutoff frequency (in Hz)
%
% Outputs
% ===============================================
% rfirtaps   = fixed point coefficients for AD9361
% rxFilters  = system object for visualization

function [rfirtaps,rxFilters] = designrxfilters9361(input)

[rfirtaps,rxFilters,~,~,~,~,~,~,~,~,~,~] = internal_designrxfilters(input);
