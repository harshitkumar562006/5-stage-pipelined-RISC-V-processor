module alu_control (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire       funct7_5,  // the 5th bit of funct7 (bit 30 of instruction)
    output reg  [3:0] ALU_control
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALU_control = 4'b0000; // ADD (for load/store)
            2'b01: ALU_control = 4'b0001; // SUB (for branches)
            2'b10: begin
                case (funct3)
                    3'b000: ALU_control = funct7_5 ? 4'b0001 : 4'b0000; // SUB/ADD
                    3'b001: ALU_control = 4'b0101; // SLL
                    3'b010: ALU_control = 4'b1000; // SLT
                    3'b011: ALU_control = 4'b1001; // SLTU
                    3'b100: ALU_control = 4'b0100; // XOR
                    3'b101: ALU_control = funct7_5 ? 4'b0111 : 4'b0110; // SRA/SRL
                    3'b110: ALU_control = 4'b0011; // OR
                    3'b111: ALU_control = 4'b0010; // AND
                    default: ALU_control = 4'b0000;
                endcase
            end
            default: ALU_control = 4'b0000;
        endcase
    end
endmodule
