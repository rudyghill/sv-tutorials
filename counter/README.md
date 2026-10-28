# 8-bit Counter

An 8-bit up counter with asynchronous active-low reset.
Meant as a teaching example: on each rising clock edge `count` goes up by one,
wrapping from 255 back to 0. `rst_n` clears it immediately.

Layout
- `design/` — the RTL (`counter.sv`)
- `tb/` — testbench and Verilator files; build output and the waveform land here
- `artifacts/` — kept outputs (not committed); `make screenshots` writes to `artifacts/screenshots/`

Build and run the sim (writes `tb/counter_waveform.fst`)
```sh
make
```

Open the waveform in gtkwaves
```sh
make wave
```

Render code screenshots of the RTL into `artifacts/screenshots/` with
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
