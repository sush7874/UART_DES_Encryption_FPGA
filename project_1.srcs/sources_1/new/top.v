//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2019 03:32:17
// Design Name: 
// Module Name: top
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


module top(input wire clk,
           input wire rst,
           
           input wire rxd,
           output wire txd,
           
           input send_encrypt
       
    );
wire tready;
    
wire [15:0] prescale=100000000/(115200*8);
wire                   tx_busy;
wire                   rx_busy;
wire                   rx_overrun_error;
wire                   rx_frame_error;

wire [7:0] address_data;
wire write;
reg ack;
reg send_valid=0;
reg [7:0] datatosend=0;

     uart uart_instance
(
    .clk(clk),
    .rst(rst),

    /*
     * AXI input
*/     
    .s_axis_tdata(datatosend),
    .s_axis_tvalid(send_valid),
    .s_axis_tready(tready),

    /*
     * AXI output
     */
    .m_axis_tdata(address_data),
    .m_axis_tvalid(write),
    .m_axis_tready(1),

    /*
     * UART interface
     */
    .rxd(rxd),
    .txd(txd),

    /*
     * Status
     */
     
    .tx_busy(tx_busy),
    .rx_busy(rx_busy),
    .rx_overrun_error(rx_overrun_error),
    .rx_frame_error(rx_frame_error),
    
    /*
     * Configuration
     */
    .prescale(prescale)

);

reg state=0;//0-state for address ,1 state for data
reg [7:0] write_address=0;
reg [7:0] write_data=0;
reg writeto_data_reg=0;
wire [63:0] data;
wire [63:0] key;

data_reg instmod(.clk(clk),
               .uart_data(write_data),
               .address(write_address),
               .write(writeto_data_reg),
               .data(data),
               .key(key));



always @(posedge clk) begin
    writeto_data_reg=0;
    ack = 0;
    if (write)begin
        case(state)
            1'b0: begin 
                    write_address=address_data;
                    if(write_address!=55)
                        state=1'b1;
                     else
                        ack = 1;
                    
                    end
            1'b1: begin 
                    write_data=address_data;
                    state=1'b0;
                    writeto_data_reg=1;
                    end                    
        endcase
        end
    end

wire [63:0] cipher;
  Encryption enc(.cipher(cipher), .message(data), .key(key), .ack(ack),.clk(clk));
  
reg [1:0] state_send=2'b00;
reg [7:0] address_send=0;
always @(posedge clk) begin
    if(tready&!send_valid)
        case (state_send)
            2'b00: begin
                    address_send=63;
                    if(send_encrypt)
                        state_send=2'b01;
                  end
            2'b01: begin
                    datatosend={cipher[address_send],cipher[address_send-1],cipher[address_send-2],cipher[address_send-3],cipher[address_send-4],cipher[address_send-5],cipher[address_send-6],cipher[address_send-7]};;//:address_send-8];
                    send_valid=1;
                    address_send=address_send-8;
                    if(address_send==8'hff)
                        state_send=2'b10;
                        
                    end
            2'b10: begin
                if(!send_encrypt)
                    state_send = 2'b00;
                 end
                    
        endcase
    
    else
        send_valid=0;
    end
endmodule
