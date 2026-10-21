// Verilog-2001 translation of ads1115_16bit_i2c_driver.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module ads1115_16bit_i2c_driver (
    input wire i2cclk,
    input wire reset,
    input wire s_reset,
    input wire [1:0] ads1115_addr,
    input wire ads1115_alert_rdy,
    output wire scl,
    inout wire sda,
    input wire [7:0] ads1115_input_mux,
    input wire [23:0] ads1115_input_fsr_pga,
    input wire [23:0] ads1115_input_dr,
    input wire ads1115_uploadck,
    output reg ads1115_loadck,
    output reg ads1115upload,
    output wire [15:0] ads1115_adc_16bit,
    output reg ads1115_ok
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

reg [7:0] addr;
wire [7:0] datain;
reg [7:0] dataout;
reg rw;
wire [3:0] rwn;
reg [5:0] d_w_r_n;
reg d_w_r_nok;
reg rewr;
reg [29:0] wdata;
reg [40:0] rdata;
reg i2c_reset;
reg i2creset;
reg scls;
reg sdas;
reg i2cok;
reg i2cs;
reg [1:0] i;
reg [4:0] wn;
reg [4:0] wnend;
reg [5:0] rn;
reg [5:0] rns;
reg [4:0] pn;
reg [3:0] rwns;
reg [5:0] d_w_r_ns;
wire [6:0] i2c_addr;
reg sw;
reg swreset;
reg [127:0] ads1115_c_d;
reg [3:0] ads1115_c_d_p;
reg [3:0] ads1115loadp;
reg ads1115loads;
reg [3:0] isini;
reg [3:0] chn;
reg [127:0] ads1115_chn;
reg [7:0] ads1115_input_muxs;

