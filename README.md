# Generic Master SPI Module

This repository contains all the infromation related to my IP implementation and description of a Generic SPI Master module that can work and be reprogrammed "on-the-fly", allowing to change parameters like 
CPOL, CPHA, BitOrdering and the possibility to change the operation mode beteween Half-bridge and Full-bridge communication.

The Serial Peripheral Interface module allows to transfer data quickly between different chips by selecting an slave through a inverted Slave Select - *SS* signal and generating a synchronizer 
SPI CLOCK - SCLK signal, that tells both the sender and receiver when to sample and shift data based on the CPOL and CPHA configuration signals, the data is shifted and sampled by the MOSI and MISO ports,
the bit ordering can be changed through the BitOrder pin, performing MSBfirst when BitOrder = 0 and LSBfirst when BitOrder = 1. 
The SPIGo signal tells the module to start the communication between the master and the slave and their functionality vary between the Full-Bridge and Half-bridge modes, alternating the MOSI Bus for TX and RX when 
HalfBridge mode and using both the MOSI and MISO for the FUll Bridge Mode.  

The module is conformed by the folllowing submodules:
- SCLK Generator that generates both the SCLK signal and a edge flag based on CPOL and CPHA configuration bits used to orchest the overall module.
- DataWord Counter that counts bits and generates a WordFlg indicating that all the packet was transfered.
- PISOZ Register that uses a tristate buffer for the Master-Out-Slave-In - *MOSI* pin that depending on the type of transmission works only as output for Full-Bridge communication and as a
  bidirectional bus for half bridge communication, alternating between Z-State for reads and asserting the BUS for writes.
- SIPO Register that is used as Master-In-Slave-Out - *MISO* pin for Full-Bridge Communications.
- General purpose enabled registers that are used for data holding and protection between transfers.
- FSM That accomplishes the communication protocol, activating each of the mentioned modules depending on the current state and activation signals. The FSM also asserts the SS signal and generates RxBusy and TxBusy signalas to indicate the user that
- theres a transaction.

In order to represent a real case module usage, it will be used a wordlength of 8 bits, and a 2MHz SCLK frequency.
Next is shown the RTL Representation of the proposed Generic Master SPI module:

<img width="829" height="820" alt="Jo" src="https://github.com/user-attachments/assets/0bde17d7-e988-49d4-a559-d53642d856ec" />

Next is shown the State Diagram that uses the FSM to control the module:

<img width="705" height="717" alt="SPI STATE DIAGRAM" src="https://github.com/user-attachments/assets/5e4d3c6c-2e34-4576-8d1f-2c0065742ec9" />

Next is shown the Output signals for each state:

<img width="1115" height="624" alt="SPI State outputs" src="https://github.com/user-attachments/assets/3e3b3613-48ac-48d1-92cf-fbb3cef668c5" />

--------------------

The described submodules with the corresponding GenericMasterSPI top module will generate the following RTL module, this representation was obtained using Vivado Design Suite:

<img width="1555" height="668" alt="image" src="https://github.com/user-attachments/assets/b46bb3ed-d689-4eb0-866e-57e582a6b5cc" />

The attached Testbench works in two ways. Setting the SPIMode = 0 and commenting the lines 19 and 41 for full bridge test. setting SPIMode = 1 and commenting the 40 line triggers the HB simulation. 

To analyze the Full-bridge implementation, it can be seen how the MOSI nad MISO signals generates 
the desired input values in a serial way, this behaviour can be seen in the next image:

<img width="1515" height="383" alt="image" src="https://github.com/user-attachments/assets/077d9b66-58eb-4a9d-9f78-9fa5674245e9" />

Next is shwon the Half-Bidge Simulation, it is needed to keep in mind that it isn't possible to see all the expected behaviour of a tristate bus in Verilog HDL becuase of the asserted Z State of the tristate bus: 

<img width="1545" height="382" alt="HB1" src="https://github.com/user-attachments/assets/37232e1f-9f9b-4700-8959-8362fd34c1ed" />

By the way uncommenting the line 19 and 41 will forcely drive data to the MOSI Bus, allowing to simulate the data being received in the RX Cycles:

<img width="1547" height="422" alt="HB2" src="https://github.com/user-attachments/assets/cccdab2e-a308-4181-9535-e712cfe87938" />

Another specs that can be provided is the resource consumption, power consumption and max system frequency in an Arty S7 FPGA Development board, achieving the following results:

<img width="388" height="56" alt="image" src="https://github.com/user-attachments/assets/362180fd-5809-4b74-abf1-236d3eb5dbb4" />
<img width="1016" height="200" alt="image" src="https://github.com/user-attachments/assets/93dcf45d-75f8-4f6a-bbc7-6d0672e248b2" />
<img width="412" height="271" alt="image" src="https://github.com/user-attachments/assets/e65c7106-7a5e-4ef4-aee5-eb6ff68e10b8" />
<img width="667" height="282" alt="image" src="https://github.com/user-attachments/assets/0004706d-1e5b-4573-8ea4-3846c8acfc70" />




------------------------------

Finally it is possible to present a real test using the mentioned FPGA, for this test, was used a simple hardware that instantiates a memory file by reading an .mem file and assigning the value readed
into the Dtaa to be sended through the MOSI port, at the same time the MOSI Port is physically connected to the MISO port so every transaction should show the sended data into a bit array, 
next are shown the related images of the described project:

Next image shows the SCLK and MOSI Lines on a fullbridge transfer: 
<img width="4032" height="3024" alt="IMG_1264" src="https://github.com/user-attachments/assets/0be85022-5074-4039-9427-8419b87dd291" />

And the received byte of a transfer:
<img width="3024" height="4032" alt="IMG_1262" src="https://github.com/user-attachments/assets/45830218-7e34-41a7-991e-318257149089" />
