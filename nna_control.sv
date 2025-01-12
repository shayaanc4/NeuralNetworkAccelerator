module nna_control(CLOCK_50, KEY[0], KEY[1], HEX0, HEX1);
	
	// Parameters
	parameter NUM_INPUTS = 256;
	parameter NUM_PERCEPTRONS_HIDDEN = 64;
	parameter NUM_PERCEPTRONS_OUTPUT = 10;

	input logic CLOCK_50;
	input logic KEY[1:0];
	
	output logic [6:0] HEX0;
	output logic [6:0] HEX1;
	
	logic [3:0] prediction;
	logic [3:0] label;
	logic signed [7:0] inputs [0:NUM_INPUTS-1];
	logic signed [31:0] activations [0:NUM_PERCEPTRONS_OUTPUT-1];
	logic [3:0] label_arr [0:0];
	logic done;

	neural_network_accelerator #(
		.NUM_INPUTS(NUM_INPUTS),
		.NUM_PERCEPTRONS_HIDDEN(NUM_PERCEPTRONS_HIDDEN),
		.NUM_PERCEPTRONS_OUTPUT(NUM_PERCEPTRONS_OUTPUT)) nn_accel(
		.clk(CLOCK_50),
		.rst(~KEY[0]),
		.ready_for_inf(KEY[1]),
		.inputs(inputs),
		.fp_done(done),
		.activations_output(activations));
	
	initial begin 
		$readmemb("inputs.txt", inputs);
		$readmemb("input_label_0.txt", label_arr);
		prediction = 4'd15;
	end
	
	assign label = label_arr[0];
	
	softmax sm(.activations(activations), .max_index(prediction));
	hex_display pred(.digit(prediction), .segments(HEX0));
	hex_display lab(.digit(label), .segments(HEX1));
	
endmodule
