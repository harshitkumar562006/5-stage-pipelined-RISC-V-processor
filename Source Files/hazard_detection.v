module hazard_detection (
    input  wire [4:0] IF_ID_rs1, IF_ID_rs2,
    input  wire [4:0] ID_EX_rd,
    input  wire       ID_EX_MemRead,
    output reg        stall
);
    always @(*) begin
        
        if (ID_EX_MemRead && ((ID_EX_rd == IF_ID_rs1) || (ID_EX_rd == IF_ID_rs2))) 
            stall = 1;
        else
            stall = 0;
    end
endmodule
