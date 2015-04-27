% Inputs
% ============================================
% hw              = boolean flag to return the approximated HW RF bandwidth
%                   or the actual RF bandwidth
%
% (input structure containing the following fields usually created via cook_input)
% --------------------------------------------
% input.RxTx     = string containing 'Rx' or 'Tx' specifying filter type
% input.Rdata    = The output datarate.
% input.FIR      = FIR interpolation/decimation rates [1 2 4]
% input.HB1      = HB1 interpolation/decimation rates [1 2]
% input.HB2      = HB2 interpolation/decimation rates [1 2]
% input.HB3      = HB3 interpolation/decimation rates [1 2 3]
% input.DAC_div  = the ADC/DAC ratio, for Rx channels, this is
%                  always '1', for Tx, it is either '1' or '2'
% input.caldiv   = The actual discrete register value that describes the
%                  rolloff for the analog filters
%
% Outputs
% ============================================
% rfbw   = related channel's complex bandwidth
% caldiv = calibration divider related to the channel's complex bandwidth

% calculate a channel's complex bandwidth related to the calibration divider value
function [rfbw, caldiv] = calculate_rfbw(input, hw)
if strcmp(input.RxTx, 'Rx')
    channel_factor = 1.4;
    % (1.4 * 2 * pi)/log(2) rounded to the same precision the driver uses
    rounded_factor = 12.6906;

    % min/max possible values for the RF bandwidth (2x baseband bandwidth) from the
    % reference manual (values are in Hz since RFbw is in Hz)
    % Rx: 0.4 MHz <= RF bandwidth <= 56 MHz
    min_rfbw = 400000;
    max_rfbw = 56000000;
else
    channel_factor = 1.6;
    % (1.6 * 2 * pi)/log(2) rounded to the same precision the driver uses
    rounded_factor = 14.5036;

    % Tx: 1.25 MHz <= RF bandwidth <= 40 MHz
    min_rfbw = 1250000;
    max_rfbw = 40000000;
end

pll_rate = get_pll_rate(input);
caldiv = input.caldiv;

if hw
    % avoid divide by zero on boundary case
    if caldiv == 1
        caldiv = 1 + eps;
    end
    % used to reproduce the divider value (caldiv) we expect on the driver
    rfbw = uint32(fix(((pll_rate - 1)/(caldiv - 1))*(2/rounded_factor)));
else
    % full precision RF bandwidth
    rfbw = round((pll_rate/caldiv)*(2/(channel_factor*(2*pi)/log(2))));
end

% If the RF bandwidth is outside the range of acceptable values we modify
% the divider value until it falls into an acceptable range.
while (rfbw < min_rfbw) || (rfbw > max_rfbw)
    if (rfbw < min_rfbw)
        caldiv = caldiv - 1;
    else
        caldiv = caldiv + 1;
    end

    if (caldiv < 1) || (caldiv > 511)
        msgbox(sprintf('Calibration divider out of bounds (1 - 511): %i', caldiv), 'Error', 'error');
        return;
    end

    input.caldiv = caldiv;
    rfbw = calculate_rfbw(input, hw);
end
