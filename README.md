# booth-multiplier-verilog
Booth Multiplier – Verilog Implementation

This repository contains the Verilog RTL implementation of a 16-bit Booth Multiplier including:

Datapath

Controller FSM

Top-level integration

Testbench

Yosys synthesis

RTL schematic generation

VCD waveform dump

🧩 1. Repository Structure
src/
   booth_datapath.v
   booth_controller.v
   booth_multiplier_full.v

tb/
   tb_booth_full.v

synth/
   synth_booth.ys
   booth_synth.v

waves/
   booth.vcd

rtl_schematic/
   booth_top.dot
   booth_top.ps

⚙️ 2. How to Run Simulation (Icarus Verilog)

iverilog -o booth_sim booth_datapath.v booth_controller.v booth_multiplier_full.v tb_booth_full.v

Next run :vvp booth_sim

Waveform:

gtkwave waves/booth.vcd

🛠️ 3. How to Run Synthesis (Yosys)

synth/synth_booth.ys

read_verilog ../src/booth_datapath.v
read_verilog ../src/booth_controller.v
read_verilog ../src/booth_multiplier_full.v

synth -top booth_multiplier_full

write_verilog booth_synth.v

show booth_multiplier_full

Run it:

yosys synth/synth_booth.ys

RTL schematic:

xdot booth_top.dot


🧪 4. Testbench Output (Sample)

TEST1: 7 * 3 = 21 (Output = 21)

TEST2: 12 * -5 = -60 (Output = -60)

TEST3: -9 * -4 = 36 (Output = 36)

🔚 5. Conclusion

This repository provides a complete, synthesizable Booth Multiplier design with a working simulation and synthesis.
