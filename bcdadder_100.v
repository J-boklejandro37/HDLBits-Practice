// Instantiate 100 copies of bcdadd to create a 100-digit BCD ripple-carry adder. 
// Your adder should add two 100-digit BCD numbers (packed into 400-bit vectors) 
// and a carry-in to produce a 100-digit sum and carry out.

module bcd100_adder (
    input [399:0] a,
    b,
    input cin,
    output cout,
    output [399:0] sum
);

    // create 100 bcd adder
    genvar i;
    wire [100:0] carry;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bcdadd_genblock
            bcdadd inst (
                .cout(carry[i+1]),
                .sum(sum[(i*4)+3:(i*4)]),
                .a(a[(i*4)+3:(i*4)]),
                .b(b[(i*4)+3:(i*4)]),
                .cin(i ? carry[i] : cin)
            );
        end
    endgenerate

    assign cout = carry[100];

endmodule


// binary-coded-decimal adder implementation
module bcdadd (
    output cout,
    output [3:0] sum,
    input [3:0] a,
    input [3:0] b,
    input cin
);

    wire [4:0] temp_sum, new_sum;

    assign temp_sum = a + b + cin;  // the code that substitutes those under

    // genvar i;
    // wire [4:1] carry;
    // generate
    //     for (i = 0; i < 4; i = i + 1) begin : fadd_genblock
    //         fadd inst (
    //             .cout(carry[i+1]),
    //             .sum(temp_sum[i]),
    //             .a(a[i]),
    //             .b(b[i]),
    //             .cin(i ? carry[i] : cin)
    //         );
    //     end
    // endgenerate

    // assign temp_sum[4] = carry[4];

    assign new_sum = (temp_sum > 4'd9) ? temp_sum + 4'd6 : temp_sum;

    assign cout = new_sum[4];
    assign sum = new_sum[3:0];

endmodule


// full adder implementation
module fadd (
    output cout,
    output sum,
    input  a,
    input  b,
    input  cin
);
    assign cout = a & b | b & cin | a & cin;
    assign sum  = a ^ b ^ cin;
endmodule
