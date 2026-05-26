module top (
    input  wire        clk,
    input  wire        reset,

    // Debug Outputs:
    output [31:0] PC,
    output [31:0] PC_plus4,
    output [31:0] instr_IF,
    output [31:0] branch_target,

    // Control Signals
    output        ALUSrc,
    output [1:0]  ALUOp,
    output        Branch,
    output        MemRead,
    output        MemWrite,
    output        MemtoReg,
    output        RegWrite,
    output        Jump,
    output        Jalr,

    // ALU and Related
    output [31:0] ID_EX_rs1,
    output [31:0] ID_EX_rs2,
    output [31:0] ALU_in1,
    output [31:0] ALU_in2,
    output [3:0]  ALU_control,
    output [31:0] alu_result,
    output        zero,

    // Immediate
    output [31:0] imm,

    // Register File
    output [4:0]  rs1_addr,
    output [4:0]  rs2_addr,
    output [4:0]  rd_addr,
    output [31:0] rs1_val,
    output [31:0] rs2_val,
    output [31:0] write_back_data,

    // Pipeline Registers (IF/ID, ID/EX, EX/MEM, MEM/WB contents)
    output [31:0] IF_ID_PC,
    output [31:0] IF_ID_instr,
    output [31:0] ID_EX_PC,
    output [31:0] ID_EX_imm,
    output [4:0]  ID_EX_rd,
    output [1:0]  ID_EX_ALUOp,
    output        ID_EX_ALUSrc,
    output        ID_EX_Branch,
    output        ID_EX_MemRead,
    output        ID_EX_MemWrite,
    output        ID_EX_RegWrite,
    output        ID_EX_MemtoReg,
    output        ID_EX_Jump,
    output        ID_EX_Jalr,
    output [31:0] EX_MEM_alu_result,
    output [31:0] EX_MEM_rs2,
    output [4:0]  EX_MEM_rd,
    output        EX_MEM_MemRead,
    output        EX_MEM_MemWrite,
    output        EX_MEM_RegWrite,
    output        EX_MEM_MemtoReg,
    output [31:0] MEM_WB_mem_data,
    output [31:0] MEM_WB_alu_result,
    output [4:0]  MEM_WB_rd,
    output        MEM_WB_RegWrite,
    output        MEM_WB_MemtoReg,

    // Hazard Signals
    output [1:0]  ForwardA,
    output [1:0]  ForwardB,
    output        stall,
    output        flush,
    output        PC_Write,
    output        IF_ID_Write,
    output        Control_Mux,

    // Data Memory Interface
    output [31:0] mem_addr,
    output [31:0] mem_write_data,
    output [31:0] mem_read_data
);
    // PC register
    reg [31:0] PC_reg;
    assign PC = PC_reg;
    assign PC_plus4 = PC_reg + 4;

    // Instruction Fetch
    instr_mem IMEM (
        .clk(clk), .addr(PC_reg), .instr(instr_IF)
    );

    // IF/ID Pipeline Register
    wire [31:0] IF_ID_instr_w;
    if_id_reg IF_ID (
        .clk(clk), .reset(reset), .stall(stall), .flush(branch_taken),
        .pc_in(PC_reg),     .instr_in(instr_IF),
        .pc_out(IF_ID_PC),  .instr_out(IF_ID_instr_w)
    );
    assign IF_ID_instr = IF_ID_instr_w;

    // Decode (ID stage)
    assign rs1_addr = IF_ID_instr_w[19:15];
    assign rs2_addr = IF_ID_instr_w[24:20];
    assign rd_addr  = IF_ID_instr_w[11:7];
    // Read registers
    reg_file RF (
        .clk(clk), .we(MEM_WB_RegWrite),
        .ra1(rs1_addr), .ra2(rs2_addr), .wa(MEM_WB_rd),
        .wd(write_back_data), .rd1(rs1_val), .rd2(rs2_val)
    );
    assign RS1_VAL = rs1_val; // ensure keep (example, use keep)
    // Control and immediate
    imm_gen IMM (.instr(IF_ID_instr_w), .imm_out(imm));
    control_unit CU (
        .opcode(IF_ID_instr_w[6:0]),
        .MemtoReg(MemtoReg), .RegWrite(RegWrite),
        .MemRead(MemRead), .MemWrite(MemWrite),
        .ALUSrc(ALUSrc), .Branch(Branch),
        .Jump(Jump), .Jalr(Jalr),
        .ALUOp(ALUOp)
    );
    
    
    hazard_detection HAZ (
        .IF_ID_rs1(rs1_addr),
        .IF_ID_rs2(rs2_addr),
        .ID_EX_rd(ID_EX_rd),
        .ID_EX_MemRead(ID_EX_MemRead),
        .stall(stall)
    );


    // ID/EX Pipeline Register
    id_ex_reg ID_EX (
        .clk(clk), .reset(reset), .flush(branch_taken),
        .pc_in(IF_ID_PC),
        .rs1_in(rs1_val), .rs2_in(rs2_val),
        .imm_in(imm),
        .rd_in(rd_addr),
        .ALUOp_in(ALUOp), .ALUSrc_in(ALUSrc),
        .Branch_in(Branch), .MemRead_in(MemRead),
        .MemWrite_in(MemWrite), .RegWrite_in(RegWrite),
        .MemtoReg_in(MemtoReg),
        .Jump_in(Jump), .Jalr_in(Jalr),
        .pc_out(ID_EX_PC),
        .rs1_out(ID_EX_rs1), .rs2_out(ID_EX_rs2),
        .imm_out(ID_EX_imm), .rd_out(ID_EX_rd),
        .ALUOp_out(ID_EX_ALUOp), .ALUSrc_out(ID_EX_ALUSrc),
        .Branch_out(ID_EX_Branch),
        .MemRead_out(ID_EX_MemRead), .MemWrite_out(ID_EX_MemWrite),
        .RegWrite_out(ID_EX_RegWrite),
        .MemtoReg_out(ID_EX_MemtoReg),
        .Jump_out(ID_EX_Jump), .Jalr_out(ID_EX_Jalr)
    );

    // Forwarding Unit
    forwarding_unit FW (
        .EX_MEM_RegWrite(EX_MEM_RegWrite), .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .EX_MEM_rd(EX_MEM_rd), .MEM_WB_rd(MEM_WB_rd),
        .ID_EX_rs1(ID_EX_rd), .ID_EX_rs2(ID_EX_rd),
        .ForwardA(ForwardA), .ForwardB(ForwardB)
    );
    // (Also instantiate correct ID_EX_rs1/rs2 forwarding if needed)

    // ALU operand selection (with forwarding)
    wire [31:0] ALU_in2_reg;
    assign ALU_in1 =
    (ForwardA == 2'b10) ? EX_MEM_alu_result :
    (ForwardA == 2'b01) ? write_back_data :
                          ID_EX_rs1;

assign ALU_in2_reg =
    (ForwardB == 2'b10) ? EX_MEM_alu_result :
    (ForwardB == 2'b01) ? write_back_data :
                          ID_EX_rs2;

assign ALU_in2 = ID_EX_ALUSrc ? ID_EX_imm : ALU_in2_reg;

    // ALU Control and Execution
    alu_control ALUCTRL (
        .ALUOp(ID_EX_ALUOp), .funct3(ID_EX_imm[2:0]), .funct7_5(ID_EX_imm[10]),
        .ALU_control(ALU_control)
    );
    alu ALU (
        .A(ALU_in1), .B(ALU_in2), .ALU_control(ALU_control),
        .result(alu_result), .zero(zero)
    );

    // Compute branch target (PC + immediate)
    assign branch_target = ID_EX_PC + ID_EX_imm;
    assign branch_taken  = (ID_EX_Branch && zero) || ID_EX_Jump || ID_EX_Jalr;

    // PC Update (with stall/flush)
    // stall logic not implemented; assume stall=0 for simplicity
    assign stall = 1'b0;
    assign PC_Write = ~stall;
    assign IF_ID_Write = ~stall;
    assign Control_Mux = branch_taken; // example: when flush = branch, controls = 0
    assign flush = branch_taken;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_reg <= 0;
        end else if (PC_Write) begin
            PC_reg <= (flush) ? branch_target : (PC_reg + 4);
        end
    end

    // EX/MEM Pipeline Register
    ex_mem_reg EX_MEM (
        .clk(clk), .reset(reset),
        .alu_result_in(alu_result), .rs2_in(ALU_in2_reg),
        .rd_in(ID_EX_rd),
        .MemRead_in(ID_EX_MemRead), .MemWrite_in(ID_EX_MemWrite),
        .RegWrite_in(ID_EX_RegWrite), .MemtoReg_in(ID_EX_MemtoReg),
        .alu_result_out(EX_MEM_alu_result), .rs2_out(EX_MEM_rs2),
        .rd_out(EX_MEM_rd), .MemRead_out(EX_MEM_MemRead),
        .MemWrite_out(EX_MEM_MemWrite), .RegWrite_out(EX_MEM_RegWrite),
        .MemtoReg_out(EX_MEM_MemtoReg)
    );

    // Data Memory
    assign mem_addr = EX_MEM_alu_result;
    assign mem_write_data = EX_MEM_rs2;
    data_mem DMEM (
        .clk(clk), .addr(mem_addr), .write_data(mem_write_data),
        .we(EX_MEM_MemWrite), .func3(ID_EX_imm[2:0]),
        .data_out(mem_read_data)
    );

    // MEM/WB Pipeline Register
    mem_wb_reg MEM_WB (
        .clk(clk), .reset(reset),
        .mem_data_in(mem_read_data), .alu_result_in(EX_MEM_alu_result),
        .rd_in(EX_MEM_rd), .RegWrite_in(EX_MEM_RegWrite),
        .MemtoReg_in(EX_MEM_MemtoReg),
        .mem_data_out(MEM_WB_mem_data), .alu_result_out(MEM_WB_alu_result),
        .rd_out(MEM_WB_rd), .RegWrite_out(MEM_WB_RegWrite),
        .MemtoReg_out(MEM_WB_MemtoReg)
    );

    // Write-back MUX
    assign write_back_data = MEM_WB_MemtoReg ? MEM_WB_mem_data : MEM_WB_alu_result;
endmodule
