// Verilog-2001 translation of rs232_t4.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module rs232_t4 #(
    parameter integer txrd_buff = 511
) (
    input wire clk,
    input wire reset,
    input wire [1:0] dl,
    input wire [2:0] parityn,
    input wire [1:0] stopn,
    input wire [3:0] f_set,
    output wire [1:0] status_s,
    input wire tx_w,
    input wire [7:0] txdata,
    output reg tx
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

wire [2:0] stopnn;
reg tx_b_empty;
reg tx_b_clr;
reg txo_w;
wire [5:0] baudrateset;
reg tx_f;
reg t_half_f;
reg tx_p_neosm;
reg txb_load;
reg [7:0] txds_bf;
reg [7:0] txd2_bf;
reg [3:0] tsend_dln;
wire [3:0] dln;
reg [2:0] tx_s;
wire [15:0] tx_baudrate;
reg [1:0] baudrate1234;
reg [7:0] tx_b_data [0:txrd_buff];
reg [clog2(txrd_buff + 1) - 1:0] tx_b_p0;
reg [clog2(txrd_buff + 1) - 1:0] tx_b_p1;
reg [clog2(txrd_buff + 2) - 1:0] tx_bbn;
reg [15:0] txbaudp__f_div;

initial tx_b_p0 = 0;
initial tx_b_p1 = 0;
initial tx_bbn = 0;
initial txbaudp__f_div = 0;

wire tx_overflow = (tx_bbn > 512) && !txb_load;
assign status_s = {txb_load, txo_w};
// txp_l
`ifdef SYNTHESIS
always @(posedge clk or negedge reset or posedge tx_b_clr or posedge tx_overflow) begin : txp_l
    if ((reset === 1'b0)) begin
        tx_b_p0 <= 0;
        tx_b_empty <= 1'b0;
        txo_w <= 1'b0;
        txb_load <= 1'b0;
        tx_b_p1 <= 0;
        tx_bbn <= 0;
    end else if (((tx_bbn > 512) && (txb_load === 1'b0))) begin
        txb_load <= 1'b1;
        txo_w <= 1'b1;
    end else if ((tx_b_clr === 1'b1)) begin
        tx_b_empty <= 1'b0;
    end else if (1'b1) begin
        if (((((tx_s == 0) && (tx_bbn > 0)) && (tx_bbn < (txrd_buff + 2))) && (tx_b_empty === 1'b0))) begin
            txd2_bf <= tx_b_data[tx_b_p0];
            tx_b_p0 <= (tx_b_p0 + 1);
            tx_b_empty <= 1'b1;
            tx_bbn <= (tx_bbn - 1);
        end else if (((tx_w === 1'b1) && (txb_load === 1'b0))) begin
            tx_b_data[tx_b_p1] <= txdata;
            tx_b_p1 <= (tx_b_p1 + 1);
            tx_bbn <= (tx_bbn + 1);
            txb_load <= 1'b1;
        end else if ((txb_load === 1'b1)) begin
            if ((tx_w === 1'b0)) begin
                txb_load <= 1'b0;
            end
        end else if ((tx_bbn < 513)) begin
            txb_load <= 1'b0;
            txo_w <= 1'b0;
        end
    end
end
`else
reg txp_l__previous_clock;
initial txp_l__previous_clock = 1'bx;
always @(clk or reset) begin : txp_l__vhdl_events
    if ((reset === 1'b0)) begin
        tx_b_p0 <= 0;
        tx_b_empty <= 1'b0;
        txo_w <= 1'b0;
        txb_load <= 1'b0;
        tx_b_p1 <= 0;
        tx_bbn <= 0;
    end else if (((tx_bbn > 512) && (txb_load === 1'b0))) begin
        txb_load <= 1'b1;
        txo_w <= 1'b1;
    end else if ((tx_b_clr === 1'b1)) begin
        tx_b_empty <= 1'b0;
    end else if (((txp_l__previous_clock === 1'b0) && (clk === 1'b1))) begin
        if (((((tx_s == 0) && (tx_bbn > 0)) && (tx_bbn < (txrd_buff + 2))) && (tx_b_empty === 1'b0))) begin
            txd2_bf <= tx_b_data[tx_b_p0];
            tx_b_p0 <= (tx_b_p0 + 1);
            tx_b_empty <= 1'b1;
            tx_bbn <= (tx_bbn - 1);
        end else if (((tx_w === 1'b1) && (txb_load === 1'b0))) begin
            tx_b_data[tx_b_p1] <= txdata;
            tx_b_p1 <= (tx_b_p1 + 1);
            tx_bbn <= (tx_bbn + 1);
            txb_load <= 1'b1;
        end else if ((txb_load === 1'b1)) begin
            if ((tx_w === 1'b0)) begin
                txb_load <= 1'b0;
            end
        end else if ((tx_bbn < 513)) begin
            txb_load <= 1'b0;
            txo_w <= 1'b0;
        end
    end
    txp_l__previous_clock = clk;
end
`endif

// txp
`ifdef SYNTHESIS
always @(posedge tx_f or negedge reset) begin : txp
    if ((reset === 1'b0)) begin
        tx_s <= 3'b000;
        tx <= 1'b1;
        tx_b_clr <= 1'b0;
    end else if (1'b1) begin
        if (((tx_s == 0) && (tx_b_empty === 1'b1))) begin
            txds_bf <= txd2_bf;
            tx <= 1'b0;
            tsend_dln <= 4'b0000;
            tx_p_neosm <= parityn[0];
            tx_b_clr <= 1'b1;
            t_half_f <= 1'b0;
            tx_s <= 3'b001;
        end else if ((tx_s != 0)) begin
            tx_b_clr <= 1'b0;
            t_half_f <= (~(t_half_f));
            case (tx_s)
                3'b001: begin
                    if ((t_half_f === 1'b1)) begin
                        if ((tsend_dln == dln)) begin
                            if ((parityn[2] === 1'b0)) begin
                                tx_s <= stopnn;
                                tx <= 1'b1;
                            end else begin
                                tx <= tx_p_neosm;
                                tx_s <= 3'b010;
                            end
                        end else begin
                            if ((parityn[1] === 1'b0)) begin
                                tx_p_neosm <= (tx_p_neosm ^ txds_bf[0]);
                            end
                            tx <= txds_bf[0];
                            txds_bf <= {txds_bf[0], txds_bf[1 +: 7]};
                            tsend_dln <= (tsend_dln + 1);
                        end
                    end
                end
                3'b011: begin
                    tx_s <= stopnn;
                    tx <= 1'b1;
                end
                default: begin
                    tx_s <= (tx_s + 1);
                end
            endcase
        end
    end
end
`else
reg txp__previous_clock;
initial txp__previous_clock = 1'bx;
always @(tx_f or reset) begin : txp__vhdl_events
    if ((reset === 1'b0)) begin
        tx_s <= 3'b000;
        tx <= 1'b1;
        tx_b_clr <= 1'b0;
    end else if (((txp__previous_clock === 1'b0) && (tx_f === 1'b1))) begin
        if (((tx_s == 0) && (tx_b_empty === 1'b1))) begin
            txds_bf <= txd2_bf;
            tx <= 1'b0;
            tsend_dln <= 4'b0000;
            tx_p_neosm <= parityn[0];
            tx_b_clr <= 1'b1;
            t_half_f <= 1'b0;
            tx_s <= 3'b001;
        end else if ((tx_s != 0)) begin
            tx_b_clr <= 1'b0;
            t_half_f <= (~(t_half_f));
            case (tx_s)
                3'b001: begin
                    if ((t_half_f === 1'b1)) begin
                        if ((tsend_dln == dln)) begin
                            if ((parityn[2] === 1'b0)) begin
                                tx_s <= stopnn;
                                tx <= 1'b1;
                            end else begin
                                tx <= tx_p_neosm;
                                tx_s <= 3'b010;
                            end
                        end else begin
                            if ((parityn[1] === 1'b0)) begin
                                tx_p_neosm <= (tx_p_neosm ^ txds_bf[0]);
                            end
                            tx <= txds_bf[0];
                            txds_bf <= {txds_bf[0], txds_bf[1 +: 7]};
                            tsend_dln <= (tsend_dln + 1);
                        end
                    end
                end
                3'b011: begin
                    tx_s <= stopnn;
                    tx <= 1'b1;
                end
                default: begin
                    tx_s <= (tx_s + 1);
                end
            endcase
        end
    end
    txp__previous_clock = tx_f;
end
`endif

// txbaudp
`ifdef SYNTHESIS
always @(posedge clk or negedge reset) begin : txbaudp
    if ((reset === 1'b0)) begin
        txbaudp__f_div = 0;
        tx_f <= 1'b0;
        baudrate1234 <= 2'b00;
    end else if (1'b1) begin
        if ((txbaudp__f_div == tx_baudrate)) begin
            txbaudp__f_div = 0;
            tx_f <= (~(tx_f));
            baudrate1234 <= (baudrate1234 + 1);
        end else begin
            txbaudp__f_div = (txbaudp__f_div + 1);
        end
    end
end
`else
reg txbaudp__previous_clock;
initial txbaudp__previous_clock = 1'bx;
always @(clk or reset) begin : txbaudp__vhdl_events
    if ((reset === 1'b0)) begin
        txbaudp__f_div = 0;
        tx_f <= 1'b0;
        baudrate1234 <= 2'b00;
    end else if (((txbaudp__previous_clock === 1'b0) && (clk === 1'b1))) begin
        if ((txbaudp__f_div == tx_baudrate)) begin
            txbaudp__f_div = 0;
            tx_f <= (~(tx_f));
            baudrate1234 <= (baudrate1234 + 1);
        end else begin
            txbaudp__f_div = (txbaudp__f_div + 1);
        end
    end
    txbaudp__previous_clock = clk;
end
`endif

assign baudrateset = {f_set, baudrate1234};
assign tx_baudrate = ((baudrateset == 6'b000000)) ? 41667 : ((baudrateset == 6'b000001)) ? 41667 : ((baudrateset == 6'b000010)) ? 41667 : ((baudrateset == 6'b000011)) ? 41666 : ((baudrateset == 6'b000100)) ? 20833 : ((baudrateset == 6'b000101)) ? 20834 : ((baudrateset == 6'b000110)) ? 20833 : ((baudrateset == 6'b000111)) ? 20833 : ((baudrateset == 6'b001000)) ? 10416 : ((baudrateset == 6'b001001)) ? 10417 : ((baudrateset == 6'b001010)) ? 10417 : ((baudrateset == 6'b001011)) ? 10417 : ((baudrateset == 6'b001100)) ? 5208 : ((baudrateset == 6'b001101)) ? 5209 : ((baudrateset == 6'b001110)) ? 5208 : ((baudrateset == 6'b001111)) ? 5208 : ((baudrateset == 6'b010000)) ? 2604 : ((baudrateset == 6'b010001)) ? 2605 : ((baudrateset == 6'b010010)) ? 2604 : ((baudrateset == 6'b010011)) ? 2604 : ((baudrateset == 6'b010100)) ? 1302 : ((baudrateset == 6'b010101)) ? 1302 : ((baudrateset == 6'b010110)) ? 1302 : ((baudrateset == 6'b010111)) ? 1302 : ((baudrateset == 6'b011000)) ? 651 : ((baudrateset == 6'b011001)) ? 651 : ((baudrateset == 6'b011010)) ? 651 : ((baudrateset == 6'b011011)) ? 651 : ((baudrateset == 6'b011100)) ? 434 : ((baudrateset == 6'b011101)) ? 434 : ((baudrateset == 6'b011110)) ? 434 : ((baudrateset == 6'b011111)) ? 434 : ((baudrateset == 6'b100000)) ? 325 : ((baudrateset == 6'b100001)) ? 326 : ((baudrateset == 6'b100010)) ? 326 : ((baudrateset == 6'b100011)) ? 325 : ((baudrateset == 6'b100100)) ? 217 : ((baudrateset == 6'b100101)) ? 217 : ((baudrateset == 6'b100110)) ? 217 : ((baudrateset == 6'b100111)) ? 217 : ((baudrateset == 6'b101000)) ? 162 : ((baudrateset == 6'b101001)) ? 163 : ((baudrateset == 6'b101010)) ? 163 : ((baudrateset == 6'b101011)) ? 163 : ((baudrateset == 6'b101100)) ? 108 : ((baudrateset == 6'b101101)) ? 109 : ((baudrateset == 6'b101110)) ? 108 : ((baudrateset == 6'b101111)) ? 108 : ((baudrateset == 6'b110000)) ? 54 : ((baudrateset == 6'b110001)) ? 55 : ((baudrateset == 6'b110010)) ? 54 : ((baudrateset == 6'b110011)) ? 54 : ((baudrateset == 6'b110100)) ? 27 : ((baudrateset == 6'b110101)) ? 27 : ((baudrateset == 6'b110110)) ? 28 : ((baudrateset == 6'b110111)) ? 27 : ((baudrateset == 6'b111000)) ? 21 : ((baudrateset == 6'b111001)) ? 22 : ((baudrateset == 6'b111010)) ? 22 : ((baudrateset == 6'b111011)) ? 22 : ((baudrateset == 6'b111100)) ? 13 : ((baudrateset == 6'b111101)) ? 14 : ((baudrateset == 6'b111110)) ? 14 : ((baudrateset == 6'b111111)) ? 13 : 0;
assign dln = ((dl == 2'b00)) ? 4'b0101 : ((dl == 2'b01)) ? 4'b0110 : ((dl == 2'b10)) ? 4'b0111 : ((dl == 2'b11)) ? 4'b1000 : 4'b0000;
assign stopnn = ((stopn == 2'b10)) ? 3'b101 : ((stopn == 2'b11)) ? 3'b110 : 3'b111;
endmodule
`default_nettype wire
