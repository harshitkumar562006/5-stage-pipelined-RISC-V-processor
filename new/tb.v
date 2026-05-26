module testbench;

    reg clk = 0;
    reg reset = 1;
    // Capture outputs from DUT
    wire [31:0] PC, PC_plus4, instr_IF, branch_target;
    wire        ALUSrc, Branch, MemRead, MemWrite, MemtoReg, RegWrite, Jump, Jalr;
    wire [1:0]  ALUOp, ForwardA, ForwardB;
    wire [31:0] ALU_in1, ALU_in2, alu_result, imm, rs1_val, rs2_val;
    wire [3:0]  ALU_control;
    wire        zero;
    wire [4:0]  rs1_addr, rs2_addr, rd_addr;
    wire [31:0] write_back_data;
    wire [31:0] IF_ID_PC, IF_ID_instr;
    wire [31:0] ID_EX_PC, ID_EX_rs1, ID_EX_rs2, ID_EX_imm;
    wire [4:0]  ID_EX_rd;
    wire [1:0]  ID_EX_ALUOp;
    wire        ID_EX_ALUSrc, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemWrite;
    wire        ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Jump, ID_EX_Jalr;
    wire [31:0] EX_MEM_alu_result, EX_MEM_rs2;
    wire [4:0]  EX_MEM_rd;
    wire        EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_RegWrite, EX_MEM_MemtoReg;
    wire [31:0] MEM_WB_mem_data, MEM_WB_alu_result;
    wire [4:0]  MEM_WB_rd;
    wire        MEM_WB_RegWrite, MEM_WB_MemtoReg;
    wire        stall, flush, PC_Write, IF_ID_Write, Control_Mux;
    wire [31:0] mem_addr, mem_write_data, mem_read_data;

    // Instantiate DUT (debug top)
    top dut (
        .clk(clk), .reset(reset),
        .PC(PC), .PC_plus4(PC_plus4), .instr_IF(instr_IF), .branch_target(branch_target),
        .ALUSrc(ALUSrc), .ALUOp(ALUOp), .Branch(Branch),
        .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg),
        .RegWrite(RegWrite), .Jump(Jump), .Jalr(Jalr),
        .ID_EX_rs1(ID_EX_rs1), .ID_EX_rs2(ID_EX_rs2),
        .ALU_in1(ALU_in1), .ALU_in2(ALU_in2),
        .ALU_control(ALU_control), .alu_result(alu_result), .zero(zero),
        .imm(imm),
        .rs1_addr(rs1_addr), .rs2_addr(rs2_addr), .rd_addr(rd_addr),
        .rs1_val(rs1_val), .rs2_val(rs2_val), .write_back_data(write_back_data),
        .IF_ID_PC(IF_ID_PC), .IF_ID_instr(IF_ID_instr),
        .ID_EX_PC(ID_EX_PC), .ID_EX_imm(ID_EX_imm), .ID_EX_rd(ID_EX_rd),
        .ID_EX_ALUOp(ID_EX_ALUOp), .ID_EX_ALUSrc(ID_EX_ALUSrc),
        .ID_EX_Branch(ID_EX_Branch), .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_MemWrite(ID_EX_MemWrite), .ID_EX_RegWrite(ID_EX_RegWrite),
        .ID_EX_MemtoReg(ID_EX_MemtoReg), .ID_EX_Jump(ID_EX_Jump),
        .ID_EX_Jalr(ID_EX_Jalr),
        .EX_MEM_alu_result(EX_MEM_alu_result), .EX_MEM_rs2(EX_MEM_rs2),
        .EX_MEM_rd(EX_MEM_rd), .EX_MEM_MemRead(EX_MEM_MemRead),
        .EX_MEM_MemWrite(EX_MEM_MemWrite),
        .EX_MEM_RegWrite(EX_MEM_RegWrite), .EX_MEM_MemtoReg(EX_MEM_MemtoReg),
        .MEM_WB_mem_data(MEM_WB_mem_data), .MEM_WB_alu_result(MEM_WB_alu_result),
        .MEM_WB_rd(MEM_WB_rd), .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MEM_WB_MemtoReg(MEM_WB_MemtoReg),
        .ForwardA(ForwardA), .ForwardB(ForwardB),
        .stall(stall), .flush(flush), .PC_Write(PC_Write),
        .IF_ID_Write(IF_ID_Write), .Control_Mux(Control_Mux),
        .mem_addr(mem_addr), .mem_write_data(mem_write_data), .mem_read_data(mem_read_data)
    );

    // Clock generator (10 ns period)
    always #5 clk = ~clk;

    // Provide reset and sample instructions
    initial begin
        
        // Initialize inputs
        reset = 1'b1;
        #12;
        reset = 1'b0;

        // Let simulation run for a few cycles
        #220;
        $finish;
    end

    

endmodule
