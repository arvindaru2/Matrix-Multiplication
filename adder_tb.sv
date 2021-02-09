
module adder_tb();


timeunit 10ns;			
timeprecision 1ns;	


	logic [63:0] a;
	logic [63:0] b;
	logic [159:0] cin;
	logic [19:0] out0, out1, out2, out3, out4, out5, out6, out7;
	logic clk;
	logic load;
	logic load_w;
	logic [159:0] mm_out;
	
	multiply_matrix unit0
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(cin),
		.a(a),
		.b(b),
		.out(mm_out)
	);

	assign out0 = mm_out[19:0];
	assign out1 = mm_out[39:20];
	assign out2 = mm_out[59:40];
	assign out3 = mm_out[79:60];
	assign out4 = mm_out[99:80];
	assign out5 = mm_out[119:100];
	assign out6 = mm_out[139:120];
	assign out7 = mm_out[159:140];	
	
	
initial 
	begin
		cin = 0;
		clk = 0;
		load = 0;
		load_w = 0;
		a = 0;
		b = 0;

	end
	
always
	begin
		#1 clk = ~clk;
	end

initial
	begin
		
		#2 cin = 0;
load_w = 1'b1;
b = 64'h730700b998c49544;
#2
b = 64'h288b3510244cea59;
#2
b = 64'h005adeae6b9d0794;
#2
b = 64'h09e5cdc7b5482ef6;
#2
b = 64'hdd7e403a2c4618e6;
#2
b = 64'h58a7d1115d13e924;
#2
b = 64'h679671e971915b08;
#2
b = 64'ha1bc82d6e5a50577;
#2
load_w = 0;
load = 1;
a = 64'h66ba6bf9809fc718;
#2
a = 64'h27a3be6a4e9c9aac;
#2
a = 64'h529f2b7fda9b60f7;
#2
a = 64'hd27f211051e8a191;
#2
a = 64'h332ffae3f5eb1417;
#2
a = 64'hb31dd5992555aedb;
#2
a = 64'h20f32500933a4336;
#2
a = 64'h378a8e77c61643fe;

	end
	
endmodule : adder_tb


