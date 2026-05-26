module instr_mem (
    input  wire        clk,
    input  wire [31:0] addr,
    output reg  [31:0] instr
);
    // 1024 x 32-bit instruction memory
    reg [31:0] mem [0:1023];

    initial begin
        $readmemh("instr.mem", mem);  // Load program
    end

    always @(posedge clk) begin
        // Word-aligned fetch: ignore bottom 2 bits of addr
        instr <= mem[addr[11:2]];
    end
endmodule
