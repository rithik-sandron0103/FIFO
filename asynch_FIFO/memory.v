module mem(input wclk,
            input wclken,
            input [3:0] waddr,
            input [7:0] din,
            input rclk,
            input [3:0] raddr,
            output [7:0] dout);

    reg [7:0] memory_array [0:15];

    always @(posedge wclk) begin
        if (wclken) memory_array[waddr] <= din;
    end

    assign dout = memory_array[raddr];

endmodule