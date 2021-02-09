module accumulator_unit 
(
    input clk,
    input load,
    input [15:0] a,
	input [19:0] b,
    output logic [19:0] out
);

	logic [19:0] ase;
	logic [19:0] adder_out;
	
	assign ase = {a[15], a[15], a[15], a[15], a};
	
	la_20 unit_0
	(
		.a(ase),
		.b(b),
		.c(1'b0),
		.s(adder_out),
		.o()
	);


	register #(20) unit_1
	(
		.clk(clk),
		.load(load),
		.in(adder_out),
		.out(out)
	);

endmodule : accumulator_unit


module multiply_accumulate_unit
(
    input clk,
    input load,
    input [7:0] a, 
	input [7:0] b,
	input [19:0] c,
    output logic [19:0] out
);

	logic [15:0] multi_out;
	logic [15:0] reg_out;

	multi8_8 unit_0
	(
		.clk(clk),
		.load(load),
		.a(a),
		.b(b),
		.m(multi_out)
	);	
	
	register #(16) unit_1
	(
		.clk(clk),
		.load(load),
		.in(multi_out),
		.out(reg_out)
	);	

	accumulator_unit unit_2
	(
		.clk(clk),
		.load(load),
		.a(reg_out),
		.b(c),
		.out(out)
	);

endmodule : multiply_accumulate_unit


module multiply_accumulate_slice
(
    input clk,
    input load,
    input [7:0] a0, a1, a2, a3, a4, a5, a6, a7, 
	input [7:0] b0, b1, b2, b3, b4, b5, b6, b7,
	input [19:0] c,
    output logic [19:0] out
);

	logic [19:0] w01, w12, w23, w34, w45, w56, w67;

	multiply_accumulate_unit unit_0
	(
		.clk(clk),
		.load(load),
		.a(a0), 
		.b(b0),
		.c(c),
		.out(w01)
	);


	multiply_accumulate_unit unit_1
	(
		.clk(clk),
		.load(load),
		.a(a1), 
		.b(b1),
		.c(w01),
		.out(w12)
	);

	multiply_accumulate_unit unit_2
	(
		.clk(clk),
		.load(load),
		.a(a2), 
		.b(b2),
		.c(w12),
		.out(w23)
	);
	
	multiply_accumulate_unit unit_3
	(
		.clk(clk),
		.load(load),
		.a(a3), 
		.b(b3),
		.c(w23),
		.out(w34)
	);

	multiply_accumulate_unit unit_4
	(
		.clk(clk),
		.load(load),
		.a(a4), 
		.b(b4),
		.c(w34),
		.out(w45)
	);	
	
	multiply_accumulate_unit unit_5
	(
		.clk(clk),
		.load(load),
		.a(a5), 
		.b(b5),
		.c(w45),
		.out(w56)
	);
	
	multiply_accumulate_unit unit_6
	(
		.clk(clk),
		.load(load),
		.a(a6), 
		.b(b6),
		.c(w56),
		.out(w67)
	);

	multiply_accumulate_unit unit_7
	(
		.clk(clk),
		.load(load),
		.a(a7), 
		.b(b7),
		.c(w67),
		.out(out)
	);	



endmodule : multiply_accumulate_slice


module slice_reg
(
    input clk,
    input load,
	input load_w,
	input [19:0] c,
    input [63:0] a,
	input [63:0] b,
	output [63:0] breg,
    output logic [19:0] out
);



	register #(64) unit0
	(
		.clk(clk),
		.load(load_w),
		.in(b),
		.out(breg)
	);


	multiply_accumulate_slice unit1
	(
		.clk(clk),
		.load(load),
		.a0(a[7:0]), .a1(a[15:8]), .a2(a[23:16]), .a3(a[31:24]), .a4(a[39:32]), .a5(a[47:40]), .a6(a[55:48]), .a7(a[63:56]), 
		.b0(breg[7:0]), .b1(breg[15:8]), .b2(breg[23:16]), .b3(breg[31:24]), .b4(breg[39:32]), .b5(breg[47:40]), .b6(breg[55:48]), .b7(breg[63:56]),
		.c(c),
		.out(out)
	);

endmodule : slice_reg


module multiply_matrix
(
    input clk,
    input load,
	input load_w,
	input [159:0] c,
    input [63:0] a,
	input [63:0] b,
    output logic [159:0] out
);

	logic [63:0] b01, b12, b23, b34, b45, b56, b67;
	logic [63:0] ad;

	input_delay_chain inst
	(
		.clk(clk),
		.load(load),
		.a(a),
		.a_out(ad)
	);


	slice_reg unit0
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(c[19:0]),
		.a(ad),
		.b(b),
		.breg(b01),
		.out(out[19:0])
	);

	slice_reg unit1
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(c[39:20]),
		.a(ad),
		.b(b01),
		.breg(b12),
		.out(out[39:20])
	);
	
	slice_reg unit2
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(c[59:40]),
		.a(ad),
		.b(b12),
		.breg(b23),
		.out(out[59:40])
	);

	slice_reg unit3
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(c[79:60]),
		.a(ad),
		.b(b23),
		.breg(b34),
		.out(out[79:60])
	);

	slice_reg unit4
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(c[99:80]),
		.a(ad),
		.b(b34),
		.breg(b45),
		.out(out[99:80])
	);

	slice_reg unit5
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(c[119:100]),
		.a(ad),
		.b(b45),
		.breg(b56),
		.out(out[119:100])
	);

	slice_reg unit6
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(c[139:120]),
		.a(ad),
		.b(b56),
		.breg(b67),
		.out(out[139:120])
	);

	slice_reg unit7
	(
		.clk(clk),
		.load(load),
		.load_w(load_w),
		.c(c[159:140]),
		.a(ad),
		.b(b67),
		.breg(),
		.out(out[159:140])
	);	


