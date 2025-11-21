// booth_controller.v
`timescale 1ns/1ps
module booth_controller(
    input  wire clk,
    input  wire start,
    input  wire q0,
    input  wire qm1,
    output reg ldA,
    output reg clrA,
    output reg sft,
    output reg ldQ,
    output reg clrQ,
    output reg clrff,
    output reg ldM,
    output reg addsub,
    output reg done
);

    reg [5:0] count;
    reg [2:0] state;

    // STATE ENCODING using only parameter (as requested)
    parameter S0  = 3'b000; // wait for start
    parameter S1  = 3'b001; // load M (cycle 1)
    parameter S1A = 3'b010; // load Q (cycle 2) + clear A and Q(-1)
    parameter S2  = 3'b011; // check bits
    parameter S3  = 3'b100; // A = A + M
    parameter S4  = 3'b101; // A = A - M
    parameter S5  = 3'b110; // shift and decrement
    parameter S6  = 3'b111; // done

    // Initialize state to avoid X
    initial begin
        state = S0;
    end

    always @(posedge clk) begin
        // default outputs (cleared each clock)
        ldA  <= 0;
        clrA <= 0;
        sft  <= 0;
        ldQ  <= 0;
        clrQ <= 0;
        clrff<= 0;
        ldM  <= 0;
        addsub<=0;
        done <= 0;

        case (state)
            S0: begin
                if (start) state <= S1;
            end

            // Load multiplicand M
            S1: begin
                ldM <= 1;
                // clear accumulator and Q(-1) now (so they are valid)
                clrA <= 1;
                clrff <= 1;
                state <= S1A;
            end

            // Load multiplier Q (separate cycle)
            S1A: begin
                ldQ <= 1;
                // also clear Q register if needed (optional)
                //clrQ <= 1; // we load Q directly so no need to clear
                // initialize counter here
                count <= 16; // change if parameterized N elsewhere
                state <= S2;
            end

            // Decision based on Q0 and Q(-1)
            S2: begin
                if ({q0, qm1} == 2'b01)
                    state <= S3;
                else if ({q0, qm1} == 2'b10)
                    state <= S4;
                else
                    state <= S5;
            end

            // A = A + M
            S3: begin
                addsub <= 0;
                ldA <= 1;   // load alu result into A
                state <= S5;
            end

            // A = A - M
            S4: begin
                addsub <= 1;
                ldA <= 1;
                state <= S5;
            end

            // shift right (A,Q,Q(-1)) and decrement count
            S5: begin
                sft <= 1;
                if (count == 0) begin
                    state <= S6;
                end else begin
                    count <= count - 1;
                    state <= S2;
                end
            end

            S6: begin
                done <= 1;
                state <= S0;
            end

            default: state <= S0;
        endcase
    end

endmodule

