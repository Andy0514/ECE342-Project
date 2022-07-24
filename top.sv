// This is the top-level module that is implemented on the FPGA.
// Its in/out ports all correspond to the actual ports of DE1-SoC.
// All signals between the computer and the SHA256 controller are
// handled using Intel SignalTap, accessed via Tcl interface on
// the computer.

module top (
	input CLOCK_50,
	output [6:0] HEX0,
   output [6:0] HEX1,
   output [6:0] HEX2,
   output [6:0] HEX3,
   output [6:0] HEX4,
   output [6:0] HEX5
);

	wire [95:0] STP_INPUT_DATA;
	wire [255:0] STP_INPUT_MIDSTATE;
	wire [255:0] STP_INPUT_TARGET;
	wire [31:0] STP_OUTPUT_NONCE;
	wire STP_INPUT_CALCULATE, STP_OUTPUT_DONE;
	
	
	// Bad module naming...
	// Probes are technically "outputs" where they read
	// signal on the FPGA. 
	// Sources are technically "inputs" because their data
	// can be read from FPGA.
	PROBE_1 probe_size_1 (
		.source_clk(CLOCK_50),
		.source(STP_INPUT_CALCULATE),
		.probe(STP_OUTPUT_DONE));
		
	PROBE_32 probe_size_32 (
		.probe(STP_OUTPUT_NONCE));
		
	PROBE_256 probe_size_256_0 (
		.source_clk(CLOCK_50),
		.source(STP_INPUT_MIDSTATE));
		
	PROBE_256 probe_size_256_1 (
		.source_clk(CLOCK_50),
		.source(STP_INPUT_TARGET));
				
	PROBE_96 probe_size_96 (
		.source_clk(CLOCK_50),
		.source(STP_INPUT_DATA));
		
	// STP_INPUT_CALCULATE will change asynchronously. 	
	// Use a synchronizer chain so that the signal becomes 
	// stable to CLOCK_50.
	logic [2:0] calc_chain;
	always_ff @(posedge CLOCK_50) begin
		calc_chain[0] <= STP_INPUT_CALCULATE;
		calc_chain[1] <= calc_chain[0];
		calc_chain[2] <= calc_chain[1];
	end
	
	SHA256_controller #(.num_cores(20)) controller (
		.CLOCK_50(CLOCK_50),
		.calculate(calc_chain[2]),
		.data(STP_INPUT_DATA),
		.midstate(STP_INPUT_MIDSTATE),
		.target(STP_INPUT_TARGET),
		.good_nonce(STP_OUTPUT_NONCE),
		.done(STP_OUTPUT_DONE),
		
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5)
	);


endmodule