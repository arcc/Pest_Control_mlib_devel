#!/bin/bash
export MATLAB=/usr/local/bin
export XILINX=/opt/Xilinx/11.1/ISE
export XILINX_EDK=/opt/Xilinx/11.1/EDK
export XILINX_DSP=/opt/Xilinx/11.1/DSP_Tools/lin64
export PLATFORM=lin64
export BEE2_XPS_LIB_PATH=/usr/local/bin/mlib_devel_10_1/xps_lib
export MLIB_ROOT=/usr/local/bin/mlib_devel_10_1
export PATH=${XILINX}/bin/${PLATFORM}:${XILINX_EDK}/bin/${PLATFORM}:${PATH}
export LD_LIBRARY_PATH=${XILINX}/bin/${PLATFORM}:${XILINX}/lib/${PLATFORM}:${XILINX_DSP}/sysgen/lib:${LD_LIBRARY_PATH}
export LMC_HOME=${XILINX}/smartmodel/${PLATFORM}/installed_lin
export PATH=${LMC_HOME}/bin:${XILINX_DSP}/common/bin:${PATH}
export INSTALLMLLOC=/usr/local/bin/matlab_R2009a
export TEMP=/tmp/
export TMP=/tmp/
$MATLAB/matlab -nodesktop -nosplash

