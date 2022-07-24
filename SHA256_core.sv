// For all bit arrays, word 0 is at the highest bit
`define IDX_W(idx) 511-idx*32:512-(idx+1)*32
`define IDX_HASH(idx) 255-idx*32:256-(idx+1)*32

/* This computes one SHA256 hash in every 64 clock cycles.
 Inputs:
	clk - clock used for computation
	init - the initial state of the SHA256 hash function. This is either predefined
			by SHA256 or the midstate given by Bitcoin
	value - the value to be hashed. This is in 512-bit blocks,
	start - the signal to tell the core to begin computing. On assertion, inputs on wires are read.
 Outputs:
	result - the returned 256-bit hash value that will be returned in 64 cycles
*/
module SHA256_core (
	input clk,
	input [255:0] init,
	input [511:0] value,
	input start,
	output [255:0] result
);

	localparam SHA256_constants = {
		32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5, 32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
		32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
		32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc, 32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
		32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
		32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
		32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3, 32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
		32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
		32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208, 32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2
	};

	// W holds the next 16 words. This is generated from 'value' initially,
	// and updated after each clock cycle according for a formula.
	// Luckily, because of the lack of temporal locality, we can discard
	// old W values after they've been used, so we don't have to keep them
	// around for all 64 clock cycles.
	logic [511:0] W_reg;
	logic [511:0] next_W;


	// hash_val holds the hash values, and the final result will be returned from this.
	// It is initialized with "init", then updated after each clock cycle according
	// to the current hash value as well as W[31:0] value
	logic [255:0] hash_val_reg;
	logic [255:0] next_hash_val;

	// a register to hold the current cycle index.
	// This lets us know which constant to use, and where
	// we are in the computation process.
	logic [7:0] index;



	always_ff @(posedge clk) begin

		if (start) begin
			index <= 'd0;
			hash_val_reg <= init;
			W_reg <= value;
		end
		else if (index < 64) begin
			index <= index + 8'd1;
			W_reg <= next_W;
			hash_val_reg <= next_hash_val;
		end

	end


	// This calculates the next W value. This is done by shifting existing values by 32 bits
	// to the left (taking out W[0]), and adding the new entry on the right side
	logic [31:0] new_W_entry, s1, s0;
	sigma1 sig1(W_reg[`IDX_W(14)], s1);
	sigma0 sig0(W_reg[`IDX_W(1)], s0);
	assign new_W_entry = s1 + W_reg[`IDX_W(9)] + s0 + W_reg[`IDX_W(0)];
	assign next_W = {W_reg[479:0], new_W_entry};


	// Calculate the temporary variables T1 and T2
	logic [31:0] T1, T2, S1, S0, ch, maj;
	SIGMA1 SIG1(hash_val_reg[`IDX_HASH(4)], S1);
	SIGMA0 SIG0(hash_val_reg[`IDX_HASH(0)], S0);
	majority maj0(hash_val_reg[`IDX_HASH(0)], hash_val_reg[`IDX_HASH(1)], hash_val_reg[`IDX_HASH(2)], maj);
	choice ch0(hash_val_reg[`IDX_HASH(4)], hash_val_reg[`IDX_HASH(5)], hash_val_reg[`IDX_HASH(6)], ch);


	assign T1 = S1 + ch + hash_val_reg[`IDX_HASH(7)] + SHA256_constants[2047-index*32-:32] + W_reg[`IDX_W(0)];
	assign T2 = S0 + maj;


	// This updates next_hash_val by shifting existing values by 32 bit to the right,
	// and adding new entry on the left. Note that modified_e_entry is sort of a misnomer
	// because we're actually adding T1 to "d", but because it gets shifted by one, it
	// becomes "e" instead
	logic [31:0] new_hash_entry, modified_e_entry;
	assign new_hash_entry = T1 + T2;
	assign modified_e_entry = hash_val_reg[`IDX_HASH(3)] + T1;
	assign next_hash_val = {new_hash_entry, hash_val_reg[255:160], modified_e_entry, hash_val_reg[127:32]};

	genvar i;
	generate
		for (i = 0; i < 8; i++) begin : OUTPUT_LOOP
			assign result[32*(i+1)-1:32*i] = hash_val_reg[32*(i+1)-1:32*i] + init[32*(i+1)-1:32*i];
		end
	endgenerate
	
endmodule
