// Verilog-2001 translation of rs232_r4.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module rs232_r4 #(
    parameter integer txrd_buff = 511
) (
    input wire clk,
    input wire reset,
    input wire [1:0] dl,
    input wire [2:0] parityn,
    input wire [1:0] stopn,
    input wire [3:0] f_set,
    output wire [2:0] status_s,
    output reg [clog2(txrd_buff + 2) - 1:0] rx_bbn,
    input wire rx_r,
    input wire rd,
    output reg [7:0] rxds
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
reg rx_b_empty;
reg rx_p_error;
reg rx_ow;
wire rdf;
reg rx_f;
reg rx_peosm;
reg r_half_f;
reg [7:0] rxd;
wire [7:0] rxdb;
wire [7:0] rx_buffer;
reg [3:0] rsend_rdlns;
wire [3:0] rdln;
wire [2:0] rc;
reg [1:0] rx_s;
wire [1:0] rff;
reg [1:0] baudrate1234;
wire [15:0] rx_baudrate;
wire [5:0] baudrateset;
reg [7:0] rx_b_data [0:txrd_buff];
reg [txrd_buff:0] rx_b_p_error;
reg [txrd_buff:0] rx_b_ow;
reg [clog2(txrd_buff + 1) - 1:0] rx_b_p0;
reg [clog2(txrd_buff + 1) - 1:0] rx_b_p1;
reg rx_b_ows;
reg upload0;
reg upload1;
reg [15:0] rxbaudp__f_div;

initial rx_b_p0 = 0;
initial rx_b_p1 = 0;
initial rxbaudp__f_div = 0;
initial rx_bbn = 0;

wire rx_idle = (rx_s[0] == rx_s[1]);
assign status_s = {{rx_b_empty, rx_p_error}, rx_ow};
assign rdf = ((rx_s[0] === rx_s[1])) ? clk : rx_f;
// rxlp
`ifdef SYNTHESIS
always @(negedge clk or negedge reset) begin : rxlp
    if ((reset === 1'b0)) begin
        rx_b_p0 <= 0;
        rx_b_empty <= 1'b0;
        rx_ow <= 1'b0;
        rx_p_error <= 1'b0;
        upload0 <= 1'b0;
        rx_b_p1 <= 0;
        rx_bbn <= 0;
    end else if (1'b1) begin
        upload0 <= upload1;
        if ((upload1 === 1'b1)) begin
            rx_b_data[rx_b_p1] <= rxdb;
            rx_b_p1 <= (rx_b_p1 + 1);
            rx_bbn <= (rx_bbn + 1);
        end else begin
            if (((rx_bbn != 0) && (rx_b_empty === 1'b0))) begin
                rxds <= rx_b_data[rx_b_p0];
                rx_ow <= rx_b_ow[rx_b_p0];
                rx_p_error <= rx_b_p_error[rx_b_p0];
                rx_b_empty <= 1'b1;
                rx_b_p0 <= (rx_b_p0 + 1);
            end else if ((rx_r === 1'b1)) begin
                rx_b_empty <= 1'b0;
                rx_bbn <= (rx_bbn - 1);
            end
        end
    end
end
`else
reg rxlp__previous_clock;
initial rxlp__previous_clock = 1'bx;
always @(clk or reset) begin : rxlp__vhdl_events
    if ((reset === 1'b0)) begin
        rx_b_p0 <= 0;
        rx_b_empty <= 1'b0;
        rx_ow <= 1'b0;
        rx_p_error <= 1'b0;
        upload0 <= 1'b0;
        rx_b_p1 <= 0;
        rx_bbn <= 0;
    end else if (((rxlp__previous_clock === 1'b1) && (clk === 1'b0))) begin
        upload0 <= upload1;
        if ((upload1 === 1'b1)) begin
            rx_b_data[rx_b_p1] <= rxdb;
            rx_b_p1 <= (rx_b_p1 + 1);
            rx_bbn <= (rx_bbn + 1);
        end else begin
            if (((rx_bbn != 0) && (rx_b_empty === 1'b0))) begin
                rxds <= rx_b_data[rx_b_p0];
                rx_ow <= rx_b_ow[rx_b_p0];
                rx_p_error <= rx_b_p_error[rx_b_p0];
                rx_b_empty <= 1'b1;
                rx_b_p0 <= (rx_b_p0 + 1);
            end else if ((rx_r === 1'b1)) begin
                rx_b_empty <= 1'b0;
                rx_bbn <= (rx_bbn - 1);
            end
        end
    end
    rxlp__previous_clock = clk;
end
`endif

// rxp
`ifdef SYNTHESIS
always @(negedge rdf or negedge reset or posedge upload0) begin : rxp
    if ((reset === 1'b0)) begin
        rx_s <= 2'b00;
        rx_b_p_error <= {txrd_buff + 1{1'b0}};
        rx_b_ow <= {txrd_buff + 1{1'b0}};
        rx_b_ows <= 1'b0;
        upload1 <= 1'b0;
    end else if ((upload0 === 1'b1)) begin
        upload1 <= 1'b0;
    end else if (1'b1) begin
        if ((rx_s == 0)) begin
            if ((rd === 1'b0)) begin
                rx_s <= 2'b01;
                r_half_f <= 1'b1;
                rx_peosm <= parityn[0];
            end
            rsend_rdlns <= 4'b0000;
        end else if ((rx_s == 2'b11)) begin
            rx_s <= (~({rd, rd}));
        end else begin
            r_half_f <= (~(r_half_f));
            if ((r_half_f === 1'b1)) begin
                if ((rsend_rdlns == rdln)) begin
                    upload1 <= 1'b1;
                    if ((rx_bbn > (txrd_buff + 1))) begin
                        rx_b_ow[rx_b_p1] <= 1'b1;
                    end else begin
                        rx_b_ow[rx_b_p1] <= 1'b0;
                    end
                    if ((parityn[2] === 1'b1)) begin
                        if ((rd !== rx_peosm)) begin
                            rx_b_p_error[rx_b_p1] <= 1'b1;
                        end
                        rx_s <= 2'b11;
                    end else begin
                        rx_s <= 2'b00;
                    end
                end else begin
                    rxd <= {rd, rxd[1 +: 7]};
                    rx_peosm <= (rx_peosm ^ rd);
                    rsend_rdlns <= (rsend_rdlns + 1);
                end
            end
        end
    end
end
`else
reg rxp__previous_clock;
initial rxp__previous_clock = 1'bx;
always @(rdf or reset) begin : rxp__vhdl_events
    if ((reset === 1'b0)) begin
        rx_s <= 2'b00;
        rx_b_p_error <= {txrd_buff + 1{1'b0}};
        rx_b_ow <= {txrd_buff + 1{1'b0}};
        rx_b_ows <= 1'b0;
        upload1 <= 1'b0;
    end else if ((upload0 === 1'b1)) begin
        upload1 <= 1'b0;
    end else if (((rxp__previous_clock === 1'b1) && (rdf === 1'b0))) begin
        if ((rx_s == 0)) begin
            if ((rd === 1'b0)) begin
                rx_s <= 2'b01;
                r_half_f <= 1'b1;
                rx_peosm <= parityn[0];
            end
            rsend_rdlns <= 4'b0000;
        end else if ((rx_s == 2'b11)) begin
            rx_s <= (~({rd, rd}));
        end else begin
            r_half_f <= (~(r_half_f));
            if ((r_half_f === 1'b1)) begin
                if ((rsend_rdlns == rdln)) begin
                    upload1 <= 1'b1;
                    if ((rx_bbn > (txrd_buff + 1))) begin
                        rx_b_ow[rx_b_p1] <= 1'b1;
                    end else begin
                        rx_b_ow[rx_b_p1] <= 1'b0;
                    end
                    if ((parityn[2] === 1'b1)) begin
                        if ((rd !== rx_peosm)) begin
                            rx_b_p_error[rx_b_p1] <= 1'b1;
                        end
                        rx_s <= 2'b11;
                    end else begin
                        rx_s <= 2'b00;
                    end
                end else begin
                    rxd <= {rd, rxd[1 +: 7]};
                    rx_peosm <= (rx_peosm ^ rd);
                    rsend_rdlns <= (rsend_rdlns + 1);
                end
            end
        end
    end
    rxp__previous_clock = rdf;
end
`endif

// rxbaudp
`ifdef SYNTHESIS
always @(posedge clk or posedge rx_idle) begin : rxbaudp
    if ((rx_s[0] === rx_s[1])) begin
        rxbaudp__f_div = 0;
        rx_f <= 1'b1;
        baudrate1234 <= 2'b00;
    end else if (1'b1) begin
        if ((rxbaudp__f_div == rx_baudrate)) begin
            rxbaudp__f_div = 0;
            rx_f <= (~(rx_f));
            baudrate1234 <= (baudrate1234 + 1);
        end else begin
            rxbaudp__f_div = (rxbaudp__f_div + 1);
        end
    end
end
`else
reg rxbaudp__previous_clock;
initial rxbaudp__previous_clock = 1'bx;
always @(clk or rx_s) begin : rxbaudp__vhdl_events
    if ((rx_s[0] === rx_s[1])) begin
        rxbaudp__f_div = 0;
        rx_f <= 1'b1;
        baudrate1234 <= 2'b00;
    end else if (((rxbaudp__previous_clock === 1'b0) && (clk === 1'b1))) begin
        if ((rxbaudp__f_div == rx_baudrate)) begin
            rxbaudp__f_div = 0;
            rx_f <= (~(rx_f));
            baudrate1234 <= (baudrate1234 + 1);
        end else begin
            rxbaudp__f_div = (rxbaudp__f_div + 1);
        end
    end
    rxbaudp__previous_clock = clk;
end
`endif

assign baudrateset = {f_set, baudrate1234};
assign rx_baudrate = ((baudrateset == 6'b000000)) ? 41667 : ((baudrateset == 6'b000001)) ? 41667 : ((baudrateset == 6'b000010)) ? 41667 : ((baudrateset == 6'b000011)) ? 41666 : ((baudrateset == 6'b000100)) ? 20833 : ((baudrateset == 6'b000101)) ? 20834 : ((baudrateset == 6'b000110)) ? 20833 : ((baudrateset == 6'b000111)) ? 20833 : ((baudrateset == 6'b001000)) ? 10416 : ((baudrateset == 6'b001001)) ? 10417 : ((baudrateset == 6'b001010)) ? 10417 : ((baudrateset == 6'b001011)) ? 10417 : ((baudrateset == 6'b001100)) ? 5208 : ((baudrateset == 6'b001101)) ? 5209 : ((baudrateset == 6'b001110)) ? 5208 : ((baudrateset == 6'b001111)) ? 5208 : ((baudrateset == 6'b010000)) ? 2604 : ((baudrateset == 6'b010001)) ? 2605 : ((baudrateset == 6'b010010)) ? 2604 : ((baudrateset == 6'b010011)) ? 2604 : ((baudrateset == 6'b010100)) ? 1302 : ((baudrateset == 6'b010101)) ? 1302 : ((baudrateset == 6'b010110)) ? 1302 : ((baudrateset == 6'b010111)) ? 1302 : ((baudrateset == 6'b011000)) ? 651 : ((baudrateset == 6'b011001)) ? 651 : ((baudrateset == 6'b011010)) ? 651 : ((baudrateset == 6'b011011)) ? 651 : ((baudrateset == 6'b011100)) ? 434 : ((baudrateset == 6'b011101)) ? 434 : ((baudrateset == 6'b011110)) ? 434 : ((baudrateset == 6'b011111)) ? 434 : ((baudrateset == 6'b100000)) ? 325 : ((baudrateset == 6'b100001)) ? 326 : ((baudrateset == 6'b100010)) ? 326 : ((baudrateset == 6'b100011)) ? 325 : ((baudrateset == 6'b100100)) ? 217 : ((baudrateset == 6'b100101)) ? 217 : ((baudrateset == 6'b100110)) ? 217 : ((baudrateset == 6'b100111)) ? 217 : ((baudrateset == 6'b101000)) ? 162 : ((baudrateset == 6'b101001)) ? 163 : ((baudrateset == 6'b101010)) ? 163 : ((baudrateset == 6'b101011)) ? 163 : ((baudrateset == 6'b101100)) ? 108 : ((baudrateset == 6'b101101)) ? 109 : ((baudrateset == 6'b101110)) ? 108 : ((baudrateset == 6'b101111)) ? 108 : ((baudrateset == 6'b110000)) ? 54 : ((baudrateset == 6'b110001)) ? 55 : ((baudrateset == 6'b110010)) ? 54 : ((baudrateset == 6'b110011)) ? 54 : ((baudrateset == 6'b110100)) ? 27 : ((baudrateset == 6'b110101)) ? 27 : ((baudrateset == 6'b110110)) ? 28 : ((baudrateset == 6'b110111)) ? 27 : ((baudrateset == 6'b111000)) ? 21 : ((baudrateset == 6'b111001)) ? 22 : ((baudrateset == 6'b111010)) ? 22 : ((baudrateset == 6'b111011)) ? 22 : ((baudrateset == 6'b111100)) ? 13 : ((baudrateset == 6'b111101)) ? 14 : ((baudrateset == 6'b111110)) ? 14 : ((baudrateset == 6'b111111)) ? 13 : 0;
assign rdln = ((dl == 2'b00)) ? 4'b0110 : ((dl == 2'b01)) ? 4'b0111 : ((dl == 2'b10)) ? 4'b1000 : ((dl == 2'b11)) ? 4'b1001 : 4'b0000;
assign rxdb = ((dl == 2'b00)) ? {3'b000, rxd[3 +: 5]} : ((dl == 2'b01)) ? {2'b00, rxd[2 +: 6]} : ((dl == 2'b10)) ? {1'b0, rxd[1 +: 7]} : ((dl == 2'b11)) ? rxd : 8'b11111111;
assign stopnn = ((stopn == 2'b10)) ? 3'b101 : ((stopn == 2'b11)) ? 3'b110 : 3'b111;
endmodule
`default_nettype wire
