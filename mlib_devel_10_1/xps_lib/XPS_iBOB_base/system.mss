
 PARAMETER VERSION = 2.2.0


BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 1.00.a
 PARAMETER PROC_INSTANCE = ppc405_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER STDIN = RS232_UART
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER STDOUT = RS232_UART
END

BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 1.00.a
 PARAMETER PROC_INSTANCE = ppc405_1
 PARAMETER STDIN = RS232_UART_1
 PARAMETER STDOUT = RS232_UART_1
END


BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu_ppc405
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = ppc405_0
 PARAMETER COMPILER = powerpc-eabi-gcc
 PARAMETER ARCHIVER = powerpc-eabi-ar
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER CORE_CLOCK_FREQ_HZ = 300000000
END

BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu_ppc405
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = ppc405_1
 PARAMETER COMPILER = powerpc-eabi-gcc
 PARAMETER ARCHIVER = powerpc-eabi-ar
 PARAMETER CORE_CLOCK_FREQ_HZ = 100000000
END


BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartlite
 PARAMETER DRIVER_VER = 1.02.a
 PARAMETER HW_INSTANCE = RS232_UART_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = plbarb
 PARAMETER DRIVER_VER = 1.01.a
 PARAMETER HW_INSTANCE = plb
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = opb0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = plb2opb
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = plb2opb_bridge_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = plb_bram_if_cntlr_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = opb_clockcontroller_0
END

#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = generic
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = opb_selectmap_fifo_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = plb2opb
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = plb2opb
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = plbarb
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.01.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = linux_plb
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = opbarb
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.02.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = linux_opb
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = uartns550
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.b
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = RS232_UART
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER CLOCK_HZ = 100000000
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = intc
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.c
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = opb_intc_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = emac
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.e
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = plb_ethernet_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = generic
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = opb_selectmap_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = generic
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = opb_software_iic_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = generic
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = opb_hardware_spi_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = generic
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = opb_serialswitch_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_NAME = generic
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER DRIVER_VER = 1.00.a
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') # PARAMETER HW_INSTANCE = opb_getswitch_0
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #END
#IF# strcmp(get(b,'type'),'xps_xsg') && strcmp(get(b,'ibob_linux'),'on') #
#IF# strcmp(get(b,'type'),'xps_adc')#BEGIN DRIVER
#IF# strcmp(get(b,'type'),'xps_adc')# PARAMETER DRIVER_NAME = generic
#IF# strcmp(get(b,'type'),'xps_adc')# PARAMETER DRIVER_VER = 1.00.a
#IF# strcmp(get(b,'type'),'xps_adc')# PARAMETER HW_INSTANCE = opb_adccontroller_0
#IF# strcmp(get(b,'type'),'xps_adc')#END
#IF# strcmp(get(b,'type'),'xps_adc')#
