// Verilog-2001 translation of joystick_driver.vhd.
// Array element at the VHDL left bound occupies the most significant bits.
// Signal assignments use <=; process variables use =. Active-low resets.
`timescale 1ns/1ps
`default_nettype none
module joystick_driver (
    input wire joystick_clk,
    input wire joystick_reset,
    output reg ads1115_reset,
    input wire ads1115_ok,
    input wire [16:0] vx,
    input wire [16:0] vy,
    input wire sw,
    output reg [5:0] joystick_keys,
    output reg joystick_ok
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

reg [7:0] joystickp__joystick_s;
reg [7:0] joystickp__joystick_s_end;
reg [4:0] joystickp__joystick_keyn;
reg [1:0] joystickp__joystick_h;
reg [1:0] joystickp__joystick_v;
reg joystickp__joystick_sw;
reg [5:0] joystickp__joystick_key;

initial joystickp__joystick_s = 0;
initial joystickp__joystick_s_end = 0;
initial joystickp__joystick_keyn = 0;
initial joystickp__joystick_key = 0;
initial joystick_keys = 0;

// joystickp
`ifdef SYNTHESIS
always @(posedge joystick_clk) begin : joystickp
    if ((joystick_reset === 1'b0)) begin
        ads1115_reset <= 1'b0;
        joystickp__joystick_s = 0;
        joystickp__joystick_keyn = 0;
        joystickp__joystick_s_end = 80;
        joystick_ok <= 1'b0;
    end else if (1'b1) begin
        case (joystickp__joystick_s)
            0: begin
                if ((joystickp__joystick_s_end != 0)) begin
                    joystickp__joystick_s_end = (joystickp__joystick_s_end - 1);
                end else begin
                    joystickp__joystick_s_end = 80;
                    joystickp__joystick_s = 1;
                end
            end
            1: begin
                ads1115_reset <= 1'b0;
                joystickp__joystick_s = 2;
            end
            2: begin
                ads1115_reset <= 1'b1;
                if ((ads1115_ok === 1'b1)) begin
                    if ((vx < 8000)) begin
                        joystickp__joystick_h = 2'b10;
                    end else if ((vx > 22000)) begin
                        joystickp__joystick_h = 2'b01;
                    end else begin
                        joystickp__joystick_h = 2'b00;
                    end
                    if ((vy < 8000)) begin
                        joystickp__joystick_v = 2'b10;
                    end else if ((vy > 22000)) begin
                        joystickp__joystick_v = 2'b01;
                    end else begin
                        joystickp__joystick_v = 2'b00;
                    end
                    if ((sw === 1'b1)) begin
                        joystickp__joystick_sw = 1'b0;
                    end else begin
                        joystickp__joystick_sw = 1'b1;
                    end
                    joystickp__joystick_key = {{(32-(5)){1'b0}}, {{joystickp__joystick_h, joystickp__joystick_v}, joystickp__joystick_sw}};
                    joystickp__joystick_s = 3;
                end
            end
            3: begin
                if (((joystickp__joystick_key != 0) && (joystickp__joystick_keyn < 5))) begin
                    if ((joystick_keys != joystickp__joystick_key)) begin
                        joystick_keys <= joystickp__joystick_key;
                        joystickp__joystick_keyn = 0;
                    end else begin
                        joystickp__joystick_keyn = (joystickp__joystick_keyn + 1);
                    end
                    joystickp__joystick_s = 1;
                end else if ((joystickp__joystick_keyn != 5)) begin
                    joystickp__joystick_s = 1;
                    joystickp__joystick_keyn = 0;
                end else begin
                    joystickp__joystick_s = 4;
                    case (joystick_keys)
                        4: begin
                            joystick_keys <= 0;
                        end
                        2: begin
                            joystick_keys <= 1;
                        end
                        16: begin
                            joystick_keys <= 2;
                        end
                        8: begin
                            joystick_keys <= 3;
                        end
                        20: begin
                            joystick_keys <= 4;
                        end
                        18: begin
                            joystick_keys <= 5;
                        end
                        12: begin
                            joystick_keys <= 6;
                        end
                        10: begin
                            joystick_keys <= 7;
                        end
                        1: begin
                            joystick_keys <= 8;
                        end
                        default: begin
                            joystickp__joystick_s = 1;
                            joystickp__joystick_keyn = 0;
                        end
                    endcase
                end
            end
            default: begin
                joystickp__joystick_s = (joystickp__joystick_s + 1);
                joystick_ok <= 1'b0;
                if ((joystickp__joystick_s == 20)) begin
                    joystick_ok <= 1'b1;
                end
                if ((joystickp__joystick_s == joystickp__joystick_s_end)) begin
                    joystickp__joystick_s = 1;
                    joystickp__joystick_keyn = 0;
                end
            end
        endcase
    end
end
`else
reg joystickp__previous_clock;
initial joystickp__previous_clock = 1'bx;
always @(joystick_clk) begin : joystickp__vhdl_events
    if ((joystick_reset === 1'b0)) begin
        ads1115_reset <= 1'b0;
        joystickp__joystick_s = 0;
        joystickp__joystick_keyn = 0;
        joystickp__joystick_s_end = 80;
        joystick_ok <= 1'b0;
    end else if (((joystickp__previous_clock === 1'b0) && (joystick_clk === 1'b1))) begin
        case (joystickp__joystick_s)
            0: begin
                if ((joystickp__joystick_s_end != 0)) begin
                    joystickp__joystick_s_end = (joystickp__joystick_s_end - 1);
                end else begin
                    joystickp__joystick_s_end = 80;
                    joystickp__joystick_s = 1;
                end
            end
            1: begin
                ads1115_reset <= 1'b0;
                joystickp__joystick_s = 2;
            end
            2: begin
                ads1115_reset <= 1'b1;
                if ((ads1115_ok === 1'b1)) begin
                    if ((vx < 8000)) begin
                        joystickp__joystick_h = 2'b10;
                    end else if ((vx > 22000)) begin
                        joystickp__joystick_h = 2'b01;
                    end else begin
                        joystickp__joystick_h = 2'b00;
                    end
                    if ((vy < 8000)) begin
                        joystickp__joystick_v = 2'b10;
                    end else if ((vy > 22000)) begin
                        joystickp__joystick_v = 2'b01;
                    end else begin
                        joystickp__joystick_v = 2'b00;
                    end
                    if ((sw === 1'b1)) begin
                        joystickp__joystick_sw = 1'b0;
                    end else begin
                        joystickp__joystick_sw = 1'b1;
                    end
                    joystickp__joystick_key = {{(32-(5)){1'b0}}, {{joystickp__joystick_h, joystickp__joystick_v}, joystickp__joystick_sw}};
                    joystickp__joystick_s = 3;
                end
            end
            3: begin
                if (((joystickp__joystick_key != 0) && (joystickp__joystick_keyn < 5))) begin
                    if ((joystick_keys != joystickp__joystick_key)) begin
                        joystick_keys <= joystickp__joystick_key;
                        joystickp__joystick_keyn = 0;
                    end else begin
                        joystickp__joystick_keyn = (joystickp__joystick_keyn + 1);
                    end
                    joystickp__joystick_s = 1;
                end else if ((joystickp__joystick_keyn != 5)) begin
                    joystickp__joystick_s = 1;
                    joystickp__joystick_keyn = 0;
                end else begin
                    joystickp__joystick_s = 4;
                    case (joystick_keys)
                        4: begin
                            joystick_keys <= 0;
                        end
                        2: begin
                            joystick_keys <= 1;
                        end
                        16: begin
                            joystick_keys <= 2;
                        end
                        8: begin
                            joystick_keys <= 3;
                        end
                        20: begin
                            joystick_keys <= 4;
                        end
                        18: begin
                            joystick_keys <= 5;
                        end
                        12: begin
                            joystick_keys <= 6;
                        end
                        10: begin
                            joystick_keys <= 7;
                        end
                        1: begin
                            joystick_keys <= 8;
                        end
                        default: begin
                            joystickp__joystick_s = 1;
                            joystickp__joystick_keyn = 0;
                        end
                    endcase
                end
            end
            default: begin
                joystickp__joystick_s = (joystickp__joystick_s + 1);
                joystick_ok <= 1'b0;
                if ((joystickp__joystick_s == 20)) begin
                    joystick_ok <= 1'b1;
                end
                if ((joystickp__joystick_s == joystickp__joystick_s_end)) begin
                    joystickp__joystick_s = 1;
                    joystickp__joystick_keyn = 0;
                end
            end
        endcase
    end
    joystickp__previous_clock = joystick_clk;
end
`endif

endmodule
`default_nettype wire
