//full adder module
module fullAdder ( 
    input a,b,cin,
    output sum,cout
);
    
    xor(w0,a,b);
    xor(sum,w0,cin);

    and(w1,a,b);
    and(w2,w0,cin);
    or(cout,w1,w2);

endmodule


// 4to1 mux module
module mux1x4 (
    input i1,i2, i3, i4,s0,s1,
    output y
    );
    
    
    not(ns0 , s0);
    not(ns1 , s1);

    and(w0, i1, ns0, ns1);
    and(w1, i2, ns0, s1);
    and(w2, i3, s0, ns1);
    and(w3, i4, s0, s1);

    or(y,w0,w1,w2,w3);

endmodule



//AC module

module AC (
    input [3:0] a,
    input [3:0] b,
    input s1,s0,cin,
    output [3:0] d,
    output carry
);

    assign z = 0;
    not(o,z);
    
    not(nb0,b[0]);
    mux1x4 m0(b[0],nb0,z,o,s1,s0,y0);

    not(nb1,b[1]);
    mux1x4 m1(b[1],nb1,z,o,s1,s0,y1);

    not(nb2,b[2]);
    mux1x4 m2(b[2],nb2,z,o,s1,s0,y2);

    not(nb3,b[3]);
    mux1x4 m3(b[3],nb3,z,o,s1,s0,y3);

    fullAdder f0(a[0],y0,cin,d[0],c0);
    fullAdder f1(a[1],y1,c0,d[1],c1);
    fullAdder f2(a[2],y2,c1,d[2],c2);
    fullAdder f3(a[3],y3,c2,d[3],carry);


    
endmodule


//  LOGIC MICROOPERATIONS module
module micro (
    input [3:0] a,
    input [3:0] b,
    input s0,s1,
    output [3:0] f
);

    and(i00,a[0],b[0]);
    or(i01,a[0],b[0]);
    xor(i02,a[0],b[0]);
    not(i03,a[0]);
    mux1x4 m0(i00,i01,i02,i03,s0,s1,f[0]);

    and(i10,a[1],b[1]);
    or(i11,a[1],b[1]);
    xor(i12,a[1],b[1]);
    not(i13,a[1]);
    mux1x4 m1(i10,i11,i12,i13,s0,s1,f[1]);

    and(i20,a[2],b[2]);
    or(i21,a[2],b[2]);
    xor(i22,a[2],b[2]);
    not(i23,a[2]);
    mux1x4 m2(i20,i21,i22,i23,s0,s1,f[2]);

    and(i30,a[3],b[3]);
    or(i31,a[3],b[3]);
    xor(i32,a[3],b[3]);
    not(i33,a[3]);
    mux1x4 m3(i30,i31,i32,i33,s0,s1,f[3]);

endmodule


module mux_4to1 (
    input wire [3:0] a, b, c, d, 
    input s0, s1, 
    output reg [3:0] out);
    always @ (a or b or c or d or s0 or s1)
    begin
        if (s0 == 0 && s1 == 0)
          out <= a;
        else if (s0 == 0 && s1 == 1)
         out <= b;
        else if (s0 == 1 && s1 == 0)
          out <= c;
     else if (s0 == 1 && s1 == 1)
          out <= d;
end
endmodule

// shif module

module shift (
    input [3:0] a,
    output [3:0] r,l
);

    assign r = a>>1;
    assign l = a<<1;
    
endmodule


// ARITHMETIC LOGIC SHIFT UNIT module


module ALSU(
    input s0,s1,s2,s3,cin,
    input [3:0] a,b,
    output [3:0] f,
    output carry
);
    wire [0:3] d;
    AC ac(b,a,s1,s0,cin,d,carry);

    wire [3:0] e;
    micro mic(b,a,s1,s0,e);

    wire [3:0] shra,shla;
    shift sh(a,shra,shla);

    mux_4to1 mux_4to1(d,e,shra,shla,s3,s2,f);
    
endmodule


// ARITHMETIC LOGIC SHIFT UNIT test

module tb_ALSU ();
    reg s0,s1,s2,s3,cin;
    reg [3:0] a,b;
    wire [3:0] f;
    wire carry;

    ALSU alsu(s0,s1,s2,s3,cin,a,b,f,carry);

    initial begin
        a = 4'b0101;
        b = 4'b1010;
        s0 = 0;
        s1 = 0;
        s2 = 0;
        s3 = 0;
        cin = 0;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 0;
        s1 = 0;
        s2 = 0;
        s3 = 0;
        cin = 1;
        #100;

        a = 4'b1101;
        b = 4'b0010;
        s0 = 1;
        s1 = 0;
        s2 = 0;
        s3 = 0;
        cin = 0;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 1;
        s1 = 0;
        s2 = 0;
        s3 = 0;
        cin = 1;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 0;
        s1 = 1;
        s2 = 0;
        s3 = 0;
        cin = 0;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 0;
        s1 = 1;
        s2 = 0;
        s3 = 0;
        cin = 1;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 1;
        s1 = 1;
        s2 = 0;
        s3 = 0;
        cin = 0;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 1;
        s1 = 1;
        s2 = 0;
        s3 = 0;
        cin = 1;
        #100;

// ============================================================================
        a = 4'b0101;
        b = 4'b1010;
        s0 = 0;
        s1 = 0;
        s2 = 1;
        s3 = 0;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 1;
        s1 = 0;
        s2 = 1;
        s3 = 0;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 0;
        s1 = 1;
        s2 = 1;
        s3 = 0;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 1;
        s1 = 1;
        s2 = 1;
        s3 = 0;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 1;
        s1 = 1;
        s2 = 0;
        s3 = 1;
        #100;

        a = 4'b0101;
        b = 4'b1010;
        s0 = 1;
        s1 = 1;
        s2 = 1;
        s3 = 1;
        #100;
    end
    
endmodule



