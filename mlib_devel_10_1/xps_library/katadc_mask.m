%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
%   Center for Astronomy Signal Processing and Electronics Research           %
%   http://seti.ssl.berkeley.edu/casper/                                      %
%   Copyright (C) 2006 University of California, Berkeley                     %
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

myname = gcb;
%set_param(myname, 'LinkStatus', 'inactive');

gateway_outs = find_system(myname,'searchdepth',1,'FollowLinks', 'on','lookundermasks','all','masktype','Xilinx Gateway Out Block');
for i =1:length(gateway_outs)
    gw = gateway_outs{i};
    if regexp(get_param(gw,'Name'),'(gain_load)$')
        toks = regexp(get_param(gw,'Name'),'(gain_load)$','tokens');
        set_param(gw,'Name',clear_name([myname,'_',toks{1}{1}]));
    elseif regexp(get_param(gw,'Name'),'(gain_value)$')
        toks = regexp(get_param(gw,'Name'),'(gain_value)$','tokens');
        set_param(gw,'Name',clear_name([myname,'_',toks{1}{1}]));
    else
        error(['Unknown gateway name: ',gw]);
    end
end

gateway_ins = find_system(gcb,'searchdepth',1,'FollowLinks', 'on', 'lookundermasks','all','masktype','Xilinx Gateway In Block');
for n = 1:length(gateway_ins)
    gw = gateway_ins{n};
    if regexp(get_param(gw,'Name'),'(user_data[iq]\d+)$')
        toks = regexp(get_param(gw,'Name'),'(user_data[iq]\d+)$','tokens');
        set_param(gw,'Name',clear_name([gcb,'_',toks{1}{1}]));
    elseif regexp(get_param(gw,'Name'),'(user_outofrange\d+)$')
        toks = regexp(get_param(gw,'Name'),'(user_outofrange\d+)$','tokens');
        set_param(gw,'Name',clear_name([gcb,'_',toks{1}{1}]));
    elseif regexp(get_param(gw,'Name'),'(user_sync\d+)$')
        toks = regexp(get_param(gw,'Name'),'(user_sync\d+)$','tokens');
        set_param(gw,'Name',clear_name([gcb,'_',toks{1}{1}]));
    elseif regexp(get_param(gw,'Name'),'(user_data_valid)$')
        toks = regexp(get_param(gw,'Name'),'(user_data_valid)$','tokens');
        set_param(gw,'Name',clear_name([gcb,'_',toks{1}{1}]));
    else
        error(['Unknown gateway name: ',gw]);
    end
end % for n = 1:length(gateway_ins)
