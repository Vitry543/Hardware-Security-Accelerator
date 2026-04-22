module aes_core(clk, rst, start, plaintext, key, ciphertext, done);
    input clk;
    input rst;
    input start;
    input [127:0] plaintext;
    input [127:0] key;
    output [127:0] ciphertext;
    output done;

    reg [127:0] ciphertext;
    reg done;

    function [7:0] sbox;
        input [7:0] a;
        begin
            case (a)
                8'h00: sbox=8'h63; 8'h01: sbox=8'h7c; 8'h02: sbox=8'h77; 8'h03: sbox=8'h7b;
                8'h04: sbox=8'hf2; 8'h05: sbox=8'h6b; 8'h06: sbox=8'h6f; 8'h07: sbox=8'hc5;
                8'h08: sbox=8'h30; 8'h09: sbox=8'h01; 8'h0a: sbox=8'h67; 8'h0b: sbox=8'h2b;
                8'h0c: sbox=8'hfe; 8'h0d: sbox=8'hd7; 8'h0e: sbox=8'hab; 8'h0f: sbox=8'h76;
                8'h10: sbox=8'hca; 8'h11: sbox=8'h82; 8'h12: sbox=8'hc9; 8'h13: sbox=8'h7d;
                8'h14: sbox=8'hfa; 8'h15: sbox=8'h59; 8'h16: sbox=8'h47; 8'h17: sbox=8'hf0;
                8'h18: sbox=8'had; 8'h19: sbox=8'hd4; 8'h1a: sbox=8'ha2; 8'h1b: sbox=8'haf;
                8'h1c: sbox=8'h9c; 8'h1d: sbox=8'ha4; 8'h1e: sbox=8'h72; 8'h1f: sbox=8'hc0;
                8'h20: sbox=8'hb7; 8'h21: sbox=8'hfd; 8'h22: sbox=8'h93; 8'h23: sbox=8'h26;
                8'h24: sbox=8'h36; 8'h25: sbox=8'h3f; 8'h26: sbox=8'hf7; 8'h27: sbox=8'hcc;
                8'h28: sbox=8'h34; 8'h29: sbox=8'ha5; 8'h2a: sbox=8'he5; 8'h2b: sbox=8'hf1;
                8'h2c: sbox=8'h71; 8'h2d: sbox=8'hd8; 8'h2e: sbox=8'h31; 8'h2f: sbox=8'h15;
                8'h30: sbox=8'h04; 8'h31: sbox=8'hc7; 8'h32: sbox=8'h23; 8'h33: sbox=8'hc3;
                8'h34: sbox=8'h18; 8'h35: sbox=8'h96; 8'h36: sbox=8'h05; 8'h37: sbox=8'h9a;
                8'h38: sbox=8'h07; 8'h39: sbox=8'h12; 8'h3a: sbox=8'h80; 8'h3b: sbox=8'he2;
                8'h3c: sbox=8'heb; 8'h3d: sbox=8'h27; 8'h3e: sbox=8'hb2; 8'h3f: sbox=8'h75;
                8'h40: sbox=8'h09; 8'h41: sbox=8'h83; 8'h42: sbox=8'h2c; 8'h43: sbox=8'h1a;
                8'h44: sbox=8'h1b; 8'h45: sbox=8'h6e; 8'h46: sbox=8'h5a; 8'h47: sbox=8'ha0;
                8'h48: sbox=8'h52; 8'h49: sbox=8'h3b; 8'h4a: sbox=8'hd6; 8'h4b: sbox=8'hb3;
                8'h4c: sbox=8'h29; 8'h4d: sbox=8'he3; 8'h4e: sbox=8'h2f; 8'h4f: sbox=8'h84;
                8'h50: sbox=8'h53; 8'h51: sbox=8'hd1; 8'h52: sbox=8'h00; 8'h53: sbox=8'hed;
                8'h54: sbox=8'h20; 8'h55: sbox=8'hfc; 8'h56: sbox=8'hb1; 8'h57: sbox=8'h5b;
                8'h58: sbox=8'h6a; 8'h59: sbox=8'hcb; 8'h5a: sbox=8'hbe; 8'h5b: sbox=8'h39;
                8'h5c: sbox=8'h4a; 8'h5d: sbox=8'h4c; 8'h5e: sbox=8'h58; 8'h5f: sbox=8'hcf;
                8'h60: sbox=8'hd0; 8'h61: sbox=8'hef; 8'h62: sbox=8'haa; 8'h63: sbox=8'hfb;
                8'h64: sbox=8'h43; 8'h65: sbox=8'h4d; 8'h66: sbox=8'h33; 8'h67: sbox=8'h85;
                8'h68: sbox=8'h45; 8'h69: sbox=8'hf9; 8'h6a: sbox=8'h02; 8'h6b: sbox=8'h7f;
                8'h6c: sbox=8'h50; 8'h6d: sbox=8'h3c; 8'h6e: sbox=8'h9f; 8'h6f: sbox=8'ha8;
                8'h70: sbox=8'h51; 8'h71: sbox=8'ha3; 8'h72: sbox=8'h40; 8'h73: sbox=8'h8f;
                8'h74: sbox=8'h92; 8'h75: sbox=8'h9d; 8'h76: sbox=8'h38; 8'h77: sbox=8'hf5;
                8'h78: sbox=8'hbc; 8'h79: sbox=8'hb6; 8'h7a: sbox=8'hda; 8'h7b: sbox=8'h21;
                8'h7c: sbox=8'h10; 8'h7d: sbox=8'hff; 8'h7e: sbox=8'hf3; 8'h7f: sbox=8'hd2;
                8'h80: sbox=8'hcd; 8'h81: sbox=8'h0c; 8'h82: sbox=8'h13; 8'h83: sbox=8'hec;
                8'h84: sbox=8'h5f; 8'h85: sbox=8'h97; 8'h86: sbox=8'h44; 8'h87: sbox=8'h17;
                8'h88: sbox=8'hc4; 8'h89: sbox=8'ha7; 8'h8a: sbox=8'h7e; 8'h8b: sbox=8'h3d;
                8'h8c: sbox=8'h64; 8'h8d: sbox=8'h5d; 8'h8e: sbox=8'h19; 8'h8f: sbox=8'h73;
                8'h90: sbox=8'h60; 8'h91: sbox=8'h81; 8'h92: sbox=8'h4f; 8'h93: sbox=8'hdc;
                8'h94: sbox=8'h22; 8'h95: sbox=8'h2a; 8'h96: sbox=8'h90; 8'h97: sbox=8'h88;
                8'h98: sbox=8'h46; 8'h99: sbox=8'hee; 8'h9a: sbox=8'hb8; 8'h9b: sbox=8'h14;
                8'h9c: sbox=8'hde; 8'h9d: sbox=8'h5e; 8'h9e: sbox=8'h0b; 8'h9f: sbox=8'hdb;
                8'ha0: sbox=8'he0; 8'ha1: sbox=8'h32; 8'ha2: sbox=8'h3a; 8'ha3: sbox=8'h0a;
                8'ha4: sbox=8'h49; 8'ha5: sbox=8'h06; 8'ha6: sbox=8'h24; 8'ha7: sbox=8'h5c;
                8'ha8: sbox=8'hc2; 8'ha9: sbox=8'hd3; 8'haa: sbox=8'hac; 8'hab: sbox=8'h62;
                8'hac: sbox=8'h91; 8'had: sbox=8'h95; 8'hae: sbox=8'he4; 8'haf: sbox=8'h79;
                8'hb0: sbox=8'he7; 8'hb1: sbox=8'hc8; 8'hb2: sbox=8'h37; 8'hb3: sbox=8'h6d;
                8'hb4: sbox=8'h8d; 8'hb5: sbox=8'hd5; 8'hb6: sbox=8'h4e; 8'hb7: sbox=8'ha9;
                8'hb8: sbox=8'h6c; 8'hb9: sbox=8'h56; 8'hba: sbox=8'hf4; 8'hbb: sbox=8'hea;
                8'hbc: sbox=8'h65; 8'hbd: sbox=8'h7a; 8'hbe: sbox=8'hae; 8'hbf: sbox=8'h08;
                8'hc0: sbox=8'hba; 8'hc1: sbox=8'h78; 8'hc2: sbox=8'h25; 8'hc3: sbox=8'h2e;
                8'hc4: sbox=8'h1c; 8'hc5: sbox=8'ha6; 8'hc6: sbox=8'hb4; 8'hc7: sbox=8'hc6;
                8'hc8: sbox=8'he8; 8'hc9: sbox=8'hdd; 8'hca: sbox=8'h74; 8'hcb: sbox=8'h1f;
                8'hcc: sbox=8'h4b; 8'hcd: sbox=8'hbd; 8'hce: sbox=8'h8b; 8'hcf: sbox=8'h8a;
                8'hd0: sbox=8'h70; 8'hd1: sbox=8'h3e; 8'hd2: sbox=8'hb5; 8'hd3: sbox=8'h66;
                8'hd4: sbox=8'h48; 8'hd5: sbox=8'h03; 8'hd6: sbox=8'hf6; 8'hd7: sbox=8'h0e;
                8'hd8: sbox=8'h61; 8'hd9: sbox=8'h35; 8'hda: sbox=8'h57; 8'hdb: sbox=8'hb9;
                8'hdc: sbox=8'h86; 8'hdd: sbox=8'hc1; 8'hde: sbox=8'h1d; 8'hdf: sbox=8'h9e;
                8'he0: sbox=8'he1; 8'he1: sbox=8'hf8; 8'he2: sbox=8'h98; 8'he3: sbox=8'h11;
                8'he4: sbox=8'h69; 8'he5: sbox=8'hd9; 8'he6: sbox=8'h8e; 8'he7: sbox=8'h94;
                8'he8: sbox=8'h9b; 8'he9: sbox=8'h1e; 8'hea: sbox=8'h87; 8'heb: sbox=8'he9;
                8'hec: sbox=8'hce; 8'hed: sbox=8'h55; 8'hee: sbox=8'h28; 8'hef: sbox=8'hdf;
                8'hf0: sbox=8'h8c; 8'hf1: sbox=8'ha1; 8'hf2: sbox=8'h89; 8'hf3: sbox=8'h0d;
                8'hf4: sbox=8'hbf; 8'hf5: sbox=8'he6; 8'hf6: sbox=8'h42; 8'hf7: sbox=8'h68;
                8'hf8: sbox=8'h41; 8'hf9: sbox=8'h99; 8'hfa: sbox=8'h2d; 8'hfb: sbox=8'h0f;
                8'hfc: sbox=8'hb0; 8'hfd: sbox=8'h54; 8'hfe: sbox=8'hbb; 8'hff: sbox=8'h16;
            endcase
        end
    endfunction

    function [7:0] xtime;
        input [7:0] x;
        begin
            xtime = {x[6:0],1'b0} ^ (8'h1b & {8{x[7]}});
        end
    endfunction

    function [7:0] mul2;
        input [7:0] x;
        begin
            mul2 = xtime(x);
        end
    endfunction

    function [7:0] mul3;
        input [7:0] x;
        begin
            mul3 = xtime(x) ^ x;
        end
    endfunction

    function [127:0] sub_bytes;
        input [127:0] s;
        begin
            sub_bytes = {
                sbox(s[127:120]), sbox(s[119:112]), sbox(s[111:104]), sbox(s[103:96]),
                sbox(s[95:88]),   sbox(s[87:80]),   sbox(s[79:72]),   sbox(s[71:64]),
                sbox(s[63:56]),   sbox(s[55:48]),   sbox(s[47:40]),   sbox(s[39:32]),
                sbox(s[31:24]),   sbox(s[23:16]),   sbox(s[15:8]),    sbox(s[7:0])
            };
        end
    endfunction

    function [127:0] shift_rows;
        input [127:0] s;
        reg [7:0] b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15;
        begin
            b0  = s[127:120]; b1  = s[119:112]; b2  = s[111:104]; b3  = s[103:96];
            b4  = s[95:88];   b5  = s[87:80];   b6  = s[79:72];   b7  = s[71:64];
            b8  = s[63:56];   b9  = s[55:48];   b10 = s[47:40];   b11 = s[39:32];
            b12 = s[31:24];   b13 = s[23:16];   b14 = s[15:8];    b15 = s[7:0];

            shift_rows = {
                b0,  b5,  b10, b15,
                b4,  b9,  b14, b3,
                b8,  b13, b2,  b7,
                b12, b1,  b6,  b11
            };
        end
    endfunction

    function [127:0] mix_columns;
        input [127:0] s;
        reg [7:0] b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15;
        reg [7:0] o0,o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15;
        begin
            b0  = s[127:120]; b1  = s[119:112]; b2  = s[111:104]; b3  = s[103:96];
            b4  = s[95:88];   b5  = s[87:80];   b6  = s[79:72];   b7  = s[71:64];
            b8  = s[63:56];   b9  = s[55:48];   b10 = s[47:40];   b11 = s[39:32];
            b12 = s[31:24];   b13 = s[23:16];   b14 = s[15:8];    b15 = s[7:0];

            o0  = mul2(b0)  ^ mul3(b1)  ^ b2       ^ b3;
            o1  = b0        ^ mul2(b1)  ^ mul3(b2) ^ b3;
            o2  = b0        ^ b1        ^ mul2(b2) ^ mul3(b3);
            o3  = mul3(b0)  ^ b1        ^ b2       ^ mul2(b3);

            o4  = mul2(b4)  ^ mul3(b5)  ^ b6       ^ b7;
            o5  = b4        ^ mul2(b5)  ^ mul3(b6) ^ b7;
            o6  = b4        ^ b5        ^ mul2(b6) ^ mul3(b7);
            o7  = mul3(b4)  ^ b5        ^ b6       ^ mul2(b7);

            o8  = mul2(b8)  ^ mul3(b9)  ^ b10      ^ b11;
            o9  = b8        ^ mul2(b9)  ^ mul3(b10)^ b11;
            o10 = b8        ^ b9        ^ mul2(b10)^ mul3(b11);
            o11 = mul3(b8)  ^ b9        ^ b10      ^ mul2(b11);

            o12 = mul2(b12) ^ mul3(b13) ^ b14      ^ b15;
            o13 = b12       ^ mul2(b13) ^ mul3(b14)^ b15;
            o14 = b12       ^ b13       ^ mul2(b14)^ mul3(b15);
            o15 = mul3(b12) ^ b13       ^ b14      ^ mul2(b15);

            mix_columns = {o0,o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15};
        end
    endfunction

    function [31:0] sub_word;
        input [31:0] w;
        begin
            sub_word = {sbox(w[31:24]), sbox(w[23:16]), sbox(w[15:8]), sbox(w[7:0])};
        end
    endfunction

    function [127:0] next_round_key;
        input [127:0] k;
        input [31:0] rcon;
        reg [31:0] w0,w1,w2,w3,temp,nw0,nw1,nw2,nw3;
        begin
            w0 = k[127:96];
            w1 = k[95:64];
            w2 = k[63:32];
            w3 = k[31:0];
            temp = sub_word({w3[23:0], w3[31:24]}) ^ rcon;
            nw0 = w0 ^ temp;
            nw1 = w1 ^ nw0;
            nw2 = w2 ^ nw1;
            nw3 = w3 ^ nw2;
            next_round_key = {nw0,nw1,nw2,nw3};
        end
    endfunction

    reg [127:0] state;
    reg [127:0] rk1,rk2,rk3,rk4,rk5,rk6,rk7,rk8,rk9,rk10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 128'h0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start) begin
                rk1  = next_round_key(key,  32'h01000000);
                rk2  = next_round_key(rk1,  32'h02000000);
                rk3  = next_round_key(rk2,  32'h04000000);
                rk4  = next_round_key(rk3,  32'h08000000);
                rk5  = next_round_key(rk4,  32'h10000000);
                rk6  = next_round_key(rk5,  32'h20000000);
                rk7  = next_round_key(rk6,  32'h40000000);
                rk8  = next_round_key(rk7,  32'h80000000);
                rk9  = next_round_key(rk8,  32'h1b000000);
                rk10 = next_round_key(rk9,  32'h36000000);

                state = plaintext ^ key;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk1;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk2;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk3;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk4;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk5;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk6;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk7;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk8;
                state = mix_columns(shift_rows(sub_bytes(state))) ^ rk9;
                state = shift_rows(sub_bytes(state)) ^ rk10;

                ciphertext <= state;
                done <= 1'b1;
            end
        end
    end
endmodule