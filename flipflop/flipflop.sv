// flipflop.sv
// D flip-flop with asynchronous active-low reset and clock enable
//
// A flip-flop is the basic unit of memory in synchronous logic: it samples
// its input D on the rising clock edge and holds that value on Q until the
// next edge. Between edges, changes on D have no effect on Q.
//
// Priority (highest first):
//   1. rst_n == 0  -> Q is forced to 0 immediately, clock or no clock
//   2. en    == 0  -> Q holds its current value
//   3. otherwise   -> Q takes D on the rising edge of clk
module flipflop (
    input  logic clk,
    input  logic rst_n,   // asynchronous, active-low reset
    input  logic en,      // clock enable
    input  logic d,
    output logic q
);
    // always_ff tells tools this block must infer flip-flops (not latches or
    // combinational logic). Putting negedge rst_n in the sensitivity list is
    // what makes the reset asynchronous: the block wakes up on the reset edge
    // without waiting for clk.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else if (en)
            q <= d;   // non-blocking (<=): all flops update together at the edge
        // no else branch: Q keeps its value, which is exactly what a flop does
    end

endmodule
