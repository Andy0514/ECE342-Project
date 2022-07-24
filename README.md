# ECE342 Project
This is my ECE342 FPGA Bitcoin-mining project implemented using Intel FPGA. I developed SHA256 calculation cores using SystemVerilog, and instantiated and controlled them using an FSM to compute Bitcoin nonce, taking into account double hashing. Data is sent to and from the computer using SignalProbe interface.

Hash rate on DE1-SoC Development Kit: 10MH/s
