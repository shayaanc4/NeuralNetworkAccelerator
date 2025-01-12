module perceptron (clk, rst, clear, en, data_in, weight, sum);
	
	parameter integer NUM_INPUTS = 784;
	parameter integer INPUT_WIDTH = 16;
	parameter integer WEIGHT_WIDTH = 16;
	
	input logic clk, rst, clear, en;
	input logic signed [7:0] data_in;
	input logic signed [7:0] weight;
	output logic signed [10:0] sum;
	
	always_ff@(posedge clk) begin
		if (clear | rst) sum <= 0;
		else if (en) sum <= sum + ((data_in * weight) >> 5);
	end
		
endmodule	
	
	 