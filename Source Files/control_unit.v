module control_unit (
    input  wire [6:0] opcode,
    output reg        MemtoReg, RegWrite,
    output reg        MemRead, MemWrite,
    output reg        ALUSrc, Branch,
    output reg        Jump, Jalr,
    output reg [1:0]  ALUOp
);
    always @(*) begin
        
        MemtoReg = 0; RegWrite = 0; MemRead = 0; MemWrite = 0;
        ALUSrc = 0; Branch = 0; Jump = 0; Jalr = 0; ALUOp = 2'b00;
        case (opcode)
            7'b0110011: begin // R-type
                RegWrite = 1; ALUOp = 2'b10;
            end
            7'b0010011: begin // I-type ALU 
                RegWrite = 1; ALUSrc = 1; ALUOp = 2'b10;
            end
            7'b0000011: begin // Load (LW)
                RegWrite = 1; MemtoReg = 1; MemRead = 1; ALUSrc = 1; ALUOp = 2'b00;
            end
            7'b0100011: begin // Store (SW)
                MemWrite = 1; ALUSrc = 1; ALUOp = 2'b00;
            end
            7'b1100011: begin // Branch (BEQ, BNE)
                Branch = 1; ALUOp = 2'b01;
            end
            7'b1101111: begin // JAL
                RegWrite = 1; Jump = 1;
            end
            7'b1100111: begin // JALR
                RegWrite = 1; Jalr = 1; ALUSrc = 1; ALUOp = 2'b00;
            end
            7'b0110111: begin // LUI
                RegWrite = 1; ALUSrc = 1; ALUOp = 2'b10;
            end
            7'b0010111: begin // AUIPC
                RegWrite = 1; ALUSrc = 1; ALUOp = 2'b10;
            end
            default: begin
               
            end
        endcase
    end
endmodule
