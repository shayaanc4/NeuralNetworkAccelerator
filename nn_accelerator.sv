module neural_network_accelerator (clk, rst, ready_for_inf, inputs, fp_done, activations_output);

	// Parameters
	parameter NUM_INPUTS = 256;
	parameter NUM_PERCEPTRONS_HIDDEN = 128;
	parameter NUM_PERCEPTRONS_OUTPUT = 10;

	// Inputs
	input logic clk, rst;
	input logic ready_for_inf;
	input logic signed [7:0] inputs [0:NUM_INPUTS-1]; // (3,5)
	
	// Outputs
	output logic fp_done;
	output logic signed [10+$clog2(NUM_PERCEPTRONS_OUTPUT):0] activations_output [0:NUM_PERCEPTRONS_OUTPUT-1];
	
	// Internal Variables
	logic clear, en_hidden, en_output;
	
	logic [$clog2(NUM_INPUTS)-1:0] input_idx_hidden;
	logic [$clog2(NUM_PERCEPTRONS_HIDDEN)-1:0] input_idx_output;
	
	logic signed [7:0] weights_hidden [0:NUM_PERCEPTRONS_HIDDEN-1]; // (3,5)
	logic signed [7:0] weights_output [0:NUM_PERCEPTRONS_OUTPUT-1];
	
	logic signed [7:0] biases_hidden [0:NUM_PERCEPTRONS_HIDDEN-1];
	logic signed [7:0] biases_output [0:NUM_PERCEPTRONS_OUTPUT-1];
	
	logic signed [10+$clog2(NUM_PERCEPTRONS_HIDDEN):0] weighted_sums_hidden [0:NUM_PERCEPTRONS_HIDDEN-1];
	logic signed [10+$clog2(NUM_PERCEPTRONS_OUTPUT):0] weighted_sums_output [0:NUM_PERCEPTRONS_OUTPUT-1];
	
	logic signed [10+$clog2(NUM_PERCEPTRONS_HIDDEN):0] sums_with_biases_hidden [0:NUM_PERCEPTRONS_HIDDEN-1];
	logic signed [10+$clog2(NUM_PERCEPTRONS_OUTPUT):0] sums_with_biases_output [0:NUM_PERCEPTRONS_OUTPUT-1];
	
	logic signed [10+$clog2(NUM_PERCEPTRONS_HIDDEN):0] activations_hidden [0:NUM_PERCEPTRONS_HIDDEN-1];
	
	memory #(.DATA_WIDTH(8), .DEPTH(NUM_PERCEPTRONS_HIDDEN*NUM_INPUTS), .PARAM_STRING("wh.txt"), .NUM_DATA(NUM_PERCEPTRONS_HIDDEN)) wmem_hidden(
		.clk(clk), 
		.mem(weights_hidden), 
		.start_addr(input_idx_hidden*NUM_PERCEPTRONS_HIDDEN));
	
	memory #(.DATA_WIDTH(8), .DEPTH(NUM_PERCEPTRONS_OUTPUT*NUM_PERCEPTRONS_HIDDEN), .PARAM_STRING("wo.txt"), .NUM_DATA(NUM_PERCEPTRONS_OUTPUT)) wmem_output(
		.clk(clk), 
		.mem(weights_output),
		.start_addr(input_idx_output*NUM_PERCEPTRONS_OUTPUT));
	
	memory #(.DATA_WIDTH(8), .DEPTH(NUM_PERCEPTRONS_HIDDEN), .PARAM_STRING("bh.txt"), .NUM_DATA(NUM_PERCEPTRONS_HIDDEN)) bmem_hidden(
		.clk(clk), 
		.mem(biases_hidden),
		.start_addr(0));
		
	memory #(.DATA_WIDTH(8), .DEPTH(NUM_PERCEPTRONS_OUTPUT), .PARAM_STRING("bo.txt"), .NUM_DATA(NUM_PERCEPTRONS_OUTPUT)) bmem_output(
		.clk(clk), 
		.mem(biases_output),
		.start_addr(0));
	
	genvar i, j;
	
	generate
		for (i = 0; i < NUM_PERCEPTRONS_HIDDEN; i++) begin: computation_hidden
			perceptron p(.clk(clk), .rst(rst), .clear(clear), .en(en_hidden), .data_in(inputs[input_idx_hidden]), .weight(weights_hidden[i]), .sum(weighted_sums_hidden[i]));
			assign sums_with_biases_hidden[i] = weighted_sums_hidden[i] + biases_hidden[i];
			sigmoid sig_hidden(.x(sums_with_biases_hidden[i]), .y(activations_hidden[i]));
		end
		
		for (j = 0; j < NUM_PERCEPTRONS_OUTPUT; j++) begin: computation_output
			perceptron p(.clk(clk), .rst(rst), .clear(clear), .en(en_output), .data_in(activations_hidden[input_idx_output]), .weight(weights_output[j]), .sum(weighted_sums_output[j]));
			assign sums_with_biases_output[j] = weighted_sums_output[j] + biases_output[j];
			sigmoid sig_output(.x(sums_with_biases_output[j]), .y(activations_output[j]));
		end
	endgenerate
	
	enum logic [2:0] {idle, hidden_active, output_active, done} current_state, next_state;

	always_comb begin
		clear = 1'b0;
		en_hidden = 1'b0;
		en_output = 1'b0;
		fp_done = 1'b0;
		case (current_state)
			idle: begin
				clear = ready_for_inf;
				next_state = ready_for_inf ? hidden_active : idle;
			end 
			hidden_active: begin
				en_hidden = 1'b1;
				next_state = (input_idx_hidden <= NUM_INPUTS - 1) ? hidden_active : output_active;
			end
			output_active: begin
				en_output = 1'b1;
				next_state = (input_idx_output <= NUM_PERCEPTRONS_HIDDEN - 1) ? output_active : done;
			end
			done: begin
				next_state = rst ? idle : done;
				fp_done = 1'b1;
			end
			default: next_state = idle;
		endcase
	end
	
	always_ff@(posedge clk or posedge rst) begin
		if (rst) begin
			input_idx_hidden <= 0;
			input_idx_output <= 0;
			current_state <= idle;
		end else begin
			current_state <= next_state;
			if (en_hidden) input_idx_hidden <= (input_idx_hidden < NUM_INPUTS - 1) ? input_idx_hidden + 1 : 0;
			else if (en_output) input_idx_output <= (input_idx_output < NUM_PERCEPTRONS_HIDDEN - 1) ? input_idx_output + 1 : 0;
			else begin
				input_idx_hidden <= 0;
				input_idx_output <= 0;
			end
		end
	end
endmodule
	
			
				