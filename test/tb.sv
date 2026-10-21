module tb;
    logic a, b, c;
    test dut(.*);
    initial begin
        $dumpfile("tb_waveform.fst");
        $dumpvars(0, tb);
        a = 1;
        b = 0;
        #1;
        $finish;
    end
endmodule
