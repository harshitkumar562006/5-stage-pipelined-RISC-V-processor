module imm_gen (
    input  wire [31:0] instr,
    output reg  [31:0] imm_out
);
    wire [6:0] opcode = instr[6:0];
    always @(*) begin
        case (opcode)
            // U-type 
            7'b0010111, 7'b0110111: 
                imm_out = {instr[31:12], 12'b0};
            // J-type (JAL)
            7'b1101111: 
                imm_out = {{11{instr[31]}}, instr[31], instr[19:12],
                           instr[20], instr[30:21], 1'b0};
            // I-type (Load, ALU immediate, JALR)
            7'b1100111, 7'b0000011, 7'b0010011: 
                imm_out = {{20{instr[31]}}, instr[31:20]};
            // B-type (BEQ/BNE)
            7'b1100011: 
                imm_out = {{19{instr[31]}}, instr[31], instr[7],
                           instr[30:25], instr[11:8], 1'b0};
            // S-type (Store)
            7'b0100011: 
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            default: 
                imm_out = 32'd0;
        endcase
    end
endmodule
