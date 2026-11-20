## Nexys A7-100T constraints for CEG3155 Lab 3 (diagram_final_lab3), per lab Table 10

## 100 MHz oscillator
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports {CLOCK}];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLOCK}];

## Global reset : CPU RESETN button (active-low)
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports {RESETBAR}];

## LOAD_FSM = SW0
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports {LOAD_FSM}];

## MSC_MAX[3:0] = SW4..SW1
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports {MSC_MAX[0]}];
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports {MSC_MAX[1]}];
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports {MSC_MAX[2]}];
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports {MSC_MAX[3]}];

## SSC_MAX[3:0] = SW8..SW5 (SW8 is on a 1.8 V bank)
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports {SSC_MAX[0]}];
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports {SSC_MAX[1]}];
set_property -dict { PACKAGE_PIN R13 IOSTANDARD LVCMOS33 } [get_ports {SSC_MAX[2]}];
set_property -dict { PACKAGE_PIN T8  IOSTANDARD LVCMOS18 } [get_ports {SSC_MAX[3]}];

## Car sensor CAPTEUR = BTNU
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports {CAPTEUR}];

## Main street light MSTL = LD16 (G, B = yellow, R)
set_property -dict { PACKAGE_PIN M16 IOSTANDARD LVCMOS33 } [get_ports {MSTL[0]}];
set_property -dict { PACKAGE_PIN R12 IOSTANDARD LVCMOS33 } [get_ports {MSTL[1]}];
set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports {MSTL[2]}];

## Side street light SSTL = LD17 (G, B = yellow, R)
set_property -dict { PACKAGE_PIN R11 IOSTANDARD LVCMOS33 } [get_ports {SSTL[0]}];
set_property -dict { PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports {SSTL[1]}];
set_property -dict { PACKAGE_PIN N16 IOSTANDARD LVCMOS33 } [get_ports {SSTL[2]}];

## Seven-segment anodes AN[7:0] (held high, display off)
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports {AN[0]}];
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports {AN[1]}];
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports {AN[2]}];
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports {AN[3]}];
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports {AN[4]}];
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports {AN[5]}];
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports {AN[6]}];
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports {AN[7]}];

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
