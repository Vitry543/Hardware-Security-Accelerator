`timescale 1ns/1ps

module tb_top;

    reg clk;
    reg rst;
    reg start;
    reg [127:0] plaintext;
    reg [127:0] key;
    wire [127:0] ciphertext;
    wire done;

    reg wr_en;
    reg [31:0] token;
    reg [127:0] key_in;
    wire [127:0] key_out;
    wire key_valid;
    wire access_violation;

    reg [127:0] fault_other;
    wire fault_flag;

    reg [7:0] mask_data;
    reg [7:0] mask_in;
    reg [7:0] mask_out;
    wire [7:0] masked_out;

    aes_core u_aes (
        .clk(clk),
        .rst(rst),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    key_mgmt u_key_mgmt (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .token(token),
        .key_in(key_in),
        .key_out(key_out),
        .key_valid(key_valid),
        .access_violation(access_violation)
    );

    fault_detect u_fault (
        .a(ciphertext),
        .b(fault_other),
        .fault_flag(fault_flag)
    );

    masked_sbox u_masked (
        .data_in(mask_data),
        .mask_in(mask_in),
        .mask_out(mask_out),
        .data_out(masked_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("aes_project.vcd");
        $dumpvars(0, tb_top);

        clk = 0;
        rst = 1;
        start = 0;
        plaintext = 128'h0;
        key = 128'h0;
        wr_en = 0;
        token = 32'h0;
        key_in = 128'h0;
        fault_other = 128'h0;
        mask_data = 8'h3c;
        mask_in = 8'ha5;
        mask_out = 8'h5a;

        #20;
        rst = 0;

        // Unauthorized write
        #10;
        wr_en = 1;
        token = 32'h12345678;
        key_in = 128'h000102030405060708090a0b0c0d0e0f;
        #10;
        wr_en = 0;
        $display("Unauthorized access_violation = %0d", access_violation);

        // Authorized write
        #10;
        wr_en = 1;
        token = 32'hDEADBEEF;
        key_in = 128'h000102030405060708090a0b0c0d0e0f;
        #10;
        wr_en = 0;
        $display("Authorized key_valid = %0d key_out = %h", key_valid, key_out);

        // AES FIPS-197 test vector
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h000102030405060708090a0b0c0d0e0f;

        #10;
        start = 1;
        #10;
        start = 0;

        #20;
        $display("Ciphertext = %h", ciphertext);

        if (ciphertext == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $display("AES TEST PASS");
        else
            $display("AES TEST FAIL");

        // Fault detection check
        fault_other = ciphertext;
        #5;
        $display("fault_flag same     = %0d", fault_flag);

        fault_other = ciphertext ^ 128'h1;
        #5;
        $display("fault_flag mismatch = %0d", fault_flag);

        // Masked S-box demo
        $display("masked_sbox: data_in=%h mask_in=%h mask_out=%h data_out=%h",
                 mask_data, mask_in, mask_out, masked_out);

        #20;
        $finish;
    end
endmodule