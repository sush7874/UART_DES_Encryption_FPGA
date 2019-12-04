`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2019 01:43:17
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tb;

integer i;
integer k;

reg [63:0] key = 64'b00010011_00110100_01010111_01111001_10011011_10111100_11011111_11110001;
reg [63:0] message =  64'b0000_0001_0010_0011_0100_0101_0110_0111_1000_1001_1010_1011_1100_1101_1110_1111;

wire txd;
reg  rxd;
reg send_enc=0;
reg clk=1;
reg rst;

top top_instance(   .clk(clk),
                    .rst(rst),
                    .rxd(rxd),
                    .txd(txd),
                    .send_encrypt(send_enc)
               );

always #(5) clk=!clk;

reg [7:0] address=0;

initial begin 
    rst=1;
    #(10)rst=0;
    for(i=0;i<8;i=i+1) begin
        address=i;
        for(k=0;k<10;k=k+1) begin
            if(k==0)
                rxd=0;
            else if(k==9)
                rxd=1;
            else begin
                rxd=address[k-1];
                end
            #(8680);
        end
        address={message[i*8+7],message[i*8+6],message[i*8+5],message[i*8+4],message[i*8+3],message[i*8+2],message[i*8+1],message[i*8]};
        for(k=0;k<10;k=k+1) begin
            if(k==0)
                rxd=0;
            else if(k==9)
                rxd=1;
            else begin
                rxd=address[k-1];
                end
            #(8680);
        end
    end
    
    for(i=0;i<8;i=i+1) begin
        address=i+8;
        for(k=0;k<10;k=k+1) begin
            if(k==0)
                rxd=0;
            else if(k==9)
                rxd=1;
            else begin
                rxd=address[k-1];
                end
            #(8680);
        end
        address={key[i*8+7],key[i*8+6],key[i*8+5],key[i*8+4],key[i*8+3],key[i*8+2],key[i*8+1],key[i*8]};
        for(k=0;k<10;k=k+1) begin
            if(k==0)
                rxd=0;
            else if(k==9)
                rxd=1;
            else begin
                rxd=address[k-1];
                end
            #(8680);
        end
        
        
    end
    
    address=55;
        for(k=0;k<10;k=k+1) begin
            if(k==0)
                rxd=0;
            else if(k==9)
                rxd=1;
            else begin
                rxd=address[k-1];
                end
            #(8680);
        end
    #(3000);
    send_enc=1;
    #(10);
    send_enc=0;
    end
endmodule
