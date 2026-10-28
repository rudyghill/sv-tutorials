// counter.sv
// 8-bit up counter with asynchronous active-low reset
//
// On every rising clock edge count goes up by one. After 255 it wraps back
// to 0, because an 8-bit register has no room for a ninth bit.
//
// Priority (highest first):
//   1. rst_n == 0  -> count forced to 0 immediately, clock or no clock
//   2. otherwise   -> count increments by 1 on the rising edge of clk
module counter (
    input  logic       clk,
    input  logic       rst_n,   // asynchronous, active-low reset
    output logic [7:0] count    // current count, 0..255
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 8'b0;
        else begin
            count <= count + 1;
        end
    end
endmodule
