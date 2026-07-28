module data_mem (
    input  wire        clk,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    input  wire        we,
    input  wire [2:0]  func3,    // 000=Store Byte, 001=Store Half Word, 010=Store Word
    output reg [31:0]  data_out
);
    // 1024 x 32-bit memory
    reg [31:0] mem [0:1023];

    always @(posedge clk) begin
        if (we) begin
            case (func3)
                3'b000: mem[addr[11:2]][ 7: 0] <= write_data[ 7: 0]; // Store Byte
                3'b001: mem[addr[11:2]][15: 0] <= write_data[15: 0]; // Store Half Word
                3'b010: mem[addr[11:2]]        <= write_data;       // Store Word
                default: ;
            endcase
        end
    end

    always @(*) begin
        case (func3)
            3'b000: // LB (sign-extend byte)
                data_out = {{24{mem[addr[11:2]][7]}}, mem[addr[11:2]][7:0]};
            3'b001: // LH (sign-extend halfword)
                data_out = {{16{mem[addr[11:2]][15]}}, mem[addr[11:2]][15:0]};
            3'b010: // LW (word)
                data_out = mem[addr[11:2]];
            3'b100: // LBU (zero-extend byte)
                data_out = {24'b0, mem[addr[11:2]][7:0]};
            3'b101: // LHU (zero-extend half)
                data_out = {16'b0, mem[addr[11:2]][15:0]};
            default:
                data_out = mem[addr[11:2]];
        endcase
    end
endmodule
