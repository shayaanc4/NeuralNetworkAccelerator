module hex_display (
    input logic [3:0] digit,     // Input hexadecimal digit (0-15)
    output logic [6:0] segments      // Active-low segments (a-g)
);

    always_comb begin
        case (digit)
            4'd0: segments = 7'b0000001; // 0
            4'd1: segments = 7'b1001111; // 1
            4'd2: segments = 7'b0010010; // 2
            4'd3: segments = 7'b0000110; // 3
            4'd4: segments = 7'b1001100; // 4
            4'd5: segments = 7'b0100100; // 5
            4'd6: segments = 7'b0100000; // 6
            4'd7: segments = 7'b0001111; // 7
            4'd8: segments = 7'b0000000; // 8
            4'd9: segments = 7'b0000100; // 9
            default: segments = 7'b1111111; // All off
        endcase
    end

endmodule
