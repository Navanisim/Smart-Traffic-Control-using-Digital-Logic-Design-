`timescale 1ns / 1ps // Time scale directive (change as per requirement)

module count_generator_tb;
parameter CLK_PERIOD = 50; // Clock period in ns

// Testbench generated signals
reg clk_tb;
reg rst_tb;

// Outputs to monitor
wire [3:0] count1_tb;
wire [3:0] count2_tb;
wire [3:0] count3_tb;
wire [3:0] count4_tb;
wire led1_tb, led2_tb, led3_tb, led4_tb;

// Instantiate the Unit Under Test (UUT)
count_generator uut (
.clk(clk_tb),
.rst(rst_tb),
.count1(count1_tb),
.count2(count2_tb),
.count3(count3_tb),
.count4(count4_tb),
.led1(led1_tb),
.led2(led2_tb),
.led3(led3_tb),
.led4(led4_tb)
);

// Clock generation: 10ns period for simulation, representing 10s as in the question
//initial begin
//    clk_tb = 0; // Initial clock state
//    forever #5 clk_tb = ~clk_tb; // Toggle every 5ns for a 10ns period
//end

// Reset pulse at the beginning
//- prev code initial begin
// Initialize Reset
// rst_tb = 1;
// #20; // Keep reset high for 20ns

// Release Reset
//rst_tb = 0;
//end-prev code
// Clock generation
always begin
    clk_tb = 1'b0;
    #((CLK_PERIOD / 2) * 1);
    clk_tb = 1'b1;
    #((CLK_PERIOD / 2) * 1);
end

// Reset assertion and release
initial begin
    rst_tb = 1'b1;
    #200; // Wait for a few clock cycles
    rst_tb = 1'b0;
    #200; // Wait for a few clock cycles
end

// Simulation time: Let's simulate for 1000ns to see the behavior over time
initial begin

    // Monitor changes
    //-prev $monitor("Time = %d, Count1 = %d, Count2 = %d, Count3 = %d, Count4 = %d", $time, count1_tb, count2_tb, count3_tb, count4_tb;
    $monitor("Time=%t, count1=%h, count2=%h, count3=%h, count4=%h, led1=%b, led2=%b, led3=%b, led4=%b", 
    $time, count1_tb, count2_tb, count3_tb, count4_tb, led1_tb, led2_tb, led3_tb, led4_tb);
    // Run simulation
    #1000;
    $finish;
end
endmodule
