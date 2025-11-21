// booth_datapath.v
`timescale 1ns/1ps
module booth_datapath #(parameter N = 16)(
    input  wire              clk,
    input  wire              ldA,       // load ALU result into A
    input  wire              clrA,
    input  wire              sft,       // shift A,Q,Qm1 together (single control)
    input  wire              ldQ,
    input  wire              clrQ,
    input  wire              clrff,
    input  wire              ldM,
    input  wire              addsub,    // 0 = add, 1 = sub
    input  wire [N-1:0]      data_in,   // used by ldM and ldQ
    output wire              q0,
    output wire              qm1,
    output wire signed [N-1:0] A_out,
    output wire signed [N-1:0] Q_out
);

    // Internal regs
    reg signed [N-1:0] A;
    reg signed [N-1:0] Q;
    reg signed [N-1:0] M;
    reg qm1_ff;

    // ALU
    wire signed [N-1:0] alu_out;
    assign alu_out = (addsub == 1'b0) ? (A + M) : (A - M);

    // Outputs
    assign q0 = Q[0];
    assign qm1 = qm1_ff;
    assign A_out = A;
    assign Q_out = Q;

    // Initialize regs to prevent X propagation
    initial begin
        A = 0;
        Q = 0;
        M = 0;
        qm1_ff = 0;
    end

    // Synchronous behavior for registers and operations
    always @(posedge clk) begin
        // Clear operations
        if (clrA) begin
            A <= 0;
        end 
        else if (ldA) begin
            // load ALU result into A (from add/sub)
            A <= alu_out;
        end 
        else if (sft) begin
            // arithmetic right shift of A
            A <= {A[N-1], A[N-1:1]};
        end

        // Q register operations
        if (clrQ) begin
            Q <= 0;
        end 
        else if (ldQ) begin
            Q <= data_in;
        end 
        else if (sft) begin
            // MSB of Q gets A[0] during shift
            Q <= {A[0], Q[N-1:1]};
        end

        // Q(-1) flip-flop
        if (clrff) begin
            qm1_ff <= 0;
        end 
        else if (sft) begin
            qm1_ff <= Q[0];
        end

        // M register
        if (ldM) begin
            M <= data_in;
        end
    end

endmodule

