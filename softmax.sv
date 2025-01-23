module softmax (activations, max_index);

	// Parameter
	parameter NUM_CLASSES = 10;

	// Input
	input logic signed [31:0] activations [0:NUM_CLASSES-1];

	// Output
	output logic [3:0] max_index;       

	// Internal
	logic signed [31:0] max_value;
	
	integer i;
	always_comb begin
	  max_value = activations[0];  
	  max_index = 0;
	  for (i = 1; i < NUM_CLASSES; i++) begin
		if (activations[i] > max_value) begin
			 max_value = activations[i]; 
			 max_index = i[3:0]; 
		end
	  end
	end
endmodule
	
