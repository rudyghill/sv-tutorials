// tb_counter.sv
// SystemVerilog Testbench for the 8-bit counter
module tb_counter;

    // --- Testbench Signals ---
    logic clk = 0;
    logic rst_n_tb = 0;
    logic [7:0] count_tb;
    logic tc_tb;

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // Instantiate DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .rst_n(rst_n_tb),
        .count(count_tb),
        .tc(tc_tb)
    );

    initial begin
        // --- TRACE SETUP ---
        $dumpfile("counter_waveform.fst");
        $dumpvars(0, tb_counter);

        $display("Starting 8-bit Counter Testbench...");

        // Hold reset across a few clock edges: count must stay 0
        repeat(2) @(posedge clk);
        #1;
        $display("--- Check 1: count held at 0 and tc low during reset");
        assert(count_tb == 8'd0 && tc_tb == 1'b0) else
            $fatal(1, "FAILURE: Check 1. Expected count=0 tc=0 in reset, got count=%0d tc=%b",
                   count_tb, tc_tb);

        // Deassert reset away from a clock edge
        @(negedge clk) rst_n_tb = 1;

        // Count up through every value: each rising edge adds one, and tc is
        // high only once count reaches 255
        $display("--- Check 2: count steps 1..255 on each edge, tc high only at 255");
        for (int i = 1; i <= 255; i++) begin
            @(posedge clk) #1;
            assert(count_tb == 8'(i) && tc_tb == (i == 255)) else
                $fatal(1, "FAILURE: Check 2. After %0d edge(s), expected count=%0d tc=%b, got count=%0d tc=%b",
                       i, i, (i == 255), count_tb, tc_tb);
        end

        // Between edges count holds at 255, so tc stays high for the whole cycle
        @(negedge clk) #1;
        $display("--- Check 3: count holds at 255 and tc stays high between edges");
        assert(count_tb == 8'd255 && tc_tb == 1'b1) else
            $fatal(1, "FAILURE: Check 3. Expected count=255 tc=1, got count=%0d tc=%b", count_tb, tc_tb);

        // Free running: the next edge wraps 255 back to 0 and tc drops
        @(posedge clk) #1;
        $display("--- Check 4: count wraps 255 -> 0 and tc goes low");
        assert(count_tb == 8'd0 && tc_tb == 1'b0) else
            $fatal(1, "FAILURE: Check 4. Expected count=0 tc=0 after wrap, got count=%0d tc=%b",
                   count_tb, tc_tb);

        // And it keeps going after the wrap
        @(posedge clk) #1;
        $display("--- Check 5: count keeps going after the wrap");
        assert(count_tb == 8'd1 && tc_tb == 1'b0) else
            $fatal(1, "FAILURE: Check 5. Expected count=1 tc=0, got count=%0d tc=%b", count_tb, tc_tb);

        // Asynchronous reset: assert mid-cycle (clk high, no edge coming)
        // and count must clear right away, not on the next clock edge
        @(posedge clk) #2;
        rst_n_tb = 0;
        #1;
        $display("--- Check 6: async reset clears count without a clock edge");
        assert(count_tb == 8'd0) else
            $fatal(1, "FAILURE: Check 6. Expected count=0 immediately after reset, got count=%0d", count_tb);

        @(negedge clk) rst_n_tb = 1;
        repeat(2) @(posedge clk);

        $display("Test finished at time %t. FST file saved as counter_waveform.fst", $time);
        $finish;
    end

endmodule
