# Simple Adder

This is a simple adder for testing purposes

Build
```sh
verilator -f verilator.f
```

Run the sim and output for gtkwaves
```sh
./obj_dir/Vtb_adder
gtkwave adder_waveform.fst
```