module count_generator (input wire clk, // Main clock input
                        input wire rst, // Reset input, active high
                        output reg [3:0] count1, // 4-bit count outputs
                        output reg [3:0] count2,
                        output reg [3:0] count3,
                        output reg [3:0] count4,
                        output reg led1, // LED outputs for each lane
                        output reg led2,
                        output reg led3,
                        output reg led4
                        );

// Internal connection for the LFSR output
wire [3:0] lfsr_out;
// LFSR taps for a 4-bit LFSR
wire feedback = lfsr_out[3] ^ lfsr_out[2];
// Instantiate the LFSR module
lfsr_pseudo_random_generator prng(.clk(clk),.rst(rst),.out(lfsr_out));
// Registers to hold the count values
reg[3:0] total_count;
reg[7:0] count1_total, count2_total, count3_total, count4_total;
// Wires to hold the ratio values
reg[7:0] count1_ratio, count2_ratio, count3_ratio, count4_ratio;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count1 <= 4'd0;
        count2 <= 4'd0;
        count3 <= 4'd0;
        count4 <= 4'd0;
        count1_total <= 8'd0;
        count2_total <= 8'd0;
        count3_total <= 8'd0;
        count4_total <= 8'd0;
        total_count <= 4'd0;
        led1 <= 1'b0;
        led2 <= 1'b0;
        led3 <= 1'b0;
        led4 <= 1'b0;
    end else begin
        // Increment each count by a different function of the LFSR output
        count1 <= count1 + lfsr_out;
        count2 <= count2 + (lfsr_out ^ 4'b0101);
        count3 <= count3 + (lfsr_out & 4'b1010);
        count4 <= count4 + (lfsr_out | 4'b1100);
        
        // Accumulate count values
        count1_total <= count1_total + count1;
        count2_total <= count2_total + count2;
        count3_total <= count3_total + count3;
        count4_total <= count4_total + count4;
        
        // Calculate total count
        total_count <= count1_total + count2_total + count3_total + count4_total;
        
        // Calculate ratios
        count1_ratio = (count1_total * 100) / total_count;
        count2_ratio = (count2_total * 100) / total_count;
        count3_ratio = (count3_total * 100) / total_count;
        count4_ratio = (count4_total * 100) / total_count;
        
        // Control LEDs based on ratios
        led1 <= count1_ratio;
        led2 <= count2_ratio;
        led3 <= count3_ratio;
        led4 <= count4_ratio;
    end
end
endmodule
