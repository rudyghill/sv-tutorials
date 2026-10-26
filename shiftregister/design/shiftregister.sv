// shiftregister.sv
// 4-bit serial-in, parallel-out shift register with asynchronous active-low reset
//
// A shift register is a chain of flip-flops where each flop's output feeds the
// next flop's input. On every rising clock edge, every bit moves one position
// along the chain: a new bit enters at q[0] from sin, and the oldest bit falls
// off the end after q[3]. After 4 clocks, the first bit shifted in appears on
// sout, which makes this a 4-cycle delay line as well as a serial-to-parallel
// converter.
//
// Priority (highest first):
//   1. rst_n == 0  -> all bits forced to 0 immediately, clock or no clock
//   2. otherwise   -> shift left by one on the rising edge of clk
module shiftregister (
    input  logic       clk,
    input  logic       rst_n,   // asynchronous, active-low reset
    input  logic       sin,     // serial input, enters at q[0]
    output logic [3:0] q,       // parallel output of all 4 stages
    output logic       sout     // serial output, the last stage
);
    // Concatenation {q[2:0], sin} builds the next value: bits 2..0 move up
    // one place and sin fills the bottom. Non-blocking assignment means every
    // stage reads the old value of its neighbour, so all bits shift together.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0000;
        else
            q <= {q[2:0], sin};
    end

    assign sout = q[3];

endmodule
