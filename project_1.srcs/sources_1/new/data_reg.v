`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2019 10:12:58 PM
// Design Name: 
// Module Name: newone
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


module data_reg(input clk,
               input [7:0] uart_data,
               input [7:0] address,
               input write,
               output [63:0] data,
               output [63:0] key
    );
    
    reg [7:0] data_key [15:0];//first 64 bits data next 64 bits key
    assign data={data_key[7],data_key[6],data_key[5],data_key[4],data_key[3],data_key[2],data_key[1],data_key[0]};
    assign key ={data_key[15],data_key[14],data_key[13],data_key[12],data_key[11],data_key[10],data_key[9],data_key[8]};
    always @(posedge clk) begin
    if(write)
        data_key[address]=uart_data;
    end
    
endmodule
