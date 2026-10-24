`timescale 1ns/1ps
module tb_mult;
`ifdef GLS
    localparam HALF   = 50;   // 100 ns period for the unit-delay netlist
    localparam SETTLE = 40;   // time for outputs to settle after edge 2
`else
    localparam HALF   = 5;    // 10 ns period, as specified
    localparam SETTLE = 1;
`endif

    reg        clk   = 1'b0;
    reg        rst_n = 1'b0;
    reg  [3:0] a     = 4'd0;
    reg  [3:0] b     = 4'd0;
    wire [7:0] p;

    integer    i, j;
    integer    errors = 0;
    reg  [7:0] expected;

    mult_array dut (.clk(clk), .rst_n(rst_n), .a(a), .b(b), .p(p));

    always #HALF clk = ~clk;

    initial begin
        $dumpfile("mult.vcd");
        $dumpvars(0, tb_mult);

        // Reset low for 2 cycles
        rst_n = 1'b0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                @(negedge clk);
                a = i;
                b = j;
                @(posedge clk);          // edge 1: inputs captured
                @(posedge clk);          // edge 2: product captured
                #SETTLE;
                expected = i * j;        // * is allowed in the testbench only
                if (p !== expected) begin
                    errors = errors + 1;
                    $display("MISMATCH a=%0d b=%0d expected=%0d got=%0d",
                             i, j, expected, p);
                end
            end
        end

        if (errors == 0)
            $display("PASS: 256 vectors checked, 0 errors");
        else
            $display("FAIL: 256 vectors checked, %0d errors", errors);

        $finish;
    end
endmodule
