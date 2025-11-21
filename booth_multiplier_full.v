// booth_multiplier_full.v
`timescale 1ns/1ps
module booth_multiplier_full #(parameter N = 16)(
    input  wire clk,
    input  wire start,
    input  wire signed [N-1:0] multiplicand,
    input  wire signed [N-1:0] multiplier,
    output wire signed [2*N-1:0] product,
    output wire done
);

    // Control signals
    wire ldA, clrA, sft;
    wire ldQ, clrQ;
    wire clrff, ldM;
    wire addsub;

    // Datapath wires
    wire q0, qm1;
    wire signed [N-1:0] A_out, Q_out;

    // Create a small data bus: multiplicand loaded when ldM, multiplier when ldQ
    wire [N-1:0] data_bus;
    assign data_bus = ldM ? multiplicand :
                      ldQ ? multiplier :
                      {N{1'b0}};

    // Instantiate datapath
    booth_datapath DP (
        .clk(clk),
        .ldA(ldA),
        .clrA(clrA),
        .sft(sft),
        .ldQ(ldQ),
        .clrQ(clrQ),
        .clrff(clrff),
        .ldM(ldM),
        .addsub(addsub),
        .data_in(data_bus),
        .q0(q0),
        .qm1(qm1),
        .A_out(A_out),
        .Q_out(Q_out)
    );

    // Instantiate controller
    booth_controller CTRL (
        .clk(clk),
        .start(start),
        .q0(q0),
        .qm1(qm1),
        .ldA(ldA),
        .clrA(clrA),
        .sft(sft),
        .ldQ(ldQ),
        .clrQ(clrQ),
        .clrff(clrff),
        .ldM(ldM),
        .addsub(addsub),
        .done(done)
    );

    assign product = {A_out, Q_out};

endmodule

