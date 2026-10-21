// verilator.f
// Verilator configuration file
// --- Source Files ---
adder.sv
tb_adder.sv
//lint.vlt

// --- General Options ---
-Wall
-Wno-fatal
--top-module tb_adder

// --- Automatic C++ Options ---
--binary
--assert
// --main
// --timing

// --- Tracing Options ---
--trace-fst
--trace-structs