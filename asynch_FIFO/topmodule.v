module Top(input wclk,
           input wrst,
           input w_en,
           input [7:0] din,
           output wfull,
           
           input rclk,
           input rrst,
           input r_en,
           output [7:0] dout,
           output rempty);

    wire [4:0] wptr, rptr;
    wire [4:0] wq2_rptr, rq2_wptr;
    wire [3:0] waddr, raddr;

    // Memory
    mem memory_core(
        .wclk(wclk),
        .wclken(w_en & !wfull),
        .waddr(waddr),
        .din(din),
        .rclk(rclk),
        .raddr(raddr),
        .dout(dout)
    );

    // Synchronizing rptr into write clock domain
    synchronizer rsynch(
        .clk(wclk),
        .rst(wrst),
        .ptr_in(rptr),
        .ptr_out(wq2_rptr)
    );

    // Synchronizing wptr into read clock domain
    synchronizer wsynch(
        .clk(rclk),
        .rst(rrst),
        .ptr_in(wptr),
        .ptr_out(rq2_wptr)
    );

    // Write logic
    w_ctrl write(
        .wclk(wclk),
        .wrst(wrst),
        .w_en(w_en),
        .wq2_rptr(wq2_rptr),
        .wfull(wfull),
        .waddr(waddr),
        .wptr(wptr)
    );

    //Read logic
    r_ctrl read(
        .rclk(rclk),
        .rrst(rrst),
        .r_en(r_en),
        .rq2_wptr(rq2_wptr),
        .rempty(rempty),
        .raddr(raddr),
        .rptr(rptr)
    );

endmodule