module mult_array (
	input wire	clk,
	input wire	rst_n,
	input wire [3:0] a,
	input wire [3:0] b,
	output reg [7:0] p
);

	//----------  Input registers (edge 1)----------
	reg [3:0] ra, rb;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ra <= 4'd0;
			rb <= 4'd0;
		end else begin
			ra <= a;
			rb <= b;
		end
	end

	// ---------- aLL INTERNAL WIRES DECLARED UP FRONT ----------
	wire [3:0] pp0, pp1, pp2, pp3;  //partial products
	wire [3:0] r0, r1, r2;          //values passed down each row
	wire [3:0] s1, s2, s3;          // sum bits
	wire [4:0] c1, c2, c3;          // carry chain (bit 0 = 0)

	// Partial products: ppi[j] = a[j] AND b[i]
	assign pp0 = ra & {4{rb[0]}};
	assign pp1 = ra & {4{rb[1]}};
	assign pp2 = ra & {4{rb[2]}};
	assign pp3 = ra & {4{rb[3]}};

	// ----------- Row 0: no adders ----------
	assign r0 = {1'b0, pp0[3], pp0[2], pp0[1]};


	// ----------Row 1----------

	assign c1[0] = 1'b0;
	full_adder r1_fa0 (.a(pp1[0]), .b(r0[0]), .cin(c1[0]), .sum(s1[0]), .cout(c1[1]));
	full_adder r1_fa1 (.a(pp1[1]), .b(r0[1]), .cin(c1[1]), .sum(s1[1]), .cout(c1[2]));
	full_adder r1_fa2 (.a(pp1[2]), .b(r0[2]), .cin(c1[2]), .sum(s1[2]), .cout(c1[3]));
	full_adder r1_fa3 (.a(pp1[3]), .b(r0[3]), .cin(c1[3]), .sum(s1[3]), .cout(c1[4]));
	assign r1 = {c1[4], s1[3], s1[2], s1[1]};

	
	// ----------Row 2----------

        assign c2[0] = 1'b0;
        full_adder r2_fa0 (.a(pp2[0]), .b(r1[0]), .cin(c2[0]), .sum(s2[0]), .cout(c2[1]));
        full_adder r2_fa1 (.a(pp2[1]), .b(r1[1]), .cin(c2[1]), .sum(s2[1]), .cout(c2[2]));
        full_adder r2_fa2 (.a(pp2[2]), .b(r1[2]), .cin(c2[2]), .sum(s2[2]), .cout(c2[3]));
        full_adder r2_fa3 (.a(pp2[3]), .b(r1[3]), .cin(c2[3]), .sum(s2[3]), .cout(c2[4]));
        assign r2 = {c2[4], s2[3], s2[2], s2[1]};

	// ----------Row 3----------

        assign c3[0] = 1'b0;
        full_adder r3_fa0 (.a(pp3[0]), .b(r2[0]), .cin(c3[0]), .sum(s3[0]), .cout(c3[1]));
        full_adder r3_fa1 (.a(pp3[1]), .b(r2[1]), .cin(c3[1]), .sum(s3[1]), .cout(c3[2]));
        full_adder r3_fa2 (.a(pp3[2]), .b(r2[2]), .cin(c3[2]), .sum(s3[2]), .cout(c3[3]));
        full_adder r3_fa3 (.a(pp3[3]), .b(r2[3]), .cin(c3[3]), .sum(s3[3]), .cout(c3[4]));
        
	// Combinational 8-bit product
	wire [7:0] pn;
	assign s3 = s3; //placeholder removed below
	assign pn = {c3[4], s3[3], s3[2], s3[1], s3[0], s2[0], s1[0], pp0[0]};

	// Output register (edge 2)
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			p <= 8'd0;
		else
			p <= pn;
	end
endmodule

