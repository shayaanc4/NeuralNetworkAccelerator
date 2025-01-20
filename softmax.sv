module softmax (activations, max_index);
	parameter NUM_CLASSES = 10;
	input logic signed [31:0] activations [0:NUM_CLASSES-1]; // Input array of activations
   output logic [3:0] max_index;       // Output index of the maximum value
	
	logic signed [31:0] max_value;  // To store the maximum value
	integer i;

	always_comb begin
	  max_value = activations[0];  // Initialize with the first element
	  max_index = 0;

	  for (i = 1; i < NUM_CLASSES; i++) begin
			if (activations[i] > max_value) begin
				 max_value = activations[i]; // Update max value
				 max_index = i[3:0];  // Update index
			end
	  end
	end
endmodule
	