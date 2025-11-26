// SPDX-License-Identifier: CERN-OHL-S-2.0
// © 2025 Rosnnel Moncada

module Generic_MatserSPI_TB();

    parameter WordLen = 8,
                SysClk = 100000000,
                SPIClkFreq = 10000000;
    

    reg clk,reset,CPOL,CPHA,SPIGo,SPIMode,MISO,Endianess;
    reg [WordLen-1:0] SendData;
    wire MOSI;
    wire RxBusy,SS,TxBusy,WordFlg,SCLK;
    wire [WordLen-1:0] ReceivedData;

    Generic_MasterSPI #(SysClk, SPIClkFreq, WordLen) DUT
    (clk,reset,CPOL,CPHA,SPIGo,SPIMode,RxBusy,SS,TxBusy,SendData,MOSI,ReceivedData,
    MISO,Endianess,WordFlg,SCLK);

    reg MOSIDriver;
    //assign MOSI = MOSIDriver;

    initial
    begin
        clk=0;
        forever #5 clk = ~clk;
    end

    integer i,j;
    initial
    begin
        #0; reset=1; CPOL=0; CPHA=0; SPIGo=0; SPIMode=0; MISO=0; Endianess=0;
             SendData=8'b0; MOSIDriver=1'bz;
        #10; reset=0;
        for(i=0; i<8; i=i+1)
        begin
            #100; SendData = $random; 
            #10; SPIGo = 1;
            #800;
            for(j=0; j<WordLen; j=j+1)
            begin
                #100; MISO = $random;
                //#100 MOSIDriver = $random;
            end
            #50; /*SPIGo = 0; MOSIDriver = 1'bz;*/
        end
    end

endmodule
