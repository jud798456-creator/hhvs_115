// Verilog-2001 translation of st7735_spi_tft_lcd_4w_driver_3.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module st7735_spi_tft_lcd_4w_driver_3 (
    input wire st7735_clk,
    input wire st7735_reset,
    input wire st7735_res,
    input wire st7735_bls,
    input wire [1:0] dci,
    input wire [15:0] cmpai,
    input wire [3:0] cbi,
    input wire [7:0] fcri,
    input wire [7:0] fcgi,
    input wire [7:0] fcbi,
    input wire [7:0] bcri,
    input wire [7:0] bcgi,
    input wire [7:0] bcbi,
    input wire [4:0] d8_1i,
    input wire [3:0] shift_hdni,
    output wire st7735_resx,
    output reg st7735_cs,
    output wire st7735_dc,
    output reg st7735_scl,
    output wire st7735_sda,
    output wire st7735_bl,
    output wire st7735_reload,
    input wire st7735_loadck,
    output reg st7735_spi_ok
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

wire [23:0] cmpa_hcd;
reg [1:0] dci_bf;
reg [1:0] dc;
reg [15:0] cmpai_bf;
reg [15:0] cmpa;
reg [7:0] fcri_bf;
reg [7:0] fcr;
reg [7:0] fcgi_bf;
reg [7:0] fcg;
reg [7:0] fcbi_bf;
reg [7:0] fcb;
reg [7:0] bcri_bf;
reg [7:0] bcr;
reg [7:0] bcgi_bf;
reg [7:0] bcg;
reg [7:0] bcbi_bf;
reg [7:0] bcb;
reg [3:0] cbi_bf;
reg [3:0] cb;
reg [3:0] di;
reg [4:0] d8_1i_bf;
reg [4:0] d8_1;
reg [3:0] shift_hdn_bf;
reg [4:0] cmpa_hcdi;
wire [4:0] cmpa_hcdis;
reg buffer_clr;
reg buffer_empty;

initial di = 0;
initial d8_1i_bf = 0;
initial d8_1 = 0;
initial shift_hdn_bf = 0;
initial cmpa_hcdi = 0;

