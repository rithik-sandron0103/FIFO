module r_ctrl #(
    parameter FIFO_DEPTH = 16  // Buffer size
)           (input rclk,                              // Read domain clock
             input rrst,                              // Read domain active-high reset
             input r_en,                              // Read enable request
             input [$clog2(FIFO_DEPTH):0] rq2_wptr,   // Synchronized write pointer from write clock domain (Gray code)
             output reg rempty,                       // Read empty flag
             output [$clog2(FIFO_DEPTH)-1:0] raddr,   // Memory read address
             output reg [$clog2(FIFO_DEPTH):0] rptr   // Read pointer output to cross clock domain (Gray code)
            );
    
    // Local parameter calculation
    localparam ADDR = $clog2(FIFO_DEPTH);

    reg [ADDR:0] rbin;        // Internal binary read pointer
    wire [ADDR:0] rbin_next;  // Next state value for binary pointer
    wire [ADDR:0] rgray_next; // Next state value for gray code pointer
    wire rempty_val;          // Combinational empty flag evaluation

    // Sequential pointer update logic
    always @(posedge rclk or posedge rrst) begin
        if (rrst) begin
            rbin <= {(ADDR+1){1'b0}};
            rptr <= {(ADDR+1){1'b0}};
        end
        else begin
            rbin <= rbin_next;
            rptr <= rgray_next;
        end
    end

    // Increment binary pointer only if read is enabled and FIFO is not empty
    assign rbin_next = rbin + (r_en && !rempty);

    // Convert the next binary pointer value to gray code
    assign rgray_next = rbin_next ^ (rbin_next>>1);

    // Extract lower address bits from the binary read pointer for memory indexing
    assign raddr = rbin[ADDR-1:0];

    // FIFO is empty when the next read Gray pointer matches the synchronized write pointer
    assign rempty_val = (rgray_next == rq2_wptr);

    // Sequential update of empty flag
    always @(posedge rclk or posedge rrst) begin
        if (rrst) rempty <= 1'b1;
        else rempty <= rempty_val;
    end

endmodule