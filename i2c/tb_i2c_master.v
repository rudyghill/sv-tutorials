// tb_i2c_master.v
`timescale 1ns/1ps

module tb_i2c_master;

    reg clk;
    reg rst_n;
    reg start;
    reg cmd_read;
    reg [6:0] addr;
    reg [7:0] tx_data;
    reg [7:0] tx_count;

    wire [7:0] rx_data;
    wire busy, done, ack_error;

    wire scl;
    wire sda;

    // simple pull-up for SDA
    pullup(sda);

    i2c_master #(.CLK_DIV(4)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .cmd_read(cmd_read),
        .addr(addr),
        .tx_data(tx_data),
        .tx_count(tx_count),
        .rx_data(rx_data),
        .busy(busy),
        .done(done),
        .ack_error(ack_error),
        .sda(sda),
        .scl(scl)
    );

    // clock gen
    always #5 clk = ~clk; // 100 MHz

    initial begin
        $dumpfile("tb_i2c_master.vcd");
        $dumpvars(0, tb_i2c_master);

        // init
        clk = 0;
        rst_n = 0;
        start = 0;
        cmd_read = 0;
        addr = 7'h50;
        tx_data = 8'hA5;
        tx_count = 8'd1;

        // release reset
        #20;
        rst_n = 1;

        // wait a bit
        #50;

        // kick off a write
        start = 1;
        #10 start = 0;

        // let it run
        #1000;

        $finish;
    end
endmodule
