`timescale 1ns/1ps

module fifo_tb();
    //Inputs of UUT
    reg clk;
    reg rst;
    reg w_en;
    reg r_en;
    reg [7:0] din;

    //Outputs of UUT
    wire [7:0] dout;
    wire full;
    wire empty;

    fifo uut(
        .clk(clk),
        .rst(rst),
        .w_en(w_en),
        .r_en(r_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    always begin
        #5 clk = ~clk;
    end

    integer i;

    initial begin
        //Initialization
        clk = 0;
        rst = 1;
        w_en = 0;
        r_en = 0;
        din = 8'b0;

        #10
        rst = 0;
        #5

        w_en = 1;
        for(i = 0; i <= 16; i = i+1) begin
            din = i;
            #10;
        end
        w_en = 0;
        #10

        r_en = 1;
        for(i = 0; i <= 16; i = i+1) begin
            #10;
        end
        r_en = 0;
        #10

        w_en = 1;
        for(i = 0; i <= 16; i = i+1) begin
            din = i+16;
            #10;
        end
        w_en = 0;

        #20
        $finish;
    end

    initial begin
        $monitor("Time=%0t | rst=%b | w_en=%b | din=%h | r_en=%b | dout=%h | full=%b | empty=%b",
                $time, rst, w_en, din, r_en, dout, full, empty);
        $dumpfile("waveform.vcd");
        $dumpvars(0, fifo_tb);
    end
endmodule