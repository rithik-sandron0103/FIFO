module w_ctrl(input wclk,
                  input wrst,
                  input w_en,
                  input [4:0] wq2_rptr,
                  output reg wfull,
                  output [3:0] waddr,
                  output reg [4:0] wptr);

    reg [4:0] wbin;
    wire [4:0] wbin_next;
    wire [4:0] wgray_next;
    wire wfull_value;

    always @(posedge wclk or posedge wrst) begin
        if (wrst) begin
            wbin <= 5'b0;
            wptr <= 5'b0;
        end
        else begin
            wbin <= wbin_next;
            wptr <= wgray_next;
        end
    end

    assign wbin_next = wbin + (w_en && !wfull); //Pointer increment logic

    assign wgray_next = wbin_next ^ (wbin_next>>1); //Binary to Gray code conversion

    assign waddr = wptr[3:0]; //Bit slicing the lower 4 bits

    assign wfull_value = (wgray_next[4] != wq2_rptr[4]) && (wgray_next[3:0] == wq2_rptr[3:0]); //Combinational calculation of flag

    //Updating flag in the next clock cycle (Sequential part)
    always @(posedge wclk or posedge wrst) begin
        if (wrst) wfull <= 0;
        else wfull <= wfull_value;
    end
endmodule