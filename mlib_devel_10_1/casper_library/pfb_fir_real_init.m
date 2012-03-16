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

function pfb_fir_real_init(blk, varargin)
% Initialize and configure the Real Polyphase Filter Bank.
%
% pfb_fir_real_init(blk, varargin)
%
% blk = The block to configure.
% varargin = {'varname', 'value', ...} pairs
% 
% Valid varnames for this block are:
% PFBSize = The size of the PFB
% TotalTaps = Total number of taps in the PFB
% WindowType = The type of windowing function to use.
% n_inputs = The number of parallel inputs
% MakeBiplex = Double up the PFB to feed a biplex FFT
% BitWidthIn = Input Bitwidth
% BitWidthOut = Output Bitwidth
% CoeffBitWidth = Bitwidth of Coefficients.
% CoeffDistMem = Implement coefficients in distributed memory
% add_latency = Latency through each adder.
% mult_latency = Latency through each multiplier
% bram_latency = Latency through each BRAM.
% conv_latency = Latency through the convert (cast) blocks. Essential if you're doing saturate/rouding logic.
% quantization = 'Truncate', 'Round  (unbiased: +/- Inf)', or 'Round
% (unbiased: Even Values)'
% fwidth = Scaling of the width of each PFB channel

clog('entering pfb_fir_real_init','trace');
% Declare any default values for arguments you might like.
defaults = {'PFBSize', 5, 'TotalTaps', 2, ...
    'WindowType', 'hamming', 'n_inputs', 1, 'MakeBiplex', 0, ...
    'BitWidthIn', 8, 'BitWidthOut', 18, 'CoeffBitWidth', 18, ...
    'CoeffDistMem', 0, 'add_latency', 1, 'mult_latency', 2, ...
    'bram_latency', 2, 'conv_latency', 1, ...
    'quantization', 'Round  (unbiased: +/- Inf)', ...
    'fwidth', 1, 'specify_mult', 'off', 'mult_spec', [2 2], ...
    'adder_folding', 'on'};

if same_state(blk, 'defaults', defaults, varargin{:}), return, end
clog('pfb_fir_real_init post same_state','trace');
check_mask_type(blk, 'pfb_fir_real');
munge_block(blk, varargin{:});

PFBSize = get_var('PFBSize', 'defaults', defaults, varargin{:});
TotalTaps = get_var('TotalTaps', 'defaults', defaults, varargin{:});
WindowType = get_var('WindowType', 'defaults', defaults, varargin{:});
n_inputs = get_var('n_inputs', 'defaults', defaults, varargin{:});
MakeBiplex = get_var('MakeBiplex', 'defaults', defaults, varargin{:});
BitWidthIn = get_var('BitWidthIn', 'defaults', defaults, varargin{:});
BitWidthOut = get_var('BitWidthOut', 'defaults', defaults, varargin{:});
CoeffBitWidth = get_var('CoeffBitWidth', 'defaults', defaults, varargin{:});
CoeffDistMem = get_var('CoeffDistMem', 'defaults', defaults, varargin{:});
add_latency = get_var('add_latency', 'defaults', defaults, varargin{:});
mult_latency = get_var('mult_latency', 'defaults', defaults, varargin{:});
bram_latency = get_var('bram_latency', 'defaults', defaults, varargin{:});
conv_latency = get_var('conv_latency', 'defaults', defaults, varargin{:});
quantization = get_var('quantization', 'defaults', defaults, varargin{:});
fwidth = get_var('fwidth', 'defaults', defaults, varargin{:});
specify_mult = get_var('specify_mult', 'defaults', defaults, varargin{:});
mult_spec = get_var('mult_spec', 'defaults', defaults, varargin{:});
adder_folding = get_var('adder_folding', 'defaults', defaults, varargin{:});

if strcmp(specify_mult, 'on') && len(mult_spec) ~= TotalTaps
    clog('Multiplier specification vector not the same as the number of taps','error');
    error('Multiplier specification vector not the same as the number of taps');
    return
end

if MakeBiplex, pols = 2;
else, pols = 1;
end

delete_lines(blk);

clog('adding inports and outports','pfb_fir_real_init_debug');

% Add ports
portnum = 1;
reuse_block(blk, 'sync', 'built-in/inport', ...
    'Position', [0 50 30 50+15], 'Port', num2str(portnum));
