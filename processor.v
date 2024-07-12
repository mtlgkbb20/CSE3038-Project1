module processor;
reg [31:0] pc; //32-bit prograom counter
reg clk; //clock
reg [7:0] datmem[0:31],mem[0:31]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire [31:0] 
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out1,
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with (Branch&ALUZero) control-mult4
out5,		//Output of mux with Ori control-mult5
out6,           //Output of mux with alu result and dataa
out7,
out8,
out9,
out10,
out11,
mult_jump_out,
pcnext,         //output of baln check
sum,		//ALU result
extad,	//Output of sign-extend unit
extzero, //Output of zero-extend unit
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
writedata,
pcreg,		//the value to be written in register
nextpc,		//pc+4
sextad;	//Output of shift left 2 unit 
wire [5:0] inst31_26;	//31-26 bits of instruction
wire [4:0] 
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instruction
inst15_11,	//15-11 bits of instruction
out0;
wire aluN, aluV;   //if alu result negative 1, if alu result overflowed 1
reg aluNreg, aluVreg;   
// reg balncheck;
wire [15:0] inst15_0;	//15-0 bits of instruction
wire nSignal_q, zSignal_q;
wire [31:0] instruc,	//current instruction
dpack;	//Read data output of memory (data read from memory)

wire [2:0] gout;	//Output of ALU control unit

wire zout,	//Zero output of ALU
pcsrc,	//Output of AND gate with Branch and ZeroOut inputs
//Control signals
regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop0,jrsal,baln,ori,jmnor,bgtzal,and_bgtzal,balncheck,jump,brnv, brnvcheck;

assign and_bgtzal = bgtzal && ~zout && ~aluNreg; // and gate for bgtzal instruction connected bgtzal, not zout and not aluN

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];

integer i;
assign writedata = dataa ? jrsal: datab;
// datamemory connections

always @(posedge clk)

//write data to memory
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=writedata[7:0];
datmem[sum[4:0]+2]=writedata[15:8];
datmem[sum[4:0]+1]=writedata[23:16];
datmem[sum[4:0]]=writedata[31:24];
end
assign nextpc = pc+4;
// or baln, jmnor, and_bgtzal
assign linkpc= baln | jmnor | and_bgtzal;

// or jmnor, jrsal
assign or_jmnor_jrsal = jmnor | jrsal;

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];


// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2
always @(posedge clk)
 
 registerfile[pcreg]= regwrite ? out3:registerfile[out1];//Write data to register

//read data from memory, sum stores address
assign dpack={datmem[sum[5:0]],datmem[sum[5:0]+1],datmem[sum[5:0]+2],datmem[sum[5:0]+3]};

//multiplexers

//mux with RegDst control
mult2_to_1_5  mult1(out0, instruc[20:16],instruc[15:11],regdest);

//Değiştirdik not!
//mux with ALUSrc control
mult2_to_1_32 mult2(out2, datab,out5,alusrc);
// //mux with ALUSrc control INITIAL
// mult2_to_1_32 mult2(out2, datab,extad,alusrc);

//mux with MemToReg control
mult2_to_1_32 mult3(out3, sum,dpack,memtoreg); // read data / alu result -> out3 (mux)

//mux with (Branch&ALUZero) control
mult2_to_1_32 mult4(out4, adder1out,adder2out,pcsrc);

//mux with Ori control
mult2_to_1_32 mult5(out5, extad, extzero, ori);

//mux with jrsal signal and sum
mult2_to_1_32 mult6(out6, sum, dataa, jrsal);

// YOK
// mult2_to_1_32 mult7(out7, datab, dataa, jrsal); 

// YOK 
//mux with dpack and out4
// mult2_to_1_32 mult8(out8, out4, dpack, jrsal); 

// mux with select bit jump -> out4 / shiftleft2 ??
mult2_to_1_32 mult_jump(mult_jump_out , out4, sextad, jump); // new ?????

// mux with select bit is or gate of jrsal/jmnor, input bits dpack, mult_jump_out, output of out7
mult2_to_1_32 mult7(out7, dpack, mult_jump_out,  or_jmnor_jrsal); // new ?????

mult2_to_1_32 mult8(out8, extad, out7,  balncheck); // new ?????

mult2_to_1_32 mult9(out9, dataa, out8,  brnvcheck); // new ?????

// YOK
// mult2_to_1_32 multlinkpc(pcreg,pcnext,nextpc,jmnor); 

// YOK
// mult2_to_1_32 multjmnor(pcnext,out9,dpack,jmnor); 

// OUT 7 YOK
//baln check
// mult2_to_1_32 multbaln(out9,out7,extad,balncheck); 

//mux to check jmnor

mult2_to_1_32 multpc(out10,out1,nextpc,linkpc);


flipflop flipflop(nSignal, clk, nSignal_q);
flipflop flipflop2(zSignal, clk, zSignal_q);

// load pc
always @(posedge clk)
// pc=pcnext;
pc=out9;

// alu, adder and control logic connections

//ALU unit
alu32 alu1(sum,dataa,out2,gout,zout,aluN,aluV);

assign balncheck = (baln)&&(aluNreg);

assign brnvcheck = (brnv)&&(~aluVreg);

//adder which adds PC and 4
adder add1(pc,32'h4,adder1out);
//adder1out = pc + 4

//adder which adds PC+4 and 2 shifted sign-extend result
adder add2(adder1out,sextad,adder2out);

//Control unit
control cont(instruc[31:26],regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop0,ori,jrsal,baln,jmnor,nsignal_q, bgtzal,jump,brnv);

//Sign extend unit
signext sext(instruc[15:0],extad);

//ALU control unit
alucont acont(aluop1,aluop0,instruc[3],instruc[2], instruc[1], instruc[0] ,gout);

//Shift-left 2 unit
shift shift2(sextad,extad);

//AND gate
assign pcsrc=branch && zout; 

always @(posedge clk)
begin
    aluNreg = aluN;
    aluVreg = aluV;
end

//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
initial
begin
$readmemh("C:\\Users\\musme\\OneDrive\\Belgeler\\GitHub\\CompOrgProject2\\initDM.dat",datmem); //read Data Memory
$readmemh("C:\\Users\\musme\\OneDrive\\Belgeler\\GitHub\\CompOrgProject2\\initIM.dat",mem);//read Instruction Memory
$readmemh("C:\\Users\\musme\\OneDrive\\Belgeler\\GitHub\\CompOrgProject2\\initReg.dat",registerfile);//read Register File

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;
#400 $finish;
	
end
initial
begin
clk=0;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial 
begin
  $monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],
"   REGISTER %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[1] );
end
endmodule