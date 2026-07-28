module id_ex_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,   
    input  wire        flush,
    input  wire [31:0] pc_in,
    input  wire [31:0] rs1_in,
    input  wire [31:0] rs2_in,
    input  wire [4:0]  rs1_addr_in,
    input  wire [4:0]  rs2_addr_in,
    input  wire [2:0]  funct3_in,
    input  wire        funct7_5_in,
    input  wire [31:0] imm_in,
    input  wire [4:0]  rd_in,
    input  wire [1:0]  ALUOp_in,
    input  wire        ALUSrc_in,
    input  wire        Branch_in,
    input  wire        MemRead_in,
    input  wire        MemWrite_in,
    input  wire        RegWrite_in,
    input  wire        MemtoReg_in,
    input  wire        Jump_in,
    input  wire        Jalr_in,
    output reg  [31:0] pc_out,
    output reg  [31:0] rs1_out,
    output reg  [31:0] rs2_out,
    output reg  [4:0]  rs1_addr_out,
    output reg  [4:0]  rs2_addr_out,
    output reg  [2:0]  funct3_out,
    output reg         funct7_5_out,
    output reg  [31:0] imm_out,
    output reg  [4:0]  rd_out,
    output reg  [1:0]  ALUOp_out,
    output reg         ALUSrc_out,
    output reg         Branch_out,
    output reg         MemRead_out,
    output reg         MemWrite_out,
    output reg         RegWrite_out,
    output reg         MemtoReg_out,
    output reg         Jump_out,
    output reg         Jalr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out    <= 32'd0;
            rs1_out   <= 32'd0;
            rs2_out   <= 32'd0;
            rs1_addr_out <= 5'd0;
            rs2_addr_out <= 5'd0;
            funct3_out   <= 3'd0;
            funct7_5_out <= 1'b0;
            imm_out   <= 32'd0;
            rd_out    <= 5'd0;
            ALUOp_out <= 2'd0;
            ALUSrc_out<= 1'b0;
            Branch_out<= 1'b0;
            MemRead_out<=1'b0;
            MemWrite_out<=1'b0;
            RegWrite_out<=1'b0;
            MemtoReg_out<=1'b0;
            Jump_out  <= 1'b0;
            Jalr_out  <= 1'b0;
        end else if (flush) begin
            // No operation EX stage
            pc_out    <= 32'd0;
            rs1_out   <= 32'd0;
            rs2_out   <= 32'd0;
            rs1_addr_out <= 5'd0;
            rs2_addr_out <= 5'd0;
            funct3_out   <= 3'd0;
            funct7_5_out <= 1'b0;
            imm_out   <= 32'd0;
            rd_out    <= 5'd0;
            ALUOp_out <= 2'd0;
            ALUSrc_out<= 1'b0;
            Branch_out<= 1'b0;
            MemRead_out<=1'b0;
            MemWrite_out<=1'b0;
            RegWrite_out<=1'b0;
            MemtoReg_out<=1'b0;
            Jump_out  <= 1'b0;
            Jalr_out  <= 1'b0;
        end else begin
            pc_out      <= pc_in;
            rs1_out     <= rs1_in;
            rs2_out     <= rs2_in;
            rs1_addr_out<= rs1_addr_in;
            rs2_addr_out<= rs2_addr_in;
            funct3_out  <= funct3_in;
            funct7_5_out<= funct7_5_in;
            imm_out     <= imm_in;
            rd_out      <= rd_in;
            ALUOp_out   <= ALUOp_in;
            ALUSrc_out  <= ALUSrc_in;
            Branch_out  <= Branch_in;
            MemRead_out <= MemRead_in;
            MemWrite_out<= MemWrite_in;
            RegWrite_out<= RegWrite_in;
            MemtoReg_out<= MemtoReg_in;
            Jump_out    <= Jump_in;
            Jalr_out    <= Jalr_in;
        end
    end
endmodule
