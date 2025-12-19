// SPDX-License-Identifier: CERN-OHL-S-2.0
// © 2025 Rosnnel Moncada

module Generic_MasterSPI #(parameter SysClk = 100000000, SPIClkFreq = 2000000, WordLen = 8)
(clk,reset,CPOL,CPHA,SPIGo,SPIMode,RxBusy,SS,TxBusy,SendData,MOSI,ReceivedData,
MISO,BitOrder,WordFlg,SCLK);

    input clk,reset,CPOL,CPHA,SPIGo,SPIMode,MISO,BitOrder;
    input [WordLen-1:0] SendData;
    inout MOSI;
    output RxBusy,SS,TxBusy,WordFlg,SCLK;
    output reg [WordLen-1:0] ReceivedData;

    reg CPOLR,CPHAR,SPIModeR,EndianessR;

    always@(posedge clk)
    begin
        if(~SPIGo)
        begin
            CPOLR <= CPOL;
            CPHAR <= CPHA;
            SPIModeR <= SPIMode;
            EndianessR <= BitOrder;
        end
    end

    wire EnSCLK,ShiftEdge,SampleEdge,EnCounter,WordFlg,LoadPISO,EnPISO,EnSIPO,EnReceivedReg,
         TristateMode;
    SPIMasterFSM SPIMasterFSM
    (.clk(clk),.reset(reset),.SPIGo(SPIGo),.EnSCLK(EnSCLK),.EnCounter(EnCounter),
    .WordFlg(WordFlg),.LoadPISO(LoadPISO),.EnPISO(EnPISO),.EnSIPO(EnSIPO),
    .EnReceivedReg(EnReceivedReg),.SPIMode(SPIModeR),.TxBusy(TxBusy),.SS(SS),
    .RxBusy(RxBusy),.TristateMode(TristateMode),.ShiftEdge(ShiftEdge));


    SCLKGenerator #(.SysClk(SysClk), .SPIClkFreq(SPIClkFreq)) SCLKGen
    (.clk(clk),.CPHA(CPHAR),.CPOL(CPOLR),.EnSCLK(EnSCLK),.SCLK(SCLK),
    .ShiftEdge(ShiftEdge),.SampleEdge(SampleEdge));

    DataWordCounter #(.WordLen(WordLen)) DataWordCounter
    (.clk(clk),.EnCount(EnCounter),.SampleEdge(SampleEdge),.WordFlg(WordFlg));

    wire [WordLen-1:0] HBReceivedData;
    PISOZReg #(.WordLen(WordLen)) PISOZReg
    (.clk(clk),.ShiftEdge(ShiftEdge),.EnPISO(EnPISO),.LoadPISO(LoadPISO),
    .WordFlg(WordFlg),.TristateMode(TristateMode),.BitOrder(EndianessR),.DataIN(SendData),
    .MOSI(MOSI),.HBReceviedData(HBReceivedData));

    wire [WordLen-1:0] FBReceivedData;
    SIPOReg #(.WordLen(WordLen)) SIPOReg
    (.clk(clk),.SampleEdge(SampleEdge),.EnSIPO(EnSIPO),.BitOrder(EndianessR),.MISO(MISO),
    .ReceivedData(FBReceivedData));

    reg [WordLen-1:0] ReceivedDataC;
    always@(*)
    begin
        case(SPIModeR)
            1'b0: 
                ReceivedDataC = FBReceivedData;
            1'b1:   
                ReceivedDataC = HBReceivedData;
            default:
                ReceivedDataC = FBReceivedData;
        endcase
    end
    
    always@(posedge clk) if(EnReceivedReg) ReceivedData <= ReceivedDataC;
    
endmodule