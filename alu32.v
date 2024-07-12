module alu32(sum, a, b, gin, zout, aluN, aluV);
output [31:0] sum;
input [31:0] a, b;
input [2:0] gin; // ALU control line
reg [31:0] sum;
reg [31:0] less;
output zout;
reg zout;
output aluN;
reg aluN;
output aluV;
reg aluV;

  always @(a or b or gin)
  begin
    aluV = 0;
    case (gin)
      3'b010: 
	begin 
	sum = a + b; // ADD
        aluV = (a[31] == b[31]) && (sum[31] != a[31]); // Check for overflow
	end
      3'b110: 
	begin
	sum = a + 1'b1 + (~b); // SUB
        aluV = (a[31] != b[31]) && (sum[31] == a[31]); // Check for overflow
        end
      3'b111: 
	begin // Set on less than
        less = a + 1'b1 + (~b);
        if (less[31]) begin
          sum = 32'b1;
          aluN = 1; // Set negative flag if result is negative
        end else begin
          sum = 32'b0;
          aluN = 0;
        end
      end
      3'b000: 
	begin
	sum = a & b; // AaluND
        aluN = sum[31]; // aluNegative flag based on MSB of result
        aluV = 0;
	end // aluNo overflow for AaluND
      3'b001: 
	begin
	sum = a | b; // OR
        aluN = sum[31]; // aluNegative flag based on MSB of result
        aluV = 0; // aluNo overflow for OR
	end
      default: sum = 32'bx;
    endcase
    zout = ~(|sum);
    aluN = sum[31];
  end
endmodule

