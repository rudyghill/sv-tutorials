# D Flip-Flop

A single-bit D flip-flop with asynchronous active-low reset and clock enable.
Meant as a teaching example: Q samples D on the rising clock edge and holds it
otherwise. `rst_n` clears Q immediately, and `en` low makes Q ignore clock edges.

Build
```sh
verilator -f verilator.f
```

Run the sim and output for gtkwaves
```sh
./obj_dir/Vtb_flipflop
gtkwave flipflop_waveform.fst
```
