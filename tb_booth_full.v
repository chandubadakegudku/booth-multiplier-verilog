// tb_booth_full.v
`timescale 1ns/1ps
module tb_booth_full();

    parameter N = 16;
    reg clk;
    reg start;
    reg signed [N-1:0] multiplicand;
    reg signed [N-1:0] multiplier;

    wire signed [2*N-1:0] product;
    wire done;

    // Instantiate DUT
    booth_multiplier_full #(N) DUT (
        .clk(clk),
        .start(start),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product),
        .done(done)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz -> period 10ns for simulation convenience

    // VCD dump
    initial begin
        $dumpfile("booth.vcd");
        $dumpvars(0, tb_booth_full);
    end

    initial begin
        // Test 1
        multiplicand = 16'd7;
        multiplier   = 16'd3;
        start = 0;
        #12;
        start = 1;   // pulse start high for one clock edge
        #10;
        start = 0;

        // Wait for completion (with timeout)
        wait(done);
        #20;
        $display("TEST1: 7 * 3 = %0d (Output = %0d)", 7*3, product);

        // Test 2
        multiplicand = 16'd12;
        multiplier   = -16'sd5;
        #20;
        start = 1;
        #10;
        start = 0;
        wait(done);
        #20;
        $display("TEST2: 12 * -5 = %0d (Output = %0d)", 12 * -5, product);

        // Test 3
        multiplicand = -16'sd9;
        multiplier   = -16'sd4;
        #20;
        start = 1;
        #10;
        start = 0;
        wait(done);
        #20;
        $display("TEST3: -9 * -4 = %0d (Output = %0d)", -9 * -4, product);

        #50 $finish;
    end

endmodule

