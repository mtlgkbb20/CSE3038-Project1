module control(in,regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2,ori,jrsal,baln,jmnor,nsignal_q, bgtzal,jump,brnv);
input [5:0] in;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2,ori,jrsal,baln,jmnor, bgtzal,jump,brnv;
input nsignal_q;
wire rformat,lw,sw,beq;
assign rformat=~|in;
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=(~in[5])& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign ori=(~in[5]) & (~in[4]) & (in[3]) & (in[2]) & (~in[1]) & (in[0]);
assign jrsal=(~in[5]) & (in[4]) & (~in[3]) & (~in[2]) & (~in[1]) & (in[0]);
assign baln= (~in[5]) & (in[4]) & (in[3]) & (~in[2]) & (~in[1]) & (in[0]);
assign jmnor=(~in[5]) & (~in[4]) & (~in[3]) & (~in[2]) & (~in[1]) & (~in[0]);
assign bgtzal=(in[5]) & (~in[4]) & (~in[3]) & (~in[2]) & (~in[1]) & (in[0]); // bgtzal added
assign jump=(~in[5]) & (~in[4]) & (~in[3]) & (~in[2]) & (in[1]) & (~in[0]); // jump added
assign brnv = (~in[5]) & (~in[4]) & (in[3]) & (~in[2]) & (in[1]) & (in[0]); // brnv added
assign regdest=rformat;
assign alusrc=lw|sw;
assign memtoreg=lw;
assign regwrite=rformat|lw;
assign memread=lw;
assign memwrite=sw;
assign branch=beq;
assign aluop1=rformat;
assign aluop2=beq;
endmodule
