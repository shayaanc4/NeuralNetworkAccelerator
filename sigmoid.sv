module sigmoid(x, y);

input signed [31:0] x;
output [31:0] y;

    always_comb begin
        if (x < -128) begin
            y = 0; // Saturation at 0
        end else if (x > 128) begin
            y = 255; // Saturation at 1
        end else if (x < -64) begin
            y = (x + 128) >> 1; // Approximation for range [-128, -64]
        end else if (x < 0) begin
            y = (x + 64) + 64; // Approximation for range [-64, 0]
        end else if (x < 64) begin
            y = (x >> 1) + 128; // Approximation for range [0, 64]
        end else begin
            y = (x >> 2) + 192; // Approximation for range [64, 128]
        end
    end
endmodule
