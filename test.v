module tb_processor;

  // Inputs
  reg clk;
  reg reset;

  // Outputs
  wire [31:0] pc;
  wire [31:0] instruc;
  wire [31:0] dataa;
  wire [31:0] datab;
  wire [31:0] dpack;
  wire [31:0] sum;
  wire [31:0] out1;
  wire [31:0] out2;
  wire [31:0] out3;
  wire [31:0] out4;
  wire [31:0] out5;
  wire [2:0] gout;
  wire zout;
  wire regdest;
  wire alusrc;
  wire memtoreg;
  wire regwrite;
  wire memread;
  wire memwrite;
  wire branch;
  wire aluop1;
  wire aluop0;

  // Instantiate the processor module
  processor processor_dut (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .instruc(instruc),
    .dataa(dataa),
    .datab(datab),
    .dpack(dpack),
    .sum(sum),
    .out1(out1),
    .out2(out2),
    .out3(out3),
    .out4(out4),
    .out5(out5),
    .gout(gout),
    .zout(zout),
    .regdest(regdest),
    .alusrc(alusrc),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .memread(memread),
    .memwrite(memwrite),
    .branch(branch),
    .aluop1(aluop1),
    .aluop0(aluop0)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Reset pulse
initial begin
    reset = 1'b1;
    #20 reset = 1'b0;
  end

  // Test data and instructions (replace with your specific test cases)
  reg [31:0] test_data[0:7];
  reg [31:0] test_instr[0:7];

  initial begin
    // Load data and instructions into memory (replace with your data)
    test_data[0] = 32'h0000000A;  // Sample data
    test_data[1] = 32'h0000000B;
    test_instr[0] = 32'h0100000A; // Sample instruction (add)
    test_instr[1] = 32'h00000005; // Sample instruction (load)

    // Write data to data memory
    integer i;
    for (i = 0; i < 8; i = i + 1) begin
      processor_dut.datmem[i] = test_data[i][7:0];
      processor_dut.datmem[i + 1] = test_data[i][15:8];
      processor_dut.datmem[i + 2] = test_data[i][23:16];
      processor_dut.datmem[i + 3] = test_data[i][31:24];
    end

    // Write instructions to instruction memory
    for (i = 0; i < 8; i = i + 1) begin
      processor_dut.mem[i] = test_instr[i][7:0];
      processor_dut.mem[i + 1] = test_instr[i][15:8];
      processor_dut.mem[i + 2] = test_instr[i][23:16];
      processor_dut.mem[i + 3] = test_instr[i][31:24];

end
endmodule
