
#beacuse of a synthesis error:
#[Place 30-574] Poor placement for routing between an IO pin and BUFG. 
#If this sub optimal condition is acceptable for this design, 
#you may use the CLOCK_DEDICATED_ROUTE constraint in the .xdc file to demote this message to a WARNING. 
#However, the use of this override is highly discouraged. These examples can be used directly in the .xdc file to override this clock rule.
#	< set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Btn_in_IBUF[4]] >
#Btn_in_IBUF[4]_inst (IBUF.O) is locked to IOB_X1Y52
#and Btn_in_IBUF_BUFG[4]_inst (BUFG.I) is provisionally placed by clockplacer on BUFGCTRL_X0Y18
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets butn_in_IBUF[0]]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets butn_in_IBUF[1]]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets butn_in_IBUF[2]]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets butn_in_IBUF[3]]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets butn_in_IBUF[4]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Switches_IBUF[0]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Switches_IBUF[1]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Switches_IBUF[2]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Switches_IBUF[3]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Switches_IBUF[4]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Switches_IBUF[5]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Switches_IBUF[6]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Switches_IBUF[7]]

# ZedBoard Audio Codec Constraints
set_property PACKAGE_PIN AA6 [get_ports BCLK]
set_property IOSTANDARD LVCMOS33 [get_ports BCLK]

set_property PACKAGE_PIN Y6 [get_ports LRCLK]
set_property IOSTANDARD LVCMOS33 [get_ports LRCLK]

set_property PACKAGE_PIN AA7 [get_ports SDATA_I]
set_property IOSTANDARD LVCMOS33 [get_ports SDATA_I]

set_property PACKAGE_PIN Y8 [get_ports SDATA_O]
set_property IOSTANDARD LVCMOS33 [get_ports SDATA_O]

set_property PACKAGE_PIN AB2 [get_ports MCLK]
set_property IOSTANDARD LVCMOS33 [get_ports MCLK]

set_property PACKAGE_PIN AB4 [get_ports iic_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_scl_io]

set_property PACKAGE_PIN AB5 [get_ports iic_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_sda_io]

set_property PACKAGE_PIN AB1 [get_ports addrbit0]
set_property IOSTANDARD LVCMOS33 [get_ports addrbit0]

set_property PACKAGE_PIN Y5 [get_ports addrbit1]
set_property IOSTANDARD LVCMOS33 [get_ports addrbit1]

set_property PACKAGE_PIN Y11 [get_ports s_data_o_monitor]
set_property IOSTANDARD LVCMOS33 [get_ports s_data_o_monitor]

# ZedBoard SW Constraints
set_property PACKAGE_PIN M15 [get_ports {Switches[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {Switches[0]}]
set_property PACKAGE_PIN H17 [get_ports {Switches[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {Switches[1]}]
set_property PACKAGE_PIN H18 [get_ports {Switches[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {Switches[2]}]
set_property PACKAGE_PIN H19 [get_ports {Switches[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {Switches[3]}]
set_property PACKAGE_PIN F21 [get_ports {Switches[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {Switches[4]}]
set_property PACKAGE_PIN H22 [get_ports {Switches[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {Switches[5]}]
set_property PACKAGE_PIN G22 [get_ports {Switches[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {Switches[6]}]
set_property PACKAGE_PIN F22 [get_ports {Switches[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {Switches[7]}]

# ZedBoard btns Constraints - 0=left, 1=central, 2=right
set_property PACKAGE_PIN N15 [get_ports {butn_in[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {butn_in[0]}]
set_property PACKAGE_PIN P16 [get_ports {butn_in[1]}] 
set_property IOSTANDARD LVCMOS25 [get_ports {butn_in[1]}]
set_property PACKAGE_PIN R18 [get_ports {butn_in[2]}] 
set_property IOSTANDARD LVCMOS25 [get_ports {butn_in[2]}]

# ZedBoard leds Constraints
set_property PACKAGE_PIN U14 [get_ports {Leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[0]}]
set_property PACKAGE_PIN U19 [get_ports {Leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[1]}]
set_property PACKAGE_PIN W22 [get_ports {Leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[2]}]
set_property PACKAGE_PIN V22 [get_ports {Leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[3]}]
set_property PACKAGE_PIN U21 [get_ports {Leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[4]}]
set_property PACKAGE_PIN U22 [get_ports {Leds[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[5]}]
set_property PACKAGE_PIN T21 [get_ports {Leds[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[6]}]
set_property PACKAGE_PIN T22 [get_ports {Leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[7]}]