module fifo(input clk,
            input rst,
            input w_en,
            input r_en,
            input [7:0] din,
            output reg [7:0] dout,
            output full,
            output empty);

    reg [7:0] memory [0:15]; //16 rows each having 8 bits

    //5-bit pointers (4 bits for addressing 0-15 and 1 bit for flags)
    reg [4:0] w_ptr;
    reg [4:0] r_ptr;

    //Write logic
    always @(posedge clk) begin
        if (rst) w_ptr <= 5'b0;
        else if (w_en && !full) begin
            memory[ w_ptr[3:0] ] <= din; //Lower 4 bits for memory indexing
            w_ptr <= w_ptr+1;
        end
    end

    //Read logic
    always @(posedge clk) begin
        if (rst) begin
            r_ptr <= 5'b0;
            dout <= 8'b0;
        end
        else if (r_en && !empty) begin
            dout <= memory[ r_ptr[3:0] ]; //Lower 4 bits for memory indexing
            r_ptr <= r_ptr+1;
        end
    end

    //Empty logic
    assign empty = (w_ptr == r_ptr);

    //Full logic
    assign full = (w_ptr[4] != r_ptr[4]) && (w_ptr[3:0] == r_ptr[3:0]);

endmodule