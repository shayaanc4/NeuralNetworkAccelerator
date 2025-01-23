module memory (clk, data_out, start_addr);

	// Parameters
	parameter integer DATA_WIDTH = 8; 
	parameter integer DEPTH = 3; 
	parameter PARAM_STRING = "XXXXX";
	parameter integer NUM_DATA = 1;

	// Inputs
	input logic clk;
	input logic [$clog2(DEPTH)-1:0] start_addr;

	// Output
	output logic [DATA_WIDTH-1:0] data_out [0:NUM_DATA-1];

	// Internal
	logic [DATA_WIDTH-1:0] temp_mem [0:DEPTH-1];
	
	initial begin
		$display("Reading from file: %s", PARAM_STRING);
		$readmemb(PARAM_STRING, temp_mem);
	end
	
	always_comb begin
        for (int i = 0; i < NUM_DATA; i++) begin
            data_out[i] = temp_mem[start_addr + i];
        end
   end
	
endmodule
