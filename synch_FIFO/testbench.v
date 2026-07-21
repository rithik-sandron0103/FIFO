`timescale 1ns/1ps

module fifo_tb();
    // Parameters
    parameter WIDTH = 8;
    parameter DEPTH = 16;

    // Inputs of UUT
    reg clk;             // System clock
    reg rst;             // Synchronous reset
    reg w_en;            // Write enable
    reg r_en;            // Read enable
    reg [WIDTH-1:0] din; // Input datastream

    // Outputs of UUT
    wire [WIDTH-1:0] dout; // Output datastream
    wire full;             // Full flag
    wire empty;            // Empty flag

    fifo #(
        .DATA_WIDTH(WIDTH),
        .FIFO_DEPTH(DEPTH)
    ) uut(
        .clk(clk),
        .rst(rst),
        .w_en(w_en),
        .r_en(r_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    integer i;

    initial begin
        // Initialization
        clk = 0;
        rst = 1;
        w_en = 0;
        r_en = 0;
        din = 8'b0;

        // Releasing reset
        #10
        rst = 0;
        #5

        // Writing to FIFO until full (Depth = 16, writes 17 entries to test guard)
        w_en = 1;
        for(i = 0; i <= 16; i = i+1) begin
            din = i;
            #10;
        end
        w_en = 0;
        #10

        // Reading to FIFO until empty
        r_en = 1;
        for(i = 0; i <= 16; i = i+1) begin
            #10;
        end
        r_en = 0;
        #10

        // Writing to verify pointer roll-over behavior after a full cycle.
        w_en = 1;
        for(i = 0; i <= 16; i = i+1) begin
            din = i+16;
            #10;
        end
        w_en = 0;

        #20
        $finish;
    end

    // Monitoring and Waveform Generation
    initial begin
        $monitor("Time=%0t | rst=%b | w_en=%b | din=%h | r_en=%b | dout=%h | full=%b | empty=%b",
                $time, rst, w_en, din, r_en, dout, full, empty);
        
        // Waveform dump
        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);
    end
endmodule
