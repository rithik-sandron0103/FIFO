module w_ctrl # (
    parameter FIFO_DEPTH = 16  // Buffer size
)          (input wclk,                             // Write domain clock
            input wrst,                             // Write domain active-high reset
            input w_en,                             // Write enable request
            input [$clog2(FIFO_DEPTH):0] wq2_rptr,  // Synchronized read pointer from read clock domain (Gray code)
            output reg wfull,                       // Write full flag 
            output [$clog2(FIFO_DEPTH)-1:0] waddr,  // Memory write address
            output reg [$clog2(FIFO_DEPTH):0] wptr  // Write pointer output to cross clock domain (Gray code)
            );

    // Local parameter calculation
    localparam ADDR = $clog2(FIFO_DEPTH);

    reg [ADDR:0] wbin;        // Internal binary write pointer
    wire [ADDR:0] wbin_next;  // Next state value for binary pointer
    wire [ADDR:0] wgray_next; // Next state value for gray code pointer
    wire wfull_value;         // Combinational full flag evaluation

    // Sequential pointer update logic
    always @(posedge wclk or posedge wrst) begin
        if (wrst) begin
            wbin <= {(ADDR+1){1'b0}};
            wptr <= {(ADDR+1){1'b0}};
        end
        else begin
            wbin <= wbin_next;
            wptr <= wgray_next;
        end
    end

    // Increment binary pointer only if write is enabled and FIFO is not full
    assign wbin_next = wbin + (w_en && !wfull);

    // Convert the next binary pointer value to gray code
    assign wgray_next = wbin_next ^ (wbin_next>>1);

    // Extract lower address bits from the binary write pointer for memory indexing
    assign waddr = wbin[ADDR-1:0];

    // FIFO is full when next write Gray pointer has mismatching MSB and MSB-1 bits but identical lower address bits compared to synchronized read pointer
    assign wfull_value = (wgray_next[ADDR] != wq2_rptr[ADDR]) && 
                         (wgray_next[ADDR-1] != wq2_rptr[ADDR-1]) &&
                         (wgray_next[ADDR-2:0] == wq2_rptr[ADDR-2:0]);

    // Sequential update of full flag
    always @(posedge wclk or posedge wrst) begin
        if (wrst) wfull <= 0;
        else wfull <= wfull_value;
    end
endmodule