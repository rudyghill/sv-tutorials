// verilator.f
// Verilator configuration file
// --- Source Files ---
flipflop.sv
tb_flipflop.sv
//lint.vlt

// --- General Options ---
-Wall
-Wno-fatal
--top-module tb_flipflop

// --- Automatic C++ Options ---
--binary
--assert
// --main
// --timing

// --- Tracing Options ---
--trace-fst
--trace-structs
