# Adder Comparison Project

A performance comparison of two 64-bit adder architectures:
- Kogge-Stone Parallel Prefix Adder (PPA)
- Ripple Carry Adder (RCA)

## Components

- **Kogge-Stone PPA** (`koggestone_ppa.vhd`): Logarithmic-time parallel prefix adder
- **Ripple Carry Adder** (`rca.vhd`): Linear-time adder
- **Supporting Modules**:
  - Half Adder (`half_adder.vhd`): Generates propagate/generate signals
  - Full Carry Operator (`full_carry_operator.vhd`): Combines propagate/generate signals

## Test Bench

`comparison_tb.vhd` verifies both adders with test vectors:
- 255 + 1 (8-bit carry chain)
- 65535 + 1 (16-bit carry chain)
- 2^32-1 + 1 (32-bit carry chain)
- 2^64-1 + 1 (64-bit full carry chain)

## Environment Setup

The recommended way to run this project is with [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build), which includes all required tools:
- GHDL (VHDL simulator)
- Yosys with GHDL plugin (synthesis)
- netlistsvg (visualization)
- GTKWave (waveform viewer)

## Simulation

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

# View results
gtkwave wave.vcd gtkwave_config.gtkw
```

## Hardware Synthesis

```bash
# Synthesize Kogge-Stone PPA (default)
make

# For RCA, edit Makefile:
# SRCS := rca.vhd
# TOP_ENTITY := rca

# Clean generated files
make clean
```

The synthesis process:
1. Creates JSON netlist (`synthesis/$(TOP_ENTITY).json`)
2. Generates SVG visualization (`synthesis/$(TOP_ENTITY).svg`)
