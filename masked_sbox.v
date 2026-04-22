module masked_sbox(data_in, mask_in, mask_out, data_out);
    input  [7:0] data_in;
    input  [7:0] mask_in;
    input  [7:0] mask_out;
    output [7:0] data_out;

    wire [7:0] sbox_in;
    wire [7:0] sbox_raw;

    assign sbox_in = data_in ^ mask_in;

    aes_sbox u0(
        .a(sbox_in),
        .d(sbox_raw)
    );

    assign data_out = sbox_raw ^ mask_out;
endmodule