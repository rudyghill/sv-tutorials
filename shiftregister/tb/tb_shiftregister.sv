// tb_shiftregister.sv
// SystemVerilog Testbench for the 4-bit shift register
module tb_shiftregister;

    // --- Testbench Signals ---
    logic clk = 0;
    logic rst_n_tb = 0;
    logic sin_tb;
    logic [3:0] q_tb;
    logic sout_tb;

    // Pattern shifted in, first bit first
    logic [3:0] pattern = 4'b1011;
    logic [3:0] expected;

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // Instantiate DUT (Device Under Test)
    shiftregister dut (
        .clk(clk),
        .rst_n(rst_n_tb),
        .sin(sin_tb),
        .q(q_tb),
        .sout(sout_tb)
    );

    initial begin
        // --- TRACE SETUP ---
        $dumpfile("shiftregister_waveform.fst");
        $dumpvars(0, tb_shiftregister);

        $display("Starting 4-bit Shift Register Testbench...");

        // Hold reset with sin high: Q must stay 0 regardless of sin and clk
        sin_tb = 1;
        repeat(2) @(posedge clk);
        #1;
        $display("--- Check 1: Q held at 0000 during reset");
        assert(q_tb == 4'b0000) else
            $fatal(1, "FAILURE: Check 1. Expected Q=0000 in reset, got Q=%b", q_tb);

        // Deassert reset away from a clock edge, with sin low so the edge
        // before the pattern starts shifts in a harmless 0
        @(negedge clk) begin
            rst_n_tb = 1;
            sin_tb   = 0;
        end

        // Shift the pattern in MSB first; each edge moves it one stage along
        expected = 4'b0000;
        for (int i = 3; i >= 0; i--) begin
            @(negedge clk) sin_tb = pattern[i];
            @(posedge clk) #1;
            expected = {expected[2:0], pattern[i]};
            $display("--- Check 2.%0d: shifted in %b, Q=%b", 3 - i, pattern[i], q_tb);
            assert(q_tb == expected) else
                $fatal(1, "FAILURE: Check 2.%0d. Expected Q=%b, got Q=%b", 3 - i, expected, q_tb);
        end

        // After 4 shifts the whole pattern is loaded and the first bit is on sout
        $display("--- Check 3: full pattern loaded, sout is first bit in");
        assert(q_tb == pattern && sout_tb == pattern[3]) else
            $fatal(1, "FAILURE: Check 3. Expected Q=%b sout=%b, got Q=%b sout=%b",
                   pattern, pattern[3], q_tb, sout_tb);

        // Changing sin between edges must NOT change Q
        @(negedge clk) sin_tb = 0;
        #1;
        $display("--- Check 4: Q ignores sin between clock edges");
        assert(q_tb == pattern) else
            $fatal(1, "FAILURE: Check 4. Expected Q to hold %b, got Q=%b", pattern, q_tb);

        // Asynchronous reset: assert mid-cycle (clk high, no edge coming)
        // and Q must clear right away, not on the next clock edge
        @(posedge clk) #2;
        rst_n_tb = 0;
        #1;
        $display("--- Check 5: async reset clears Q without a clock edge");
        assert(q_tb == 4'b0000 && sout_tb == 1'b0) else
            $fatal(1, "FAILURE: Check 5. Expected Q=0000 immediately after reset, got Q=%b", q_tb);

        @(negedge clk) rst_n_tb = 1;
        repeat(2) @(posedge clk);

        $display("Test finished at time %t. FST file saved as shiftregister_waveform.fst", $time);
        $finish;
    end

endmodule
