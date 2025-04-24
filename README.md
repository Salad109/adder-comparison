# Adder Comparison Project

This project implements and compares two 64-bit adder architectures:
- Kogge-Stone Parallel Prefix Adder (PPA)
- Ripple Carry Adder (RCA)

## Components

- **Kogge-Stone PPA** (`koggestone_ppa.vhd`): A logarithmic-time parallel prefix adder
- **Ripple Carry Adder** (`rca.vhd`): A simple linear-time adder
- **Test Bench** (`comparison_tb.vhd`): Compares both adders with identical inputs
- **Supporting Modules**:
  - Half Adder (`half_adder.vhd`): Generates propagate and generate signals
  - Full Carry Operator (`full_carry_operator.vhd`): Combines propagate and generate signals

## Test Cases

The test bench verifies both adders with various test vectors:
- 255 + 1 (8-bit carry chain)
- 65535 + 1 (16-bit carry chain)
- 2^32-1 + 1 (32-bit carry chain)
- 2^64-1 + 1 (64-bit full carry chain)

## Running the Simulation

The project is configured to run with GHDL:

```bash
# Analyze all files
ghdl -a half_adder.vhd
ghdl -a full_carry_operator.vhd
ghdl -a koggestone_ppa.vhd
ghdl -a rca.vhd
ghdl -a comparison_tb.vhd

# Elaborate test bench
ghdl -e adders_comparison_tb

# Run simulation
ghdl -r adders_comparison_tb --vcd=wave.vcd
```

## Viewing Results

A GTKWave configuration file is provided to visualize the results:

```bash
gtkwave wave.vcd gtkwave_config.gtkw
```

This displays input vectors and output results for both adder designs, allowing for comparison of performance characteristics and verification of correct operation.

## Hardware Synthesis

The project includes a Makefile for synthesizing designs using Yosys+GHDL:

```bash
# Synthesize default design (Kogge-Stone PPA)
make

# Clean generated files
make clean
```

The Makefile targets:
- Generate a JSON netlist in `synthesis/$(TOP_ENTITY).json`
- Create an SVG visualization in `synthesis/$(TOP_ENTITY).svg`

To synthesize a different module, modify the Makefile variables:
```
SRCS := rca.vhd
TOP_ENTITY := rca
```

Requirements: Yosys with GHDL plugin and netlistsvg.