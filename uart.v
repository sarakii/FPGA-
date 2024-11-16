`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 12:27:16
// Design Name: 
// Module Name: uart
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


module uart(
    input sys_clk_p,
    input sys_clk_n,
    input sys_rst_n,

    output tx,
    input rx,
    // output rx_done,
    // output tx_done,
    output led // 配置引脚的话必须是端口
    );

    /* 用于将rx到的数据从tx重新发出去 */
    wire rx_done; // 接收1帧完成（仿真时，需将这个标志位设置成output端口）
    wire tx_done; // 接收1帧完成（仿真时，需将这个标志位设置成output端口）
    wire rx_busy; // 接收状态
    wire [7:0] rx_data; // 接收到的8位数据
    reg [7:0] rx_data_temp; // 串口8位数据缓冲
    reg send_en; // 发送使能

    // 差分信号输出
    IBUFDS diff_clk(
        .I(sys_clk_p),
        .IB(sys_clk_n),
        .O(sys_clk)
    );

    // 串口接收数据缓冲，实现一收一发
    always @(posedge sys_clk or negedge sys_rst_n)begin
        if(!sys_rst_n)begin
            rx_data_temp <= 1'b0;
        end else if(rx_done)begin // 接收完毕
            rx_data_temp <= rx_data;
        end
    end

    reg rx_done_d0, rx_done_d1;
    always @(posedge sys_clk or negedge sys_rst_n)begin
        if(!sys_rst_n)begin
            rx_done_d0 <= 1'b0;
            rx_done_d1 <= 1'b0;
        end else begin
            rx_done_d0 <= rx_done;
            rx_done_d1 <= rx_done_d0;
        end
    end

    // 控制串口发送
    always @(posedge sys_clk or negedge sys_rst_n)begin
        if(!sys_rst_n)begin
            send_en <= 1'b0;
        end else if(tx_done)begin
            send_en <= 1'b0;
        end else if(~rx_done_d1 && rx_done_d0)begin
            send_en <= 1'b1;
        end
    end

    // 发送模块
    uart_tx u_uart_tx(
        .clk(sys_clk),
        .rst_n(sys_rst_n),

        .Baud_Set(4),
        .data(rx_data_temp), // 发送数据
        .tx(tx),
        .send_en(send_en), // 发送使能控制
        .tx_done(tx_done)
    );
    
    // 接收模块
    uart_rx u_uart_rx (
        .clk(sys_clk),
        .rst_n(sys_rst_n),

        .Baud_Set(4),
        .rx(rx), // 串行接收数据线，接收发送方的串行数据
        .data(rx_data), // 并行输出数据
        .rx_busy(rx_busy), // 接收状态
        .rx_done(rx_done) // 接收完成
    );

    // led指示灯逻辑
    assign led = (rx_data == 8'h69)? ~led:led;

endmodule
