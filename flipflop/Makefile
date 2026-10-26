# Makefile for the D flip-flop
#
#   make        build if needed, then run the sim (writes the waveform)
#   make build  build the Verilator binary only
#   make wave   run the sim if needed, then open the waveform in GTKWave
#   make screenshots  render code images of the RTL into img/ with silicon
#   make clean  remove build output and the waveform
#
# Layout: design/ holds the RTL, tb/ holds the testbench and Verilator files.
# Verilator and the sim run inside tb/, so obj_dir/ and the waveform land there.

TOP  := tb_flipflop
RTL  := design/flipflop.sv
SRCS := $(RTL) tb/tb_flipflop.sv
BIN  := tb/obj_dir/V$(TOP)
WAVE := tb/flipflop_waveform.fst

# Assumes OSS CAD Suite is on PATH: source <suite>/environment first
VERILATOR ?= verilator
GTKWAVE   ?= gtkwave

.PHONY: all build sim wave screenshots clean

all: sim

build: $(BIN)

# verilator skips relinking when a source was touched but not changed, so
# touch the binary to stop make from treating it as out of date every time
$(BIN): $(SRCS) tb/verilator.f
	@command -v $(VERILATOR) >/dev/null || { echo "$(VERILATOR) not found: source <oss-cad-suite>/environment first"; exit 1; }
	cd tb && $(VERILATOR) -f verilator.f
	@touch $@

# sim always reruns (it takes milliseconds) so a failing check is never hidden
# behind a waveform left over from the last run
sim: $(BIN)
	cd tb && ./obj_dir/V$(TOP)

# wave reuses an existing waveform, even from a failed run, for debugging
$(WAVE): $(BIN)
	cd tb && ./obj_dir/V$(TOP)

wave: $(WAVE)
	@command -v $(GTKWAVE) >/dev/null || { echo "$(GTKWAVE) not found: source <oss-cad-suite>/environment first"; exit 1; }
	$(GTKWAVE) $(WAVE)

# Highlight ranges are auto-detected; override with
#   make screenshots PORT_LINES=1-6 LOGIC_LINES=7-12
screenshots:
	PORT_LINES=$(PORT_LINES) LOGIC_LINES=$(LOGIC_LINES) ./screenshots.sh $(RTL) img

# img/ is left alone: the screenshots are meant to be kept
clean:
	rm -rf tb/obj_dir $(WAVE)
