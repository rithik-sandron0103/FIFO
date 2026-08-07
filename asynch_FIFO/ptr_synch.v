module synchronizer #(
    parameter FIFO_DEPTH = 16  // Buffer size
)       (input clk,                                // Destination clock domain
         input rst,                                // Destination domain active-high reset
         input [$clog2(FIFO_DEPTH):0] ptr_in,      // Asynchronous pointer input from source domain
         output reg [$clog2(FIFO_DEPTH):0] ptr_out // ynchronized pointer output in destination domain
         );

    // Local parameter calculation
    localparam ADDR = $clog2(FIFO_DEPTH);

    // First stage synchronizer register
    reg [ADDR:0] q1_ptr;
    reg [ADDR:0] q2_ptr;

    // 2-stage D flip-flop Synchronizer
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q1_ptr <= {(ADDR+1){1'b0}};
            q2_ptr  <= {(ADDR+1){1'b0}};
            ptr_out <= {(ADDR+1){1'b0}};
        end
        else begin
            q1_ptr <= ptr_in;   // Stage 1: Captures asynchronous input (prone to metastability)
            q2_ptr <= q1_ptr;   // Stage 2: Allows metastable state to resolve
            ptr_out <= q2_ptr;  // Clean output
        end
    end
endmodule