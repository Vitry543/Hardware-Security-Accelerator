module fault_detect(a, b, fault_flag);
    input  [127:0] a;
    input  [127:0] b;
    output fault_flag;

    assign fault_flag = (a != b);
endmodule