initial d_w_r_n = 0;
initial i = 0;
initial wn = 0;
initial wnend = 0;
initial rn = 0;
initial rns = 0;
initial pn = 0;
initial rwns = 0;
initial d_w_r_ns = 0;
initial sw = 1'b0;
initial swreset = 1'b0;
initial ads1115_c_d = {16{8'h00}};
initial ads1115_c_d_p = 0;
initial ads1115loadp = 0;
initial ads1115loads = 1'b0;
initial isini = 0;
initial chn = 0;
initial ads1115_chn = {8{16'h0000}};

assign i2c_addr = {5'b10010, ads1115_addr};
assign datain = ads1115_c_d[120 - 8*ads1115_c_d_p +: 8];
// Sequential logic
`ifdef SYNTHESIS
always @(posedge i2cclk or negedge reset or negedge s_reset) begin : sequential_0
    if (((reset === 1'b0) || (s_reset === 1'b0))) begin
        sw <= 1'b0;
        ads1115_input_muxs <= ads1115_input_mux;
        i2c_reset <= 1'b0;
        ads1115loads <= 1'b0;
        if ((s_reset === 1'b0)) begin
            swreset <= 1'b1;
        end
        if (swreset) begin
            isini <= 0;
        end else begin
            isini <= 2;
        end
        ads1115_ok <= 1'b0;
    end else if (1'b1) begin
        if (sw) begin
            if ((d_w_r_n > 0)) begin
                if ((d_w_r_nok === 1'b0)) begin
                    i2c_reset <= 1'b1;
                    rewr <= 1'b0;
                end else if ((rewr === 1'b0)) begin
                    ads1115_c_d_p <= (ads1115_c_d_p + 1);
                    if ((rw === 1'b1)) begin
                        ads1115_chn[112 - 16*chn +: 16] <= {ads1115_chn[112 - 16*chn +: 8], dataout};
                    end
                    d_w_r_n <= (d_w_r_n - 1);
                    rewr <= 1'b1;
                end
            end else begin
                if ((isini == 3)) begin
                    ads1115_input_muxs[chn] <= 1'b0;
                end
                i2c_reset <= 1'b0;
                sw <= 1'b0;
            end
        end else begin
            ads1115_c_d_p <= 0;
            if ((isini == 0)) begin
                addr <= 8'b00000011;
                ads1115_c_d[120 +: 8] <= 8'b10000000;
                ads1115_c_d[112 +: 8] <= 8'b00000000;
                rw <= 1'b0;
                d_w_r_n <= 2;
                isini <= 1;
                sw <= 1'b1;
            end else if ((isini == 1)) begin
                addr <= 8'b00000010;
                ads1115_c_d[120 +: 8] <= 8'b00000000;
                ads1115_c_d[112 +: 8] <= 8'b00000000;
                rw <= 1'b0;
                d_w_r_n <= 2;
                isini <= 2;
                sw <= 1'b1;
            end else if ((isini == 2)) begin
                addr <= 8'b00000001;
                rw <= 1'b0;
                d_w_r_n <= 2;
                isini <= 3;
                sw <= 1'b1;
                if ((ads1115_input_muxs[0] === 1'b1)) begin
                    chn <= 0;
                    ads1115_c_d[120 +: 8] <= {{4'b1000, ads1115_input_fsr_pga[0 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[0 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[1] === 1'b1)) begin
                    chn <= 1;
                    ads1115_c_d[120 +: 8] <= {{4'b1001, ads1115_input_fsr_pga[3 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[3 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[2] === 1'b1)) begin
                    chn <= 2;
                    ads1115_c_d[120 +: 8] <= {{4'b1010, ads1115_input_fsr_pga[6 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[6 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[3] === 1'b1)) begin
                    chn <= 3;
                    ads1115_c_d[120 +: 8] <= {{4'b1011, ads1115_input_fsr_pga[9 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[9 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[4] === 1'b1)) begin
                    chn <= 4;
                    ads1115_c_d[120 +: 8] <= {{4'b1100, ads1115_input_fsr_pga[12 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[12 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[5] === 1'b1)) begin
                    chn <= 5;
                    ads1115_c_d[120 +: 8] <= {{4'b1101, ads1115_input_fsr_pga[15 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[15 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[6] === 1'b1)) begin
                    chn <= 6;
                    ads1115_c_d[120 +: 8] <= {{4'b1110, ads1115_input_fsr_pga[18 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[18 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[7] === 1'b1)) begin
                    chn <= 7;
                    ads1115_c_d[120 +: 8] <= {{4'b1111, ads1115_input_fsr_pga[21 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[21 +: 3], 5'b00000};
                end else begin
                    sw <= 1'b0;
                    isini <= 4;
                    ads1115loads <= (~(ads1115loads));
                end
            end else if ((isini == 3)) begin
                if ((ads1115_alert_rdy === 1'b0)) begin
                    addr <= 8'b00000000;
                    rw <= 1'b1;
                    d_w_r_n <= 2;
                    isini <= 2;
                    sw <= 1'b1;
                end
            end else if ((isini == 4)) begin
                ads1115_ok <= 1'b1;
                swreset <= 1'b0;
            end
        end
    end
end
`else
reg sequential_0__previous_clock;
initial sequential_0__previous_clock = 1'bx;
always @(i2cclk or reset or s_reset) begin : sequential_0__vhdl_events
    if (((reset === 1'b0) || (s_reset === 1'b0))) begin
        sw <= 1'b0;
        ads1115_input_muxs <= ads1115_input_mux;
        i2c_reset <= 1'b0;
        ads1115loads <= 1'b0;
        if ((s_reset === 1'b0)) begin
            swreset <= 1'b1;
        end
        if (swreset) begin
            isini <= 0;
        end else begin
            isini <= 2;
        end
        ads1115_ok <= 1'b0;
    end else if (((sequential_0__previous_clock === 1'b0) && (i2cclk === 1'b1))) begin
        if (sw) begin
            if ((d_w_r_n > 0)) begin
                if ((d_w_r_nok === 1'b0)) begin
                    i2c_reset <= 1'b1;
                    rewr <= 1'b0;
                end else if ((rewr === 1'b0)) begin
                    ads1115_c_d_p <= (ads1115_c_d_p + 1);
                    if ((rw === 1'b1)) begin
                        ads1115_chn[112 - 16*chn +: 16] <= {ads1115_chn[112 - 16*chn +: 8], dataout};
                    end
                    d_w_r_n <= (d_w_r_n - 1);
                    rewr <= 1'b1;
                end
            end else begin
                if ((isini == 3)) begin
                    ads1115_input_muxs[chn] <= 1'b0;
                end
                i2c_reset <= 1'b0;
                sw <= 1'b0;
            end
        end else begin
            ads1115_c_d_p <= 0;
            if ((isini == 0)) begin
                addr <= 8'b00000011;
                ads1115_c_d[120 +: 8] <= 8'b10000000;
                ads1115_c_d[112 +: 8] <= 8'b00000000;
                rw <= 1'b0;
                d_w_r_n <= 2;
                isini <= 1;
                sw <= 1'b1;
            end else if ((isini == 1)) begin
                addr <= 8'b00000010;
                ads1115_c_d[120 +: 8] <= 8'b00000000;
                ads1115_c_d[112 +: 8] <= 8'b00000000;
                rw <= 1'b0;
                d_w_r_n <= 2;
                isini <= 2;
                sw <= 1'b1;
            end else if ((isini == 2)) begin
                addr <= 8'b00000001;
                rw <= 1'b0;
                d_w_r_n <= 2;
                isini <= 3;
                sw <= 1'b1;
                if ((ads1115_input_muxs[0] === 1'b1)) begin
                    chn <= 0;
                    ads1115_c_d[120 +: 8] <= {{4'b1000, ads1115_input_fsr_pga[0 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[0 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[1] === 1'b1)) begin
                    chn <= 1;
                    ads1115_c_d[120 +: 8] <= {{4'b1001, ads1115_input_fsr_pga[3 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[3 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[2] === 1'b1)) begin
                    chn <= 2;
                    ads1115_c_d[120 +: 8] <= {{4'b1010, ads1115_input_fsr_pga[6 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[6 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[3] === 1'b1)) begin
                    chn <= 3;
                    ads1115_c_d[120 +: 8] <= {{4'b1011, ads1115_input_fsr_pga[9 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[9 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[4] === 1'b1)) begin
                    chn <= 4;
                    ads1115_c_d[120 +: 8] <= {{4'b1100, ads1115_input_fsr_pga[12 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[12 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[5] === 1'b1)) begin
                    chn <= 5;
                    ads1115_c_d[120 +: 8] <= {{4'b1101, ads1115_input_fsr_pga[15 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[15 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[6] === 1'b1)) begin
                    chn <= 6;
                    ads1115_c_d[120 +: 8] <= {{4'b1110, ads1115_input_fsr_pga[18 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[18 +: 3], 5'b00000};
                end else if ((ads1115_input_muxs[7] === 1'b1)) begin
                    chn <= 7;
                    ads1115_c_d[120 +: 8] <= {{4'b1111, ads1115_input_fsr_pga[21 +: 3]}, 1'b1};
                    ads1115_c_d[112 +: 8] <= {ads1115_input_dr[21 +: 3], 5'b00000};
                end else begin
                    sw <= 1'b0;
                    isini <= 4;
                    ads1115loads <= (~(ads1115loads));
                end
            end else if ((isini == 3)) begin
                if ((ads1115_alert_rdy === 1'b0)) begin
                    addr <= 8'b00000000;
                    rw <= 1'b1;
                    d_w_r_n <= 2;
                    isini <= 2;
                    sw <= 1'b1;
                end
            end else if ((isini == 4)) begin
                ads1115_ok <= 1'b1;
                swreset <= 1'b0;
            end
        end
    end
    sequential_0__previous_clock = i2cclk;
end
`endif

assign ads1115_adc_16bit = ads1115_chn[112 - 16*ads1115loadp +: 16];
// Sequential logic
`ifdef SYNTHESIS
always @(posedge ads1115_uploadck) begin : sequential_1
    if ((ads1115upload !== ads1115loads)) begin
        ads1115upload <= ads1115loads;
        ads1115loadp <= 0;
        ads1115_loadck <= 1'b0;
    end else if (1'b1) begin
        if ((ads1115loadp < 8)) begin
            ads1115_loadck <= (~(ads1115_loadck));
            if ((ads1115_loadck === 1'b1)) begin
                ads1115loadp <= (ads1115loadp + 1);
            end
        end
    end
end
`else
reg sequential_1__previous_clock;
initial sequential_1__previous_clock = 1'bx;
always @(ads1115_uploadck) begin : sequential_1__vhdl_events
    if ((ads1115upload !== ads1115loads)) begin
        ads1115upload <= ads1115loads;
        ads1115loadp <= 0;
        ads1115_loadck <= 1'b0;
    end else if (((sequential_1__previous_clock === 1'b0) && (ads1115_uploadck === 1'b1))) begin
        if ((ads1115loadp < 8)) begin
            ads1115_loadck <= (~(ads1115_loadck));
            if ((ads1115_loadck === 1'b1)) begin
                ads1115loadp <= (ads1115loadp + 1);
            end
        end
    end
    sequential_1__previous_clock = ads1115_uploadck;
end
`endif

assign sda = ((sdas === 1'b0)) ? 1'b0 : 1'bz;
assign scl = ((scls === 1'b0)) ? 1'b0 : 1'b1;
// Sequential logic
`ifdef SYNTHESIS
always @(posedge i2cclk or negedge i2c_reset) begin : sequential_2
    if ((i2c_reset === 1'b0)) begin
        wdata <= {{{{{{{{1'b0, i2c_addr}, 1'b0}, 1'b1}, addr}, 1'b1}, datain}, 1'b1}, 2'b00};
        wn <= 29;
        rdata <= {{{{{{{{{{{{1'b0, i2c_addr}, 1'b0}, 1'b1}, addr}, 1'b1}, 2'b10}, i2c_addr}, 1'b1}, 1'b1}, 8'b11111111}, 1'b1}, 2'b00};
        rn <= 40;
        rns <= 40;
        i <= 0;
        wnend <= 0;
        pn <= 29;
        scls <= 1'b1;
        sdas <= 1'b1;
        i2cok <= 1'b0;
        i2cs <= 1'b0;
        rwns <= rwn;
        d_w_r_ns <= d_w_r_n;
        d_w_r_nok <= 1'b0;
        i2creset <= 1'b0;
    end else if (1'b1) begin
        if ((i2cok === 1'b0)) begin
            if ((i2creset === 1'b1)) begin
                scls <= 1'b1;
                sdas <= 1'b1;
                i <= 0;
                rn <= rns;
                wn <= 29;
                if ((pn == 0)) begin
                    pn <= 29;
                    i2creset <= 1'b0;
                    rwns <= (rwns - 1);
                    if ((rwns <= 1)) begin
                        i2cok <= 1'b1;
                        i2cs <= 1'b1;
                    end
                end else begin
                    pn <= (pn - 1);
                end
            end else if ((rw === 1'b0)) begin
                if ((d_w_r_nok === 1'b1)) begin
                    d_w_r_nok <= (~(rewr));
                    wdata[3 +: 8] <= datain;
                end else if ((wn == wnend)) begin
                    sdas <= 1'b1;
                    i2cok <= 1'b1;
                    d_w_r_nok <= 1'b1;
                end else begin
                    i <= (i + 1);
                    case (i)
                        0: begin
                            sdas <= wdata[wn];
                        end
                        1: begin
                            scls <= 1'b1;
                            wn <= (wn - 1);
                            if ((((wn == 20) || (wn == 11)) || (wn == 2))) begin
                                i2creset <= sda;
                            end
                        end
                        default: begin
                            scls <= 1'b0;
                            i <= 0;
                            if (((d_w_r_ns != 1) && (wn == 1))) begin
                                d_w_r_nok <= 1'b1;
                                d_w_r_ns <= (d_w_r_ns - 1);
                                wn <= 10;
                            end
                        end
                    endcase
                end
            end else begin
                if ((d_w_r_nok === 1'b1)) begin
                    d_w_r_nok <= (~(rewr));
                end else if ((rn == 0)) begin
                    sdas <= 1'b1;
                    i2cok <= 1'b1;
                    d_w_r_nok <= 1'b1;
                end else begin
                    i <= (i + 1);
                    case (i)
                        0: begin
                            sdas <= rdata[rn];
                        end
                        1: begin
                            scls <= 1'b1;
                            rn <= (rn - 1);
                            if ((((rn == 31) || (rn == 22)) || (rn == 11))) begin
                                i2creset <= sda;
                            end
                            if (((rn < 11) && (rn > 2))) begin
                                dataout <= {dataout[0 +: 7], sda};
                            end
                            if ((rn == 21)) begin
                                i <= 0;
                            end
                        end
                        default: begin
                            scls <= 1'b0;
                            i <= 0;
                            if ((d_w_r_ns != 1)) begin
                                rdata[2] <= 1'b0;
                                if ((rn == 1)) begin
                                    d_w_r_nok <= 1'b1;
                                    d_w_r_ns <= (d_w_r_ns - 1);
                                    rn <= 10;
                                end
                            end else begin
                                rdata[2] <= 1'b1;
                            end
                        end
                    endcase
                end
            end
        end
    end
end
`else
reg sequential_2__previous_clock;
initial sequential_2__previous_clock = 1'bx;
always @(i2cclk or i2c_reset) begin : sequential_2__vhdl_events
    if ((i2c_reset === 1'b0)) begin
        wdata <= {{{{{{{{1'b0, i2c_addr}, 1'b0}, 1'b1}, addr}, 1'b1}, datain}, 1'b1}, 2'b00};
        wn <= 29;
        rdata <= {{{{{{{{{{{{1'b0, i2c_addr}, 1'b0}, 1'b1}, addr}, 1'b1}, 2'b10}, i2c_addr}, 1'b1}, 1'b1}, 8'b11111111}, 1'b1}, 2'b00};
        rn <= 40;
        rns <= 40;
        i <= 0;
        wnend <= 0;
        pn <= 29;
        scls <= 1'b1;
        sdas <= 1'b1;
        i2cok <= 1'b0;
        i2cs <= 1'b0;
        rwns <= rwn;
        d_w_r_ns <= d_w_r_n;
        d_w_r_nok <= 1'b0;
        i2creset <= 1'b0;
    end else if (((sequential_2__previous_clock === 1'b0) && (i2cclk === 1'b1))) begin
        if ((i2cok === 1'b0)) begin
            if ((i2creset === 1'b1)) begin
                scls <= 1'b1;
                sdas <= 1'b1;
                i <= 0;
                rn <= rns;
                wn <= 29;
                if ((pn == 0)) begin
                    pn <= 29;
                    i2creset <= 1'b0;
                    rwns <= (rwns - 1);
                    if ((rwns <= 1)) begin
                        i2cok <= 1'b1;
                        i2cs <= 1'b1;
                    end
                end else begin
                    pn <= (pn - 1);
                end
            end else if ((rw === 1'b0)) begin
                if ((d_w_r_nok === 1'b1)) begin
                    d_w_r_nok <= (~(rewr));
                    wdata[3 +: 8] <= datain;
                end else if ((wn == wnend)) begin
                    sdas <= 1'b1;
                    i2cok <= 1'b1;
                    d_w_r_nok <= 1'b1;
                end else begin
                    i <= (i + 1);
                    case (i)
                        0: begin
                            sdas <= wdata[wn];
                        end
                        1: begin
                            scls <= 1'b1;
                            wn <= (wn - 1);
                            if ((((wn == 20) || (wn == 11)) || (wn == 2))) begin
                                i2creset <= sda;
                            end
                        end
                        default: begin
                            scls <= 1'b0;
                            i <= 0;
                            if (((d_w_r_ns != 1) && (wn == 1))) begin
                                d_w_r_nok <= 1'b1;
                                d_w_r_ns <= (d_w_r_ns - 1);
                                wn <= 10;
                            end
                        end
                    endcase
                end
            end else begin
                if ((d_w_r_nok === 1'b1)) begin
                    d_w_r_nok <= (~(rewr));
                end else if ((rn == 0)) begin
                    sdas <= 1'b1;
                    i2cok <= 1'b1;
                    d_w_r_nok <= 1'b1;
                end else begin
                    i <= (i + 1);
                    case (i)
                        0: begin
                            sdas <= rdata[rn];
                        end
                        1: begin
                            scls <= 1'b1;
                            rn <= (rn - 1);
                            if ((((rn == 31) || (rn == 22)) || (rn == 11))) begin
                                i2creset <= sda;
                            end
                            if (((rn < 11) && (rn > 2))) begin
                                dataout <= {dataout[0 +: 7], sda};
                            end
                            if ((rn == 21)) begin
                                i <= 0;
                            end
                        end
                        default: begin
                            scls <= 1'b0;
                            i <= 0;
                            if ((d_w_r_ns != 1)) begin
                                rdata[2] <= 1'b0;
                                if ((rn == 1)) begin
                                    d_w_r_nok <= 1'b1;
                                    d_w_r_ns <= (d_w_r_ns - 1);
                                    rn <= 10;
                                end
                            end else begin
                                rdata[2] <= 1'b1;
                            end
                        end
                    endcase
                end
            end
        end
    end
    sequential_2__previous_clock = i2cclk;
end
`endif

endmodule
`default_nettype wire
