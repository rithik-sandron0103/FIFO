`timescale 1ns/1ps

module fifo_tb();
    // Parameters
    parameter WIDTH = 8;
    parameter DEPTH = 16;

    // Inputs of Unit Under Test (UUT)
    reg wclk;               // Write domain clock
    reg wrst;               // Write domain active-high reset
    reg w_en;               // Write enable request
    reg [WIDTH-1:0] din;    // Input data bus
    reg rclk;               // Read domain clock
    reg rrst;               // Read domain active-high reset
    reg r_en;               // Read enable request

    // Outputs of Unit Under Test (UUT)
    wire wfull;             // Write full status flag
    wire [WIDTH-1:0] dout;  // Output data bus
    wire rempty;            // Read empty status flag

    Top #(
        .DATA_WIDTH(WIDTH),
        .FIFO_DEPTH(DEPTH)
    ) uut(
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

    // Clock generation
    initial begin
        // Initialization
        wclk = 0;
        rclk = 0;
    end
    // Write clock (Time period = 10ns)
    always begin
        #5 wclk = ~wclk;
    end
    // Read clock (Time period = 15 ns)
    always begin
        #7.5 rclk = ~rclk;
    end

    // Reset control
    initial begin
        // Initialization
        wrst = 1;
        rrst = 1;

        // Releasing both resets
        #30
        wrst = 0;
        rrst = 0;
    end

    // Data transfer tests
    integer i;
    initial begin
        // Initialization
        w_en = 0;
        r_en = 0;
        din = 8'b0;

        // Waiting for reset to clear
        #40
        @(posedge wclk) 

        // Write burst until full (Depth = 16, writes 17 entries to test guard)
        w_en = 1;
        for (i = 0; i <= 16; i = i+1) begin
            din = i;
            #10;
        end
        w_en = 0;
        #10

        // Read burst until empty
        r_en = 1;
        for (i = 0; i <= 16; i = i+1) begin
            #10;
        end
        r_en = 0;
        #10

        // Writing to verify pointer roll-over behavior after a full cycle.
        w_en = 1;
        for (i = 0; i <= 16; i = i+1) begin
            din = i+16;
            #10;
        end
        w_en=0;

        #20
        $finish;
    end

    // Monitoring and Waveform Generation
    initial begin
        $monitor("Time=%0t | wclk=%b | rclk=%b | wrst=%b | rrst=%b | w_en=%b | din=%h | r_en=%b | dout=%h | wfull=%b | rempty=%b",
                $time, wclk, rclk, wrst, rrst, w_en, din, r_en, dout, wfull, rempty);
        
        // Waveform dump
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, fifo_tb);
    end
endmodule