reuse_block(blk, 'sync_out', 'built-in/outport', ...
    'Position', [150*(TotalTaps+4) 50*portnum*TotalTaps 150*(TotalTaps+4)+30 50*portnum*TotalTaps+15], 'Port', num2str(portnum));
for p=1:pols,
    for i=1:2^n_inputs,
        portnum = portnum + 1; % Skip one to allow sync & sync_out to be 1
        in_name = ['pol',tostring(p),'_in',tostring(i)];
        out_name = ['pol',tostring(p),'_out',tostring(i)];
        reuse_block(blk, in_name, 'built-in/inport', ...
            'Position', [0 50*portnum*TotalTaps 30 50*portnum*TotalTaps+15], 'Port', tostring(portnum));
        reuse_block(blk, out_name, 'built-in/outport', ...
            'Position', [150*(TotalTaps+4) 50*portnum*TotalTaps 150*(TotalTaps+4)+30 50*portnum*TotalTaps+15], 'Port', tostring(portnum));
    end
end

% Add Blocks
portnum = 0;
for p=1:pols,
    for i=1:2^n_inputs,
        portnum = portnum + 1;

        clog(['adding taps for pol ',num2str(p),' input ',num2str(i)],'pfb_fir_real_init_debug');

        for t=1:TotalTaps,
            use_hdl = 'on';
            use_embedded = 'off';
            if( strcmp(specify_mult,'on') ) 
                if( mult_spec(t) == 0 ), 
                    use_embedded = 'off';
                elseif( mult_spec(t) == 2);
                    use_hdl = 'on';
                    use_embedded = 'off';
                end
            end
            
            if t==1,
                src_blk = 'casper_library_pfbs/first_tap_real';
                name = ['pol',tostring(p),'_in',tostring(i),'_first_tap'];
                reuse_block(blk, name, src_blk, ...
                    'use_hdl', tostring(use_hdl), 'use_embedded', tostring(use_embedded), ...
                    'Position', [150*t 50*portnum*TotalTaps 150*t+100 50*portnum*TotalTaps+30]);
                propagate_vars([blk,'/',name],'defaults', defaults, varargin{:});
            elseif t==TotalTaps,
                src_blk = 'casper_library_pfbs/last_tap_real';
                name = ['pol',tostring(p),'_in',tostring(i),'_last_tap'];
                reuse_block(blk, name, src_blk, ...
                    'use_hdl', tostring(use_hdl), 'use_embedded', tostring(use_embedded), ...
                    'Position', [150*t 50*portnum*TotalTaps 150*t+100 50*portnum*TotalTaps+30]);
                propagate_vars([blk,'/',name],'defaults', defaults, varargin{:});
            else,
                src_blk = 'casper_library_pfbs/tap_real';
                name = ['pol',tostring(p),'_in',tostring(i),'_tap',tostring(t)];
                reuse_block(blk, name, src_blk, ...
                   'use_hdl', tostring(use_hdl), 'use_embedded', tostring(use_embedded), ...
                    'bram_latency', tostring(bram_latency), ...
                    'mult_latency', tostring(mult_latency), ...
                     'data_width', tostring(BitWidthIn), ...
                    'coeff_width', tostring(CoeffBitWidth), ...
                    'coeff_frac_width', tostring(CoeffBitWidth-1), ...
                    'delay', tostring(2^(PFBSize-n_inputs)), ...
                    'Position', [150*t 50*portnum*TotalTaps 150*t+100 50*portnum*TotalTaps+30]);
            end
