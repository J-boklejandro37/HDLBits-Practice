module top_module (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    wire [23:0] bcdtime;
    assign bcdtime = {hh, mm, ss};

    always @(posedge clk) pm <= reset ? 0 : ((bcdtime == 24'h115959) ? ~pm : pm);

    bcd99count inst0 (
        clk,
        reset,
        ena,
        8'h00,
        8'h59,
        8'h00,
        ss
    );
    bcd99count inst1 (
        clk,
        reset,
        (ena && ss == 8'h59),
        8'h00,
        8'h59,
        8'h00,
        mm
    );
    bcd99count inst2 (
        clk,
        reset,
        (ena && mm == 8'h59 && ss == 8'h59),
        8'h12,
        8'h12,
        8'h01,
        hh
    );


endmodule


module bcd99count (
    input clk,
    reset,
    enable,
    input [7:0] reset_v,
    roll,
    roll_to,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (reset) q <= reset_v;
        else begin
            if (enable) begin
                if (q == roll) q <= roll_to;
                else begin
                    q[3:0] <= (q[3:0] == 9) ? 0 : q[3:0] + 1;
                    q[7:4] <= (q[3:0] == 9) ? ((q[7:4] == 9) ? 0 : q[7:4] + 1) : q[7:4];
                end
            end else q <= q;
        end
    end

endmodule