endmodule : multiply_matrix


module input_delay_chain
(
    input clk,
    input load,
    input [63:0] a,
    output logic [63:0] a_out
);

	logic [7:0] a10, a11;
	logic [7:0] a20, a21, a22;
	logic [7:0] a30, a31, a32, a33;
	logic [7:0] a40, a41, a42, a43, a44;
	logic [7:0] a50, a51, a52, a53, a54, a55;
	logic [7:0] a60, a61, a62, a63, a64, a65, a66;
	logic [7:0] a70, a71, a72, a73, a74, a75, a76, a77;
		
	assign a10 = a[15:8];
	assign a20 = a[23:16];
	assign a30 = a[31:24];
	assign a40 = a[39:32];
	assign a50 = a[47:40];
	assign a60 = a[55:48];
	assign a70 = a[63:56];
	
	register #(8) unit1_0 (.clk(clk), .load(load), .in(a10), .out(a11));

	register #(8) unit2_0 (.clk(clk), .load(load), .in(a20), .out(a21));	
	register #(8) unit2_1 (.clk(clk), .load(load), .in(a21), .out(a22));

	register #(8) unit3_0 (.clk(clk), .load(load), .in(a30), .out(a31));
	register #(8) unit3_1 (.clk(clk), .load(load), .in(a31), .out(a32));
	register #(8) unit3_2 (.clk(clk), .load(load), .in(a32), .out(a33));

	register #(8) unit4_0 (.clk(clk), .load(load), .in(a40), .out(a41));
	register #(8) unit4_1 (.clk(clk), .load(load), .in(a41), .out(a42));
	register #(8) unit4_2 (.clk(clk), .load(load), .in(a42), .out(a43));
	register #(8) unit4_3 (.clk(clk), .load(load), .in(a43), .out(a44));

	register #(8) unit5_0 (.clk(clk), .load(load), .in(a50), .out(a51));
	register #(8) unit5_1 (.clk(clk), .load(load), .in(a51), .out(a52));
	register #(8) unit5_2 (.clk(clk), .load(load), .in(a52), .out(a53));
	register #(8) unit5_3 (.clk(clk), .load(load), .in(a53), .out(a54));
	register #(8) unit5_4 (.clk(clk), .load(load), .in(a54), .out(a55));

	register #(8) unit6_0 (.clk(clk), .load(load), .in(a60), .out(a61));
	register #(8) unit6_1 (.clk(clk), .load(load), .in(a61), .out(a62));
	register #(8) unit6_2 (.clk(clk), .load(load), .in(a62), .out(a63));
	register #(8) unit6_3 (.clk(clk), .load(load), .in(a63), .out(a64));
	register #(8) unit6_4 (.clk(clk), .load(load), .in(a64), .out(a65));
	register #(8) unit6_5 (.clk(clk), .load(load), .in(a65), .out(a66));

	register #(8) unit7_0 (.clk(clk), .load(load), .in(a70), .out(a71));
	register #(8) unit7_1 (.clk(clk), .load(load), .in(a71), .out(a72));
	register #(8) unit7_2 (.clk(clk), .load(load), .in(a72), .out(a73));
	register #(8) unit7_3 (.clk(clk), .load(load), .in(a73), .out(a74));
	register #(8) unit7_4 (.clk(clk), .load(load), .in(a74), .out(a75));
	register #(8) unit7_5 (.clk(clk), .load(load), .in(a75), .out(a76));
	register #(8) unit7_6 (.clk(clk), .load(load), .in(a76), .out(a77));

	assign a_out = {a77, a66, a55, a44, a33, a22, a11, a[7:0]};


endmodule : input_delay_chain