%            reuse_block(blk, name, src_blk, ...
%                'Position', [150*t 50*portnum 150*t+100 50*portnum+30]);
%            propagate_vars([blk,'/',name],'defaults', defaults, varargin{:});
            if t==1,
                set_param([blk,'/',name], 'nput', tostring(i-1));
            end
        end
        
    clog(['adder tree, scale and convert blocks for pol ',num2str(p),' input ',num2str(i)],'pfb_fir_real_init_debug');
    %add adder tree
    reuse_block(blk, ['adder_', tostring(p), '_' ,tostring(i)], 'casper_library_misc/adder_tree', ...
        'n_inputs', tostring(TotalTaps), 'latency', tostring(add_latency), ...
        'first_stage_hdl', adder_folding, 'behavioral', 'off', ...
        'Position', [150*(TotalTaps+1) 50*portnum*TotalTaps 150*(TotalTaps+1)+100 50*(portnum+1)*TotalTaps-20]);

    %add shift, convert blocks
    scale_factor = 1 + nextpow2(TotalTaps);
    reuse_block(blk, ['scale_',tostring(p),'_',tostring(i)], 'xbsIndex_r4/Scale', ...
        'scale_factor', tostring(-scale_factor), ...
        'Position', [150*(TotalTaps+2) 50*(portnum+1)*TotalTaps-50 150*(TotalTaps+2)+30 50*(portnum+1)*TotalTaps-25]);    
    reuse_block(blk, ['convert_', tostring(p),'_', tostring(i)], 'xbsIndex_r4/Convert', ...
        'arith_type', 'Signed  (2''s comp)', 'n_bits', tostring(BitWidthOut), ...
        'bin_pt', tostring(BitWidthOut-1), 'quantization', quantization, ...
        'overflow', 'Saturate', 'latency', tostring(add_latency), ...
        'latency',tostring(conv_latency),...
        'Position', [150*(TotalTaps+2)+60 50*(portnum+1)*TotalTaps-50 150*(TotalTaps+2)+90 50*(portnum+1)*TotalTaps-25]);
    
    end
end

clog('joining inports to blocks','pfb_fir_real_init_debug');

for p=1:pols,
    for i=1:2^n_inputs,
        in_name = ['pol',tostring(p),'_in',tostring(i)];
        blk_name = ['pol',tostring(p),'_in',tostring(i),'_first_tap'];
        out_name = ['pol',tostring(p),'_out',tostring(i)];
        adder_name = ['adder_',tostring(p),'_',tostring(i)];
        convert_name = ['convert_',tostring(p), '_',tostring(i)];
        scale_name = ['scale_',tostring(p), '_',tostring(i)];
    
        add_line(blk, [in_name,'/1'], [blk_name,'/1']);
        add_line(blk, 'sync/1', [blk_name,'/2']);
    
        if i==1 && p==1, 
            reuse_block(blk, 'delay1', 'xbsIndex_r4/Delay', ...
                'latency', tostring(conv_latency), ...
                'Position', [150*(TotalTaps+2)+60 50 150*(TotalTaps+2)+90 80]);
            add_line(blk, [adder_name,'/1'], 'delay1/1');
            add_line(blk, 'delay1/1', 'sync_out/1');
        end

        add_line(blk, [adder_name,'/2'], [scale_name,'/1']);    
        add_line(blk, [scale_name,'/1'], [convert_name,'/1']);
        add_line(blk, [convert_name,'/1'], [out_name,'/1']);

    end
end

clog('joining blocks to outports','pfb_fir_real_init_debug');

% Add Lines
for p=1:pols,
    for i=1:2^n_inputs,
        adder_name = ['adder_',tostring(p),'_',tostring(i)];
        for t=2:TotalTaps,
            blk_name = ['pol',tostring(p),'_in',tostring(i),'_tap',tostring(t)];
                
            if t == TotalTaps,
                blk_name = ['pol',tostring(p),'_in',tostring(i),'_last_tap'];
                add_line(blk, [blk_name,'/2'], [adder_name,'/1']);  
                add_line(blk, [blk_name,'/1'], [adder_name,'/',tostring(t+1)]);    
            end 

            if t==2,
                prev_blk_name = ['pol',tostring(p),'_in',tostring(i),'_first_tap'];
            else,
                prev_blk_name = ['pol',tostring(p),'_in',tostring(i),'_tap',tostring(t-1)];
            end

            for n=1:3, add_line(blk, [prev_blk_name,'/',tostring(n)], [blk_name,'/',tostring(n)]);
            end
            add_line (blk, [prev_blk_name,'/4'],[adder_name,'/',tostring(t)]);
        end
    end
end


clean_blocks(blk);

fmtstr = sprintf('taps=%d, add_latency=%d', TotalTaps, add_latency);
set_param(blk, 'AttributesFormatString', fmtstr);
save_state(blk, 'defaults', defaults, varargin{:});
clog('exiting pfb_fir_real_init','trace');
