// Verilog-2001 translation of e111_01_01_rom.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module e111_01_01_rom #(
    parameter integer addr_length = 2751,
    parameter ram_init_file_set = "",
    // Hex words for simulation only; Quartus uses the MIF attribute below.
    parameter sim_hex_file = ""
) (
    input wire [clog2(addr_length + 1) - 1:0] addr,
    input wire clk,
    output reg [15:0] q,
    output reg [15:0] qq
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

// Preserve Quartus MIF initialization and infer a synchronous ROM.
(* ram_init_file = ram_init_file_set *) reg [15:0] rom [0:addr_length];
`ifndef SYNTHESIS
initial begin
    if (sim_hex_file != "") $readmemh(sim_hex_file, rom);
end
`endif
always @(posedge clk) begin
    q <= rom[addr];
    qq <= rom[addr + 1];
end
endmodule
`default_nettype wire
