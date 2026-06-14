module r_ctrl(input rclk,
                 input rrst,
                 input r_en,
                 input [4:0] rq2_wptr,
                 output reg rempty,
                 output [3:0] raddr,
                 output reg [4:0] rptr);
    
    reg [4:0] rbin;
    wire [4:0] rbin_next;
    wire [4:0] rgray_next;
    wire rempty_val;

    always @(posedge rclk or posedge rrst) begin
        if (rrst) begin
            rbin <= 5'b0;
            rptr <= 5'b0;
        end
        else begin
            rbin <= rbin_next;
            rptr <= rgray_next;
        end
    end

    assign rbin_next = rbin + (r_en && !rempty); //Pointer increment logic

    assign rgray_next = rbin_next ^ (rbin_next>>1); //Binary to Gray code conversion

    assign raddr = rptr[3:0]; //Bit slicing the lower 4 bits

    assign rempty_val = (rgray_next == rq2_wptr); //Combinational calculation of flag

    //Updating flag in the next clock cycle (Sequential part)
    always @(posedge rclk or posedge rrst) begin
        if (rrst) rempty <= 1;
        else rempty <= rempty_val;
    end

endmodule