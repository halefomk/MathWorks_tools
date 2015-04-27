% Inputs (structure containing the following fields usually created via cook_input)
% ============================================
% RxTx     = string containing 'Rx' or 'Tx' specifying filter type
% Rdata    = The output datarate.
% FIR      = FIR interpolation/decimation rates [1 2 4]
% HB1      = HB1 interpolation/decimation rates [1 2]
% HB2      = HB2 interpolation/decimation rates [1 2]
% HB3      = HB3 interpolation/decimation rates [1 2 3]
% DAC_div  = the ADC/DAC ratio, for Rx channels, this is
%            always '1', for Tx, it is either '1' or '2'
%
% Outputs
% ===============================================
% PLL_rate = PLL rate in HZ for the filter

function PLL_rate = get_pll_rate(input)
if strcmp(input.RxTx, 'Rx')
    PLL_rate = input.Rdata * input.FIR * input.HB1 * ...
        input.HB2 * input.HB3 * input.PLL_mult;
else
    PLL_rate = input.Rdata * input.FIR * input.HB1 * ...
        input.HB2 * input.HB3 * input.DAC_div * ...
        input.PLL_mult;
end
