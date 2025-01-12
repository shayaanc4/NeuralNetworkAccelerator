module memory (clk, mem, start_addr);

	parameter integer DATA_WIDTH = 8; 
	parameter integer DEPTH = 3; 
	parameter PARAM_STRING = "XXXXX";
	parameter integer NUM_DATA = 1;
	
	input logic clk;
	input logic [$clog2(DEPTH)-1:0] start_addr;
	output logic [DATA_WIDTH-1:0] mem [0:NUM_DATA-1];
	
	logic [DATA_WIDTH-1:0] temp_mem [0:DEPTH-1];

	
	initial begin
		$display("Reading from file: %s", PARAM_STRING);
		$readmemb(PARAM_STRING, temp_mem);
	end
	
	always_comb begin
        for (int i = 0; i < NUM_DATA; i++) begin
            mem[i] = temp_mem[start_addr + i];
        end
    end
	
endmodule
