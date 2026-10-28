// tb_counter.sv
// SystemVerilog Testbench for the 8-bit counter
module tb_counter;

    // --- Testbench Signals ---
    logic clk = 0;
    logic rst_n_tb = 0;
    logic [7:0] count_tb;

    // Number of clock edges to count through in Check 2
    localparam int CYCLES = 5;

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // Instantiate DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .rst_n(rst_n_tb),
        .count(count_tb)
    );

    initial begin
        // --- TRACE SETUP ---
        $dumpfile("counter_waveform.fst");
        $dumpvars(0, tb_counter);

        $display("Starting 8-bit Counter Testbench...");

        // Hold reset across a few clock edges: count must stay 0
        repeat(2) @(posedge clk);
        #1;
        $display("--- Check 1: count held at 0 during reset");
        assert(count_tb == 8'd0) else
            $fatal(1, "FAILURE: Check 1. Expected count=0 in reset, got count=%0d", count_tb);

        // Deassert reset away from a clock edge
        @(negedge clk) rst_n_tb = 1;

        // Each rising edge adds one
        for (int i = 1; i <= CYCLES; i++) begin
            @(posedge clk) #1;
            $display("--- Check 2.%0d: after %0d edge(s), count=%0d", i, i, count_tb);
            assert(count_tb == 8'(i)) else
                $fatal(1, "FAILURE: Check 2.%0d. Expected count=%0d, got count=%0d", i, i, count_tb);
        end

        // Between edges count must hold its value
        @(negedge clk) #1;
        $display("--- Check 3: count holds between clock edges");
        assert(count_tb == 8'(CYCLES)) else
            $fatal(1, "FAILURE: Check 3. Expected count to hold %0d, got count=%0d", CYCLES, count_tb);

        // Asynchronous reset: assert mid-cycle (clk high, no edge coming)
        // and count must clear right away, not on the next clock edge
        @(posedge clk) #2;
        rst_n_tb = 0;
        #1;
        $display("--- Check 4: async reset clears count without a clock edge");
        assert(count_tb == 8'd0) else
            $fatal(1, "FAILURE: Check 4. Expected count=0 immediately after reset, got count=%0d", count_tb);

        @(negedge clk) rst_n_tb = 1;
        repeat(2) @(posedge clk);

        $display("Test finished at time %t. FST file saved as counter_waveform.fst", $time);
        $finish;
    end

endmodule
