// verilator.f
// Verilator configuration file
// --- Source Files ---
// Paths are relative to tb/, where the Makefile runs verilator
../design/counter.sv
tb_counter.sv
//lint.vlt

// --- General Options ---
-Wall
-Wno-fatal
--top-module tb_counter

// --- Automatic C++ Options ---
--binary
--assert
// --main
// --timing

// --- Tracing Options ---
--trace-fst
--trace-structs
