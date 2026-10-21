// verilator.f
// Verilator configuration file
// --- Source Files ---
test.sv
tb.sv
//lint.vlt

// --- General Options ---
-Wall
-Wno-fatal
--top-module tb

// --- Automatic C++ Options ---
--binary
--assert
// --main
// --timing

// --- Tracing Options ---
--trace-fst
--trace-structs

// UVM Support?
+incdir+$UVM_HOME
$UVM_HOME/uvm_pkg.sv