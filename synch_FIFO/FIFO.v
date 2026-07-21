module fifo #(
    parameter BIT_WIDTH = 8,    // Data width of each FIFO entry
    parameter FIFO_DEPTH = 16   // Buffer size
)          (input clk,
            input rst,
            input w_en,
            input r_en,
            input [BIT_WIDTH-1:0] din,
            output reg [BIT_WIDTH-1:0] dout,
            output full,
            output empty);

    // Memory array declaration: 16 rows of 8-bit data (by default)
    reg [BIT_WIDTH-1:0] memory [0:FIFO_DEPTH-1];

    // Local Parameter Calculation
    localparam ADDR = $clog2(FIFO_DEPTH); //Minimum number of bits to represent each mempry element

    // Pointers are sized to (ADDR + 1) bits. 
    // The MSB acts as a wrap-around/direction toggle bit for flag logic
    // The lower bits ([ADDR-1:0]) are used for physical memory addressing.
    reg [ADDR:0] w_ptr;
    reg [ADDR:0] r_ptr;

    // Write logic
    always @(posedge clk) begin
        if (rst) begin
            w_ptr <= {(ADDR+1){1'b0}};
        end
        else if (w_en && !full) begin
            memory[ w_ptr[ADDR-1:0] ] <= din; // Lower bits for memory indexing
            w_ptr <= w_ptr+1;
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (rst) begin
            r_ptr <= {(ADDR+1){1'b0}};
            dout <= {BIT_WIDTH{1'b0}};
        end
        else if (r_en && !empty) begin
            dout <= memory[ r_ptr[ADDR-1:0] ]; //Lower bits for memory indexing
            r_ptr <= r_ptr+1;
        end
    end

    // Status Flags logic

    // Empty logic: Pointers are completely identical (same wrap, same address)
    assign empty = (w_ptr == r_ptr);

    // Full logic: MSBs are different (one has wrapped around more than the other) but the addresses are identical
    assign full = (w_ptr[ADDR] != r_ptr[ADDR]) && (w_ptr[ADDR-1:0] == r_ptr[ADDR-1:0]);

endmodule