module mem #(
    parameter DATA_WIDTH = 8, // Data width of each FIFO entry
    parameter FIFO_DEPTH = 16 // Buffer size
)          (input wclk,                            // Write domain clock
            input wclken,                          // Write clock enable
            input [$clog2(FIFO_DEPTH)-1:0] waddr,  // Dynamic write address bus
            input [DATA_WIDTH-1:0] din,            // Input data bus
            input rclk,                            // Read domain clock
            input rclken,                          // Read clock enable
            input [$clog2(FIFO_DEPTH)-1:0] raddr,  // Dynamic read address bus
            output reg [DATA_WIDTH-1:0] dout       // Output data bus
            );

    // Memory array declaration: 16 rows of 8-bit data (by default)
    reg [DATA_WIDTH-1:0] memory_array [0:FIFO_DEPTH-1];

    // Synchronous write logic
    always @(posedge wclk) begin
        if (wclken) memory_array[waddr] <= din;
    end

    // Synchronous read logic
    always @(posedge rclk) begin
        if (rclken) dout <= memory_array[raddr];
    end

endmodule