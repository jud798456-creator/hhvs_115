// Verilog-2001 translation of k4x4.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module k4x4 (
    input wire kf,
    input wire reset,
    input wire [1:0] ki,
    output wire [1:0] ko,
    output reg [4:0] kn,
    output wire [4:0] kv,
    output wire [7:0] kascii,
    output wire kok,
    output reg koo
);
function integer clog2;
    input integer value;
    integer v;
    begin
        v = value - 1;
        clog2 = 0;
        while (v > 0) begin
            clog2 = clog2 + 1;
            v = v >> 1;
        end
        if (clog2 == 0) clog2 = 1;
    end
endfunction

wire [3:0] ki2;
reg [3:0] ko2;
reg [7:0] ks;
localparam [7:0] ks_end = 200;
localparam [79:0] kn_kv = {5'd0, 5'd1, 5'd16, 5'd16, 5'd2, 5'd3, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16};
localparam [127:0] kn_kascii = {8'h30, 8'h31, 8'h32, 8'h33, 8'h32, 8'h33, 8'h35, 8'h37, 8'h36, 8'h37, 8'h38, 8'h0B, 8'h0C, 8'h0D, 8'h0E, 8'h0F};

initial ks = 0;
initial kn = 0;

wire scan_done = (ks == ks_end) || !reset;
assign ki2 = {2'b11, ki};
assign ko = ko2[0 +: 2];
assign kv = kn_kv[75 - 5*kn +: 5];
assign kascii = kn_kascii[120 - 8*kn +: 8];
assign kok = ((ks == 20)) ? 1'b1 : 1'b0;
// Sequential logic
`ifdef SYNTHESIS
always @(posedge kf or posedge scan_done) begin : sequential_0
    if (((ks == ks_end) || (reset === 1'b0))) begin
        kn <= 0;
        ko2 <= 4'b1110;
        ks <= 0;
    end else if (1'b1) begin
        if ((ks > 0)) begin
            ks <= (ks + 1);
            if (((ki2 == 15) && ((ks < 2) || (ks > 25)))) begin
                ks <= ks_end;
            end
        end else if ((ki2[(0)+((((kn / 4))-(0))*(1))] === 1'b0)) begin
            ks <= 1;
            koo <= (~(koo));
        end else begin
            kn <= (kn + 1);
            if ((kn == 15)) begin
                ks <= ks_end;
            end
            ko2 <= {{{ko2[2], ko2[1]}, ko2[0]}, ko2[3]};
        end
    end
end
`else
reg sequential_0__previous_clock;
initial sequential_0__previous_clock = 1'bx;
always @(kf) begin : sequential_0__vhdl_events
    if (((ks == ks_end) || (reset === 1'b0))) begin
        kn <= 0;
        ko2 <= 4'b1110;
        ks <= 0;
    end else if (((sequential_0__previous_clock === 1'b0) && (kf === 1'b1))) begin
        if ((ks > 0)) begin
            ks <= (ks + 1);
            if (((ki2 == 15) && ((ks < 2) || (ks > 25)))) begin
                ks <= ks_end;
            end
        end else if ((ki2[(0)+((((kn / 4))-(0))*(1))] === 1'b0)) begin
            ks <= 1;
            koo <= (~(koo));
        end else begin
            kn <= (kn + 1);
            if ((kn == 15)) begin
                ks <= ks_end;
            end
            ko2 <= {{{ko2[2], ko2[1]}, ko2[0]}, ko2[3]};
        end
    end
    sequential_0__previous_clock = kf;
end
`endif

endmodule
`default_nettype wire
