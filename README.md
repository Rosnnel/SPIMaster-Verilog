# Generic Master SPI Module

This repository contains all the infromation related to my IP implementation and description of a Generic SPI Master module that can work and be reprogrammed "on-the-fly", allowing to change parameters like 
CPOL, CPHA, Endianess and the possibility to change the operation mode beteween Half-bridge and Full-bridge communication.

The Serial Peripheral Interface modukle allows to transfer data quickly between different chips by selecting an slave through a inverted Slave Select - *SS* signal and generating a synchronizer 
SPI CLOCK - SCLK signal, that tells both the sender and receiver when to sample and shift data based on the CPOL and CPHA configuration signals, the data is shifted and sampled by the MOSI and MISO ports,
the bit ordering can be changed through the Endianess bit, performing Little-Endian when Endianess = 0 and Big-Endian when Endianess = 1. 
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

Next is shown the RTL Representation of the proposed Generic Master SPI module:

<img width="893" height="925" alt="SPI Master" src="https://github.com/user-attachments/assets/0d54faa7-6623-4648-b456-90ca702b9d69" />

Next is shown the State Diagram that uses the FSM to control the module:

<img width="705" height="717" alt="SPI STATE DIAGRAM" src="https://github.com/user-attachments/assets/5e4d3c6c-2e34-4576-8d1f-2c0065742ec9" />

Next is shown the Output signals for each state:

<img width="1115" height="624" alt="SPI State outputs" src="https://github.com/user-attachments/assets/3e3b3613-48ac-48d1-92cf-fbb3cef668c5" />

--------------------

The described submodules with the corresponding GenericMasterSPI top module will generate the following RTL module, this representation was obtained using Vivado Design Suite:

<img width="1567" height="688" alt="RTL" src="https://github.com/user-attachments/assets/9e68c983-aa39-4bcc-af8c-7ba269d8c998" />

The attached Testbench works in two ways. Setting the SPIMode = 0 and commenting the lines 19 and 41 for full bridge test. setting SPIMode = 1 and commenting the 40 line triggers the HB simulation. 

To analyze the Full-bridge implementation, it can be seen how the MOSI nad MISO signals generates 
the desired input values in a serial way, this behaviour can be seen in the next image:

<img width="1492" height="382" alt="FB" src="https://github.com/user-attachments/assets/8973916d-9858-4d9b-91a9-175345e4e7bc" />

Next is shwon the Half-Bidge Simulation, it is needed to keep in mind that it isn't possible to see all the expected behaviour of a tristate bus in Verilog HDL becuase of the asserted Z State of the tristate bus: 

<img width="1545" height="382" alt="HB1" src="https://github.com/user-attachments/assets/37232e1f-9f9b-4700-8959-8362fd34c1ed" />

By the way uncommenting the line 19 and 41 will forcely drive data to the MOSI Bus, allowing to simulate the data being received in the RX Cycles:

<img width="1547" height="422" alt="HB2" src="https://github.com/user-attachments/assets/cccdab2e-a308-4181-9535-e712cfe87938" />

Another specs that can be provided is the resource consumption, power consumption and max system frequency in an Arty S7 FPGA Development board, achieving the following results:
<img width="607" height="81" alt="Utilization" src="https://github.com/user-attachments/assets/bc23c8ee-24a6-4aaf-9b57-92f6790747b1" />
<img width="400" height="242" alt="image" src="https://github.com/user-attachments/assets/ff1d07ad-c125-494e-bbf2-d1f8652238a2" />
<img width="404" height="64" alt="image" src="https://github.com/user-attachments/assets/a6ed3677-49cb-486c-aa4d-519e3ed17174" />
<img width="1012" height="203" alt="image" src="https://github.com/user-attachments/assets/941fe6c1-ba35-4e39-a640-04fedc86de24" />

------------------------------

Finally it is possible to present a real test using the mentioned FPGA, for this test, was used a simple hardware that instantiates a memory file by reading an .mem file and assigning the value readed
into the Dtaa to be sended through the MOSI port, at the same time the MOSI Port is physically connected to the MISO port so every transaction should show the sended data into a bit array, 
next are shown the related images of the described project:

Next image shows the SCLK and MOSI Lines on a fullbridge transfer: 
<img width="4032" height="3024" alt="IMG_1264" src="https://github.com/user-attachments/assets/0be85022-5074-4039-9427-8419b87dd291" />

And the received byte of a transfer:
<img width="3024" height="4032" alt="IMG_1262" src="https://github.com/user-attachments/assets/45830218-7e34-41a7-991e-318257149089" />
