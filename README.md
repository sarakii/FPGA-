一个基于FPGA的串口收发实验，使用的硬件是正点原子MPSOC4EV芯片开发板。
实现的功能：使用串口助手往开发板发送数据，开发板接收到数据后把数据发回串口助手。
经实测，一个1.71MB的文本文件可以正确地被接收并发回串口助手，无误码。

- 下面是实验截图：
- 串口收发文本
![Snipaste_2024-11-16_22-09-12](https://github.com/user-attachments/assets/4d115060-18f8-4460-8451-a15269a54c70)
- 收发文件比对
![Snipaste_2024-11-16_22-09-33](https://github.com/user-attachments/assets/b275ba78-a28f-49de-8645-3a0098fe7be6)
