// SHA256 defines a few operations, or transforms, on words (32-bit data) 
// This file implements these operations

module sigma0 (input [31:0] in, output [31:0] out);
	// sigma 0 implements ROTR7 XOR ROTR18 XOR SHR3
	logic [31:0] shift_right;
	assign shift_right = in >> 3;
	assign out = {in[6:0], in[31:7]} ^ {in[17:0], in[31:18]} ^ shift_right;
endmodule


module sigma1 (input [31:0] in, output [31:0] out);
	// sigma1 implements ROTR17 XOR ROTR19 XOR SHR10
	logic [31:0] shift_right;
	assign shift_right = in >> 10;
	assign out = {in[16:0], in[31:17]} ^ {in[18:0], in[31:19]} ^ shift_right;
endmodule


module SIGMA0 (input [31:0] in, output [31:0] out);
	// SIGMA0 implements ROTR2 XOR ROTR13 XOR ROTR22
	assign out = {in[1:0], in[31:2]} ^ {in[12:0], in[31:13]} ^ {in[21:0], in[31:22]};
endmodule


module SIGMA1 (input [31:0] in, output [31:0] out);
	// SIGMA1 implements ROTR6 XOR ROTR11 XOR ROTR25
	assign out = {in[5:0], in[31:6]} ^ {in[10:0], in[31:11]} ^ {in[24:0], in[31:25]};
endmodule


module choice (input [31:0] in0, in1, in2, output [31:0] out);
	// choice takes input from either in1 or in2, depending on in0 value.
	// For a particular bit, if in0 is 0, it takes the bit of in2; otherwise, it takes the value of in1
	// Using truth table, the expression is ~in0&in2 + in0&in1
	assign out = (~in0 & in2) | (in0 & in1);
endmodule

module majority (input [31:0] in0, in1, in2, output [31:0] out);
	// majority function returns 0 for a bit if the corresponding bits have a majority of 0;
	// otherwise, it returns 1. 
	assign out = in0 & (in1 | in2) | (in1 & in2);
endmodule
