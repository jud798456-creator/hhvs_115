`timescale 1ns/1ps
module rom_tb;
    reg clk = 0;
    reg [1:0] addr = 0;
    wire [15:0] q, qq;
    e111_01_01_rom #(.addr_length(3), .sim_hex_file("rom.hex")) dut (
        .addr(addr), .clk(clk), .q(q), .qq(qq)
    );
    initial begin
        #5 clk = 1;
        #1;
        if (q !== 16'h1234 || qq !== 16'habcd) begin
            $display("FAIL: ROM first read"); $finish(1);
        end
        clk = 0; addr = 1;
        #4;
        if (q !== 16'h1234) begin
            $display("FAIL: ROM changed without a clock"); $finish(1);
        end
        clk = 1;
        #1;
        if (q !== 16'habcd || qq !== 16'h55aa) begin
            $display("FAIL: ROM adjacent read"); $finish(1);
        end
        clk = 0; addr = 2;
        #4 clk = 1;
        #1;
        if (q !== 16'h55aa || qq !== 16'h0f0f) begin
            $display("FAIL: ROM last valid adjacent read"); $finish(1);
        end
        $display("e111_01_01_rom: PASS (clocked read, adjacent read, output hold)");
        $finish;
    end
endmodule
