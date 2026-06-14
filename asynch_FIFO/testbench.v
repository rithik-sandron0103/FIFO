`timescale 1ns/1ps

module fifo_tb();
    // Inputs of UUT
    reg wclk;
    reg wrst;
    reg w_en;
    reg [7:0] din;
    reg rclk;
    reg rrst;
    reg r_en;

    // Outputs of UUT
    wire wfull;
    wire [7:0] dout;
    wire rempty;

    Top uut(
        .wclk(wclk),
        .wrst(wrst),
        .w_en(w_en),
        .din(din),
        .wfull(wfull),
        .rclk(rclk),
        .rrst(rrst),
        .r_en(r_en),
        .dout(dout),
        .rempty(rempty)
    );

    //Write clock (Time period = 10ns)
    always begin
        #5 wclk = ~wclk;
    end

    //Read clock (Time period = 15 ns)
    always begin
        #7.5 rclk = ~rclk;
    end

    integer i;
    initial begin
        // Initialization
        wclk = 0;
        wrst = 1;
        w_en = 0;
        rclk = 0;
        rrst = 1;
        r_en = 0;
        din = 8'b0;

        #30
        wrst = 0;
        rrst = 0;
        #10

        w_en = 1;
        for (i = 0; i <= 16; i = i+1) begin
            din = i;
            #10;
        end
        w_en = 0;
        #10

        r_en = 1;
        for (i = 0; i <= 16; i = i+1) begin
            #10;
        end
        r_en = 0;
        #10

        w_en = 1;
        for (i = 0; i <= 16; i = i+1) begin
            din = i+16;
            #10;
        end
        w_en=0;

        #20
        $finish;
    end

    initial begin
        $monitor("Time=%0t | wclk=%b | rclk=%b | wrst=%b | rrst=%b | w_en=%b | din=%h | r_en=%b | dout=%h | wfull=%b | rempty=%b",
                $time, wclk, rclk, wrst, rrst, w_en, din, r_en, dout, wfull, rempty);
        $dumpfile("waveform.vcd");
        $dumpvars(0, fifo_tb);
    end
endmodule