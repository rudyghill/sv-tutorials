# D Flip-Flop

A single-bit D flip-flop with asynchronous active-low reset.
Meant as a teaching example: Q samples D on the rising clock edge and holds it
otherwise. `rst_n` clears Q immediately.

Layout
- `design/` — the RTL (`flipflop.sv`)
- `tb/` — testbench and Verilator files; build output and the waveform land here
- `img/` — generated screenshots (not committed)

Build and run the sim (writes `tb/flipflop_waveform.fst`)
```sh
make
```

Open the waveform in gtkwaves
```sh
make wave
```

Render code screenshots of the RTL into `img/` with
[silicon](https://github.com/Aloxaf/silicon): comments stripped, one full view,
one with the ports highlighted and one with the logic highlighted. Highlight
ranges are auto-detected; override with `PORT_LINES=` / `LOGIC_LINES=`.
```sh
make screenshots
```

Remove build output
```sh
make clean
```

Source the OSS CAD Suite first:
`source ~/eda/oss-cad-suite/environment`.
