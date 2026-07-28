module reg_file (
    input  wire        clk,
    input  wire        we,
    input  wire [4:0]  ra1, ra2,
    input  wire [4:0]  wa,
    input  wire [31:0] wd,
    output wire [31:0] rd1, rd2
);
    reg [31:0] regs [0:31];
    integer i;
    // registers to 0 
    initial begin
        for (i = 0; i < 32; i = i+1) regs[i] = 32'b0;
    end

    // Synchronous write
    always @(posedge clk) begin
        if (we && (wa != 0))
            regs[wa] <= wd;
    end

    // Asynchronous reads
    assign rd1 = regs[ra1]; 
    assign rd2 = regs[ra2];
endmodule
