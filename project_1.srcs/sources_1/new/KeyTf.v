
module KeyTf(output reg [47:0] key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13, key14, key15, key16, input [63:0] key);
  //Key transform where, 56 bitsare taken from the 64 bit key.
  function [55:0] PC1_perm(input [63:0] key);
    integer PC1[55:0];
    integer i;
    reg [55:0] temp_perm;
    begin
			PC1[0] = 57;PC1[1] = 49;PC1[2] = 41;PC1[3] = 33;PC1[4] = 25;PC1[5] = 17;PC1[6] = 9;PC1[7] = 1;
			PC1[8] = 58;PC1[9] = 50;PC1[10] = 42;PC1[11] = 34;PC1[12] = 26;PC1[13] = 18;PC1[14] = 10;PC1[15] = 2;
			PC1[16] = 59;PC1[17] = 51;PC1[18] = 43;PC1[19] = 35;PC1[20] = 27;PC1[21] = 19;PC1[22] = 11;PC1[23] = 3;
			PC1[24] = 60;PC1[25] = 52;PC1[26] = 44;PC1[27] = 36;PC1[28] = 63;PC1[29] = 55;PC1[30] = 47;PC1[31] = 39;
			PC1[32] = 31;PC1[33] = 23;PC1[34] = 15;PC1[35] = 7;PC1[36] = 62;PC1[37] = 54;PC1[38] = 46;PC1[39] = 38;
			PC1[40] = 30;PC1[41] = 22;PC1[42] = 14;PC1[43] = 6;PC1[44] = 61;PC1[45] = 53;PC1[46] = 45;PC1[47] = 37;
      PC1[48] = 29;PC1[49] = 21;PC1[50] = 13;PC1[51] = 5;PC1[52] = 28;PC1[53] = 20;PC1[54] = 12;PC1[55] = 4;

			for(i=0; i<56; i=i+1)
        temp_perm[55-i] = key[64-PC1[i]];

			PC1_perm = temp_perm;
    end
  endfunction
  // key transform 2. where 48 bits are chosen from the 56 bit key. (this key is different for every iteration. )
  // 16 iterations are carried out.
  function [47:0] PC2_perm(input [55:0] key_s);
    integer PC2[47:0];
    integer i;
    reg [47:0] temp_perm;
    begin
			PC2[0] = 14;PC2[1] = 17;PC2[2] = 11;PC2[3] = 24;PC2[4] = 1;PC2[5] = 5;PC2[6] = 3;PC2[7] = 28;
			PC2[8] = 15;PC2[9] = 6;PC2[10] = 21;PC2[11] = 10;PC2[12] = 23;PC2[13] = 19;PC2[14] = 12;PC2[15] = 4;
			PC2[16] = 26;PC2[17] = 8;PC2[18] = 16;PC2[19] = 7;PC2[20] = 27;PC2[21] = 20;PC2[22] = 13;PC2[23] = 2;
			PC2[24] = 41;PC2[25] = 52;PC2[26] = 31;PC2[27] = 37;PC2[28] = 47;PC2[29] = 55;PC2[30] = 30;PC2[31] = 40;
			PC2[32] = 51;PC2[33] = 45;PC2[34] = 33;PC2[35] = 48;PC2[36] = 44;PC2[37] = 49;PC2[38] = 39;PC2[39] = 56;
			PC2[40] = 34;PC2[41] = 53;PC2[42] = 46;PC2[43] = 42;PC2[44] = 50;PC2[45] = 36;PC2[46] = 29;PC2[47] = 32;

			for(i=0; i<48; i=i+1)
        temp_perm[47-i] = key_s[56-PC2[i]];

			PC2_perm = temp_perm;
    end
  endfunction
// Left shift function to choose the 48 bit key from the 56 bit key.
  function [55:0] C_i_D_i(input integer i, input [27:0] C_last, D_last);
    integer shift_left[0:15];
    begin
      shift_left[0] = 1;
      shift_left[1] = 1;
      shift_left[2] = 2;
      shift_left[3] = 2;
      shift_left[4] = 2;
      shift_left[5] = 2;
      shift_left[6] = 2;
      shift_left[7] = 2;
      shift_left[8] = 1;
      shift_left[9] = 2;
      shift_left[10] = 2;
      shift_left[11] = 2;
      shift_left[12] = 2;
      shift_left[13] = 2;
      shift_left[14] = 2;
      shift_left[15] = 1;

      if(shift_left[i-1] == 'd1)
        C_i_D_i = {C_last[26:0], C_last[27], D_last[26:0], D_last[27]};
      else if(shift_left[i-1] == 'd2)
        C_i_D_i = {C_last[25:1], C_last[27:26], D_last[25:0], D_last[27:26]};

    end
  endfunction

  reg [55:0] temp_pc1;
  reg [27:0] C[16:0], D[16:0];
  reg [47:0] K[0:15];
  integer i;

  always @(key)
  begin
    temp_pc1 = PC1_perm(key);
    C[0] = temp_pc1[55:28];
    D[0] = temp_pc1[27:0];
    for(i=1; i<=16; i=i+1)
    begin
      {C[i], D[i]} = C_i_D_i(i, C[i-1], D[i-1]);
      K[i-1] = PC2_perm({C[i], D[i]});
    end

    key1 = K[0];
    key2 = K[1];
    key3 = K[2];
    key4 = K[3];
    key5 = K[4];
    key6 = K[5];
    key7 = K[6];
    key8 = K[7];
    key9 = K[8];
    key10 = K[9];
    key11 = K[10];
    key12 = K[11];
    key13 = K[12];
    key14 = K[13];
    key15 = K[14];
    key16 = K[15];
  end
endmodule