assign st7735_resx = st7735_res;
assign st7735_bl = st7735_bls;
assign cmpa_hcd = ((dc[1] === 1'b0)) ? {8'b00000000, cmpa} : (((cmpa[di] === 1'b1) && (cb == 4'b0001))) ? {{{12'b000000000000, fcr[0 +: 4]}, fcg[0 +: 4]}, fcb[0 +: 4]} : (((cmpa[di] === 1'b0) && (cb == 4'b0001))) ? {{{12'b000000000000, bcr[0 +: 4]}, bcg[0 +: 4]}, bcb[0 +: 4]} : (((cmpa[di] === 1'b1) && (cb == 4'b0010))) ? {{{8'b00000000, fcr[0 +: 5]}, fcg[0 +: 6]}, fcb[0 +: 5]} : (((cmpa[di] === 1'b0) && (cb == 4'b0010))) ? {{{8'b00000000, bcr[0 +: 5]}, bcg[0 +: 6]}, bcb[0 +: 5]} : (((cmpa[di] === 1'b1) && (cb == 4'b0011))) ? {{{{{fcr[0 +: 6], 2'b00}, fcg[0 +: 6]}, 2'b00}, fcb[0 +: 6]}, 2'b00} : (((cmpa[di] === 1'b0) && (cb == 4'b0011))) ? {{{{{bcr[0 +: 6], 2'b00}, bcg[0 +: 6]}, 2'b00}, bcb[0 +: 6]}, 2'b00} : (((cmpa[di] === 1'b1) && (cb == 4'b0000))) ? {{fcr, fcg}, fcb} : (((cmpa[di] === 1'b0) && (cb == 4'b0000))) ? {{bcr, bcg}, bcb} : ((cb == 4'b0101)) ? {{{12'b000000000000, fcr[0 +: 4]}, fcg[0 +: 4]}, fcb[0 +: 4]} : ((cb == 4'b0110)) ? {{{8'b00000000, fcr[0 +: 5]}, fcg[0 +: 6]}, fcb[0 +: 5]} : ((cb == 4'b0111)) ? {{{{{fcr[0 +: 6], 2'b00}, fcg[0 +: 6]}, 2'b00}, fcb[0 +: 6]}, 2'b00} : ((cb == 4'b1001)) ? {{{12'b000000000000, fcr[4 +: 4]}, fcg[4 +: 4]}, fcb[4 +: 4]} : ((cb == 4'b1010)) ? {{{8'b00000000, fcr[3 +: 5]}, fcg[2 +: 6]}, fcb[3 +: 5]} : ((cb == 4'b1011)) ? {{fcr, fcg}, fcb} : ((cb == 4'b1101)) ? {{fcr, fcg}, fcb} : ((cb == 4'b1110)) ? {{fcr, fcg}, fcb} : ((cb == 4'b1111)) ? {{fcr, fcg}, fcb} : 24'b000000000000000000000000;
assign cmpa_hcdis = ((cb[0 +: 2] == 2'b01)) ? 11 : ((cb[0 +: 2] == 2'b10)) ? 15 : ((cb[0 +: 2] == 2'b11)) ? 23 : 23;
assign st7735_reload = (buffer_empty | buffer_clr);
// data_in
`ifdef SYNTHESIS
always @(posedge st7735_loadck or negedge st7735_reset or posedge buffer_clr) begin : data_in
    if (((st7735_reset === 1'b0) || (buffer_clr === 1'b1))) begin
        buffer_empty <= 1'b0;
    end else if (1'b1) begin
        dci_bf <= dci;
        cmpai_bf <= cmpai;
        fcri_bf <= fcri;
        fcgi_bf <= fcgi;
        fcbi_bf <= fcbi;
        bcri_bf <= bcri;
        bcgi_bf <= bcgi;
        bcbi_bf <= bcbi;
        cbi_bf <= cbi;
        d8_1i_bf <= d8_1i;
        shift_hdn_bf <= shift_hdni;
        buffer_empty <= 1'b1;
    end
end
`else
reg data_in__previous_clock;
initial data_in__previous_clock = 1'bx;
always @(st7735_loadck or st7735_reset) begin : data_in__vhdl_events
    if (((st7735_reset === 1'b0) || (buffer_clr === 1'b1))) begin
        buffer_empty <= 1'b0;
    end else if (((data_in__previous_clock === 1'b0) && (st7735_loadck === 1'b1))) begin
        dci_bf <= dci;
        cmpai_bf <= cmpai;
        fcri_bf <= fcri;
        fcgi_bf <= fcgi;
        fcbi_bf <= fcbi;
        bcri_bf <= bcri;
        bcgi_bf <= bcgi;
        bcbi_bf <= bcbi;
        cbi_bf <= cbi;
        d8_1i_bf <= d8_1i;
        shift_hdn_bf <= shift_hdni;
        buffer_empty <= 1'b1;
    end
    data_in__previous_clock = st7735_loadck;
end
`endif

assign st7735_dc = dc[0];
assign st7735_sda = cmpa_hcd[cmpa_hcdi];
// Sequential logic
`ifdef SYNTHESIS
always @(posedge st7735_clk or negedge st7735_reset) begin : sequential_1
    if ((st7735_reset === 1'b0)) begin
        buffer_clr <= 1'b0;
        dc <= dci;
        cmpa <= cmpai;
        cmpa_hcdi <= 7;
        st7735_cs <= 1'b1;
        st7735_scl <= 1'b0;
        st7735_spi_ok <= 1'b0;
    end else if (1'b1) begin
        buffer_clr <= 1'b0;
        if ((st7735_spi_ok === 1'b1)) begin
            st7735_cs <= 1'b1;
        end else if ((st7735_cs === 1'b1)) begin
            st7735_cs <= 1'b0;
        end else if ((st7735_scl === 1'b0)) begin
            st7735_scl <= 1'b1;
        end else begin
            st7735_scl <= 1'b0;
            if ((cmpa_hcdi > 0)) begin
                cmpa_hcdi <= (cmpa_hcdi - 1);
            end else if ((((dc[1] === 1'b1) && (cb[2 +: 2] == 2'b00)) && (di > (16 - d8_1)))) begin
                di <= (di - 1);
                cmpa_hcdi <= cmpa_hcdis;
            end else if ((buffer_empty === 1'b1)) begin
                dc <= dci_bf;
                cmpa <= cmpai_bf;
                fcr <= fcri_bf;
                fcg <= fcgi_bf;
                fcb <= fcbi_bf;
                bcr <= bcri_bf;
                bcg <= bcgi_bf;
                bcb <= bcbi_bf;
                cb <= cbi_bf;
                d8_1 <= d8_1i_bf;
                di <= (15 - shift_hdn_bf);
                if ((dci_bf[1] === 1'b0)) begin
                    cmpa_hcdi <= 7;
                end else if ((cbi_bf[0 +: 2] == 2'b01)) begin
                    cmpa_hcdi <= 11;
                end else if ((cbi_bf[0 +: 2] == 2'b10)) begin
                    cmpa_hcdi <= 15;
                end else begin
                    cmpa_hcdi <= 23;
                end
                buffer_clr <= 1'b1;
            end else begin
                st7735_spi_ok <= 1'b1;
            end
        end
    end
end
`else
reg sequential_1__previous_clock;
initial sequential_1__previous_clock = 1'bx;
always @(st7735_clk or st7735_reset) begin : sequential_1__vhdl_events
    if ((st7735_reset === 1'b0)) begin
        buffer_clr <= 1'b0;
        dc <= dci;
        cmpa <= cmpai;
        cmpa_hcdi <= 7;
        st7735_cs <= 1'b1;
        st7735_scl <= 1'b0;
        st7735_spi_ok <= 1'b0;
    end else if (((sequential_1__previous_clock === 1'b0) && (st7735_clk === 1'b1))) begin
        buffer_clr <= 1'b0;
        if ((st7735_spi_ok === 1'b1)) begin
            st7735_cs <= 1'b1;
        end else if ((st7735_cs === 1'b1)) begin
            st7735_cs <= 1'b0;
        end else if ((st7735_scl === 1'b0)) begin
            st7735_scl <= 1'b1;
        end else begin
            st7735_scl <= 1'b0;
            if ((cmpa_hcdi > 0)) begin
                cmpa_hcdi <= (cmpa_hcdi - 1);
            end else if ((((dc[1] === 1'b1) && (cb[2 +: 2] == 2'b00)) && (di > (16 - d8_1)))) begin
                di <= (di - 1);
                cmpa_hcdi <= cmpa_hcdis;
            end else if ((buffer_empty === 1'b1)) begin
                dc <= dci_bf;
                cmpa <= cmpai_bf;
                fcr <= fcri_bf;
                fcg <= fcgi_bf;
                fcb <= fcbi_bf;
                bcr <= bcri_bf;
                bcg <= bcgi_bf;
                bcb <= bcbi_bf;
                cb <= cbi_bf;
                d8_1 <= d8_1i_bf;
                di <= (15 - shift_hdn_bf);
                if ((dci_bf[1] === 1'b0)) begin
                    cmpa_hcdi <= 7;
                end else if ((cbi_bf[0 +: 2] == 2'b01)) begin
                    cmpa_hcdi <= 11;
                end else if ((cbi_bf[0 +: 2] == 2'b10)) begin
                    cmpa_hcdi <= 15;
                end else begin
                    cmpa_hcdi <= 23;
                end
                buffer_clr <= 1'b1;
            end else begin
                st7735_spi_ok <= 1'b1;
            end
        end
    end
    sequential_1__previous_clock = st7735_clk;
end
`endif

endmodule
`default_nettype wire
