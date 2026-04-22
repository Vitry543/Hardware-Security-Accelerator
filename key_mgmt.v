module key_mgmt(clk, rst, wr_en, token, key_in, key_out, key_valid, access_violation);
    input         clk;
    input         rst;
    input         wr_en;
    input  [31:0] token;
    input  [127:0] key_in;
    output [127:0] key_out;
    output        key_valid;
    output        access_violation;

    reg [127:0] key_reg;
    reg         valid_reg;
    reg         violation_reg;

    parameter SECRET_TOKEN = 32'hDEADBEEF;

    assign key_out = key_reg;
    assign key_valid = valid_reg;
    assign access_violation = violation_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            key_reg <= 128'h0;
            valid_reg <= 1'b0;
            violation_reg <= 1'b0;
        end else begin
            violation_reg <= 1'b0;
            if (wr_en) begin
                if (token == SECRET_TOKEN) begin
                    key_reg <= key_in;
                    valid_reg <= 1'b1;
                end else begin
                    violation_reg <= 1'b1;
                end
            end
        end
    end
endmodule