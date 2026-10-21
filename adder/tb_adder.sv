// tb_adder.sv
// SystemVerilog Testbench for the 4-bit adder
module tb_adder;
    
    // --- Testbench Signals ---
    logic clk = 0;
    logic rst = 1;
    logic [3:0] A_tb, B_tb;
    logic Cin_tb;
    logic [3:0] Sum_tb;
    logic Cout_tb;

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // Instantiate DUT (Device Under Test)
    // .*( ) uses implicit port connection by name
    adder dut (
        .A(A_tb),
        .B(B_tb),
        .Cin(Cin_tb),
        .Sum(Sum_tb),
        .Cout(Cout_tb)
    );

    initial begin
        // --- MANDATORY: TRACE SETUP ---
        // 1. Name the output FST file explicitly
        $dumpfile("adder_waveform.fst");
        // 2. Start dumping all signals in this module (depth 0)
        $dumpvars(0, tb_adder); 
        
        $display("Starting 4-bit Adder Testbench...");

        // Initial setup and reset
        A_tb = 4'b0; B_tb = 4'b0; Cin_tb = 0;
        
        #10; // Hold reset for one full clock cycle
        rst = 0; // Deassert reset
        
        // --- Stimulus Sequence ---

        // Test 1: 5 + 3 + 0 = 8 (0101 + 0011 + 0 = 1000)
        @(posedge clk) begin
            A_tb <= 4'd5;
            B_tb <= 4'd3;
            Cin_tb <= 0;
        end
        // CHECK 1: Wait for clock to capture inputs, then check outputs
        @(posedge clk) begin
            $display("--- Check 1: 5 + 3 + 0 = 8");
            assert(Sum_tb == 4'd8 && Cout_tb == 1'b0) else 
                $fatal(1, "FAILURE: Test 1 failed. Expected Sum=8, Cout=0. Got Sum=%0d, Cout=%b", Sum_tb, Cout_tb);
        end

        // Test 2: 15 + 1 + 1 = 1 (Cout=1) (1111 + 0001 + 1 = 1_0001)
        @(posedge clk) begin
            A_tb <= 4'd15;
            B_tb <= 4'd1;
            Cin_tb <= 1;
        end
        // CHECK 2
        @(posedge clk) begin
            $display("--- Check 2: 15 + 1 + 1 = 17");
            assert(Sum_tb == 4'd1 && Cout_tb == 1'b1) else 
                $fatal(1, "FAILURE: Test 2 failed. Expected Sum=1, Cout=1. Got Sum=%0d, Cout=%b", Sum_tb, Cout_tb);
        end

        // Test 3: 10 + 2 + 0 = 12 (1010 + 0010 + 0 = 1100)
        @(posedge clk) begin
            A_tb <= 4'd10;
            B_tb <= 4'd2;
            Cin_tb <= 0;
        end
        // CHECK 3
        @(posedge clk) begin
            $display("--- Check 3: 10 + 2 + 0 = 12");
            assert(Sum_tb == 4'd12 && Cout_tb == 1'b0) else 
                $fatal(1, "FAILURE: Test 3 failed. Expected Sum=12, Cout=0. Got Sum=%0d, Cout=%b", Sum_tb, Cout_tb);
        end
        
        // Wait for final result propagation
        repeat(3) @(posedge clk); 

        // Simulation ends gracefully, ensuring trace file is closed
        $display("Test finished at time %t. FST file saved as adder_waveform.fst", $time);
        $finish;
    end
    
endmodule
