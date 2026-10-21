# Test Suite

This is just a folder/module where I can experiment and try things. Mainly testing verilator's features but also verlog things as well.

Build
```sh
verilator -f verilator.f
```

Run the sim and output for gtkwaves
```sh
./obj_dir/Vtb
gtkwave tb_waveform.fst
```