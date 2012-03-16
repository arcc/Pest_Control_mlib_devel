% Initialize and configure the fft biplex.
%
% fft_biplex_init(blk, varargin)
%
% blk = The block to configure.
% varargin = {'varname', 'value', ...} pairs
% 
% Valid varnames for this block are:
% FFTSize = Size of the FFT (2^FFTSize points).
% input_bit_width = Bit width of input and output data.
% coeff_bit_width = Bit width of coefficients.
% add_latency = The latency of adders in the system.
% mult_latency = The latency of multipliers in the system.
% bram_latency = The latency of BRAM in the system. 
% quantization = Quantization behavior.
% overflow = Overflow behavior.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
%   Center for Astronomy Signal Processing and Electronics Research           %
%   http://seti.ssl.berkeley.edu/casper/                                      %
%   Copyright (C) 2007 Terry Filiba, Aaron Parsons                            %
%                                                                             %
%   This program is free software; you can redistribute it and/or modify      %
%   it under the terms of the GNU General Public License as published by      %
%   the Free Software Foundation; either version 2 of the License, or         %
%   (at your option) any later version.                                       %
%                                                                             %
%   This program is distributed in the hope that it will be useful,           %
%   but WITHOUT ANY WARRANTY; without even the implied warranty of            %
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             %
%   GNU General Public License for more details.                              %
%                                                                             %
%   You should have received a copy of the GNU General Public License along   %
%   with this program; if not, write to the Free Software Foundation, Inc.,   %
%   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.               %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fft_biplex_init(blk, varargin)

clog('entering fft_biplex_init','trace');
% Declare any default values for arguments you might like.
defaults = {'FFTSize', 2, 'arch', 'Virtex5', 'opt_target', 'logic', ...
    'input_bit_width', 18, 'coeff_bit_width', 18, ...
    'quantization', 'Round  (unbiased: +/- Inf)', 'overflow', 'Saturate', ...
    'add_latency', 1, 'mult_latency', 2, 'bram_latency', 2, ...
    'conv_latency', 1, 'coeffs_bit_limit', 8, 'delays_bit_limit', 8, ...
    'specify_mult', 'off', 'mult_spec', [2 2], 'dsp48_adders', 'off'};
if same_state(blk, 'defaults', defaults, varargin{:}), return, end
clog('fft_biplex_init post same_state', 'trace');
check_mask_type(blk, 'fft_biplex');
munge_block(blk, varargin{:});

FFTSize = get_var('FFTSize', 'defaults', defaults, varargin{:});
arch = get_var('arch', 'defaults', defaults, varargin{:});
opt_target = get_var('opt_target', 'defaults', defaults, varargin{:});
input_bit_width = get_var('input_bit_width', 'defaults', defaults, varargin{:});
coeff_bit_width = get_var('coeff_bit_width', 'defaults', defaults, varargin{:});
quantization = get_var('quantization', 'defaults', defaults, varargin{:});
overflow = get_var('overflow', 'defaults', defaults, varargin{:});
add_latency = get_var('add_latency', 'defaults', defaults, varargin{:});
mult_latency = get_var('mult_latency', 'defaults', defaults, varargin{:});
bram_latency = get_var('bram_latency', 'defaults', defaults, varargin{:});
conv_latency = get_var('conv_latency', 'defaults', defaults, varargin{:});
coeffs_bit_limit = get_var('coeffs_bit_limit', 'defaults', defaults, varargin{:});
delays_bit_limit = get_var('delays_bit_limit', 'defaults', defaults, varargin{:});
specify_mult = get_var('specify_mult', 'defaults', defaults, varargin{:});
mult_spec = get_var('mult_spec', 'defaults', defaults, varargin{:});
dsp48_adders = get_var('dsp48_adders', 'defaults', defaults, varargin{:});

clog(flatstrcell(varargin),'fft_biplex_init_debug');

%propagate_vars([blk,'/biplex_core'],'defaults', defaults, varargin{:});
set_param([blk,'/biplex_core'], 'FFTSize', 'FFTSize', ...
 	'input_bit_width', num2str(input_bit_width), ...
    'coeff_bit_width', num2str(coeff_bit_width), 'quantization', tostring(quantization), ...
	'overflow', tostring(overflow), 'add_latency', num2str(add_latency), ...
	'mult_latency', num2str(mult_latency), 'bram_latency', num2str(bram_latency), ...
	'conv_latency', num2str(conv_latency), 'arch', tostring(arch), ...
	'opt_target', tostring(opt_target), 'dsp48_adders', tostring(dsp48_adders), ...
	'coeffs_bit_limit', num2str(coeffs_bit_limit), 'delays_bit_limit', num2str(delays_bit_limit), ...
	'specify_mult', tostring(specify_mult), 'mult_spec', tostring(mult_spec)); 
propagate_vars([blk,'/biplex_cplx_unscrambler'],'defaults', defaults, varargin{:});

fmtstr = sprintf('%d stages\n%s',FFTSize,arch);
set_param(blk, 'AttributesFormatString', fmtstr);
save_state(blk, 'defaults', defaults, varargin{:});
clog('exiting fft_biplex_init', 'trace');

