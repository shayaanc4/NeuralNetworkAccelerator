/* 
	This function is based off a low-power piecewise second-order approximation of the sigmoid function adapted from:
	Tisan, Alin & Oniga, Stefan & Mic, Daniel & Attila, Buchman. (2009). 
	Digital Implementation of The Sigmoid Function for FPGA Circuits. 
	ACTA TECHNICA NAPOCENSIS Electronics and Telecommunications
*/

module sigmoid(in, out);
	
   input logic signed [7:0] in;
   output logic signed [15:0] out;

   logic signed [7:0] mag, mag_norm, sum;
   logic signed [15:0] square, square_halved;

   always_comb begin
		mag = in[7] ? -in : in; // get the magnitude of the input
		mag_norm = mag >>> 2; // normalize the magnitude between [0, 1]
		sum = mag_norm + 8'b111_10000; // subtract 0.5

		square = sum * sum; // square result

		square_halved = square >>> 1; // divide by 2

		out = in[7] ? square_halved : 16'b00000001_00000000 - square_halved;
   end

endmodule
