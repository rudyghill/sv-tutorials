// adder.sv
// Simple 4-bit ripple-carry adder module (Device Under Test)
module adder (
    input logic [3:0] A, B,
    input logic Cin,
    output logic [3:0] Sum,
    output logic Cout
);
    // Standard SystemVerilog arithmetic to compute the sum and carry out
    assign {Cout, Sum} = A + B + Cin;
    
endmodule