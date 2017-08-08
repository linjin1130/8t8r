######################################################################################
# Create Clock definitions
######################################################################################
# FPGA Clock, 125MHz
create_clock -period 8.000 -name clock_125m_clka [get_ports CLK_A7_C_REFA_P]
set_input_jitter clock_125m_clka 0.100

######################################################################################
# ADC0
######################################################################################
# DCO Clock, 500MHz

#create_clock -period 2.000 -name ADC0_DCO_P -waveform {0.000 1.000} [get_ports ADC0_DCO_P]
#set_input_delay -clock [get_clocks ADC0_DCO_P] -max -add_delay 1.500 [get_ports *ADC0_D*_*_P]
#set_input_delay -clock [get_clocks ADC0_DCO_P] -min -add_delay 0.500 [get_ports *ADC0_D*_*_P]
#set_input_delay -clock [get_clocks ADC0_DCO_P] -max -add_delay 1.500 [get_ports ADC0_FCO_P]
#set_input_delay -clock [get_clocks ADC0_DCO_P] -min -add_delay 0.500 [get_ports ADC0_FCO_P]
create_clock -period 2.000 -name ADC0_DCO_P -waveform {0.000 1.000} [get_ports ADC0_DCO_P]
set_input_delay -clock [get_clocks ADC0_DCO_P] -max -add_delay 0.600 [get_ports *ADC0_D*_*_P]
set_input_delay -clock [get_clocks ADC0_DCO_P] -min -add_delay 0.400 [get_ports *ADC0_D*_*_P]
set_input_delay -clock [get_clocks ADC0_DCO_P] -max -add_delay 0.600 [get_ports ADC0_FCO_P]
set_input_delay -clock [get_clocks ADC0_DCO_P] -min -add_delay 0.400 [get_ports ADC0_FCO_P]

######################################################################################
# ADC0
######################################################################################
# DCO Clock, 500MHz
#create_clock -period 2.000 -name ADC1_DCO_P -waveform {0.000 1.000} [get_ports ADC1_DCO_P]
#set_input_delay -clock [get_clocks ADC1_DCO_P] -max -add_delay 1.500 [get_ports *ADC1_D*_*_P]
#set_input_delay -clock [get_clocks ADC1_DCO_P] -min -add_delay 0.500 [get_ports *ADC1_D*_*_P]
#set_input_delay -clock [get_clocks ADC1_DCO_P] -max -add_delay 1.500 [get_ports ADC1_FCO_P]
#set_input_delay -clock [get_clocks ADC1_DCO_P] -min -add_delay 0.500 [get_ports ADC1_FCO_P]

create_clock -period 2.000 -name ADC1_DCO_P -waveform {0.000 1.000} [get_ports ADC1_DCO_P]
set_input_delay -clock [get_clocks ADC1_DCO_P] -max -add_delay 0.600 [get_ports *ADC1_D*_*_P]
set_input_delay -clock [get_clocks ADC1_DCO_P] -min -add_delay 0.400 [get_ports *ADC1_D*_*_P]
set_input_delay -clock [get_clocks ADC1_DCO_P] -max -add_delay 0.600 [get_ports ADC1_FCO_P]
set_input_delay -clock [get_clocks ADC1_DCO_P] -min -add_delay 0.400 [get_ports ADC1_FCO_P]

#create_clock -period 2.000 -name ADC0_DCO_P [get_ports ADC0_DCO_P]
#set_input_jitter ADC0_DCO_P 0.100
#set_input_delay -clock ADC0_DCO_P -max -add_delay 1.5 [get_ports ADC0_DCO_P]
# create_clock -period 8 -name clock_125m_clkb [get_ports CLK_A7_C_REFB_P]
# set_input_jitter clock_125m_clkb 0.100

# ADC clk, 125M


######################################################################################
# Input Output Offset definitions
######################################################################################

