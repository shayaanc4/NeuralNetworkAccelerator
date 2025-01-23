module nna_control(CLOCK_50, KEY, SW, HEX0, HEX1, LEDR);
	
	// Parameters
	parameter NUM_INPUTS = 256;
	parameter NUM_PERCEPTRONS_HIDDEN = 64;
	parameter NUM_PERCEPTRONS_OUTPUT = 10;

	// Inputs
	input logic CLOCK_50;
	input logic [3:0] KEY; 
	input logic [9:0] SW;

	// Outputs
	output logic [6:0] HEX0;
	output logic [6:0] HEX1;
	output logic [9:0] LEDR;

	// Internal
	logic [3:0] prediction;
	logic [3:0] prediction_temp;
	logic [3:0] label;
	logic [7:0] inputs [0:NUM_INPUTS-1];
	logic signed [15:0] activations [0:NUM_PERCEPTRONS_OUTPUT-1];
	logic [3:0] label_arr [0:0];
	logic done;
	
	neural_network_accelerator #(
		.NUM_INPUTS(NUM_INPUTS),
		.NUM_PERCEPTRONS_HIDDEN(NUM_PERCEPTRONS_HIDDEN),
		.NUM_PERCEPTRONS_OUTPUT(NUM_PERCEPTRONS_OUTPUT)) nn_accel(
		.clk(CLOCK_50),
		.rst(~KEY[0]),
		.ready_for_inf(SW[0]),
		.inputs(inputs),
		.fp_done(done),
		.activations_output(activations));
	
	initial begin 
		$readmemb("inputs.txt", inputs);
		$readmemb("input_label.txt", label_arr);
	end
	
	assign label = label_arr[0];
	assign LEDR[0] = done;
	
	softmax #(.NUM_CLASSES(NUM_PERCEPTRONS_OUTPUT)) sm(.activations(activations), .max_index(prediction_temp));
	assign prediction = done ? prediction_temp : 4'd15;
	
	hex_display pred(.num(prediction), .segments(HEX0));
	hex_display lab(.num(label), .segments(HEX1));
	
endmodule
