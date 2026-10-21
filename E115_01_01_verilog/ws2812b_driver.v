// Verilog-2001 translation of ws2812b_driver.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module ws2812b_driver (
    input wire ws2812bclk,
    input wire ws2812breset,
    input wire ws2812b_loadck,
    input wire [23:0] ws2812b_ledgrbdata,
    output wire ws2812b_reload,
    output reg ws2812b_emitter_ok,
    output wire ws2812bout
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

reg [23:0] ledgrbdata0;
wire [23:0] ledgrbdata1;
reg [2:0] data01;
reg [4:0] datan;
reg [1:0] bitn;
reg [23:0] ws2812b_receive_buffer [0:63];
reg [6:0] ws2812b_receive_bufferp;
reg [6:0] ws2812b_get_bufferp;

initial data01 = 3'b000;
initial datan = 0;
initial bitn = 0;
initial ws2812b_receive_bufferp = 0;
initial ws2812b_get_bufferp = 0;

assign ws2812bout = data01[2];
// leddata_load
`ifdef SYNTHESIS
always @(posedge ws2812b_loadck or negedge ws2812breset) begin : leddata_load
    if ((ws2812breset === 1'b0)) begin
        ws2812b_receive_bufferp <= 0;
    end else if (1'b1) begin
        ws2812b_receive_buffer[ws2812b_receive_bufferp] <= ws2812b_ledgrbdata;
        ws2812b_receive_bufferp <= (ws2812b_receive_bufferp + 1);
    end
end
`else
reg leddata_load__previous_clock;
initial leddata_load__previous_clock = 1'bx;
always @(ws2812b_loadck or ws2812breset) begin : leddata_load__vhdl_events
    if ((ws2812breset === 1'b0)) begin
        ws2812b_receive_bufferp <= 0;
    end else if (((leddata_load__previous_clock === 1'b0) && (ws2812b_loadck === 1'b1))) begin
        ws2812b_receive_buffer[ws2812b_receive_bufferp] <= ws2812b_ledgrbdata;
        ws2812b_receive_bufferp <= (ws2812b_receive_bufferp + 1);
    end
    leddata_load__previous_clock = ws2812b_loadck;
end
`endif

// ws2812b_send
`ifdef SYNTHESIS
always @(posedge ws2812bclk or negedge ws2812breset) begin : ws2812b_send
    if ((ws2812breset === 1'b0)) begin
        data01 <= 3'b000;
        ws2812b_emitter_ok <= 1'b0;
        datan <= 0;
        bitn <= 0;
        ws2812b_get_bufferp <= 0;
    end else if (1'b1) begin
        if ((bitn != 0)) begin
            data01 <= {data01[0 +: 2], 1'b0};
            bitn <= (bitn - 1);
        end else if ((datan != 0)) begin
            data01 <= {{1'b1, ledgrbdata0[datan - 1]}, 1'b0};
            datan <= (datan - 1);
            bitn <= 2;
        end else if ((ws2812b_get_bufferp != ws2812b_receive_bufferp)) begin
            ledgrbdata0 <= ws2812b_receive_buffer[ws2812b_get_bufferp];
            ws2812b_get_bufferp <= (ws2812b_get_bufferp + 1);
            datan <= 23;
            data01 <= {{1'b1, ws2812b_receive_buffer[ws2812b_get_bufferp][23]}, 1'b0};
            bitn <= 2;
            ws2812b_emitter_ok <= 1'b1;
        end else begin
            ws2812b_emitter_ok <= 1'b0;
        end
    end
end
`else
reg ws2812b_send__previous_clock;
initial ws2812b_send__previous_clock = 1'bx;
always @(ws2812bclk or ws2812breset) begin : ws2812b_send__vhdl_events
    if ((ws2812breset === 1'b0)) begin
        data01 <= 3'b000;
        ws2812b_emitter_ok <= 1'b0;
        datan <= 0;
        bitn <= 0;
        ws2812b_get_bufferp <= 0;
    end else if (((ws2812b_send__previous_clock === 1'b0) && (ws2812bclk === 1'b1))) begin
        if ((bitn != 0)) begin
            data01 <= {data01[0 +: 2], 1'b0};
            bitn <= (bitn - 1);
        end else if ((datan != 0)) begin
            data01 <= {{1'b1, ledgrbdata0[datan - 1]}, 1'b0};
            datan <= (datan - 1);
            bitn <= 2;
        end else if ((ws2812b_get_bufferp != ws2812b_receive_bufferp)) begin
            ledgrbdata0 <= ws2812b_receive_buffer[ws2812b_get_bufferp];
            ws2812b_get_bufferp <= (ws2812b_get_bufferp + 1);
            datan <= 23;
            data01 <= {{1'b1, ws2812b_receive_buffer[ws2812b_get_bufferp][23]}, 1'b0};
            bitn <= 2;
            ws2812b_emitter_ok <= 1'b1;
        end else begin
            ws2812b_emitter_ok <= 1'b0;
        end
    end
    ws2812b_send__previous_clock = ws2812bclk;
end
`endif

endmodule
`default_nettype wire
