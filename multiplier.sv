module dec_mux 
(
	input logic [2:0] sel,
	input logic [8:0] zer, p1, p2, m1, m2,
	output logic [8:0] o
);

always_comb
begin
	if (sel == 3'b000)
		o = zer;
	else if (sel == 3'b001)
		o = p1;
	else if (sel == 3'b010)
		o = p1;
	else if (sel == 3'b011)
		o = p2;
	else if (sel == 3'b100)
		o = m2;
	else if (sel == 3'b101)
		o = m1;
	else if (sel == 3'b110)
		o = m1;
	else
		o = zer;
end

endmodule : dec_mux


module booth_pp
(
	input logic [7:0] a, b,
	output logic [8:0] pp0, pp1, pp2, pp3
);

	logic [2:0] dec0, dec1, dec2, dec3;
	logic [7:0] invb;
	logic [7:0] negb;
	
	logic [8:0] zeros = 9'h000;
	logic [8:0] p1;
	logic [8:0] p2;
	logic [8:0] m1;
	logic [8:0] m2;

	assign dec0[2:1] = a[1:0];
	assign dec0[0] = 1'b0;
	assign dec1 = a[3:1];
	assign dec2 = a[5:3];
	assign dec3 = a[7:5];
	
	assign invb = ~b;
	
	la_8 unitA
	(
		.a(zeros[7:0]),
		.b(invb),
		.c(1'b1),
		.s(negb),
		.o()
	);
	
	assign p1 = {b[7], b};
	assign p2 = {b, 1'b0};	
	assign m1 = {negb[7], negb};
	assign m2 = {negb, 1'b0};	


	dec_mux unit0
	(
		.sel(dec0),
		.zer(zeros),
		.p1(p1),
		.p2(p2),
		.m1(m1),
		.m2(m2),
		.o(pp0)
	);	

	dec_mux unit1
	(
		.sel(dec1),
		.zer(zeros),
		.p1(p1),
		.p2(p2),
		.m1(m1),
		.m2(m2),
		.o(pp1)
	);	
	
		dec_mux unit2
	(
		.sel(dec2),
		.zer(zeros),
		.p1(p1),
		.p2(p2),
		.m1(m1),
		.m2(m2),
		.o(pp2)
	);	
	
		dec_mux unit3
	(
		.sel(dec3),
		.zer(zeros),
		.p1(p1),
		.p2(p2),
		.m1(m1),
		.m2(m2),
		.o(pp3)
	);	

endmodule : booth_pp



module csa_12
(
	input logic [8:0] pp0, pp1, pp2, pp3,
	output logic [15:0] fp0, fp1
);

	logic [11:0] se0;
	logic [10:0] se1, se2;
	logic [9:0] se3;
	
	logic pp0s, pp1s, pp2s, pp3s;
	logic pp0si, pp1si, pp2si, pp3si;
	
	assign pp0s = pp0[8]; 
	assign pp1s = pp1[8];
	assign pp2s = pp2[8];
	assign pp3s = pp3[8];

	assign pp0si = ~pp0s;
	assign pp1si = ~pp1s;
	assign pp2si = ~pp2s;
	assign pp3si = ~pp3s;

	assign se0 = {pp0si, pp0s, pp0s, pp0};
	assign se1 = {1, pp1si, pp1};
	assign se2 = {1, pp2si, pp2};
	assign se3 = {pp3si, pp3};	

	logic [8:0] sw0, cw0;
	logic [8:0] sw1, cw1;
	
	hadder unit0_4 	(.a(se0[4]),  .b(se1[2]),              .s(sw0[0]), .o(cw0[0]));
	fadder unit0_5	(.a(se0[5]),  .b(se1[3]),  .c(se2[1]), .s(sw0[1]), .o(cw0[1]));
	fadder unit0_6	(.a(se0[6]),  .b(se1[4]),  .c(se2[2]), .s(sw0[2]), .o(cw0[2]));
	fadder unit0_7	(.a(se0[7]),  .b(se1[5]),  .c(se2[3]), .s(sw0[3]), .o(cw0[3]));
	fadder unit0_8	(.a(se0[8]),  .b(se1[6]),  .c(se2[4]), .s(sw0[4]), .o(cw0[4]));
	fadder unit0_9	(.a(se0[9]),  .b(se1[7]),  .c(se2[5]), .s(sw0[5]), .o(cw0[5]));
	fadder unit0_10	(.a(se0[10]), .b(se1[8]),  .c(se2[6]), .s(sw0[6]), .o(cw0[6]));
	fadder unit0_11	(.a(se0[11]), .b(se1[9]),  .c(se2[7]), .s(sw0[7]), .o(cw0[7]));
	fadder unit0_12	(.a(se3[6]),  .b(se1[10]), .c(se2[8]), .s(sw0[8]), .o(cw0[8]));	
	
	hadder inst1_6 	(.a(cw0[1]),  .b(sw0[2]),              .s(sw1[0]), .o(cw1[0]));
	fadder unit1_7	(.a(cw0[2]),  .b(sw0[3]),  .c(se3[1]), .s(sw1[1]), .o(cw1[1]));
	fadder unit1_8	(.a(cw0[3]),  .b(sw0[4]),  .c(se3[2]), .s(sw1[2]), .o(cw1[2]));
	fadder unit1_9	(.a(cw0[4]),  .b(sw0[5]),  .c(se3[3]), .s(sw1[3]), .o(cw1[3]));
	fadder unit1_10	(.a(cw0[5]),  .b(sw0[6]),  .c(se3[4]), .s(sw1[4]), .o(cw1[4]));
	fadder unit1_11	(.a(cw0[6]),  .b(sw0[7]),  .c(se3[5]), .s(sw1[5]), .o(cw1[5]));
	hadder unit1_12	(.a(cw0[7]),  .b(sw0[8]),  			   .s(sw1[6]), .o(cw1[6]));
	fadder unit1_13	(.a(cw0[8]),  .b(se2[9]),  .c(se3[7]), .s(sw1[7]), .o(cw1[7]));
	hadder unit1_14	(.a(se2[10]), .b(se3[8]),              .s(sw1[8]), .o(cw1[8]));	
	
	assign fp0 = {cw1, se3[0], cw0[0], sw0[0], se0[3:0]};
	assign fp1 = {se3[9], sw1, sw0[1], se2[0], se1[1], se1[0], 1'b0, 1'b0};
	
endmodule : csa_12

module multi8_8
(
	input logic clk, load,
	input logic [7:0] a, b,
	output logic [15:0] m
);

	logic [8:0] pp0, pp1, pp2, pp3;
	logic [8	:0] ppr0, ppr1, ppr2, ppr3;
	logic [15:0] fp0, fp1;

	booth_pp unit_0
	(
		.a(a),
		.b(b),
		.pp0(pp0),
		.pp1(pp1),
		.pp2(pp2),
		.pp3(pp3)
	);

	register #(9) unit_A
	(
		.clk(clk),
		.load(load),
		.in(pp0),
		.out(ppr0)
	);

	register #(9) unit_B
	(
		.clk(clk),
		.load(load),
		.in(pp1),
		.out(ppr1)
	);

	register #(9) unit_C
	(
		.clk(clk),
		.load(load),
		.in(pp2),
		.out(ppr2)
	);

	register #(9) unit_D
	(
		.clk(clk),
		.load(load),
		.in(pp3),
		.out(ppr3)
	);


	csa_12 unit_1
	(
		.pp0(ppr0),
		.pp1(ppr1),
		.pp2(ppr2),
		.pp3(ppr3),
		.fp0(fp0),
		.fp1(fp1)
	);
	
	la_16 unit_2
	(
		.a(fp0),
		.b(fp1),
		.c(1'b0),
		.s(m),
		.o()
	);	

endmodule : multi8_8

