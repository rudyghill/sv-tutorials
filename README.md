# Common Hardware Libraries
Author: Rudy Hill

Tested using the OSS CAD Suite using Verilator and GTKWaves

Intention is to run these on Lattice Hardware using Yosys

To use the OSS tools, download them and I put them in ~/eda:

```
source ~/eda/oss-cad-suite/environment
```

## Structure

Each module has its own folder with the RTL in `design/`, the testbench and
Verilator files in `tb/`, and a Makefile to build, simulate and screenshot it.
See [STRUCTURE.md](STRUCTURE.md) for the full layout and conventions.

## Contributions

Co-authored with Claude Opus 5.5
