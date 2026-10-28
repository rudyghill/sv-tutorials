# Module Structure

Every module lives in its own top-level folder, laid out the same way so the
same commands work everywhere. [`shiftregister/`](shiftregister/) is the
reference: copy it when starting a new module. `flipflop/` follows it too.
Older modules (`adder/`, `i2c/`) predate this layout and are being moved over.

```
<module>/
├── README.md            what the module does, how to build and run it
├── Makefile             build, sim, wave, screenshots, clean
├── screenshots.sh       renders code images of the RTL with silicon
├── design/
│   └── <module>.sv      the RTL, one module per file
├── tb/
│   ├── tb_<module>.sv   self-checking testbench
│   ├── verilator.f      Verilator options and source list
│   ├── lint.vlt         Verilator lint waivers
│   ├── obj_dir/         generated: Verilator build output
│   └── <module>_waveform.fst   generated: sim waveform
└── artifacts/           generated outputs worth keeping
    └── screenshots/     code images from `make screenshots`
```

Generated files are gitignored (`obj_dir/`, `*.fst`, `artifacts/`), so only
the sources, the Makefile and the docs are committed. `artifacts/` is the one
place for outputs you want to keep around locally; `img/` is deliberately left
free for committed documentation images.

## Setup

The Makefiles expect the OSS CAD Suite to already be on `PATH`:

```sh
source ~/eda/oss-cad-suite/environment
```

If it isn't, `make` stops with a message saying so. Screenshots also need
[silicon](https://github.com/Aloxaf/silicon), which is installed separately.

## Make targets

Run these from inside the module folder.

| Command            | What it does |
|--------------------|--------------|
| `make`             | Builds if a source changed, then always runs the sim |
| `make build`       | Builds the sim without running it |
| `make wave`        | Opens the waveform in GTKWave, running the sim first if there isn't one |
| `make screenshots` | Writes `artifacts/screenshots/<module>_{full,ports,logic}.png` |
| `make clean`       | Removes `tb/obj_dir/` and the waveform; leaves `artifacts/` alone |

## Conventions

**Names.** The RTL module is `<module>` in `design/<module>.sv`, and its
testbench is `tb_<module>` in `tb/tb_<module>.sv`. Testbench signals that
drive or watch DUT ports take a `_tb` suffix (`d_tb`, `q_tb`); the clock
is just `clk`.

**`design/`.** Only synthesizable RTL goes here, nothing simulation-only, so
the folder can be handed straight to Yosys. Comments explain the hardware for
a reader learning HDL. `screenshots.sh` strips them from the images.

**`tb/`.** Verilator runs from inside `tb/`, so the paths in `verilator.f`
are relative to that folder (the RTL is `../design/<module>.sv`), and the
waveform is written there. To build by hand, run
`cd tb && verilator -f verilator.f`.

**Testbenches are self-checking.** Each check prints a `--- Check N:` line
and uses `assert ... else $fatal(...)`, so a wrong result stops the sim with
a non-zero exit instead of relying on someone reading the waveform. The
testbench dumps every signal with `$dumpfile("<module>_waveform.fst")` and
`$dumpvars(0, tb_<module>)`.

**Screenshots.** `make screenshots` strips comments, then renders the full
file, the port list highlighted, and the module body highlighted. Highlight
ranges are detected automatically; override them with
`make screenshots PORT_LINES=1-7 LOGIC_LINES=8-15`. The script only depends
on its arguments, so it can be copied into a new module unchanged.

## Starting a new module

1. Copy `shiftregister/` to `<module>/`, then delete its `artifacts/` and `tb/obj_dir/`.
2. Rename the `.sv` files and replace `shiftregister` with `<module>` in
   `Makefile`, `tb/verilator.f` and the testbench.
3. Write the RTL and testbench, then run `make` until every check passes.
4. Update the module's `README.md`.

## TODO

- [ ] Add a clean `template/` module to copy instead of `shiftregister/`. It
      should have the full layout with a placeholder RTL module and testbench,
      a Makefile with one name to change, and no generated files. Once it
      exists, point "Starting a new module" at it.
