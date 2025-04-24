# Change these to synthesize selected design. 

# Example for koggestone_ppa:
# SRCS := koggestone_ppa.vhd full_carry_operator.vhd half_adder.vhd
# TOP_ENTITY := koggestone_ppa

# Example for rca:
# SRCS := rca.vhd
# TOP_ENTITY := rca

SRCS := koggestone_ppa.vhd full_carry_operator.vhd half_adder.vhd
TOP_ENTITY := koggestone_ppa

all:
	mkdir -p synthesis
	yosys -m ghdl -p "ghdl --std=08 $(SRCS) -e $(TOP_ENTITY); prep -top $(TOP_ENTITY); write_json synthesis/$(TOP_ENTITY).json"
	netlistsvg synthesis/$(TOP_ENTITY).json -o synthesis/$(TOP_ENTITY).svg

clean:
	rm -f synthesis/$(TOP_ENTITY).json synthesis/$(TOP_ENTITY).svg
	rm -rf synthesis

.PHONY: all clean
