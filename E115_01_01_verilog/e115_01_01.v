// Verilog-2001 translation of e115_01_01.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module e115_01_01 #(
    parameter integer addr_length_n = 2751,
    parameter ram_init_file_fnset = "E115_01_01_w_2space原始編碼.mif",
    parameter integer txrd_buff_n = 511,
    parameter integer ov2640_image_ws = 128,
    parameter integer ov2640_image_hs = 160
) (
    input wire sclk,
    input wire s_reset,
    input wire [8:0] m7_0,
    output wire [1:0] ko,
    input wire [1:0] ki,
    output wire koo,
    output reg kxx,
    output reg joystickxx,
    output reg [4:0] kout,
    output reg [7:0] scano,
    output wire [7:0] d7led,
    output wire ws2812bout,
    output wire ads1115_scl,
    inout wire ads1115_sda,
    input wire ads1115_alert_rdy,
    output wire st7735_resx,
    output wire st7735_cs,
    output wire st7735_dc,
    output wire st7735_scl,
    output wire st7735_sda,
    output wire st7735_bl,
    input wire rd,
    output wire tx
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

localparam [1:0] dl = 2'b11;
localparam [2:0] parityn = 3'b000;
localparam [1:0] stopn = 2'b00;
localparam [3:0] f_set = 4'b1011;
reg s_reset_t;
reg tx_w;
wire [1:0] status_ts;
wire [7:0] txdata;
reg s_reset_r;
reg rx_r;
wire [2:0] status_rs;
wire [7:0] rxds;
localparam [1:0] dl2 = 2'b11;
localparam [2:0] parityn2 = 3'b000;
localparam [1:0] stopn2 = 2'b00;
localparam [3:0] f_set2 = 4'b1011;
wire tx_w2;
wire [1:0] status_ts2;
wire [7:0] txdata2;
wire s_reset_r2;
reg rx_r2;
wire [2:0] status_rs2;
wire [7:0] rxds2;
wire [clog2(txrd_buff_n + 2) - 1:0] rdatalength;
wire [clog2(txrd_buff_n + 2) - 1:0] rdatalength2;
wire [8*txrd_buff_n + 7:0] fpga_esp8266;
reg [8*txrd_buff_n + 7:0] esp8266_fpga;
wire [8*txrd_buff_n + 7:0] fpga_esp82662;
wire [8*txrd_buff_n + 7:0] esp8266_fpga2;
reg [8*txrd_buff_n + 7:0] esp8266_fpga_int;
reg [7:0] pre_item;
wire [7:0] instruction;
wire [7:0] instruction2;
reg [clog2(txrd_buff_n + 1) - 1:0] cmdn;
reg [clog2(txrd_buff_n + 1) - 1:0] cmdn_r;
reg [clog2(txrd_buff_n + 1) - 1:0] cmdns;
reg [clog2(txrd_buff_n + 1) - 1:0] cmdn_rs;
reg [9:0] esp8266resettime;
reg esp8266_power;
reg sys_uartfs;
wire st7735_clk;
reg st7735_reset;
wire st7735_res;
reg st7735_bls;
reg [1:0] dci;
wire [15:0] cmpai;
wire [3:0] cbi;
wire [7:0] fcri;
wire [7:0] fcgi;
wire [7:0] fcbi;
wire [7:0] bcri;
wire [7:0] bcgi;
wire [7:0] bcbi;
wire [4:0] d8_1i;
wire [3:0] shift_hdni;
wire st7735_reload;
reg st7735_loadck;
wire st7735_spi_ok;
wire [15:0] q;
wire kf;
wire kreset;
wire [4:0] kn;
wire [4:0] kv;
wire [7:0] kascii;
wire kok;
reg ws2812bclk;
reg ws2812breset;
reg ws2812b_loadck;
reg [23:0] ws2812b_ledgrbdata;
wire ws2812b_reload;
wire ws2812b_emitter_ok;
reg [3:0] fd2;
reg ws2812bp_reset;
reg ws2812bp_ok;
wire ws2812bpck;
reg [12:0] ws2812bp_time_dn;
reg [383:0] ws2812b_8basecolor;
reg [23:0] ws2812b_8crgb;
reg [23:0] ws2812b_8cgrb;
reg [3:0] ws2812b_b1_colori;
reg [3:0] ws2812b_b0_colori;
reg [3:0] ws2812b_dir;
reg [5:0] ws2812b_xyshift;
reg ws2812b_flash_enable;
reg ws2812b_flashnes;
reg [3:0] ws2812b_flashns;
reg [63:0] ws2812b_flash_add;
reg [3:0] ws2812b_flash_adds;
reg [23:0] ws2812b_colors1;
reg [23:0] ws2812b_colord1;
reg [23:0] ws2812b_colors2;
reg [23:0] ws2812b_colord2;
reg [2:0] ws2812b_flash_speed;
reg ws2812b_mask_enable;
reg [63:0] ws2812b_mask_add;
reg [1:0] ws2812b_mask_adds;
reg [3:0] ws2812b_mask_ms;
reg [3:0] ws2812b_maskcolors1or2;
reg [23:0] ws2812b_maskcolors1;
reg [23:0] ws2812b_maskcolors2;
reg [7:0] ws2812b_mask_r;
reg [7:0] ws2812b_mask_g;
reg [7:0] ws2812b_mask_b;
reg [5:0] ws2812b_xy;
reg ws2812b_reset0;
reg [3:0] ws2812bp_ms;
reg [3:0] ws2812b_colorsc1;
reg [127:0] ws2812b_64;
reg ws2812b_64p;
reg [127:0] ws2812b_8x8;
reg ws2812b_8x8p;
reg [127:0] ws2812b_16x4;
reg ws2812b_16x4p;
reg [383:0] ws2812b_rgb3bitx64;
reg ws2812b_rgb3bitx64p;
reg [575:0] ws2812b_rgb3bitnx64;
reg [1:0] ws2812b_rgb3bitnx64p;
reg [383:0] ws2812b_rgb3bittnx64;
reg ws2812b_rgb3bittnx64p;
reg [383:0] ws2812b_grb3bitx64;
reg ws2812b_grb3bitx64p;
reg [575:0] ws2812b_grb3bitnx64;
reg [1:0] ws2812b_grb3bitnx64p;
reg [4095:0] ws2812b_8r8g_8b16bit;
reg ws2812b_8r8g_8b16bitp;
reg [3071:0] ws2812b_8g8r8b24bit;
reg ws2812b_8g8r8b24bitp;
reg [3071:0] ws2812b_8r8g8b24bit;
reg ws2812b_8r8g8b24bitp;
wire ads1115_reset;
reg [7:0] ads1115_input_mux;
reg [23:0] ads1115_input_fsr_pga;
reg [23:0] ads1115_input_dr;
wire ads1115_loadck;
wire ads1115upload;
wire [15:0] ads1115_adc_16bit;
wire ads1115_ok;
reg [255:0] ads1115_adcs;
reg [319:0] ads1115_adcn;
reg [15:0] ads1115_adc_signed;
reg [3:0] ads1115_adcp;
reg [3:0] ads1115_bin;
reg joystick_reset;
wire joystick_ok;
wire [5:0] joystick_keys;
wire [5:0] joystick_keystest;
wire [7:0] joystick_so;
reg [47:0] d7_db;
reg [7:0] d7dot;
reg [7:0] flashs;
reg [7:0] flash_a_g;
wire [6:0] flash_a_gs;
reg [2:0] scanp;
localparam [272:0] disp7 = {7'b1000000, 7'b1111001, 7'b0100100, 7'b0110000, 7'b0011001, 7'b0010010, 7'b0000010, 7'b1111000, 7'b0000000, 7'b0010000, 7'b1111111, 7'b0001000, 7'b0000011, 7'b1000110, 7'b0100001, 7'b0000110, 7'b0001110, 7'b1000010, 7'b0001001, 7'b1001111, 7'b1110001, 7'b0001010, 7'b1000111, 7'b0101010, 7'b0101011, 7'b0100011, 7'b0001100, 7'b0011000, 7'b0101111, 7'b0010010, 7'b0000111, 7'b1000001, 7'b1110011, 7'b1010101, 7'b0110110, 7'b0010001, 7'b0100100, 7'b1111101, 7'b1111001};
wire [223:0] st7735_it;
localparam [223:0] st7735_it__initial = {8'h11, 8'h29, 8'hB4, 8'h03, 8'h36, 8'hC0, 8'h38, 8'h20, 8'h13, 8'h30, 8'h00, 8'h00, 8'h00, 8'hA1, 8'h3A, 8'h06, 8'h2A, 8'h00, 8'h00, 8'h00, 8'h83, 8'h2B, 8'h00, 8'h00, 8'h00, 8'hA1, 8'h2C, 8'h28};
reg [383:0] st7735_8basecolor;
reg [3:0] b1_colori;
reg [3:0] b0_colori;
reg [3:0] monoc;
reg [4:0] st7735_data_c_inc;
reg [4:0] st7735_com_pn;
wire [4:0] st7735_com_pn0;
reg [6:0] st7735_com_pointer;
reg [6:0] st7735_com_pointers;
wire st7735_p_clk;
reg st7735_p_reset;
reg st7735_p_ok;
reg st7735_reset0;
wire [15:0] gdata;
reg [15:0] gdata0;
wire [15:0] gdata1;
wire [15:0] gdata2;
wire [15:0] gdata3;
wire [15:0] gdata4;
wire [15:0] gdata5;
wire [15:0] gdata6;
wire [15:0] gdata7;
wire [15:0] gdata8;
wire [15:0] gdata9;
wire [15:0] gdata10;
wire [15:0] gdata11;
wire [15:0] gdata12;
wire [15:0] gdata13;
wire [15:0] gdata14;
wire [15:0] gdata15;
wire [23:0] fc2;
reg [23:0] bc2;
reg [3:0] cbis;
reg [3:0] st7735_ch;
reg [7:0] st7735_colmod;
reg [7:0] st7735_invctr;
reg [7:0] st7735_madctl;
reg [7:0] st7735_idmoff_on;
reg [7:0] st7735_invoff_on;
reg [7:0] st7735_noron_ptlon;
reg [7:0] st7735_dispon_off;
reg [7:0] st7735_psl;
reg [7:0] st7735_pel;
reg [7:0] st7735_data_cpointer;
reg [7:0] st7735_data_rpointer;
reg [7:0] st7735_data_cpointer_begin;
reg [7:0] st7735_data_cpointer_end;
reg [7:0] st7735_x;
reg [7:0] st7735_xincn;
reg [7:0] st7735_data_rpointer_begin;
reg [7:0] st7735_data_rpointer_end;
reg [7:0] st7735_y;
reg [15:0] st7735_xinc1;
reg [15:0] st7735_xinc1_c;
reg [15:0] st7735_xinc1_m;
reg [26:0] st7735_time_dn;
reg isword;
reg [7:0] word_w;
wire [7:0] w_w_b;
reg [6:0] shift_x;
reg [7:0] shift_y;
wire [3:0] st7735_x0;
reg [3:0] d0_setn;
reg remove_leading_0;
reg [63:0] st7735_data;
wire [63:0] st7735_data_tsl2561;
wire [63:0] st7735_data_dht11_t;
wire [63:0] st7735_data_dht11_h;
wire [15:0] st7735_vl1;
wire [15:0] st7735_vl2;
wire [7:0] st7735_xx1;
wire [7:0] st7735_xx2;
wire [7:0] st7735_yy1;
wire [7:0] st7735_yy2;
wire [15:0] gdata565;
wire is_ov2640;
reg [27:0] fd;
wire sw_clk;
wire e115_1_1_mainclk;
wire oled_p_clk;
wire oled_p_reset;
wire [11:0] times;
reg [9:0] times1;
reg [9:0] times2;
reg [9:0] times3;
reg [9:0] times4;
reg [9:0] times5;
wire [9:0] sound_times;
reg s0on;
reg [26:0] m70s;
wire [7:0] m701;
wire [7:0] m702;
wire [7:0] m701s;
wire [7:0] m710s;
wire [7:0] m702x;
wire [7:0] m702xx;
wire [3:0] m;
wire [1:0] mmx;
reg [1:0] mm;
wire [7:0] m7_76543210;
wire [7:0] m7s;
reg [2:0] mms;
reg [3:0] mx;
reg [3:0] fp;
wire [3:0] f6;
wire [3:0] fx;
wire [3:0] fpx;
reg [479:0] f012345;
reg [clog2(addr_length_n + 1) - 1:0] befriendc_p;
wire [clog2(addr_length_n + 1) - 1:0] befriendc_pp;
wire [3:0] f012345_6_7;
wire [3:0] f012345_6_5;
wire [3:0] m7_76543210_7downto5;
wire [3:0] m7_76543210_4downto2;
reg [2:0] ws2812bp_c_r;
reg [2:0] ws2812bp_c_g;
reg [2:0] ws2812bp_c_b;
reg [4:0] e115_1_1_main__k;
reg [4:0] e115_1_1_main__k2;
reg e115_1_1_main__k00sw;
reg process_1__asd1115load;
reg [3:0] process_1__ads1115loadp;
reg [1:0] ws2812bp__swok;
reg [23:0] ws2812bp__ws2812b_ledgrbdatas;
reg [15:0] ws2812bp__mx16_1;
reg [15:0] ws2812bp__mx16_2;
reg [6:0] ws2812bp__ws2812b_n;
reg [5:0] ws2812bp__ws2812b_n1;
reg [2:0] ws2812bp__ws2812b_n3;
reg ws2812bp__ws2812b_grb_ok;
reg ws2812bp__fd20_27;
reg ws2812bp__ws2812b_flashs;
reg ws2812bp__ws2812b_flashnes1;
reg [3:0] ws2812bp__ws2812b_flashn;
reg [3:0] ws2812bp__rgbn;
reg [15:0] ws2812bp__td;
reg [12:0] ws2812bp__tds;
localparam [287:0] ws2812bp__ws2812b_dirxy = {{6'd0, 6'd1, 6'd1}, {6'd56, 6'd56, 6'd57}, {6'd63, 6'd63, 6'd63}, {6'd7, 6'd8, 6'd7}, {6'd7, 6'd63, 6'd15}, {6'd63, 6'd56, 6'd55}, {6'd56, 6'd1, 6'd49}, {6'd0, 6'd8, 6'd9}, {6'd56, 6'd1, 6'd49}, {6'd0, 6'd8, 6'd9}, {6'd7, 6'd63, 6'd15}, {6'd63, 6'd56, 6'd55}, {6'd63, 6'd63, 6'd63}, {6'd7, 6'd8, 6'd7}, {6'd0, 6'd1, 6'd1}, {6'd56, 6'd56, 6'd57}};
reg [3:0] ws2812bp__ws2812b_flash_adds2;
reg ws2812bp__ws2812b_mask_adds2;
reg [3:0] ws2812bp__ws2812b_mask_ms2;
reg st7735_p__sw;
reg st7735_p__swok;
reg [26:0] st7735_p__td;

function [7:0] to_vec_8;
    input [31:0] value;
    begin
        to_vec_8 = value;
    end
endfunction

function [16:0] to_vec_17;
    input [31:0] value;
    begin
        to_vec_17 = value;
    end
endfunction

initial esp8266_fpga_int = 0;
initial cmdn = 0;
initial cmdn_r = 0;
initial cmdns = 0;
initial cmdn_rs = 0;
initial esp8266resettime = 0;
initial esp8266_power = 1'b0;
initial sys_uartfs = 1'b0;
initial ws2812bp_time_dn = 0;
initial ws2812b_8basecolor = {{8'h00, 8'h00, 8'h00}, {8'hFF, 8'h00, 8'h00}, {8'h00, 8'hFF, 8'h00}, {8'h00, 8'h00, 8'hFF}, {8'hFF, 8'hFF, 8'h00}, {8'hFF, 8'h00, 8'hFF}, {8'h00, 8'hFF, 8'hFF}, {8'hFF, 8'hFF, 8'hFF}, {8'h9E, 8'hAA, 8'h29}, {8'hD2, 8'hCC, 8'h63}, {8'hBD, 8'hFD, 8'hC4}, {8'h00, 8'h00, 8'h00}, {8'h00, 8'h00, 8'h00}, {8'h00, 8'h00, 8'h00}, {8'h00, 8'h00, 8'h00}, {8'h00, 8'h00, 8'hFF}};
initial ws2812b_8crgb = {3'd0, 3'd3, 3'd2, 3'd6, 3'd1, 3'd5, 3'd4, 3'd7};
initial ws2812b_8cgrb = {3'd0, 3'd3, 3'd1, 3'd5, 3'd2, 3'd6, 3'd4, 3'd7};
initial ws2812b_b1_colori = 1;
initial ws2812b_b0_colori = 2;
initial ws2812b_dir = 0;
initial ws2812b_xyshift = 0;
initial ws2812b_flashns = 0;
initial ws2812b_flash_adds = 0;
initial ws2812b_flash_speed = 0;
initial ws2812b_mask_adds = 0;
initial ws2812b_mask_ms = 0;
initial ws2812b_maskcolors1or2 = 0;
initial ws2812b_xy = 0;
initial ws2812bp_ms = 0;
initial ws2812b_colorsc1 = 0;
initial ws2812b_64 = {64'b0000000000000000000010000000100000001000000010000000100011111111, 64'b0000000000001000000010000000100001111110000010000000100000000000};
initial ws2812b_64p = 0;
initial ws2812b_8x8 = {{8'h00, 8'h08, 8'h08, 8'h08, 8'h7E, 8'h08, 8'h08, 8'h00}, {8'h00, 8'h08, 8'h08, 8'h08, 8'h7E, 8'h08, 8'h08, 8'hFF}};
initial ws2812b_8x8p = 0;
initial ws2812b_16x4 = {{16'h0008, 16'h0808, 16'h7E08, 16'h08FF}, {16'h0008, 16'hFE08, 16'h7E08, 16'h08FF}};
initial ws2812b_16x4p = 0;
initial ws2812b_rgb3bitx64 = {{3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100}, {3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111}};
initial ws2812b_rgb3bitx64p = 0;
initial ws2812b_rgb3bitnx64 = {{3'd1, 3'd2, 3'd4, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0}, {3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd4, 3'd4, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd4, 3'd4, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0}, {64{3'd0}}};
initial ws2812b_rgb3bitnx64p = 0;
initial ws2812b_rgb3bittnx64 = {{3'd5, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd2, 3'd2, 3'd3}, {3'd1, 3'd2, 3'd3, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd7, 3'd6, 3'd5, 3'd4, 3'd3, 3'd2, 3'd1, 3'd0}};
initial ws2812b_rgb3bittnx64p = 0;
initial ws2812b_grb3bitx64 = {{3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100}, {3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b011, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b101, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b110, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b010, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b100, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111, 3'b111}};
initial ws2812b_grb3bitx64p = 0;
initial ws2812b_grb3bitnx64 = {{3'd1, 3'd2, 3'd4, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0}, {3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd4, 3'd4, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd4, 3'd4, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0}, {64{3'd0}}};
initial ws2812b_grb3bitnx64p = 0;
initial ws2812b_8r8g_8b16bit = {{16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000}, {16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'h00FF, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFF00, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF, 16'h0000, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'h00FF, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFF00, 16'h0000, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00, 16'hFFFF, 16'hFF00}};
initial ws2812b_8r8g_8b16bitp = 0;
initial ws2812b_8g8r8b24bit = {{24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'hFFFF00, 24'hFF00FF, 24'h000000, 24'h00FFFF, 24'h00FFFF, 24'h000000, 24'hFF00FF, 24'h00FF00, 24'hFFFF00, 24'h000000, 24'hFF00FF, 24'h00FFFF, 24'h00FFFF, 24'hFF00FF, 24'h000000, 24'h00FF00, 24'hFFFF00, 24'hFFFFFF, 24'hFFFFFF, 24'h0000FF, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'h00FF00, 24'hFFFF00, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'hFF0000, 24'hFFFFFF, 24'hFFFFFF, 24'h00FF00, 24'hFFFF00, 24'h000000, 24'hFF00FF, 24'h00FFFF, 24'h00FFFF, 24'hFF00FF, 24'h000000, 24'h00FF00, 24'hFFFF00, 24'hFF00FF, 24'h000000, 24'h00FFFF, 24'h00FFFF, 24'h000000, 24'hFF00FF, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00}, {24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'hFFFF00, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'h00FF00, 24'hFFFF00, 24'hFF0000, 24'hFF00FF, 24'h00FFFF, 24'h00FFFF, 24'hFF00FF, 24'hFF0000, 24'h00FF00, 24'h0000FF, 24'hFF0000, 24'hFFFFFF, 24'h0000FF, 24'h00FF00, 24'hFFFFFF, 24'hFF0000, 24'h00FF00, 24'h0000FF, 24'hFF0000, 24'hFFFFFF, 24'h00FF00, 24'hFF0000, 24'hFFFFFF, 24'hFF0000, 24'h00FF00, 24'hFFFF00, 24'hFF0000, 24'hFF00FF, 24'h00FFFF, 24'h00FFFF, 24'hFF00FF, 24'hFF0000, 24'h00FF00, 24'hFFFF00, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00}};
initial ws2812b_8g8r8b24bitp = 0;
initial ws2812b_8r8g8b24bit = {{24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'hFFFF00, 24'hFF00FF, 24'h000000, 24'h00FFFF, 24'h00FFFF, 24'h000000, 24'hFF00FF, 24'h00FF00, 24'hFFFF00, 24'h000000, 24'hFF00FF, 24'h00FFFF, 24'h00FFFF, 24'hFF00FF, 24'h000000, 24'h00FF00, 24'hFFFF00, 24'hFFFFFF, 24'hFFFFFF, 24'h0000FF, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'h00FF00, 24'hFFFF00, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'hFF0000, 24'hFFFFFF, 24'hFFFFFF, 24'h00FF00, 24'hFFFF00, 24'h000000, 24'hFF00FF, 24'h00FFFF, 24'h00FFFF, 24'hFF00FF, 24'h000000, 24'h00FF00, 24'hFFFF00, 24'hFF00FF, 24'h000000, 24'h00FFFF, 24'h00FFFF, 24'h000000, 24'hFF00FF, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00}, {24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'hFFFF00, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'h00FF00, 24'hFFFF00, 24'hFF0000, 24'hFF00FF, 24'h00FFFF, 24'h00FFFF, 24'hFF00FF, 24'hFF0000, 24'h00FF00, 24'h0000FF, 24'hFF0000, 24'hFFFFFF, 24'h0000FF, 24'h00FF00, 24'hFFFFFF, 24'hFF0000, 24'h00FF00, 24'h0000FF, 24'hFF0000, 24'hFFFFFF, 24'h00FF00, 24'hFF0000, 24'hFFFFFF, 24'hFF0000, 24'h00FF00, 24'hFFFF00, 24'hFF0000, 24'hFF00FF, 24'h00FFFF, 24'h00FFFF, 24'hFF00FF, 24'hFF0000, 24'h00FF00, 24'hFFFF00, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'hFF0000, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00, 24'h00FF00}};
initial ws2812b_8r8g8b24bitp = 0;
initial ads1115_input_mux = 8'b00110000;
initial ads1115_input_fsr_pga = 24'b011011001001011011011011;
initial ads1115_input_dr = 24'b111111111111111111111111;
initial ads1115_adcs = {16{16'h0000}};
initial ads1115_adcn = {16{20'd0}};
initial ads1115_adc_signed = {16{1'd0}};
initial ads1115_adcp = 0;
initial ads1115_bin = 15;
initial joystick_reset = 1'b0;
initial d7_db = 0;
initial scanp = 0;
initial st7735_8basecolor = {{8'h00, 8'h00, 8'h00}, {8'hFF, 8'h00, 8'h00}, {8'h00, 8'hFF, 8'h00}, {8'h00, 8'h00, 8'hFF}, {8'hFF, 8'hFF, 8'h00}, {8'hFF, 8'h00, 8'hFF}, {8'h00, 8'hFF, 8'hFF}, {8'hFF, 8'hFF, 8'hFF}, {8'h9E, 8'hAA, 8'h29}, {8'hD2, 8'hCC, 8'h63}, {8'hBD, 8'hFD, 8'hC4}, {8'h00, 8'h00, 8'h00}, {8'h00, 8'h00, 8'h00}, {8'h00, 8'h00, 8'h00}, {8'h00, 8'h00, 8'h00}, {8'h00, 8'h00, 8'hFF}};
initial b1_colori = 0;
initial b0_colori = 0;
initial monoc = 0;
initial st7735_data_c_inc = 0;
initial st7735_com_pn = 0;
initial st7735_com_pointer = 0;
initial st7735_com_pointers = 0;
initial bc2 = {8'h00, 8'h00, 8'h00};
initial st7735_psl = 0;
initial st7735_pel = 0;
initial st7735_data_cpointer = 0;
initial st7735_data_rpointer = 0;
initial st7735_data_cpointer_begin = 0;
initial st7735_data_cpointer_end = 0;
initial st7735_x = 0;
initial st7735_xincn = 0;
initial st7735_data_rpointer_begin = 0;
initial st7735_data_rpointer_end = 0;
initial st7735_y = 0;
initial st7735_xinc1 = 0;
initial st7735_xinc1_c = 0;
initial st7735_xinc1_m = 0;
initial st7735_time_dn = 0;
initial isword = 1'b0;
initial word_w = 0;
initial shift_x = 0;
initial shift_y = 0;
initial d0_setn = 0;
initial st7735_data = 0;
initial times1 = 0;
initial times2 = 0;
initial times3 = 0;
initial times4 = 0;
initial times5 = 0;
initial mms = 0;
initial fp = 0;
initial f012345 = {{6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd19, 6'd24, 6'd16, 6'd10, 6'd10, 6'd10, 6'd0, 6'd0}, {6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10}};
initial befriendc_p = 0;
initial e115_1_1_main__k = 0;
initial e115_1_1_main__k2 = 0;
initial e115_1_1_main__k00sw = 0;
initial process_1__asd1115load = 1'b0;
initial process_1__ads1115loadp = 0;
initial ws2812bp__swok = 0;
initial ws2812bp__ws2812b_n = 0;
initial ws2812bp__ws2812b_n1 = 0;
initial ws2812bp__ws2812b_n3 = 0;
initial ws2812bp__ws2812b_flashn = 0;
initial ws2812bp__rgbn = 0;
initial ws2812bp__td = 0;
initial ws2812bp__tds = 0;
initial ws2812bp__ws2812b_flash_adds2 = 0;
initial ws2812bp__ws2812b_mask_adds2 = 0;
initial ws2812bp__ws2812b_mask_ms2 = 0;
initial st7735_p__sw = 0;
initial st7735_p__td = 0;
initial kout = 0;

rs232_t4 #(
    .txrd_buff(txrd_buff_n)
) uarttx (
    .clk(sclk),
    .reset(s_reset_t),
    .dl(dl),
    .parityn(parityn),
    .stopn(stopn),
    .f_set(f_set),
    .status_s(status_ts),
    .tx_w(tx_w),
    .txdata(txdata),
    .tx(tx)
);

rs232_r4 #(
    .txrd_buff(txrd_buff_n)
) uartrx (
    .clk(sclk),
    .reset(s_reset_r),
    .dl(dl),
    .parityn(parityn),
    .stopn(stopn),
    .f_set(f_set),
    .status_s(status_rs),
    .rx_bbn(rdatalength),
    .rx_r(rx_r),
    .rd(rd),
    .rxds(rxds)
);

k4x4 u3 (
    .kf(fd[17]),
    .reset(s_reset),
    .ki(ki),
    .ko(ko),
    .kn(kn),
    .kv(kv),
    .kascii(kascii),
    .kok(kok),
    .koo(koo)
);

joystick_driver joystick1 (
    .joystick_clk(fd[17]),
    .joystick_reset(joystick_reset),
    .ads1115_reset(ads1115_reset),
    .ads1115_ok(ads1115_ok),
    .vx(to_vec_17(ads1115_adcn[220 +: 20])),
    .vy(to_vec_17(ads1115_adcn[200 +: 20])),
    .sw(m70s[2]),
    .joystick_keys(joystick_keys),
    .joystick_ok(joystick_ok)
);

ws2812b_driver ws2812bn (
    .ws2812bclk(ws2812bclk),
    .ws2812breset(ws2812breset),
    .ws2812b_loadck(ws2812b_loadck),
    .ws2812b_ledgrbdata(ws2812b_ledgrbdata),
    .ws2812b_reload(ws2812b_reload),
    .ws2812b_emitter_ok(ws2812b_emitter_ok),
    .ws2812bout(ws2812bout)
);

ads1115_16bit_i2c_driver ads1115 (
    .i2cclk(fd[4]),
    .reset(ads1115_reset),
    .s_reset(s_reset),
    .ads1115_addr(2'b00),
    .ads1115_alert_rdy(ads1115_alert_rdy),
    .scl(ads1115_scl),
    .sda(ads1115_sda),
    .ads1115_input_mux(ads1115_input_mux),
    .ads1115_input_fsr_pga(ads1115_input_fsr_pga),
    .ads1115_input_dr(ads1115_input_dr),
    .ads1115_uploadck(sclk),
    .ads1115_loadck(ads1115_loadck),
    .ads1115upload(ads1115upload),
    .ads1115_adc_16bit(ads1115_adc_16bit),
    .ads1115_ok(ads1115_ok)
);

e111_01_01_rom #(
    .addr_length(addr_length_n),
    .ram_init_file_set(ram_init_file_fnset)
) rom (
    .addr(befriendc_pp),
    .clk(sclk),
    .q(q),
    .qq()
);

st7735_spi_tft_lcd_4w_driver_3 st7735_spi_tft_lcd (
    .st7735_clk(st7735_clk),
    .st7735_reset(st7735_reset),
    .st7735_res(st7735_res),
    .st7735_bls(st7735_bls),
    .dci(dci),
    .cmpai(cmpai),
    .cbi(cbi),
    .fcri(fcri),
    .fcgi(fcgi),
    .fcbi(fcbi),
    .bcri(bcri),
    .bcgi(bcgi),
    .bcbi(bcbi),
    .d8_1i(d8_1i),
    .shift_hdni(shift_hdni),
    .st7735_resx(st7735_resx),
    .st7735_cs(st7735_cs),
    .st7735_dc(st7735_dc),
    .st7735_scl(st7735_scl),
    .st7735_sda(st7735_sda),
    .st7735_bl(st7735_bl),
    .st7735_reload(st7735_reload),
    .st7735_loadck(st7735_loadck),
    .st7735_spi_ok(st7735_spi_ok)
);

assign st7735_res = s_reset;
assign st7735_it[192 +: 8] = st7735_invctr;
assign st7735_it[176 +: 8] = st7735_madctl;
assign st7735_it[168 +: 8] = st7735_idmoff_on;
assign st7735_it[160 +: 8] = st7735_invoff_on;
assign st7735_it[152 +: 8] = st7735_noron_ptlon;
assign st7735_it[128 +: 8] = to_vec_8(st7735_psl);
assign st7735_it[112 +: 8] = to_vec_8(st7735_pel);
assign st7735_it[96 +: 8] = st7735_colmod;
assign st7735_it[72 +: 8] = to_vec_8(((st7735_data_cpointer_begin % 128) + 2));
assign st7735_it[56 +: 8] = to_vec_8(((st7735_data_cpointer_end % 128) + 2));
assign st7735_it[32 +: 8] = to_vec_8(((st7735_data_rpointer_begin % 160) + 1));
assign st7735_it[16 +: 8] = to_vec_8(((st7735_data_rpointer_end % 160) + 1));
assign st7735_it[0 +: 8] = st7735_dispon_off;
assign txdata = fpga_esp8266[8*cmdn - 8*cmdns + 8*txrd_buff_n +: 8];
assign mmx = {m702[1], m702[0]};
assign e115_1_1_mainclk = ((sys_uartfs === 1'b0)) ? fd[17] : sclk;
// e115_1_1_main
`ifdef SYNTHESIS
always @(posedge e115_1_1_mainclk) begin : e115_1_1_main
    if ((s_reset === 1'b0)) begin
        mm <= (~(mmx));
        d7_db <= {6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10};
        flash_a_g <= 8'b00000000;
        flashs <= 8'b00000000;
        d7dot <= 8'b00000000;
        ws2812bp_reset <= 1'b0;
        ws2812bp_ms <= 0;
        ws2812b_colorsc1 <= 0;
        ws2812b_b1_colori <= 1;
        ws2812b_b0_colori <= 2;
        ws2812b_dir <= 0;
        ws2812bp_time_dn <= 1;
        ws2812b_xyshift <= 0;
        ws2812b_flash_enable <= 1'b0;
        ws2812b_flashns <= 4;
        ws2812b_flashnes <= 1'b1;
        ws2812b_flash_add <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
        ws2812b_flash_adds <= 0;
        ws2812b_colors1 <= 24'h00FF00;
        ws2812b_colord1 <= 24'hFFFF00;
        ws2812b_colors2 <= 24'hFF0000;
        ws2812b_colord2 <= 24'hFF00FF;
        ws2812b_flash_speed <= 5;
        ws2812b_reset0 <= 1'b0;
        ws2812bp_c_r <= 3'b111;
        ws2812bp_c_g <= 3'b111;
        ws2812bp_c_b <= 3'b111;
        ws2812b_mask_enable <= 1'b0;
        ws2812b_mask_add <= {64{1'b0}};
        ws2812b_mask_adds <= 1;
        ws2812b_mask_ms <= 2;
        ws2812b_maskcolors1or2 <= 0;
        ws2812b_maskcolors1 <= 24'hFF00FF;
        ws2812b_maskcolors2 <= 24'hFF00FF;
        ws2812b_mask_r <= 8'hFF;
        ws2812b_mask_g <= 8'hFF;
        ws2812b_mask_b <= 8'hFF;
        ads1115_adcp <= 0;
        joystick_reset <= 1'b0;
        e115_1_1_main__k = 16;
        s0on <= 1'b0;
        mms <= 5;
        mx <= {4{1'b0}};
        st7735_reset0 <= 1'b0;
        d0_setn <= 7;
        s_reset_t <= 1'b0;
        s_reset_r <= 1'b0;
        rx_r <= 1'b0;
        tx_w <= 1'b0;
        cmdn_r <= 0;
        cmdn_rs <= 0;
        cmdn <= 0;
        cmdns <= 0;
        kxx <= 1'b0;
        joystickxx <= 1'b0;
        esp8266resettime <= 400;
        esp8266_power <= 1'b0;
        sys_uartfs <= 1'b0;
        fp <= 9;
    end else if (((rx_r === 1'b1) && (status_rs[2] === 1'b0))) begin
        rx_r <= 1'b0;
    end else if (((rx_r2 === 1'b1) && (status_rs2[2] === 1'b0))) begin
        rx_r2 <= 1'b0;
    end else if (1'b1) begin
        joystick_reset <= 1'b1;
        if ((esp8266resettime == 0)) begin
            s_reset_t <= 1'b1;
            s_reset_r <= 1'b1;
        end else begin
            esp8266resettime <= (esp8266resettime - 1);
            if ((esp8266resettime == 500)) begin
                esp8266_power <= 1'b1;
            end
        end
        if ((((s_reset_t === 1'b1) && (cmdn > 0)) || (((s_reset_r === 1'b1) && (status_rs[2] === 1'b1)) && (cmdn_r > 0)))) begin
            sys_uartfs <= 1'b1;
            if ((((s_reset_t === 1'b1) && (cmdn > 0)) && (tx_w === 1'b0))) begin
                if ((status_ts[1] === 1'b0)) begin
                    tx_w <= 1'b1;
                end
            end else if (((tx_w === 1'b1) && (status_ts[1] === 1'b1))) begin
                tx_w <= 1'b0;
                cmdn <= (cmdn - 1);
            end
            if (((((s_reset_r === 1'b1) && (status_rs[2] === 1'b1)) && (rx_r === 1'b0)) && (cmdn_r > 0))) begin
                rx_r <= 1'b1;
                if ((cmdn_rs == 511)) begin
                    cmdn_r <= {{(32-(8)){1'b0}}, rxds};
                    cmdn_rs <= {{(32-(8)){1'b0}}, rxds};
                end else begin
                    cmdn_r <= (cmdn_r - 1);
                    esp8266_fpga[8*cmdn_r - 8*cmdn_rs + 8*txrd_buff_n +: 8] <= rxds;
                    esp8266_fpga_int[8*cmdn_r - 8*cmdn_rs + 8*txrd_buff_n +: 8] <= {{(32-(8)){1'b0}}, rxds};
                    if (((cmdn_rs == 510) && (rxds == 8'hFF))) begin
                        cmdn_r <= 0;
                        cmdn_rs <= (cmdn_rs - cmdn_r);
                    end
                    pre_item <= rxds;
                    if (((cmdn_rs == 509) && (cmdn_rs != cmdn_r))) begin
                        if (((pre_item == 8'hFE) && (rxds == 8'hFF))) begin
                            cmdn_r <= 0;
                            cmdn_rs <= ((cmdn_rs - cmdn_r) - 1);
                        end
                    end
                end
            end
        end else begin
            sys_uartfs <= 1'b0;
            e115_1_1_main__k = 16;
            if ((kok === 1'b1)) begin
                e115_1_1_main__k = kv;
                e115_1_1_main__k2 = kv;
            end else if (((cmdn_r == 0) && (s_reset_r === 1'b1))) begin
                e115_1_1_main__k = (esp8266_fpga_int[8*txrd_buff_n +: 8] + 5);
                e115_1_1_main__k2 = esp8266_fpga_int[8*txrd_buff_n +: 8];
                if ((rdatalength != 0)) begin
                    s_reset_r <= 1'b0;
                    e115_1_1_main__k = 16;
                end
                kxx <= (~(kxx));
            end else if ((joystick_ok === 1'b1)) begin
                e115_1_1_main__k = (joystick_keys + 20);
                e115_1_1_main__k2 = joystick_keys;
                joystickxx <= (~(joystickxx));
            end
            cmdn_r <= 1;
            if ((e115_1_1_main__k != 16)) begin
                kout <= (31 - e115_1_1_main__k);
            end
            if ((mm != mmx)) begin
                mm <= mmx;
                s0on <= 1'b0;
                s_reset_t <= 1'b0;
                s_reset_r <= 1'b0;
                cmdn_r <= 1;
                cmdn_rs <= 1;
                cmdns <= 1;
                ws2812bp_reset <= 1'b0;
                ws2812b_8basecolor[288 +: 72] <= {{8'hFF, 8'h00, 8'h00}, {8'h00, 8'hFF, 8'h00}, {8'h00, 8'h00, 8'hFF}};
                ws2812b_flash_enable <= 1'b0;
                ws2812b_mask_enable <= 1'b0;
                st7735_p_reset <= 1'b0;
                st7735_bls <= 1'b1;
                st7735_data_c_inc <= 16;
                st7735_colmod <= 8'h05;
                st7735_invctr <= 8'h03;
                st7735_madctl <= 8'hC0;
                st7735_idmoff_on <= 8'h38;
                st7735_invoff_on <= 8'h20;
                st7735_noron_ptlon <= 8'h13;
                st7735_dispon_off <= 8'h29;
                st7735_psl <= 0;
                st7735_pel <= 161;
                st7735_data_cpointer_begin <= 0;
                st7735_data_rpointer_begin <= 0;
                st7735_data_cpointer_end <= 127;
                st7735_data_rpointer_end <= 159;
                if ((st7735_reset0 === 1'b0)) begin
                    st7735_com_pointers <= 0;
                end else begin
                    st7735_com_pointers <= 16;
                end
                st7735_time_dn <= 0;
                b1_colori <= 0;
                b0_colori <= 7;
                monoc <= 0;
                isword <= 1'b0;
                remove_leading_0 <= 1'b0;
                d0_setn <= 7;
                word_w <= 20;
                gdata0 <= {16{1'b0}};
                cbis <= 4'b0010;
                st7735_ch <= 4'b0000;
                shift_y <= 0;
                shift_x <= 0;
            end else if ((st7735_reset0 === 1'b0)) begin
                if ((st7735_p_ok === 1'b1)) begin
                    st7735_reset0 <= 1'b1;
                    st7735_p_reset <= 1'b0;
                end else begin
                    gdata0 <= {16{1'b0}};
                    st7735_p_reset <= 1'b1;
                end
            end else if ((ws2812b_reset0 === 1'b0)) begin
                if ((ws2812bp_ok === 1'b1)) begin
                    ws2812b_reset0 <= 1'b1;
                    ws2812bp_reset <= 1'b0;
                end else begin
                    ws2812bp_ms <= 0;
                    ws2812b_colorsc1 <= 0;
                    ws2812bp_reset <= 1'b1;
                end
            end else begin
                case (mmx)
                    2'b00: begin
                        if ((s0on === 1'b0)) begin
                            if ((e115_1_1_main__k == 0)) begin
                                s0on <= 1'b1;
                                times1 <= 0;
                                times2 <= 1;
                                times3 <= 0;
                                st7735_time_dn <= 0;
                                st7735_p_reset <= 1'b1;
                                e115_1_1_main__k00sw = 1'b1;
                            end
                        end else if ((e115_1_1_main__k == 1)) begin
                            mm <= (~(mmx));
                        end else begin
                            if ((st7735_p_ok === 1'b0)) begin
                                st7735_p_reset <= 1'b1;
                            end else begin
                                st7735_p_reset <= 1'b0;
                                if (e115_1_1_main__k00sw) begin
                                    st7735_ch <= 4'b0001;
                                    b1_colori <= 1;
                                    b0_colori <= 7;
                                    isword <= 1'b1;
                                    word_w <= 32;
                                    st7735_data_cpointer_begin <= 0;
                                    st7735_data_cpointer_end <= 127;
                                    st7735_data_rpointer_begin <= 10;
                                    st7735_data_rpointer_end <= 41;
                                    st7735_data <= {to_vec_8(times1), to_vec_8((times1 + 1)), to_vec_8((times1 + 2)), to_vec_8((times1 + 3)), 8'd0, 8'd0, 8'd0, 8'd0};
                                    times1 <= ((times1 + 4) % 28);
                                    befriendc_p <= 960;
                                    st7735_time_dn <= 0;
                                end else begin
                                    st7735_ch <= 4'b0001;
                                    b1_colori <= 3;
                                    b0_colori <= 7;
                                    isword <= 1'b1;
                                    word_w <= 24;
                                    st7735_data_cpointer_begin <= 4;
                                    st7735_data_cpointer_end <= 123;
                                    st7735_data_rpointer_begin <= 70;
                                    st7735_data_rpointer_end <= 101;
                                    st7735_data <= {8'd11, to_vec_8(times3), 8'd13, to_vec_8(times2), 8'd12, 8'd0, 8'd0, 8'd0};
                                    times2 <= ((times2 % 8) + 1);
                                    times3 <= ((times3 + (times2 / 8)) % 9);
                                    befriendc_p <= 0;
                                    st7735_time_dn <= 50000000;
                                end
                                e115_1_1_main__k00sw = (!(e115_1_1_main__k00sw));
                            end
                        end
                    end
                    2'b01: begin
                        d7_db <= f012345[432 - 48*fp +: 48];
                        if ((fp < 9)) begin
                            d7dot <= 8'b00010000;
                        end
                        if (((e115_1_1_main__k > 4) && (e115_1_1_main__k < 14))) begin
                            fp <= (e115_1_1_main__k - 5);
                            f012345[672 - 48*e115_1_1_main__k +: 6] <= ((e115_1_1_main__k - 5) % 10);
                            f012345[678 - 48*e115_1_1_main__k +: 6] <= ((e115_1_1_main__k - 5) / 10);
                        end
                    end
                    2'b10: begin
                        if ((s0on === 1'b0)) begin
                            if ((e115_1_1_main__k == 0)) begin
                                s0on <= 1'b1;
                                st7735_time_dn <= 0;
                                st7735_p_reset <= 1'b1;
                                times1 <= 1;
                                ws2812bp_reset <= 1'b1;
                                ws2812bp_ms <= 5;
                                ws2812b_dir <= 0;
                                ws2812bp_time_dn <= 300;
                                ws2812b_rgb3bitnx64[0 +: 192] <= ws2812b_rgb3bitnx64[384 +: 192];
                                ws2812b_rgb3bitnx64p <= 2;
                            end
                        end else if ((e115_1_1_main__k == 1)) begin
                            mm <= (~(mmx));
                        end else begin
                            if ((ws2812bp_ok === 1'b0)) begin
                                ws2812bp_reset <= 1'b1;
                            end else begin
                                ws2812bp_reset <= 1'b0;
                                times1 <= (times1 + 1);
                                if ((times1 < 48)) begin
                                    if (((times1 % 6) == 0)) begin
                                        ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 9], ws2812b_rgb3bitnx64[9 +: 183]};
                                    end else begin
                                        ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 3], ws2812b_rgb3bitnx64[3 +: 189]};
                                    end
                                end else if ((times1 == 48)) begin
                                    ws2812b_rgb3bitnx64[0 +: 192] <= ws2812b_rgb3bitnx64[192 +: 192];
                                    ws2812bp_time_dn <= 0;
                                    ws2812b_xy <= 36;
                                end else if ((times1 == 49)) begin
                                    times1 <= times1;
                                    ws2812bp_reset <= 1'b1;
                                    if ((e115_1_1_main__k == 20)) begin
                                        if ((ws2812b_xy < 56)) begin
                                            ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 24], ws2812b_rgb3bitnx64[24 +: 168]};
                                            ws2812bp_reset <= 1'b0;
                                            ws2812b_xy <= (ws2812b_xy + 8);
                                        end
                                    end else if ((e115_1_1_main__k == 21)) begin
                                        if ((ws2812b_xy > 15)) begin
                                            ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 168], ws2812b_rgb3bitnx64[168 +: 24]};
                                            ws2812bp_reset <= 1'b0;
                                            ws2812b_xy <= (ws2812b_xy - 8);
                                        end
                                    end else if ((e115_1_1_main__k == 22)) begin
                                        if (((ws2812b_xy % 8) != 7)) begin
                                            ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 3], ws2812b_rgb3bitnx64[3 +: 189]};
                                            ws2812bp_reset <= 1'b0;
                                            ws2812b_xy <= (ws2812b_xy + 1);
                                        end
                                    end else if ((e115_1_1_main__k == 23)) begin
                                        if (((ws2812b_xy % 8) != 1)) begin
                                            ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 189], ws2812b_rgb3bitnx64[189 +: 3]};
                                            ws2812bp_reset <= 1'b0;
                                            ws2812b_xy <= (ws2812b_xy - 1);
                                        end
                                    end else if ((e115_1_1_main__k == 28)) begin
                                        times1 <= (times1 + 1);
                                        ws2812bp_reset <= 1'b1;
                                    end
                                end else begin
                                    times1 <= times1;
                                    ws2812bp_reset <= 1'b1;
                                end
                            end
                        end
                    end
                    2'b11: begin
                        if ((s0on === 1'b0)) begin
                            if ((e115_1_1_main__k == 0)) begin
                                s0on <= 1'b1;
                                d7_db <= {8{6'd10}};
                                d7dot <= {8{1'b0}};
                                times1 <= 0;
                                times2 <= 0;
                                times3 <= 0;
                                times4 <= 0;
                                times5 <= 0;
                                st7735_time_dn <= 0;
                                st7735_p_reset <= 1'b1;
                                ws2812bp_reset <= 1'b1;
                                ws2812bp_ms <= 5;
                                ws2812b_dir <= 0;
                                ws2812bp_time_dn <= 0;
                                ws2812b_rgb3bitnx64[0 +: 192] <= {64{3'd0}};
                                ws2812b_rgb3bitnx64p <= 2;
                                ws2812b_xy <= 0;
                                ws2812b_8basecolor[288 +: 72] <= {{8'h9F, 8'h00, 8'h00}, {8'h00, 8'h9F, 8'h00}, {8'h00, 8'h00, 8'h9F}};
                                ws2812bp_c_r <= 3'b100;
                                ws2812bp_c_g <= 3'b100;
                                ws2812bp_c_b <= 3'b100;
                                fp <= 9;
                            end
                        end else if ((e115_1_1_main__k == 1)) begin
                            mm <= (~(mmx));
                        end else begin
                            d7_db <= f012345[432 - 48*fp +: 48];
                            if ((fp < 9)) begin
                                d7dot <= 8'b00010000;
                            end
                            if (((st7735_p_ok === 1'b0) || (ws2812bp_ok === 1'b0))) begin
                                ws2812bp_reset <= 1'b1;
                                st7735_p_reset <= 1'b1;
                            end else begin
                                ws2812bp_reset <= 1'b0;
                                st7735_p_reset <= 1'b0;
                                times3 <= (times3 + 1);
                                if ((times3 == 0)) begin
                                    st7735_ch <= 4'b0001;
                                    b1_colori <= 1;
                                    b0_colori <= 7;
                                    isword <= 1'b1;
                                    word_w <= 32;
                                    st7735_data_cpointer_begin <= 0;
                                    st7735_data_cpointer_end <= 127;
                                    st7735_data_rpointer_begin <= 10;
                                    st7735_data_rpointer_end <= 41;
                                    st7735_data <= {8'd0, 8'd1, 8'd2, 8'd3, 8'd0, 8'd0, 8'd0, 8'd0};
                                    befriendc_p <= 960;
                                    st7735_time_dn <= 0;
                                end else if ((times3 == 1)) begin
                                    st7735_ch <= 4'b0001;
                                    b1_colori <= 3;
                                    b0_colori <= 7;
                                    isword <= 1'b1;
                                    word_w <= 24;
                                    st7735_data_cpointer_begin <= 4;
                                    st7735_data_cpointer_end <= 123;
                                    st7735_data_rpointer_begin <= 70;
                                    st7735_data_rpointer_end <= 101;
                                    st7735_data <= {8'd11, to_vec_8(times1), 8'd13, to_vec_8(times2), 8'd12, 8'd0, 8'd0, 8'd0};
                                    befriendc_p <= 0;
                                    if ((times1 > 0)) begin
                                        ws2812b_rgb3bitnx64[0 +: 192] <= {64{3'd0}};
                                        ws2812b_rgb3bitnx64[186 - 3*ws2812b_xy +: 6] <= {3'd4, 3'd4};
                                        ws2812b_rgb3bitnx64[162 - 3*ws2812b_xy +: 6] <= {3'd4, 3'd4};
                                    end
                                    ws2812b_8basecolor[288 +: 72] <= {{{ws2812bp_c_r, 5'b11111}, 8'h00, 8'h00}, {8'h00, {ws2812bp_c_g, 5'b11111}, 8'h00}, {8'h00, 8'h00, {ws2812bp_c_b, 5'b11111}}};
                                end else begin
                                    ws2812bp_reset <= 1'b1;
                                    st7735_p_reset <= 1'b1;
                                    times3 <= times3;
                                    if (((times4 != 0) && (times5 != 0))) begin
                                        if ((e115_1_1_main__k == 8)) begin
                                            fp <= 3;
                                            f012345[288 +: 6] <= (times5 % 10);
                                            f012345[294 +: 6] <= (times5 / 10);
                                        end
                                    end else if (((times3 == 2) && (times1 == 0))) begin
                                        if ((e115_1_1_main__k == 28)) begin
                                            times1 <= 1;
                                            times2 <= 1;
                                            times3 <= 1;
                                        end
                                    end else begin
                                        case (e115_1_1_main__k)
                                            2: begin
                                                if ((ws2812bp_c_r < 7)) begin
                                                    ws2812bp_c_r <= (ws2812bp_c_r + 1);
                                                    ws2812bp_c_g <= (ws2812bp_c_g + 1);
                                                    ws2812bp_c_b <= (ws2812bp_c_b + 1);
                                                    times3 <= 1;
                                                end
                                            end
                                            3: begin
                                                if ((ws2812bp_c_r > 2)) begin
                                                    ws2812bp_c_r <= (ws2812bp_c_r - 1);
                                                    ws2812bp_c_g <= (ws2812bp_c_g - 1);
                                                    ws2812bp_c_b <= (ws2812bp_c_b - 1);
                                                    times3 <= 1;
                                                end
                                            end
                                            20: begin
                                                if ((times2 < 7)) begin
                                                    times2 <= (times2 + 1);
                                                    ws2812b_xy <= (ws2812b_xy + 8);
                                                    times3 <= 1;
                                                end
                                            end
                                            21: begin
                                                if ((times2 > 1)) begin
                                                    times2 <= (times2 - 1);
                                                    ws2812b_xy <= (ws2812b_xy - 8);
                                                    times3 <= 1;
                                                end
                                            end
                                            22: begin
                                                if ((times1 < 7)) begin
                                                    times1 <= (times1 + 1);
                                                    ws2812b_xy <= (ws2812b_xy + 1);
                                                    times3 <= 1;
                                                end
                                            end
                                            23: begin
                                                if ((times1 > 1)) begin
                                                    times1 <= (times1 - 1);
                                                    ws2812b_xy <= (ws2812b_xy - 1);
                                                    times3 <= 1;
                                                end
                                            end
                                            28: begin
                                                times3 <= 1;
                                                times4 <= times1;
                                                times5 <= times2;
                                                times1 <= 0;
                                                times2 <= 0;
                                            end
                                            default: begin
                                            end
                                        endcase
                                    end
                                end
                            end
                        end
                    end
                    default: begin
                        ;
                    end
                endcase
            end
        end
    end
end
`else
reg e115_1_1_main__previous_clock;
initial e115_1_1_main__previous_clock = 1'bx;
always @(e115_1_1_mainclk) begin : e115_1_1_main__vhdl_events
    if ((s_reset === 1'b0)) begin
        mm <= (~(mmx));
        d7_db <= {6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10, 6'd10};
        flash_a_g <= 8'b00000000;
        flashs <= 8'b00000000;
        d7dot <= 8'b00000000;
        ws2812bp_reset <= 1'b0;
        ws2812bp_ms <= 0;
        ws2812b_colorsc1 <= 0;
        ws2812b_b1_colori <= 1;
        ws2812b_b0_colori <= 2;
        ws2812b_dir <= 0;
        ws2812bp_time_dn <= 1;
        ws2812b_xyshift <= 0;
        ws2812b_flash_enable <= 1'b0;
        ws2812b_flashns <= 4;
        ws2812b_flashnes <= 1'b1;
        ws2812b_flash_add <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
        ws2812b_flash_adds <= 0;
        ws2812b_colors1 <= 24'h00FF00;
        ws2812b_colord1 <= 24'hFFFF00;
        ws2812b_colors2 <= 24'hFF0000;
        ws2812b_colord2 <= 24'hFF00FF;
        ws2812b_flash_speed <= 5;
        ws2812b_reset0 <= 1'b0;
        ws2812bp_c_r <= 3'b111;
        ws2812bp_c_g <= 3'b111;
        ws2812bp_c_b <= 3'b111;
        ws2812b_mask_enable <= 1'b0;
        ws2812b_mask_add <= {64{1'b0}};
        ws2812b_mask_adds <= 1;
        ws2812b_mask_ms <= 2;
        ws2812b_maskcolors1or2 <= 0;
        ws2812b_maskcolors1 <= 24'hFF00FF;
        ws2812b_maskcolors2 <= 24'hFF00FF;
        ws2812b_mask_r <= 8'hFF;
        ws2812b_mask_g <= 8'hFF;
        ws2812b_mask_b <= 8'hFF;
        ads1115_adcp <= 0;
        joystick_reset <= 1'b0;
        e115_1_1_main__k = 16;
        s0on <= 1'b0;
        mms <= 5;
        mx <= {4{1'b0}};
        st7735_reset0 <= 1'b0;
        d0_setn <= 7;
        s_reset_t <= 1'b0;
        s_reset_r <= 1'b0;
        rx_r <= 1'b0;
        tx_w <= 1'b0;
        cmdn_r <= 0;
        cmdn_rs <= 0;
        cmdn <= 0;
        cmdns <= 0;
        kxx <= 1'b0;
        joystickxx <= 1'b0;
        esp8266resettime <= 400;
        esp8266_power <= 1'b0;
        sys_uartfs <= 1'b0;
        fp <= 9;
    end else if (((rx_r === 1'b1) && (status_rs[2] === 1'b0))) begin
        rx_r <= 1'b0;
    end else if (((rx_r2 === 1'b1) && (status_rs2[2] === 1'b0))) begin
        rx_r2 <= 1'b0;
    end else if (((e115_1_1_main__previous_clock === 1'b0) && (e115_1_1_mainclk === 1'b1))) begin
        joystick_reset <= 1'b1;
        if ((esp8266resettime == 0)) begin
            s_reset_t <= 1'b1;
            s_reset_r <= 1'b1;
        end else begin
            esp8266resettime <= (esp8266resettime - 1);
            if ((esp8266resettime == 500)) begin
                esp8266_power <= 1'b1;
            end
        end
        if ((((s_reset_t === 1'b1) && (cmdn > 0)) || (((s_reset_r === 1'b1) && (status_rs[2] === 1'b1)) && (cmdn_r > 0)))) begin
            sys_uartfs <= 1'b1;
            if ((((s_reset_t === 1'b1) && (cmdn > 0)) && (tx_w === 1'b0))) begin
                if ((status_ts[1] === 1'b0)) begin
                    tx_w <= 1'b1;
                end
            end else if (((tx_w === 1'b1) && (status_ts[1] === 1'b1))) begin
                tx_w <= 1'b0;
                cmdn <= (cmdn - 1);
            end
            if (((((s_reset_r === 1'b1) && (status_rs[2] === 1'b1)) && (rx_r === 1'b0)) && (cmdn_r > 0))) begin
                rx_r <= 1'b1;
                if ((cmdn_rs == 511)) begin
                    cmdn_r <= {{(32-(8)){1'b0}}, rxds};
                    cmdn_rs <= {{(32-(8)){1'b0}}, rxds};
                end else begin
                    cmdn_r <= (cmdn_r - 1);
                    esp8266_fpga[8*cmdn_r - 8*cmdn_rs + 8*txrd_buff_n +: 8] <= rxds;
                    esp8266_fpga_int[8*cmdn_r - 8*cmdn_rs + 8*txrd_buff_n +: 8] <= {{(32-(8)){1'b0}}, rxds};
                    if (((cmdn_rs == 510) && (rxds == 8'hFF))) begin
                        cmdn_r <= 0;
                        cmdn_rs <= (cmdn_rs - cmdn_r);
                    end
                    pre_item <= rxds;
                    if (((cmdn_rs == 509) && (cmdn_rs != cmdn_r))) begin
                        if (((pre_item == 8'hFE) && (rxds == 8'hFF))) begin
                            cmdn_r <= 0;
                            cmdn_rs <= ((cmdn_rs - cmdn_r) - 1);
                        end
                    end
                end
            end
        end else begin
            sys_uartfs <= 1'b0;
            e115_1_1_main__k = 16;
            if ((kok === 1'b1)) begin
                e115_1_1_main__k = kv;
                e115_1_1_main__k2 = kv;
            end else if (((cmdn_r == 0) && (s_reset_r === 1'b1))) begin
                e115_1_1_main__k = (esp8266_fpga_int[8*txrd_buff_n +: 8] + 5);
                e115_1_1_main__k2 = esp8266_fpga_int[8*txrd_buff_n +: 8];
                if ((rdatalength != 0)) begin
                    s_reset_r <= 1'b0;
                    e115_1_1_main__k = 16;
                end
                kxx <= (~(kxx));
            end else if ((joystick_ok === 1'b1)) begin
                e115_1_1_main__k = (joystick_keys + 20);
                e115_1_1_main__k2 = joystick_keys;
                joystickxx <= (~(joystickxx));
            end
            cmdn_r <= 1;
            if ((e115_1_1_main__k != 16)) begin
                kout <= (31 - e115_1_1_main__k);
            end
            if ((mm != mmx)) begin
                mm <= mmx;
                s0on <= 1'b0;
                s_reset_t <= 1'b0;
                s_reset_r <= 1'b0;
                cmdn_r <= 1;
                cmdn_rs <= 1;
                cmdns <= 1;
                ws2812bp_reset <= 1'b0;
                ws2812b_8basecolor[288 +: 72] <= {{8'hFF, 8'h00, 8'h00}, {8'h00, 8'hFF, 8'h00}, {8'h00, 8'h00, 8'hFF}};
                ws2812b_flash_enable <= 1'b0;
                ws2812b_mask_enable <= 1'b0;
                st7735_p_reset <= 1'b0;
                st7735_bls <= 1'b1;
                st7735_data_c_inc <= 16;
                st7735_colmod <= 8'h05;
                st7735_invctr <= 8'h03;
                st7735_madctl <= 8'hC0;
                st7735_idmoff_on <= 8'h38;
                st7735_invoff_on <= 8'h20;
                st7735_noron_ptlon <= 8'h13;
                st7735_dispon_off <= 8'h29;
                st7735_psl <= 0;
                st7735_pel <= 161;
                st7735_data_cpointer_begin <= 0;
                st7735_data_rpointer_begin <= 0;
                st7735_data_cpointer_end <= 127;
                st7735_data_rpointer_end <= 159;
                if ((st7735_reset0 === 1'b0)) begin
                    st7735_com_pointers <= 0;
                end else begin
                    st7735_com_pointers <= 16;
                end
                st7735_time_dn <= 0;
                b1_colori <= 0;
                b0_colori <= 7;
                monoc <= 0;
                isword <= 1'b0;
                remove_leading_0 <= 1'b0;
                d0_setn <= 7;
                word_w <= 20;
                gdata0 <= {16{1'b0}};
                cbis <= 4'b0010;
                st7735_ch <= 4'b0000;
                shift_y <= 0;
                shift_x <= 0;
            end else if ((st7735_reset0 === 1'b0)) begin
                if ((st7735_p_ok === 1'b1)) begin
                    st7735_reset0 <= 1'b1;
                    st7735_p_reset <= 1'b0;
                end else begin
                    gdata0 <= {16{1'b0}};
                    st7735_p_reset <= 1'b1;
                end
            end else if ((ws2812b_reset0 === 1'b0)) begin
                if ((ws2812bp_ok === 1'b1)) begin
                    ws2812b_reset0 <= 1'b1;
                    ws2812bp_reset <= 1'b0;
                end else begin
                    ws2812bp_ms <= 0;
                    ws2812b_colorsc1 <= 0;
                    ws2812bp_reset <= 1'b1;
                end
            end else begin
                case (mmx)
                    2'b00: begin
                        if ((s0on === 1'b0)) begin
                            if ((e115_1_1_main__k == 0)) begin
                                s0on <= 1'b1;
                                times1 <= 0;
                                times2 <= 1;
                                times3 <= 0;
                                st7735_time_dn <= 0;
                                st7735_p_reset <= 1'b1;
                                e115_1_1_main__k00sw = 1'b1;
                            end
                        end else if ((e115_1_1_main__k == 1)) begin
                            mm <= (~(mmx));
                        end else begin
                            if ((st7735_p_ok === 1'b0)) begin
                                st7735_p_reset <= 1'b1;
                            end else begin
                                st7735_p_reset <= 1'b0;
                                if (e115_1_1_main__k00sw) begin
                                    st7735_ch <= 4'b0001;
                                    b1_colori <= 1;
                                    b0_colori <= 7;
                                    isword <= 1'b1;
                                    word_w <= 32;
                                    st7735_data_cpointer_begin <= 0;
                                    st7735_data_cpointer_end <= 127;
                                    st7735_data_rpointer_begin <= 10;
                                    st7735_data_rpointer_end <= 41;
                                    st7735_data <= {to_vec_8(times1), to_vec_8((times1 + 1)), to_vec_8((times1 + 2)), to_vec_8((times1 + 3)), 8'd0, 8'd0, 8'd0, 8'd0};
                                    times1 <= ((times1 + 4) % 28);
                                    befriendc_p <= 960;
                                    st7735_time_dn <= 0;
                                end else begin
                                    st7735_ch <= 4'b0001;
                                    b1_colori <= 3;
                                    b0_colori <= 7;
                                    isword <= 1'b1;
                                    word_w <= 24;
                                    st7735_data_cpointer_begin <= 4;
                                    st7735_data_cpointer_end <= 123;
                                    st7735_data_rpointer_begin <= 70;
                                    st7735_data_rpointer_end <= 101;
                                    st7735_data <= {8'd11, to_vec_8(times3), 8'd13, to_vec_8(times2), 8'd12, 8'd0, 8'd0, 8'd0};
                                    times2 <= ((times2 % 8) + 1);
                                    times3 <= ((times3 + (times2 / 8)) % 9);
                                    befriendc_p <= 0;
                                    st7735_time_dn <= 50000000;
                                end
                                e115_1_1_main__k00sw = (!(e115_1_1_main__k00sw));
                            end
                        end
                    end
                    2'b01: begin
                        d7_db <= f012345[432 - 48*fp +: 48];
                        if ((fp < 9)) begin
                            d7dot <= 8'b00010000;
                        end
                        if (((e115_1_1_main__k > 4) && (e115_1_1_main__k < 14))) begin
                            fp <= (e115_1_1_main__k - 5);
                            f012345[672 - 48*e115_1_1_main__k +: 6] <= ((e115_1_1_main__k - 5) % 10);
                            f012345[678 - 48*e115_1_1_main__k +: 6] <= ((e115_1_1_main__k - 5) / 10);
                        end
                    end
                    2'b10: begin
                        if ((s0on === 1'b0)) begin
                            if ((e115_1_1_main__k == 0)) begin
                                s0on <= 1'b1;
                                st7735_time_dn <= 0;
                                st7735_p_reset <= 1'b1;
                                times1 <= 1;
                                ws2812bp_reset <= 1'b1;
                                ws2812bp_ms <= 5;
                                ws2812b_dir <= 0;
                                ws2812bp_time_dn <= 300;
                                ws2812b_rgb3bitnx64[0 +: 192] <= ws2812b_rgb3bitnx64[384 +: 192];
                                ws2812b_rgb3bitnx64p <= 2;
                            end
                        end else if ((e115_1_1_main__k == 1)) begin
                            mm <= (~(mmx));
                        end else begin
                            if ((ws2812bp_ok === 1'b0)) begin
                                ws2812bp_reset <= 1'b1;
                            end else begin
                                ws2812bp_reset <= 1'b0;
                                times1 <= (times1 + 1);
                                if ((times1 < 48)) begin
                                    if (((times1 % 6) == 0)) begin
                                        ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 9], ws2812b_rgb3bitnx64[9 +: 183]};
                                    end else begin
                                        ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 3], ws2812b_rgb3bitnx64[3 +: 189]};
                                    end
                                end else if ((times1 == 48)) begin
                                    ws2812b_rgb3bitnx64[0 +: 192] <= ws2812b_rgb3bitnx64[192 +: 192];
                                    ws2812bp_time_dn <= 0;
                                    ws2812b_xy <= 36;
                                end else if ((times1 == 49)) begin
                                    times1 <= times1;
                                    ws2812bp_reset <= 1'b1;
                                    if ((e115_1_1_main__k == 20)) begin
                                        if ((ws2812b_xy < 56)) begin
                                            ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 24], ws2812b_rgb3bitnx64[24 +: 168]};
                                            ws2812bp_reset <= 1'b0;
                                            ws2812b_xy <= (ws2812b_xy + 8);
                                        end
                                    end else if ((e115_1_1_main__k == 21)) begin
                                        if ((ws2812b_xy > 15)) begin
                                            ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 168], ws2812b_rgb3bitnx64[168 +: 24]};
                                            ws2812bp_reset <= 1'b0;
                                            ws2812b_xy <= (ws2812b_xy - 8);
                                        end
                                    end else if ((e115_1_1_main__k == 22)) begin
                                        if (((ws2812b_xy % 8) != 7)) begin
                                            ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 3], ws2812b_rgb3bitnx64[3 +: 189]};
                                            ws2812bp_reset <= 1'b0;
                                            ws2812b_xy <= (ws2812b_xy + 1);
                                        end
                                    end else if ((e115_1_1_main__k == 23)) begin
                                        if (((ws2812b_xy % 8) != 1)) begin
                                            ws2812b_rgb3bitnx64[0 +: 192] <= {ws2812b_rgb3bitnx64[0 +: 189], ws2812b_rgb3bitnx64[189 +: 3]};
                                            ws2812bp_reset <= 1'b0;
                                            ws2812b_xy <= (ws2812b_xy - 1);
                                        end
                                    end else if ((e115_1_1_main__k == 28)) begin
                                        times1 <= (times1 + 1);
                                        ws2812bp_reset <= 1'b1;
                                    end
                                end else begin
                                    times1 <= times1;
                                    ws2812bp_reset <= 1'b1;
                                end
                            end
                        end
                    end
                    2'b11: begin
                        if ((s0on === 1'b0)) begin
                            if ((e115_1_1_main__k == 0)) begin
                                s0on <= 1'b1;
                                d7_db <= {8{6'd10}};
                                d7dot <= {8{1'b0}};
                                times1 <= 0;
                                times2 <= 0;
                                times3 <= 0;
                                times4 <= 0;
                                times5 <= 0;
                                st7735_time_dn <= 0;
                                st7735_p_reset <= 1'b1;
                                ws2812bp_reset <= 1'b1;
                                ws2812bp_ms <= 5;
                                ws2812b_dir <= 0;
                                ws2812bp_time_dn <= 0;
                                ws2812b_rgb3bitnx64[0 +: 192] <= {64{3'd0}};
                                ws2812b_rgb3bitnx64p <= 2;
                                ws2812b_xy <= 0;
                                ws2812b_8basecolor[288 +: 72] <= {{8'h9F, 8'h00, 8'h00}, {8'h00, 8'h9F, 8'h00}, {8'h00, 8'h00, 8'h9F}};
                                ws2812bp_c_r <= 3'b100;
                                ws2812bp_c_g <= 3'b100;
                                ws2812bp_c_b <= 3'b100;
                                fp <= 9;
                            end
                        end else if ((e115_1_1_main__k == 1)) begin
                            mm <= (~(mmx));
                        end else begin
                            d7_db <= f012345[432 - 48*fp +: 48];
                            if ((fp < 9)) begin
                                d7dot <= 8'b00010000;
                            end
                            if (((st7735_p_ok === 1'b0) || (ws2812bp_ok === 1'b0))) begin
                                ws2812bp_reset <= 1'b1;
                                st7735_p_reset <= 1'b1;
                            end else begin
                                ws2812bp_reset <= 1'b0;
                                st7735_p_reset <= 1'b0;
                                times3 <= (times3 + 1);
                                if ((times3 == 0)) begin
                                    st7735_ch <= 4'b0001;
                                    b1_colori <= 1;
                                    b0_colori <= 7;
                                    isword <= 1'b1;
                                    word_w <= 32;
                                    st7735_data_cpointer_begin <= 0;
                                    st7735_data_cpointer_end <= 127;
                                    st7735_data_rpointer_begin <= 10;
                                    st7735_data_rpointer_end <= 41;
                                    st7735_data <= {8'd0, 8'd1, 8'd2, 8'd3, 8'd0, 8'd0, 8'd0, 8'd0};
                                    befriendc_p <= 960;
                                    st7735_time_dn <= 0;
                                end else if ((times3 == 1)) begin
                                    st7735_ch <= 4'b0001;
                                    b1_colori <= 3;
                                    b0_colori <= 7;
                                    isword <= 1'b1;
                                    word_w <= 24;
                                    st7735_data_cpointer_begin <= 4;
                                    st7735_data_cpointer_end <= 123;
                                    st7735_data_rpointer_begin <= 70;
                                    st7735_data_rpointer_end <= 101;
                                    st7735_data <= {8'd11, to_vec_8(times1), 8'd13, to_vec_8(times2), 8'd12, 8'd0, 8'd0, 8'd0};
                                    befriendc_p <= 0;
                                    if ((times1 > 0)) begin
                                        ws2812b_rgb3bitnx64[0 +: 192] <= {64{3'd0}};
                                        ws2812b_rgb3bitnx64[186 - 3*ws2812b_xy +: 6] <= {3'd4, 3'd4};
                                        ws2812b_rgb3bitnx64[162 - 3*ws2812b_xy +: 6] <= {3'd4, 3'd4};
                                    end
                                    ws2812b_8basecolor[288 +: 72] <= {{{ws2812bp_c_r, 5'b11111}, 8'h00, 8'h00}, {8'h00, {ws2812bp_c_g, 5'b11111}, 8'h00}, {8'h00, 8'h00, {ws2812bp_c_b, 5'b11111}}};
                                end else begin
                                    ws2812bp_reset <= 1'b1;
                                    st7735_p_reset <= 1'b1;
                                    times3 <= times3;
                                    if (((times4 != 0) && (times5 != 0))) begin
                                        if ((e115_1_1_main__k == 8)) begin
                                            fp <= 3;
                                            f012345[288 +: 6] <= (times5 % 10);
                                            f012345[294 +: 6] <= (times5 / 10);
                                        end
                                    end else if (((times3 == 2) && (times1 == 0))) begin
                                        if ((e115_1_1_main__k == 28)) begin
                                            times1 <= 1;
                                            times2 <= 1;
                                            times3 <= 1;
                                        end
                                    end else begin
                                        case (e115_1_1_main__k)
                                            2: begin
                                                if ((ws2812bp_c_r < 7)) begin
                                                    ws2812bp_c_r <= (ws2812bp_c_r + 1);
                                                    ws2812bp_c_g <= (ws2812bp_c_g + 1);
                                                    ws2812bp_c_b <= (ws2812bp_c_b + 1);
                                                    times3 <= 1;
                                                end
                                            end
                                            3: begin
                                                if ((ws2812bp_c_r > 2)) begin
                                                    ws2812bp_c_r <= (ws2812bp_c_r - 1);
                                                    ws2812bp_c_g <= (ws2812bp_c_g - 1);
                                                    ws2812bp_c_b <= (ws2812bp_c_b - 1);
                                                    times3 <= 1;
                                                end
                                            end
                                            20: begin
                                                if ((times2 < 7)) begin
                                                    times2 <= (times2 + 1);
                                                    ws2812b_xy <= (ws2812b_xy + 8);
                                                    times3 <= 1;
                                                end
                                            end
                                            21: begin
                                                if ((times2 > 1)) begin
                                                    times2 <= (times2 - 1);
                                                    ws2812b_xy <= (ws2812b_xy - 8);
                                                    times3 <= 1;
                                                end
                                            end
                                            22: begin
                                                if ((times1 < 7)) begin
                                                    times1 <= (times1 + 1);
                                                    ws2812b_xy <= (ws2812b_xy + 1);
                                                    times3 <= 1;
                                                end
                                            end
                                            23: begin
                                                if ((times1 > 1)) begin
                                                    times1 <= (times1 - 1);
                                                    ws2812b_xy <= (ws2812b_xy - 1);
                                                    times3 <= 1;
                                                end
                                            end
                                            28: begin
                                                times3 <= 1;
                                                times4 <= times1;
                                                times5 <= times2;
                                                times1 <= 0;
                                                times2 <= 0;
                                            end
                                            default: begin
                                            end
                                        endcase
                                    end
                                end
                            end
                        end
                    end
                    default: begin
                        ;
                    end
                endcase
            end
        end
    end
    e115_1_1_main__previous_clock = e115_1_1_mainclk;
end
`endif

// Sequential logic
`ifdef SYNTHESIS
always @(posedge ads1115_loadck) begin : sequential_1
    if ((process_1__asd1115load !== ads1115upload)) begin
        process_1__asd1115load = ads1115upload;
        process_1__ads1115loadp = 0;
    end else if (1'b1) begin
        if ((process_1__ads1115loadp < 8)) begin
            ads1115_adcs[240 - 16*process_1__ads1115loadp +: 16] <= ads1115_adc_16bit;
            if ((ads1115_adc_16bit[15] === 1'b0)) begin
                ads1115_adc_signed[15 - process_1__ads1115loadp] <= 0;
                ads1115_adcn[300 - 20*process_1__ads1115loadp +: 20] <= ({{(32-(16)){1'b0}}, ads1115_adc_16bit} / (2 ** (15 - ads1115_bin)));
            end else begin
                ads1115_adc_signed[15 - process_1__ads1115loadp] <= 1;
                ads1115_adcn[300 - 20*process_1__ads1115loadp +: 20] <= (({{(32-(16)){1'b0}}, (~(ads1115_adc_16bit))} + 1) / (2 ** (15 - ads1115_bin)));
            end
            process_1__ads1115loadp = (process_1__ads1115loadp + 1);
        end
    end
end
`else
reg sequential_1__previous_clock;
initial sequential_1__previous_clock = 1'bx;
always @(ads1115_loadck) begin : sequential_1__vhdl_events
    if ((process_1__asd1115load !== ads1115upload)) begin
        process_1__asd1115load = ads1115upload;
        process_1__ads1115loadp = 0;
    end else if (((sequential_1__previous_clock === 1'b0) && (ads1115_loadck === 1'b1))) begin
        if ((process_1__ads1115loadp < 8)) begin
            ads1115_adcs[240 - 16*process_1__ads1115loadp +: 16] <= ads1115_adc_16bit;
            if ((ads1115_adc_16bit[15] === 1'b0)) begin
                ads1115_adc_signed[15 - process_1__ads1115loadp] <= 0;
                ads1115_adcn[300 - 20*process_1__ads1115loadp +: 20] <= ({{(32-(16)){1'b0}}, ads1115_adc_16bit} / (2 ** (15 - ads1115_bin)));
            end else begin
                ads1115_adc_signed[15 - process_1__ads1115loadp] <= 1;
                ads1115_adcn[300 - 20*process_1__ads1115loadp +: 20] <= (({{(32-(16)){1'b0}}, (~(ads1115_adc_16bit))} + 1) / (2 ** (15 - ads1115_bin)));
            end
            process_1__ads1115loadp = (process_1__ads1115loadp + 1);
        end
    end
    sequential_1__previous_clock = ads1115_loadck;
end
`endif

// scan_p
`ifdef SYNTHESIS
always @(posedge fd[14] or negedge s_reset) begin : scan_p
    if ((s_reset === 1'b0)) begin
        scanp <= 0;
        scano <= 8'b00000000;
    end else if (1'b1) begin
        scanp <= (scanp + 1);
        scano <= {scano[0 +: 7], scano[7]};
        if ((scanp == 7)) begin
            scanp <= 0;
            scano <= 8'b00000001;
        end
    end
end
`else
reg scan_p__previous_clock;
initial scan_p__previous_clock = 1'bx;
always @(fd[14] or s_reset) begin : scan_p__vhdl_events
    if ((s_reset === 1'b0)) begin
        scanp <= 0;
        scano <= 8'b00000000;
    end else if (((scan_p__previous_clock === 1'b0) && (fd[14] === 1'b1))) begin
        scanp <= (scanp + 1);
        scano <= {scano[0 +: 7], scano[7]};
        if ((scanp == 7)) begin
            scanp <= 0;
            scano <= 8'b00000001;
        end
    end
    scan_p__previous_clock = fd[14];
end
`endif

assign flash_a_gs = (((flash_a_g[scanp] & fd[23]) === 1'b1)) ? 7'b1111111 : 7'b0000000;
assign d7led = (~({((~(d7dot[scanp])) | ((d7dot[scanp] & flashs[scanp]) & fd[23])), (disp7[(0)+(((38)-(d7_db[6*scanp +: 6]))*(7)) +: 7] | flash_a_gs)}));
assign ws2812bpck = sclk;
// ws2812bp
`ifdef SYNTHESIS
always @(posedge ws2812bpck) begin : ws2812bp
    if ((ws2812bp_reset === 1'b0)) begin
        ws2812bp__swok = 0;
        ws2812bp_ok <= 1'b0;
        ws2812b_loadck <= 1'b0;
        ws2812bp__ws2812b_grb_ok = 1'b0;
    end else if (1'b1) begin
        if ((ws2812bp__swok < 2)) begin
            if ((ws2812bp__swok == 0)) begin
                ws2812bp__swok = 1;
                ws2812bp__ws2812b_n1 = (ws2812bp__ws2812b_dirxy[282 - 18*ws2812b_dir +: 6] + ws2812b_xyshift);
                ws2812bp__tds = ws2812bp_time_dn;
                ws2812bp__td = 50000;
                ws2812bp__ws2812b_n = 0;
                ws2812bp__ws2812b_n3 = 7;
                ws2812bp__fd20_27 = fd[ws2812b_flash_speed + 20];
                ws2812breset <= 1'b0;
                if ((ws2812bp_ok === 1'b0)) begin
                    ws2812bp__ws2812b_flashn = ws2812b_flashns;
                    ws2812bp__ws2812b_flashnes1 = ws2812b_flashnes;
                    ws2812bp__ws2812b_flashs = fd[ws2812b_flash_speed + 20];
                end
            end else begin
                if ((ws2812bp__ws2812b_n == 64)) begin
                    if ((ws2812b_emitter_ok === 1'b0)) begin
                        if (((ws2812bp__tds == 0) || (ws2812bp_ok === 1'b1))) begin
                            ws2812bp_ok <= 1'b1;
                            ws2812bp__swok = 2;
                            ws2812bp__fd20_27 = fd[ws2812b_flash_speed + 20];
                        end else begin
                            ws2812bp__td = (ws2812bp__td - 1);
                            if ((ws2812bp__td == 0)) begin
                                ws2812bp__tds = (ws2812bp__tds - 1);
                                ws2812bp__td = 50000;
                            end
                        end
                    end
                end else begin
                    if ((ws2812bp__ws2812b_grb_ok === 1'b0)) begin
                        ws2812breset <= 1'b1;
                        case (ws2812bp_ms)
                            0: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_colorsc1 +: 8], ws2812b_8basecolor[376 - 24*ws2812b_colorsc1 +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_colorsc1 +: 8]};
                            end
                            1: begin
                                if ((ws2812b_64[-64*ws2812b_64p + ws2812bp__ws2812b_n1 + 64] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b1_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b1_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b1_colori +: 8]};
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b0_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b0_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b0_colori +: 8]};
                                end
                            end
                            2: begin
                                if ((ws2812b_8x8[((64 - 64*ws2812b_8x8p)+(((7)-((ws2812bp__ws2812b_n1 / 8)))*(8)))+((((ws2812bp__ws2812b_n1 % 8))-(0))*(1))] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b1_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b1_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b1_colori +: 8]};
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b0_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b0_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b0_colori +: 8]};
                                end
                            end
                            3: begin
                                if ((ws2812b_16x4[((64 - 64*ws2812b_16x4p)+(((3)-((ws2812bp__ws2812b_n1 / 16)))*(16)))+((((ws2812bp__ws2812b_n1 % 16))-(0))*(1))] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b1_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b1_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b1_colori +: 8]};
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b0_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b0_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b0_colori +: 8]};
                                end
                            end
                            4: begin
                                ws2812bp__rgbn = ws2812b_8crgb[(0)+(((7)-({{(32-(3)){1'b0}}, ws2812b_rgb3bitx64[-192*ws2812b_rgb3bitx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]}))*(3)) +: 3];
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812bp__rgbn +: 8], ws2812b_8basecolor[376 - 24*ws2812bp__rgbn +: 8]}, ws2812b_8basecolor[360 - 24*ws2812bp__rgbn +: 8]};
                            end
                            5: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[((0)+(((15)-(ws2812b_8crgb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(8) +: 8], ws2812b_8basecolor[((0)+(((15)-(ws2812b_8crgb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(16) +: 8]}, ws2812b_8basecolor[((0)+(((15)-(ws2812b_8crgb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(0) +: 8]};
                            end
                            6: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[((0)+(((15)-(ws2812b_rgb3bittnx64[-192*ws2812b_rgb3bittnx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]))*(24)))+(8) +: 8], ws2812b_8basecolor[((0)+(((15)-(ws2812b_rgb3bittnx64[-192*ws2812b_rgb3bittnx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]))*(24)))+(16) +: 8]}, ws2812b_8basecolor[((0)+(((15)-(ws2812b_rgb3bittnx64[-192*ws2812b_rgb3bittnx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]))*(24)))+(0) +: 8]};
                            end
                            7: begin
                                ws2812bp__rgbn = ws2812b_8cgrb[(0)+(((7)-({{(32-(3)){1'b0}}, ws2812b_grb3bitx64[-192*ws2812b_grb3bitx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]}))*(3)) +: 3];
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812bp__rgbn +: 8], ws2812b_8basecolor[376 - 24*ws2812bp__rgbn +: 8]}, ws2812b_8basecolor[360 - 24*ws2812bp__rgbn +: 8]};
                            end
                            8: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[((0)+(((15)-(ws2812b_8cgrb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(8) +: 8], ws2812b_8basecolor[((0)+(((15)-(ws2812b_8cgrb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(16) +: 8]}, ws2812b_8basecolor[((0)+(((15)-(ws2812b_8cgrb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(0) +: 8]};
                            end
                            9: begin
                                ws2812bp__mx16_1 = ws2812b_8r8g_8b16bit[-2048*ws2812b_8r8g_8b16bitp - 32*ws2812bp__ws2812b_n1 + 4080 +: 16];
                                ws2812bp__mx16_2 = ws2812b_8r8g_8b16bit[-2048*ws2812b_8r8g_8b16bitp - 32*ws2812bp__ws2812b_n1 + 4064 +: 16];
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812bp__mx16_1[0 +: 8], ws2812bp__mx16_1[8 +: 8]}, ws2812bp__mx16_2[8 +: 8]};
                            end
                            10: begin
                                ws2812bp__ws2812b_ledgrbdatas = ws2812b_8g8r8b24bit[-1536*ws2812b_8g8r8b24bitp - 24*ws2812bp__ws2812b_n1 + 3048 +: 24];
                            end
                            11: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8r8g8b24bit[-1536*ws2812b_8r8g8b24bitp - 24*ws2812bp__ws2812b_n1 + 3056 +: 8], ws2812b_8r8g8b24bit[-1536*ws2812b_8r8g8b24bitp - 24*ws2812bp__ws2812b_n1 + 3064 +: 8]}, ws2812b_8r8g8b24bit[-1536*ws2812b_8r8g8b24bitp - 24*ws2812bp__ws2812b_n1 + 3048 +: 8]};
                            end
                            default: begin
                            end
                        endcase
                        ws2812bp__ws2812b_grb_ok = 1'b1;
                        ws2812bp__ws2812b_flash_adds2 = 0;
                        if ((ws2812b_flash_enable === 1'b1)) begin
                            if (((ws2812bp__fd20_27 ^ ws2812bp__ws2812b_flashs) === 1'b1)) begin
                                ws2812bp__ws2812b_flash_adds2 = ws2812b_flash_adds;
                            end
                        end else begin
                            ws2812bp__ws2812b_flash_adds2 = ws2812b_flash_adds;
                        end
                        case (ws2812bp__ws2812b_flash_adds2)
                            1: begin
                                if ((ws2812b_flash_add[63 - ws2812bp__ws2812b_n1] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end
                            end
                            2: begin
                                if ((ws2812b_flash_add[63 - ws2812bp__ws2812b_n] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end
                            end
                            3: begin
                                if ((ws2812b_flash_add[63 - ws2812bp__ws2812b_n1] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord2;
                                end
                            end
                            4: begin
                                if ((ws2812b_flash_add[63 - ws2812bp__ws2812b_n] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord2;
                                end
                            end
                            5: begin
                                if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_colors1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end
                            end
                            6: begin
                                if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_colors1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end else if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_colors2)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord2;
                                end
                            end
                            7: begin
                                if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_colors1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end
                            end
                            8: begin
                                if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_colors1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end else if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_colors2)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord2;
                                end
                            end
                            default: begin
                            end
                        endcase
                        if ((ws2812b_mask_enable === 1'b1)) begin
                            ws2812bp__ws2812b_mask_adds2 = 0;
                            if (((ws2812b_mask_adds == 1) && (ws2812b_mask_add[63 - ws2812bp__ws2812b_n1] === 1'b1))) begin
                                ws2812bp__ws2812b_mask_adds2 = 1;
                            end else if (((ws2812b_mask_adds == 2) && (ws2812b_mask_add[63 - ws2812bp__ws2812b_n] === 1'b1))) begin
                                ws2812bp__ws2812b_mask_adds2 = 1;
                            end
                            if ((ws2812bp__ws2812b_mask_adds2 != 0)) begin
                                ws2812bp__ws2812b_mask_ms2 = 0;
                                if ((ws2812b_maskcolors1or2 == 0)) begin
                                    ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                end else if ((ws2812b_maskcolors1or2 == 1)) begin
                                    if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_maskcolors1)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end
                                end else if ((ws2812b_maskcolors1or2 == 2)) begin
                                    if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_maskcolors1)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end else if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_maskcolors2)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end
                                end else if ((ws2812b_maskcolors1or2 == 3)) begin
                                    if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_maskcolors1)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end
                                end else if ((ws2812b_maskcolors1or2 == 4)) begin
                                    if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_maskcolors1)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end else if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_maskcolors2)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end
                                end
                                case (ws2812bp__ws2812b_mask_ms2)
                                    1: begin
                                        ws2812bp__ws2812b_ledgrbdatas = (~(ws2812bp__ws2812b_ledgrbdatas));
                                    end
                                    2: begin
                                        ws2812bp__ws2812b_ledgrbdatas = (ws2812bp__ws2812b_ledgrbdatas & {{ws2812b_mask_g, ws2812b_mask_r}, ws2812b_mask_b});
                                    end
                                    3: begin
                                        if ((ws2812bp__ws2812b_ledgrbdatas[16 +: 8] != 0)) begin
                                            ws2812bp__ws2812b_ledgrbdatas[16 +: 8] = (ws2812bp__ws2812b_ledgrbdatas[16 +: 8] | ws2812b_mask_g);
                                        end
                                        if ((ws2812bp__ws2812b_ledgrbdatas[8 +: 8] != 0)) begin
                                            ws2812bp__ws2812b_ledgrbdatas[8 +: 8] = (ws2812bp__ws2812b_ledgrbdatas[8 +: 8] | ws2812b_mask_r);
                                        end
                                        if ((ws2812bp__ws2812b_ledgrbdatas[0 +: 8] != 0)) begin
                                            ws2812bp__ws2812b_ledgrbdatas[16 +: 8] = (ws2812bp__ws2812b_ledgrbdatas[16 +: 8] | ws2812b_mask_g);
                                        end
                                    end
                                    4: begin
                                        ws2812bp__ws2812b_ledgrbdatas = (ws2812bp__ws2812b_ledgrbdatas ^ {{ws2812b_mask_g, ws2812b_mask_r}, ws2812b_mask_b});
                                    end
                                    default: begin
                                    end
                                endcase
                            end
                        end
                        ws2812b_ledgrbdata <= ws2812bp__ws2812b_ledgrbdatas;
                        if ((ws2812bp__ws2812b_n3 == 0)) begin
                            ws2812bp__ws2812b_n1 = (ws2812bp__ws2812b_n1 + ws2812bp__ws2812b_dirxy[270 - 18*ws2812b_dir +: 6]);
                        end else begin
                            ws2812bp__ws2812b_n1 = (ws2812bp__ws2812b_n1 + ws2812bp__ws2812b_dirxy[276 - 18*ws2812b_dir +: 6]);
                        end
                        ws2812bp__ws2812b_n3 = (ws2812bp__ws2812b_n3 - 1);
                    end else if ((ws2812b_loadck === 1'b0)) begin
                        ws2812b_loadck <= 1'b1;
                    end else begin
                        ws2812b_loadck <= 1'b0;
                        ws2812bp__ws2812b_n = (ws2812bp__ws2812b_n + 1);
                        ws2812bp__ws2812b_grb_ok = 1'b0;
                    end
                end
            end
        end else if (((ws2812b_flash_enable === 1'b1) && (fd[ws2812b_flash_speed + 20] !== ws2812bp__fd20_27))) begin
            if ((ws2812bp__ws2812b_flashn != 0)) begin
                ws2812bp__swok = 0;
                if ((ws2812bp__ws2812b_flashn != 15)) begin
                    if (((ws2812bp__ws2812b_flashs ^ fd[ws2812b_flash_speed + 20]) === 1'b1)) begin
                        ws2812bp__ws2812b_flashn = (ws2812bp__ws2812b_flashn - 1);
                    end
                end
            end else if ((ws2812bp__ws2812b_flashnes1 === 1'b1)) begin
                ws2812bp__swok = 0;
                ws2812bp__ws2812b_flashnes1 = (~(ws2812bp__ws2812b_flashnes1));
            end
        end
    end
end
`else
reg ws2812bp__previous_clock;
initial ws2812bp__previous_clock = 1'bx;
always @(ws2812bpck) begin : ws2812bp__vhdl_events
    if ((ws2812bp_reset === 1'b0)) begin
        ws2812bp__swok = 0;
        ws2812bp_ok <= 1'b0;
        ws2812b_loadck <= 1'b0;
        ws2812bp__ws2812b_grb_ok = 1'b0;
    end else if (((ws2812bp__previous_clock === 1'b0) && (ws2812bpck === 1'b1))) begin
        if ((ws2812bp__swok < 2)) begin
            if ((ws2812bp__swok == 0)) begin
                ws2812bp__swok = 1;
                ws2812bp__ws2812b_n1 = (ws2812bp__ws2812b_dirxy[282 - 18*ws2812b_dir +: 6] + ws2812b_xyshift);
                ws2812bp__tds = ws2812bp_time_dn;
                ws2812bp__td = 50000;
                ws2812bp__ws2812b_n = 0;
                ws2812bp__ws2812b_n3 = 7;
                ws2812bp__fd20_27 = fd[ws2812b_flash_speed + 20];
                ws2812breset <= 1'b0;
                if ((ws2812bp_ok === 1'b0)) begin
                    ws2812bp__ws2812b_flashn = ws2812b_flashns;
                    ws2812bp__ws2812b_flashnes1 = ws2812b_flashnes;
                    ws2812bp__ws2812b_flashs = fd[ws2812b_flash_speed + 20];
                end
            end else begin
                if ((ws2812bp__ws2812b_n == 64)) begin
                    if ((ws2812b_emitter_ok === 1'b0)) begin
                        if (((ws2812bp__tds == 0) || (ws2812bp_ok === 1'b1))) begin
                            ws2812bp_ok <= 1'b1;
                            ws2812bp__swok = 2;
                            ws2812bp__fd20_27 = fd[ws2812b_flash_speed + 20];
                        end else begin
                            ws2812bp__td = (ws2812bp__td - 1);
                            if ((ws2812bp__td == 0)) begin
                                ws2812bp__tds = (ws2812bp__tds - 1);
                                ws2812bp__td = 50000;
                            end
                        end
                    end
                end else begin
                    if ((ws2812bp__ws2812b_grb_ok === 1'b0)) begin
                        ws2812breset <= 1'b1;
                        case (ws2812bp_ms)
                            0: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_colorsc1 +: 8], ws2812b_8basecolor[376 - 24*ws2812b_colorsc1 +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_colorsc1 +: 8]};
                            end
                            1: begin
                                if ((ws2812b_64[-64*ws2812b_64p + ws2812bp__ws2812b_n1 + 64] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b1_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b1_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b1_colori +: 8]};
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b0_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b0_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b0_colori +: 8]};
                                end
                            end
                            2: begin
                                if ((ws2812b_8x8[((64 - 64*ws2812b_8x8p)+(((7)-((ws2812bp__ws2812b_n1 / 8)))*(8)))+((((ws2812bp__ws2812b_n1 % 8))-(0))*(1))] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b1_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b1_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b1_colori +: 8]};
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b0_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b0_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b0_colori +: 8]};
                                end
                            end
                            3: begin
                                if ((ws2812b_16x4[((64 - 64*ws2812b_16x4p)+(((3)-((ws2812bp__ws2812b_n1 / 16)))*(16)))+((((ws2812bp__ws2812b_n1 % 16))-(0))*(1))] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b1_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b1_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b1_colori +: 8]};
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812b_b0_colori +: 8], ws2812b_8basecolor[376 - 24*ws2812b_b0_colori +: 8]}, ws2812b_8basecolor[360 - 24*ws2812b_b0_colori +: 8]};
                                end
                            end
                            4: begin
                                ws2812bp__rgbn = ws2812b_8crgb[(0)+(((7)-({{(32-(3)){1'b0}}, ws2812b_rgb3bitx64[-192*ws2812b_rgb3bitx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]}))*(3)) +: 3];
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812bp__rgbn +: 8], ws2812b_8basecolor[376 - 24*ws2812bp__rgbn +: 8]}, ws2812b_8basecolor[360 - 24*ws2812bp__rgbn +: 8]};
                            end
                            5: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[((0)+(((15)-(ws2812b_8crgb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(8) +: 8], ws2812b_8basecolor[((0)+(((15)-(ws2812b_8crgb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(16) +: 8]}, ws2812b_8basecolor[((0)+(((15)-(ws2812b_8crgb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(0) +: 8]};
                            end
                            6: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[((0)+(((15)-(ws2812b_rgb3bittnx64[-192*ws2812b_rgb3bittnx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]))*(24)))+(8) +: 8], ws2812b_8basecolor[((0)+(((15)-(ws2812b_rgb3bittnx64[-192*ws2812b_rgb3bittnx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]))*(24)))+(16) +: 8]}, ws2812b_8basecolor[((0)+(((15)-(ws2812b_rgb3bittnx64[-192*ws2812b_rgb3bittnx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]))*(24)))+(0) +: 8]};
                            end
                            7: begin
                                ws2812bp__rgbn = ws2812b_8cgrb[(0)+(((7)-({{(32-(3)){1'b0}}, ws2812b_grb3bitx64[-192*ws2812b_grb3bitx64p - 3*ws2812bp__ws2812b_n1 + 381 +: 3]}))*(3)) +: 3];
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[368 - 24*ws2812bp__rgbn +: 8], ws2812b_8basecolor[376 - 24*ws2812bp__rgbn +: 8]}, ws2812b_8basecolor[360 - 24*ws2812bp__rgbn +: 8]};
                            end
                            8: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8basecolor[((0)+(((15)-(ws2812b_8cgrb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(8) +: 8], ws2812b_8basecolor[((0)+(((15)-(ws2812b_8cgrb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(16) +: 8]}, ws2812b_8basecolor[((0)+(((15)-(ws2812b_8cgrb[(0)+(((7)-(ws2812b_rgb3bitnx64[-192*ws2812b_rgb3bitnx64p - 3*ws2812bp__ws2812b_n1 + 573 +: 3]))*(3)) +: 3]))*(24)))+(0) +: 8]};
                            end
                            9: begin
                                ws2812bp__mx16_1 = ws2812b_8r8g_8b16bit[-2048*ws2812b_8r8g_8b16bitp - 32*ws2812bp__ws2812b_n1 + 4080 +: 16];
                                ws2812bp__mx16_2 = ws2812b_8r8g_8b16bit[-2048*ws2812b_8r8g_8b16bitp - 32*ws2812bp__ws2812b_n1 + 4064 +: 16];
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812bp__mx16_1[0 +: 8], ws2812bp__mx16_1[8 +: 8]}, ws2812bp__mx16_2[8 +: 8]};
                            end
                            10: begin
                                ws2812bp__ws2812b_ledgrbdatas = ws2812b_8g8r8b24bit[-1536*ws2812b_8g8r8b24bitp - 24*ws2812bp__ws2812b_n1 + 3048 +: 24];
                            end
                            11: begin
                                ws2812bp__ws2812b_ledgrbdatas = {{ws2812b_8r8g8b24bit[-1536*ws2812b_8r8g8b24bitp - 24*ws2812bp__ws2812b_n1 + 3056 +: 8], ws2812b_8r8g8b24bit[-1536*ws2812b_8r8g8b24bitp - 24*ws2812bp__ws2812b_n1 + 3064 +: 8]}, ws2812b_8r8g8b24bit[-1536*ws2812b_8r8g8b24bitp - 24*ws2812bp__ws2812b_n1 + 3048 +: 8]};
                            end
                            default: begin
                            end
                        endcase
                        ws2812bp__ws2812b_grb_ok = 1'b1;
                        ws2812bp__ws2812b_flash_adds2 = 0;
                        if ((ws2812b_flash_enable === 1'b1)) begin
                            if (((ws2812bp__fd20_27 ^ ws2812bp__ws2812b_flashs) === 1'b1)) begin
                                ws2812bp__ws2812b_flash_adds2 = ws2812b_flash_adds;
                            end
                        end else begin
                            ws2812bp__ws2812b_flash_adds2 = ws2812b_flash_adds;
                        end
                        case (ws2812bp__ws2812b_flash_adds2)
                            1: begin
                                if ((ws2812b_flash_add[63 - ws2812bp__ws2812b_n1] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end
                            end
                            2: begin
                                if ((ws2812b_flash_add[63 - ws2812bp__ws2812b_n] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end
                            end
                            3: begin
                                if ((ws2812b_flash_add[63 - ws2812bp__ws2812b_n1] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord2;
                                end
                            end
                            4: begin
                                if ((ws2812b_flash_add[63 - ws2812bp__ws2812b_n] === 1'b1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end else begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord2;
                                end
                            end
                            5: begin
                                if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_colors1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end
                            end
                            6: begin
                                if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_colors1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end else if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_colors2)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord2;
                                end
                            end
                            7: begin
                                if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_colors1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end
                            end
                            8: begin
                                if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_colors1)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord1;
                                end else if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_colors2)) begin
                                    ws2812bp__ws2812b_ledgrbdatas = ws2812b_colord2;
                                end
                            end
                            default: begin
                            end
                        endcase
                        if ((ws2812b_mask_enable === 1'b1)) begin
                            ws2812bp__ws2812b_mask_adds2 = 0;
                            if (((ws2812b_mask_adds == 1) && (ws2812b_mask_add[63 - ws2812bp__ws2812b_n1] === 1'b1))) begin
                                ws2812bp__ws2812b_mask_adds2 = 1;
                            end else if (((ws2812b_mask_adds == 2) && (ws2812b_mask_add[63 - ws2812bp__ws2812b_n] === 1'b1))) begin
                                ws2812bp__ws2812b_mask_adds2 = 1;
                            end
                            if ((ws2812bp__ws2812b_mask_adds2 != 0)) begin
                                ws2812bp__ws2812b_mask_ms2 = 0;
                                if ((ws2812b_maskcolors1or2 == 0)) begin
                                    ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                end else if ((ws2812b_maskcolors1or2 == 1)) begin
                                    if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_maskcolors1)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end
                                end else if ((ws2812b_maskcolors1or2 == 2)) begin
                                    if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_maskcolors1)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end else if ((ws2812bp__ws2812b_ledgrbdatas == ws2812b_maskcolors2)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end
                                end else if ((ws2812b_maskcolors1or2 == 3)) begin
                                    if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_maskcolors1)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end
                                end else if ((ws2812b_maskcolors1or2 == 4)) begin
                                    if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_maskcolors1)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end else if ((ws2812bp__ws2812b_ledgrbdatas != ws2812b_maskcolors2)) begin
                                        ws2812bp__ws2812b_mask_ms2 = ws2812b_mask_ms;
                                    end
                                end
                                case (ws2812bp__ws2812b_mask_ms2)
                                    1: begin
                                        ws2812bp__ws2812b_ledgrbdatas = (~(ws2812bp__ws2812b_ledgrbdatas));
                                    end
                                    2: begin
                                        ws2812bp__ws2812b_ledgrbdatas = (ws2812bp__ws2812b_ledgrbdatas & {{ws2812b_mask_g, ws2812b_mask_r}, ws2812b_mask_b});
                                    end
                                    3: begin
                                        if ((ws2812bp__ws2812b_ledgrbdatas[16 +: 8] != 0)) begin
                                            ws2812bp__ws2812b_ledgrbdatas[16 +: 8] = (ws2812bp__ws2812b_ledgrbdatas[16 +: 8] | ws2812b_mask_g);
                                        end
                                        if ((ws2812bp__ws2812b_ledgrbdatas[8 +: 8] != 0)) begin
                                            ws2812bp__ws2812b_ledgrbdatas[8 +: 8] = (ws2812bp__ws2812b_ledgrbdatas[8 +: 8] | ws2812b_mask_r);
                                        end
                                        if ((ws2812bp__ws2812b_ledgrbdatas[0 +: 8] != 0)) begin
                                            ws2812bp__ws2812b_ledgrbdatas[16 +: 8] = (ws2812bp__ws2812b_ledgrbdatas[16 +: 8] | ws2812b_mask_g);
                                        end
                                    end
                                    4: begin
                                        ws2812bp__ws2812b_ledgrbdatas = (ws2812bp__ws2812b_ledgrbdatas ^ {{ws2812b_mask_g, ws2812b_mask_r}, ws2812b_mask_b});
                                    end
                                    default: begin
                                    end
                                endcase
                            end
                        end
                        ws2812b_ledgrbdata <= ws2812bp__ws2812b_ledgrbdatas;
                        if ((ws2812bp__ws2812b_n3 == 0)) begin
                            ws2812bp__ws2812b_n1 = (ws2812bp__ws2812b_n1 + ws2812bp__ws2812b_dirxy[270 - 18*ws2812b_dir +: 6]);
                        end else begin
                            ws2812bp__ws2812b_n1 = (ws2812bp__ws2812b_n1 + ws2812bp__ws2812b_dirxy[276 - 18*ws2812b_dir +: 6]);
                        end
                        ws2812bp__ws2812b_n3 = (ws2812bp__ws2812b_n3 - 1);
                    end else if ((ws2812b_loadck === 1'b0)) begin
                        ws2812b_loadck <= 1'b1;
                    end else begin
                        ws2812b_loadck <= 1'b0;
                        ws2812bp__ws2812b_n = (ws2812bp__ws2812b_n + 1);
                        ws2812bp__ws2812b_grb_ok = 1'b0;
                    end
                end
            end
        end else if (((ws2812b_flash_enable === 1'b1) && (fd[ws2812b_flash_speed + 20] !== ws2812bp__fd20_27))) begin
            if ((ws2812bp__ws2812b_flashn != 0)) begin
                ws2812bp__swok = 0;
                if ((ws2812bp__ws2812b_flashn != 15)) begin
                    if (((ws2812bp__ws2812b_flashs ^ fd[ws2812b_flash_speed + 20]) === 1'b1)) begin
                        ws2812bp__ws2812b_flashn = (ws2812bp__ws2812b_flashn - 1);
                    end
                end
            end else if ((ws2812bp__ws2812b_flashnes1 === 1'b1)) begin
                ws2812bp__swok = 0;
                ws2812bp__ws2812b_flashnes1 = (~(ws2812bp__ws2812b_flashnes1));
            end
        end
    end
    ws2812bp__previous_clock = ws2812bpck;
end
`endif

assign st7735_x0 = ((((st7735_data[56 +: 8] > 0) || (remove_leading_0 === 1'b0)) || (d0_setn == 1))) ? 0 : (((st7735_data[48 +: 8] > 0) || (d0_setn == 2))) ? 1 : (((st7735_data[40 +: 8] > 0) || (d0_setn == 3))) ? 2 : (((st7735_data[32 +: 8] > 0) || (d0_setn == 4))) ? 3 : (((st7735_data[24 +: 8] > 0) || (d0_setn == 5))) ? 4 : (((st7735_data[16 +: 8] > 0) || (d0_setn == 6))) ? 5 : (((st7735_data[8 +: 8] > 0) || (d0_setn == 7))) ? 6 : 7;
assign befriendc_pp = (((isword == 1'b0) && (monoc == 1))) ? (((befriendc_p + st7735_xinc1_c) + (shift_y * word_w)) + shift_x) : ((isword == 1'b0)) ? (((befriendc_p + st7735_xinc1_m) + (shift_y * w_w_b)) + (shift_x / 16)) : (((befriendc_p + ((st7735_data[(0)+(((7)-((st7735_x / w_w_b)))*(8)) +: 8] * w_w_b) * ((st7735_data_rpointer_end - st7735_data_rpointer_begin) + 1))) + (st7735_x % w_w_b)) + (st7735_y * w_w_b));
assign gdata1 = (((isword == 1'b0) || (isword && ((st7735_x / w_w_b) >= st7735_x0)))) ? q : {16{1'b0}};
assign gdata565 = q;
assign fc2[16 +: 8] = {3'b000, gdata565[11 +: 5]};
assign fc2[8 +: 8] = {2'b00, gdata565[5 +: 6]};
assign fc2[0 +: 8] = {3'b000, gdata565[0 +: 5]};
assign gdata2 = (((st7735_yy1 == st7735_y) || (st7735_yy2 == st7735_y))) ? {16{1'b1}} : {16{1'b0}};
assign gdata3 = ((st7735_xx1 == st7735_x)) ? st7735_vl1 : ((st7735_xx2 == st7735_x)) ? st7735_vl2 : {16{1'b0}};
assign gdata = ((st7735_ch == 4'b0000)) ? gdata0 : ((st7735_ch == 4'b0001)) ? gdata1 : ((st7735_ch == 4'b0010)) ? gdata2 : ((st7735_ch == 4'b0011)) ? gdata3 : ((st7735_ch == 4'b0100)) ? gdata4 : ((st7735_ch == 4'b0101)) ? gdata5 : ((st7735_ch == 4'b0110)) ? gdata6 : ((st7735_ch == 4'b0111)) ? gdata7 : ((st7735_ch == 4'b1000)) ? 16'b1111111111111111 : ((st7735_ch == 4'b1001)) ? gdata9 : gdata10;
assign cbi = cbis;
assign fcri = ((monoc == 0)) ? st7735_8basecolor[376 - 24*b1_colori +: 8] : fc2[16 +: 8];
assign fcgi = ((monoc == 0)) ? st7735_8basecolor[368 - 24*b1_colori +: 8] : fc2[8 +: 8];
assign fcbi = ((monoc == 0)) ? st7735_8basecolor[360 - 24*b1_colori +: 8] : fc2[0 +: 8];
assign bcri = ((monoc == 0)) ? st7735_8basecolor[376 - 24*b0_colori +: 8] : bc2[16 +: 8];
assign bcgi = ((monoc == 0)) ? st7735_8basecolor[368 - 24*b0_colori +: 8] : bc2[16 +: 8];
assign bcbi = ((monoc == 0)) ? st7735_8basecolor[360 - 24*b0_colori +: 8] : bc2[16 +: 8];
assign d8_1i = (((isword && ((word_w % 16) != 0)) && ((st7735_x % w_w_b) == (w_w_b - 1)))) ? (word_w % 16) : ((((st7735_data_cpointer + st7735_data_c_inc) - 1) <= st7735_data_cpointer_end)) ? st7735_data_c_inc : ((st7735_data_cpointer_end - st7735_data_cpointer) + 1);
assign shift_hdni = (((st7735_x == 0) && (monoc == 0))) ? (shift_x % 16) : 0;
assign w_w_b = (((word_w % 16) == 0)) ? (word_w / 16) : ((word_w / 16) + 1);
assign cmpai = ((dci[1] === 1'b0)) ? {8'b00000000, st7735_it[216 - 8*st7735_com_pointer +: 8]} : gdata;
assign st7735_com_pn0 = ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'h26)) ? 1 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'h2A)) ? 4 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'h2B)) ? 4 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'h2C)) ? 31 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'h30)) ? 4 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'h36)) ? 1 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'h3A)) ? 1 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hB1)) ? 3 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hB2)) ? 3 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hB3)) ? 6 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hB4)) ? 1 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hB6)) ? 2 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hC0)) ? 2 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hC1)) ? 1 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hC2)) ? 4 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hC3)) ? 4 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hC4)) ? 2 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hC5)) ? 2 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hC7)) ? 1 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hE0)) ? 16 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hE1)) ? 16 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hFC)) ? 2 : ((st7735_it[216 - 8*st7735_com_pointer +: 8] == 8'hFF)) ? 3 : 0;
assign st7735_clk = sclk;
assign st7735_p_clk = sclk;
// st7735_p
`ifdef SYNTHESIS
always @(posedge st7735_p_clk or negedge st7735_p_reset) begin : st7735_p
    if ((st7735_p_reset === 1'b0)) begin
        st7735_reset <= 1'b0;
        st7735_com_pointer <= st7735_com_pointers;
        st7735_loadck <= 1'b0;
        st7735_com_pn <= st7735_com_pn0;
        st7735_p__sw = 1'b1;
        if ((st7735_com_pn0 == 31)) begin
            st7735_p__sw = 1'b0;
        end
        st7735_x <= 0;
        st7735_y <= 0;
        st7735_xincn <= 0;
        st7735_xinc1 <= 0;
        st7735_xinc1_c <= 0;
        st7735_xinc1_m <= 0;
        st7735_p_ok <= 1'b0;
        st7735_p__swok = 1'b0;
        dci <= 2'b00;
        st7735_p__td = st7735_time_dn;
    end else if (1'b1) begin
        st7735_loadck <= 1'b0;
        if ((st7735_p__swok === 1'b1)) begin
            if ((st7735_p__td == 0)) begin
                st7735_p_ok <= 1'b1;
            end else begin
                st7735_p__td = (st7735_p__td - 1);
            end
        end else if ((st7735_reset === 1'b0)) begin
            st7735_reset <= 1'b1;
            st7735_data_cpointer <= st7735_data_cpointer_begin;
            st7735_data_rpointer <= st7735_data_rpointer_begin;
        end else if (((st7735_com_pointer < 28) && (st7735_com_pn != 31))) begin
            if ((st7735_com_pn == 0)) begin
                dci <= 2'b00;
            end else begin
                dci <= 2'b01;
            end
            if ((st7735_p__sw == 1'b1)) begin
                st7735_com_pointer <= (st7735_com_pointer + 1);
                st7735_p__sw = 1'b0;
            end else if ((st7735_reload === 1'b0)) begin
                st7735_loadck <= 1'b1;
                st7735_p__sw = 1'b1;
                if ((st7735_com_pn != 0)) begin
                    st7735_com_pn <= (st7735_com_pn - 1);
                end else begin
                    st7735_com_pn <= st7735_com_pn0;
                    if ((st7735_com_pn0 == 31)) begin
                        st7735_p__sw = 1'b0;
                    end
                end
            end
        end else if ((st7735_com_pn != 31)) begin
            st7735_p__swok = st7735_spi_ok;
        end else if ((st7735_data_rpointer <= st7735_data_rpointer_end)) begin
            dci <= 2'b11;
            if (st7735_p__sw) begin
                if (((isword && ((word_w % 16) != 0)) && ((st7735_x % w_w_b) == (w_w_b - 1)))) begin
                    st7735_data_cpointer <= (st7735_data_cpointer + (word_w % 16));
                    st7735_xincn <= (st7735_xincn + (word_w % 16));
                end else begin
                    if ((monoc == 0)) begin
                        if ((st7735_x == 0)) begin
                            st7735_data_cpointer <= ((st7735_data_cpointer + st7735_data_c_inc) - (shift_x % 16));
                            st7735_xincn <= ((st7735_xincn + st7735_data_c_inc) - (shift_x % 16));
                        end else begin
                            st7735_data_cpointer <= (st7735_data_cpointer + st7735_data_c_inc);
                            st7735_xincn <= (st7735_xincn + st7735_data_c_inc);
                        end
                    end else begin
                        st7735_data_cpointer <= (st7735_data_cpointer + st7735_data_c_inc);
                        st7735_xincn <= (st7735_xincn + st7735_data_c_inc);
                    end
                end
                st7735_x <= (st7735_x + 1);
                st7735_xinc1 <= (st7735_xinc1 + 1);
                st7735_xinc1_c <= (st7735_xinc1_c + 1);
                st7735_xinc1_m <= (st7735_xinc1_m + 1);
                if (((st7735_data_cpointer + st7735_data_c_inc) > st7735_data_cpointer_end)) begin
                    st7735_data_cpointer <= st7735_data_cpointer_begin;
                    st7735_xincn <= 0;
                    st7735_x <= 0;
                    st7735_data_rpointer <= (st7735_data_rpointer + 1);
                    st7735_y <= (st7735_y + 1);
                    st7735_xinc1_c <= ((st7735_y + 1) * word_w);
                    st7735_xinc1_m <= ((st7735_y + 1) * w_w_b);
                end
                st7735_p__sw = 1'b0;
            end else if (((st7735_reload === 1'b0) && (dci == 2'b11))) begin
                st7735_loadck <= 1'b1;
                st7735_p__sw = 1'b1;
            end
        end else begin
            st7735_p__swok = st7735_spi_ok;
        end
    end
end
`else
reg st7735_p__previous_clock;
initial st7735_p__previous_clock = 1'bx;
always @(st7735_p_clk or st7735_p_reset) begin : st7735_p__vhdl_events
    if ((st7735_p_reset === 1'b0)) begin
        st7735_reset <= 1'b0;
        st7735_com_pointer <= st7735_com_pointers;
        st7735_loadck <= 1'b0;
        st7735_com_pn <= st7735_com_pn0;
        st7735_p__sw = 1'b1;
        if ((st7735_com_pn0 == 31)) begin
            st7735_p__sw = 1'b0;
        end
        st7735_x <= 0;
        st7735_y <= 0;
        st7735_xincn <= 0;
        st7735_xinc1 <= 0;
        st7735_xinc1_c <= 0;
        st7735_xinc1_m <= 0;
        st7735_p_ok <= 1'b0;
        st7735_p__swok = 1'b0;
        dci <= 2'b00;
        st7735_p__td = st7735_time_dn;
    end else if (((st7735_p__previous_clock === 1'b0) && (st7735_p_clk === 1'b1))) begin
        st7735_loadck <= 1'b0;
        if ((st7735_p__swok === 1'b1)) begin
            if ((st7735_p__td == 0)) begin
                st7735_p_ok <= 1'b1;
            end else begin
                st7735_p__td = (st7735_p__td - 1);
            end
        end else if ((st7735_reset === 1'b0)) begin
            st7735_reset <= 1'b1;
            st7735_data_cpointer <= st7735_data_cpointer_begin;
            st7735_data_rpointer <= st7735_data_rpointer_begin;
        end else if (((st7735_com_pointer < 28) && (st7735_com_pn != 31))) begin
            if ((st7735_com_pn == 0)) begin
                dci <= 2'b00;
            end else begin
                dci <= 2'b01;
            end
            if ((st7735_p__sw == 1'b1)) begin
                st7735_com_pointer <= (st7735_com_pointer + 1);
                st7735_p__sw = 1'b0;
            end else if ((st7735_reload === 1'b0)) begin
                st7735_loadck <= 1'b1;
                st7735_p__sw = 1'b1;
                if ((st7735_com_pn != 0)) begin
                    st7735_com_pn <= (st7735_com_pn - 1);
                end else begin
                    st7735_com_pn <= st7735_com_pn0;
                    if ((st7735_com_pn0 == 31)) begin
                        st7735_p__sw = 1'b0;
                    end
                end
            end
        end else if ((st7735_com_pn != 31)) begin
            st7735_p__swok = st7735_spi_ok;
        end else if ((st7735_data_rpointer <= st7735_data_rpointer_end)) begin
            dci <= 2'b11;
            if (st7735_p__sw) begin
                if (((isword && ((word_w % 16) != 0)) && ((st7735_x % w_w_b) == (w_w_b - 1)))) begin
                    st7735_data_cpointer <= (st7735_data_cpointer + (word_w % 16));
                    st7735_xincn <= (st7735_xincn + (word_w % 16));
                end else begin
                    if ((monoc == 0)) begin
                        if ((st7735_x == 0)) begin
                            st7735_data_cpointer <= ((st7735_data_cpointer + st7735_data_c_inc) - (shift_x % 16));
                            st7735_xincn <= ((st7735_xincn + st7735_data_c_inc) - (shift_x % 16));
                        end else begin
                            st7735_data_cpointer <= (st7735_data_cpointer + st7735_data_c_inc);
                            st7735_xincn <= (st7735_xincn + st7735_data_c_inc);
                        end
                    end else begin
                        st7735_data_cpointer <= (st7735_data_cpointer + st7735_data_c_inc);
                        st7735_xincn <= (st7735_xincn + st7735_data_c_inc);
                    end
                end
                st7735_x <= (st7735_x + 1);
                st7735_xinc1 <= (st7735_xinc1 + 1);
                st7735_xinc1_c <= (st7735_xinc1_c + 1);
                st7735_xinc1_m <= (st7735_xinc1_m + 1);
                if (((st7735_data_cpointer + st7735_data_c_inc) > st7735_data_cpointer_end)) begin
                    st7735_data_cpointer <= st7735_data_cpointer_begin;
                    st7735_xincn <= 0;
                    st7735_x <= 0;
                    st7735_data_rpointer <= (st7735_data_rpointer + 1);
                    st7735_y <= (st7735_y + 1);
                    st7735_xinc1_c <= ((st7735_y + 1) * word_w);
                    st7735_xinc1_m <= ((st7735_y + 1) * w_w_b);
                end
                st7735_p__sw = 1'b0;
            end else if (((st7735_reload === 1'b0) && (dci == 2'b11))) begin
                st7735_loadck <= 1'b1;
                st7735_p__sw = 1'b1;
            end
        end else begin
            st7735_p__swok = st7735_spi_ok;
        end
    end
    st7735_p__previous_clock = st7735_p_clk;
end
`endif

assign m701 = {{{{{{{m70s[4], m70s[7]}, m70s[10]}, m70s[13]}, m70s[16]}, m70s[19]}, m70s[22]}, m70s[25]};
assign m702 = {{{{{{{m70s[5], m70s[8]}, m70s[11]}, m70s[14]}, m70s[17]}, m70s[20]}, m70s[23]}, m70s[26]};
assign sw_clk = fd[18];
// Sequential logic
`ifdef SYNTHESIS
always @(posedge sw_clk) begin : sequential_5
    integer i;
    for (i = 0; i <= 8; i = i + 1) begin
        if ((m7_0[i] === m70s[26 - 3*i])) begin
            m70s[24 - 3*i +: 3] <= {m70s[26 - 3*i], 2'b00};
        end else if (1'b1) begin
            m70s[24 - 3*i +: 3] <= (m70s[24 - 3*i +: 3] + 1);
        end
    end
end
`else
reg sequential_5__previous_clock;
initial sequential_5__previous_clock = 1'bx;
always @(sw_clk) begin : sequential_5__vhdl_events
    integer i;
    for (i = 0; i <= 8; i = i + 1) begin
        if ((m7_0[i] === m70s[26 - 3*i])) begin
            m70s[24 - 3*i +: 3] <= {m70s[26 - 3*i], 2'b00};
        end else if (((sequential_5__previous_clock === 1'b0) && (sw_clk === 1'b1))) begin
            m70s[24 - 3*i +: 3] <= (m70s[24 - 3*i +: 3] + 1);
        end
    end
    sequential_5__previous_clock = sw_clk;
end
`endif

// freq_div
`ifdef SYNTHESIS
always @(posedge sclk) begin : freq_div
    if ((s_reset === 1'b0)) begin
        fd <= {28{1'b0}};
        ws2812bclk <= 1'b0;
    end else if (1'b1) begin
        fd <= (fd + 1);
        if ((fd2 == 6)) begin
            fd2 <= {4{1'b0}};
            ws2812bclk <= (~(ws2812bclk));
        end else begin
            fd2 <= (fd2 + 1);
        end
    end
end
`else
reg freq_div__previous_clock;
initial freq_div__previous_clock = 1'bx;
always @(sclk) begin : freq_div__vhdl_events
    if ((s_reset === 1'b0)) begin
        fd <= {28{1'b0}};
        ws2812bclk <= 1'b0;
    end else if (((freq_div__previous_clock === 1'b0) && (sclk === 1'b1))) begin
        fd <= (fd + 1);
        if ((fd2 == 6)) begin
            fd2 <= {4{1'b0}};
            ws2812bclk <= (~(ws2812bclk));
        end else begin
            fd2 <= (fd2 + 1);
        end
    end
    freq_div__previous_clock = sclk;
end
`endif

assign st7735_it[8] = st7735_it__initial[8];
assign st7735_it[9] = st7735_it__initial[9];
assign st7735_it[10] = st7735_it__initial[10];
assign st7735_it[11] = st7735_it__initial[11];
assign st7735_it[12] = st7735_it__initial[12];
assign st7735_it[13] = st7735_it__initial[13];
assign st7735_it[14] = st7735_it__initial[14];
assign st7735_it[15] = st7735_it__initial[15];
assign st7735_it[24] = st7735_it__initial[24];
assign st7735_it[25] = st7735_it__initial[25];
assign st7735_it[26] = st7735_it__initial[26];
assign st7735_it[27] = st7735_it__initial[27];
assign st7735_it[28] = st7735_it__initial[28];
assign st7735_it[29] = st7735_it__initial[29];
assign st7735_it[30] = st7735_it__initial[30];
assign st7735_it[31] = st7735_it__initial[31];
assign st7735_it[40] = st7735_it__initial[40];
assign st7735_it[41] = st7735_it__initial[41];
assign st7735_it[42] = st7735_it__initial[42];
assign st7735_it[43] = st7735_it__initial[43];
assign st7735_it[44] = st7735_it__initial[44];
assign st7735_it[45] = st7735_it__initial[45];
assign st7735_it[46] = st7735_it__initial[46];
assign st7735_it[47] = st7735_it__initial[47];
assign st7735_it[48] = st7735_it__initial[48];
assign st7735_it[49] = st7735_it__initial[49];
assign st7735_it[50] = st7735_it__initial[50];
assign st7735_it[51] = st7735_it__initial[51];
assign st7735_it[52] = st7735_it__initial[52];
assign st7735_it[53] = st7735_it__initial[53];
assign st7735_it[54] = st7735_it__initial[54];
assign st7735_it[55] = st7735_it__initial[55];
assign st7735_it[64] = st7735_it__initial[64];
assign st7735_it[65] = st7735_it__initial[65];
assign st7735_it[66] = st7735_it__initial[66];
assign st7735_it[67] = st7735_it__initial[67];
assign st7735_it[68] = st7735_it__initial[68];
assign st7735_it[69] = st7735_it__initial[69];
assign st7735_it[70] = st7735_it__initial[70];
assign st7735_it[71] = st7735_it__initial[71];
assign st7735_it[80] = st7735_it__initial[80];
assign st7735_it[81] = st7735_it__initial[81];
assign st7735_it[82] = st7735_it__initial[82];
assign st7735_it[83] = st7735_it__initial[83];
assign st7735_it[84] = st7735_it__initial[84];
assign st7735_it[85] = st7735_it__initial[85];
assign st7735_it[86] = st7735_it__initial[86];
assign st7735_it[87] = st7735_it__initial[87];
assign st7735_it[88] = st7735_it__initial[88];
assign st7735_it[89] = st7735_it__initial[89];
assign st7735_it[90] = st7735_it__initial[90];
assign st7735_it[91] = st7735_it__initial[91];
assign st7735_it[92] = st7735_it__initial[92];
assign st7735_it[93] = st7735_it__initial[93];
assign st7735_it[94] = st7735_it__initial[94];
assign st7735_it[95] = st7735_it__initial[95];
assign st7735_it[104] = st7735_it__initial[104];
assign st7735_it[105] = st7735_it__initial[105];
assign st7735_it[106] = st7735_it__initial[106];
assign st7735_it[107] = st7735_it__initial[107];
assign st7735_it[108] = st7735_it__initial[108];
assign st7735_it[109] = st7735_it__initial[109];
assign st7735_it[110] = st7735_it__initial[110];
assign st7735_it[111] = st7735_it__initial[111];
assign st7735_it[120] = st7735_it__initial[120];
assign st7735_it[121] = st7735_it__initial[121];
assign st7735_it[122] = st7735_it__initial[122];
assign st7735_it[123] = st7735_it__initial[123];
assign st7735_it[124] = st7735_it__initial[124];
assign st7735_it[125] = st7735_it__initial[125];
assign st7735_it[126] = st7735_it__initial[126];
assign st7735_it[127] = st7735_it__initial[127];
assign st7735_it[136] = st7735_it__initial[136];
assign st7735_it[137] = st7735_it__initial[137];
assign st7735_it[138] = st7735_it__initial[138];
assign st7735_it[139] = st7735_it__initial[139];
assign st7735_it[140] = st7735_it__initial[140];
assign st7735_it[141] = st7735_it__initial[141];
assign st7735_it[142] = st7735_it__initial[142];
assign st7735_it[143] = st7735_it__initial[143];
assign st7735_it[144] = st7735_it__initial[144];
assign st7735_it[145] = st7735_it__initial[145];
assign st7735_it[146] = st7735_it__initial[146];
assign st7735_it[147] = st7735_it__initial[147];
assign st7735_it[148] = st7735_it__initial[148];
assign st7735_it[149] = st7735_it__initial[149];
assign st7735_it[150] = st7735_it__initial[150];
assign st7735_it[151] = st7735_it__initial[151];
assign st7735_it[184] = st7735_it__initial[184];
assign st7735_it[185] = st7735_it__initial[185];
assign st7735_it[186] = st7735_it__initial[186];
assign st7735_it[187] = st7735_it__initial[187];
assign st7735_it[188] = st7735_it__initial[188];
assign st7735_it[189] = st7735_it__initial[189];
assign st7735_it[190] = st7735_it__initial[190];
assign st7735_it[191] = st7735_it__initial[191];
assign st7735_it[200] = st7735_it__initial[200];
assign st7735_it[201] = st7735_it__initial[201];
assign st7735_it[202] = st7735_it__initial[202];
assign st7735_it[203] = st7735_it__initial[203];
assign st7735_it[204] = st7735_it__initial[204];
assign st7735_it[205] = st7735_it__initial[205];
assign st7735_it[206] = st7735_it__initial[206];
assign st7735_it[207] = st7735_it__initial[207];
assign st7735_it[208] = st7735_it__initial[208];
assign st7735_it[209] = st7735_it__initial[209];
assign st7735_it[210] = st7735_it__initial[210];
assign st7735_it[211] = st7735_it__initial[211];
assign st7735_it[212] = st7735_it__initial[212];
assign st7735_it[213] = st7735_it__initial[213];
assign st7735_it[214] = st7735_it__initial[214];
assign st7735_it[215] = st7735_it__initial[215];
assign st7735_it[216] = st7735_it__initial[216];
assign st7735_it[217] = st7735_it__initial[217];
assign st7735_it[218] = st7735_it__initial[218];
assign st7735_it[219] = st7735_it__initial[219];
assign st7735_it[220] = st7735_it__initial[220];
assign st7735_it[221] = st7735_it__initial[221];
assign st7735_it[222] = st7735_it__initial[222];
assign st7735_it[223] = st7735_it__initial[223];
endmodule
`default_nettype wire
