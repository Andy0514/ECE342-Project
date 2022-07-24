
module dut_sha256_core();

	// 20MHz clock
	logic clk;
	always #10 clk = ~clk;

	// This is the testing module that instantiates the SHA256 core
	logic [255:0] init;
	logic [511:0] value;
	logic start;
	logic [255:0] result;
	SHA256_core mycore (
		.clk(clk),
		.init(init),
		.value(value),
		.start(start),
		.result(result)
	);


	initial begin
		clk = 0;

		#5;
		init = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
		value = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
		start = 1'b1;
		#20;

		start = 1'b0;

		#4000;

		#5;
		init = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
		value = 512'h1c2f28d9e4bbdb6521bfa0ce3907cbc15f103b02430141bc4d4c35153135ea4c8000000000000000000000000000000000000000000000000000000000000100;
		start = 1'b1;
		#20;

		start = 1'b0;
		#4000;
		$stop();
	end

endmodule

module dut_controller();

	// 20MHz clock
	logic clk;
	always #10 clk = ~clk;

	// This is the testing module that instantiates the SHA256 core
	logic [255:0] midstate;
	logic [95:0] data;
	logic [255:0] target;
	logic calculate;
	logic [31:0] nonce;
	logic done;

	SHA256_controller dut (
			.CLOCK_50(clk),
			.calculate(calculate),
			.data(data),
			.midstate(midstate),
			.target(target),
			.good_nonce(nonce),
			.done(done)
		);

		initial begin
			clk = 0;
			#5;
			midstate = 256'h9fd47d57faf88825063461d541602d390d6660430815e94bbf5de76d74b4c79d;
			data = 96'h1a65600ea6c8cb4db3936a1a;
			target = 256'h0000000000006a93b30000000000000000000000000000000000000000000000;
			calculate = 1'b1;
			#220;
			calculate = 1'b0;
			#40;
			calculate = 1'b1;
			#60;
			calculate = 1'b0;
			#20000;
			$stop();
		end

endmodule
