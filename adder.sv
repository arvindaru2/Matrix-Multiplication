module hadder
(
	input logic a, b,
	output logic s, o
);

always_comb
begin
	s = a ^ b;
	o = a & b;
end

endmodule : hadder

module fadder
(
	input logic a, b, c,
	output logic s, o
);
	logic h;

always_comb
begin
	h = a ^ b;
	s = h ^ c;
	o = (a & b) | (h & c);
end

endmodule : fadder



module la_adder
(
	input logic a, b, c,
	output logic s
);

always_comb
begin
	s = a ^ b ^ c;
end

endmodule : la_adder

module la_logic
(
	input logic [3:0] a, b,
	input logic c,
	output logic [3:0] o
);

	logic p0, p1, p2, p3;
	logic g0, g1, g2, g3;
	logic gg;

always_comb
begin

	g0 = a[0] & b[0];
	g1 = a[1] & b[1];
	g2 = a[2] & b[2];
	g3 = a[3] & b[3];
	
	p0 = a[0] | b[0]; 
	p1 = a[1] | b[1];
	p2 = a[2] | b[2];
	p3 = a[3] | b[3];

	gg = g3 | (g2 & p3) | (g1 & p3 & p2) | (g0 & p3 & p2 & p1);

	o[0] = g0 | (p0 & c);
	o[1] = g1 | (p1 & o[0]);
	o[2] = g2 | (p2 & o[1]);
	
	o[3] = (p0 & p1 & p2 & p3 & c) | gg;
	
end

endmodule : la_logic



module la_4
(
	input logic [3:0] a, b,
	input logic c,
	output logic [3:0] s,
	output logic o
);

	logic [3:0] c_wire;
	assign o = c_wire[3];

	la_adder unit0
	(
		.a(a[0]),
		.b(b[0]),
		.c(c),
		.s(s[0])
	);

	la_adder unit1
	(
		.a(a[1]),
		.b(b[1]),
		.c(c_wire[0]),
		.s(s[1])
	);

	la_adder unit2
	(
		.a(a[2]),
		.b(b[2]),
		.c(c_wire[1]),
		.s(s[2])
	);

	la_adder unit3
	(
		.a(a[3]),
		.b(b[3]),
		.c(c_wire[2]),
		.s(s[3])
	);


	la_logic unitA
	(
		.a(a),
		.b(b),
		.c(c),
		.o(c_wire)
	);

endmodule : la_4

module la_8
(
	input logic [7:0] a, b,
	input logic c,
	output logic [7:0] s,
	output logic o
);

	logic c_wire;

	la_4 unit0
	(
		.a(a[3:0]),
		.b(b[3:0]),
		.c(c),
		.s(s[3:0]),
		.o(c_wire)
	);

	la_4 unit1
	(
		.a(a[7:4]),
		.b(b[7:4]),
		.c(c_wire),
		.s(s[7:4]),
		.o(o)
	);
	
endmodule : la_8


module la_16
(
	input logic [15:0] a, b,
	input logic c,
	output logic [15:0] s,
	output logic o
);

	logic c_wire;

	la_8 unit0
	(
		.a(a[7:0]),
		.b(b[7:0]),
		.c(c),
		.s(s[7:0]),
		.o(c_wire)
	);

	la_8 unit1
	(
		.a(a[15:8]),
		.b(b[15:8]),
		.c(c_wire),
		.s(s[15:8]),
		.o(o)
	);
	
endmodule : la_16


module la_20
(
	input logic [19:0] a, b,
	input logic c,
	output logic [19:0] s,
	output logic o
);

	logic c_wire;

	la_16 unit0
	(
		.a(a[15:0]),
		.b(b[15:0]),
		.c(c),
		.s(s[15:0]),
		.o(c_wire)
	);

	la_4 unit1
	(
		.a(a[19:16]),
		.b(b[19:16]),
		.c(c_wire),
		.s(s[19:16]),
		.o(o)
	);
	
endmodule : la_20


module csa_4
(
	input logic [3:0] a, b, c,
	output logic [3:0] s, o

);

	fadder unit0
	(
		.a(a[0]),
		.b(b[0]),
		.c(c[0]),
		.s(s[0]),
		.o(o[0])
	);

	fadder unit1
	(
		.a(a[1]),
		.b(b[1]),
		.c(c[1]),
		.s(s[1]),
		.o(o[1])
	);
	
	fadder unit2
	(
		.a(a[2]),
		.b(b[2]),
		.c(c[2]),
		.s(s[2]),
		.o(o[2])
	);

	fadder unit3
	(
		.a(a[3]),
		.b(b[3]),
		.c(c[3]),
		.s(s[3]),
		.o(o[3])
	);	

endmodule : csa_4

module csa_16
(
	input logic [15:0] a, b, c,
	output logic [15:0] s, o

);

	csa_4 unit0
	(
		.a(a[3:0]),
		.b(b[3:0]),
		.c(c[3:0]),
		.s(s[3:0]),
		.o(o[3:0])
	);

	csa_4 unit1
	(
		.a(a[7:4]),
		.b(b[7:4]),
		.c(c[7:4]),
		.s(s[7:4]),
		.o(o[7:4])
	);
	
	csa_4 unit2
	(
		.a(a[11:8]),
		.b(b[11:8]),
		.c(c[11:8]),
		.s(s[11:8]),
		.o(o[11:8])
	);

	csa_4 unit3
	(
		.a(a[15:12]),
		.b(b[15:12]),
		.c(c[15:12]),
		.s(s[15:12]),
		.o(o[15:12])
	);	

endmodule : csa_16






