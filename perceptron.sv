module perceptron (clk, rst, en, data_in, weight, sum);

	// Parameters
	parameter integer NUM_INPUTS = 784;
	parameter integer INPUT_WIDTH = 16;
	parameter integer WEIGHT_WIDTH = 16;

	// Inputs
	input logic clk, rst, en;
	input logic signed [7:0] data_in; // (3,5)
	input logic signed [7:0] weight; // (3,5)

	// Output
	output logic signed [12:0] sum; // (8,5)

	// Internal
	logic signed [15:0] mult; // (6,10)
	logic signed [10:0] mult_trunc; // (6,5)
	
	assign mult = data_in * weight;
	assign mult_trunc = mult[15:5];
	
	always_ff@(posedge clk) begin
		if (rst) sum <= 0;
		else if (en) sum <= sum + mult_trunc;
	end
		
endmodule
	
	 
