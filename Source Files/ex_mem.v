module ex_mem_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] alu_result_in,
    input  wire [31:0] rs2_in,
    input  wire [4:0]  rd_in,
    input  wire        MemRead_in,
    input  wire        MemWrite_in,
    input  wire        RegWrite_in,
    input  wire        MemtoReg_in,
    output reg  [31:0] alu_result_out,
    output reg  [31:0] rs2_out,
    output reg  [4:0]  rd_out,
    output reg         MemRead_out,
    output reg         MemWrite_out,
    output reg         RegWrite_out,
    output reg         MemtoReg_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'd0;
            rs2_out        <= 32'd0;
            rd_out         <= 5'd0;
            MemRead_out    <= 1'b0;
            MemWrite_out   <= 1'b0;
            RegWrite_out   <= 1'b0;
            MemtoReg_out   <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            rs2_out        <= rs2_in;
            rd_out         <= rd_in;
            MemRead_out    <= MemRead_in;
            MemWrite_out   <= MemWrite_in;
            RegWrite_out   <= RegWrite_in;
            MemtoReg_out   <= MemtoReg_in;
        end
    end
endmodule
