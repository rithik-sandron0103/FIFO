module synchronizer(input clk,
                 input rst,
                 input [4:0] ptr_in,
                 output reg [4:0] ptr_out);

    reg [4:0] q1_ptr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q1_ptr <= 5'b0;
            ptr_out <= 5'b0;
        end
        else begin
            q1_ptr <= ptr_in; //2-stage pointer synchronizer (2 flip flops)
            ptr_out <= q1_ptr;
        end
    end
endmodule