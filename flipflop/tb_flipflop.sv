// tb_flipflop.sv
// SystemVerilog Testbench for the D flip-flop
module tb_flipflop;

    // --- Testbench Signals ---
    logic clk = 0;
    logic rst_n_tb = 0;
    logic en_tb, d_tb;
    logic q_tb;

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // Instantiate DUT (Device Under Test)
    flipflop dut (
        .clk(clk),
        .rst_n(rst_n_tb),
        .en(en_tb),
        .d(d_tb),
        .q(q_tb)
    );

    initial begin
        // --- TRACE SETUP ---
        $dumpfile("flipflop_waveform.fst");
        $dumpvars(0, tb_flipflop);

        $display("Starting D Flip-Flop Testbench...");

        // Hold reset with D high: Q must stay 0 regardless of D and clk
        en_tb = 1; d_tb = 1;
        repeat(2) @(posedge clk);
        #1;
        $display("--- Check 1: Q held at 0 during reset");
        assert(q_tb == 1'b0) else
            $fatal(1, "FAILURE: Check 1. Expected Q=0 in reset, got Q=%b", q_tb);

        // Deassert reset away from a clock edge
        @(negedge clk) rst_n_tb = 1;

        // Q follows D on the rising edge when enabled
        @(negedge clk) d_tb = 1;
        @(posedge clk) #1;
        $display("--- Check 2: Q captures D=1 on rising edge");
        assert(q_tb == 1'b1) else
            $fatal(1, "FAILURE: Check 2. Expected Q=1, got Q=%b", q_tb);

        // Changing D between edges must NOT change Q
        @(negedge clk) d_tb = 0;
        #1;
        $display("--- Check 3: Q ignores D between clock edges");
        assert(q_tb == 1'b1) else
            $fatal(1, "FAILURE: Check 3. Expected Q to hold 1, got Q=%b", q_tb);

        // ...until the next rising edge
        @(posedge clk) #1;
        $display("--- Check 4: Q captures D=0 on next rising edge");
        assert(q_tb == 1'b0) else
            $fatal(1, "FAILURE: Check 4. Expected Q=0, got Q=%b", q_tb);

        // With enable low, Q holds even across clock edges
        @(negedge clk) begin
            en_tb = 0;
            d_tb  = 1;
        end
        repeat(3) @(posedge clk);
        #1;
        $display("--- Check 5: Q holds while en=0");
        assert(q_tb == 1'b0) else
            $fatal(1, "FAILURE: Check 5. Expected Q to hold 0, got Q=%b", q_tb);

        // Re-enable and load a 1 so the reset check below is meaningful
        @(negedge clk) en_tb = 1;
        @(posedge clk) #1;
        assert(q_tb == 1'b1) else
            $fatal(1, "FAILURE: Expected Q=1 after re-enable, got Q=%b", q_tb);

        // Asynchronous reset: assert mid-cycle (clk high, no edge coming)
        // and Q must clear right away, not on the next clock edge
        @(posedge clk) #2;
        rst_n_tb = 0;
        #1;
        $display("--- Check 6: async reset clears Q without a clock edge");
        assert(q_tb == 1'b0) else
            $fatal(1, "FAILURE: Check 6. Expected Q=0 immediately after reset, got Q=%b", q_tb);

        @(negedge clk) rst_n_tb = 1;
        repeat(2) @(posedge clk);

        $display("Test finished at time %t. FST file saved as flipflop_waveform.fst", $time);
        $finish;
    end

endmodule
