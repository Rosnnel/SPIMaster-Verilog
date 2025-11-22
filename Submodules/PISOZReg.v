module PISOZReg #(parameter WordLen=8)
(clk,SCLKEdgeFlg,EnPISO,LoadPISO,WordFlg,TristateMode,Endiannes,DataIN,MOSI,HBReceviedData);

    input TristateMode;
    input clk,SCLKEdgeFlg,EnPISO,LoadPISO,WordFlg,Endiannes;
    input [WordLen-1:0] DataIN;
    output [WordLen-1:0]HBReceviedData;
    inout MOSI;

    reg [WordLen-1:0] TXReg,RXReg;

    always@(posedge clk)
    begin
        if(EnPISO)
        begin
            if(TristateMode) //Transmitting Data
            begin
                if(LoadPISO)
                    TXReg <= DataIN;
                else if(SCLKEdgeFlg && ~WordFlg)
                begin
                    if(~Endiannes)      //Little Endian
                        TXReg <= {1'b0,TXReg[WordLen-1:1]};
                    else                //Big Endian
                        TXReg <= {TXReg[WordLen-2:0],1'b0};
                end
            end
            else if(~TristateMode) //Receiving Data
            begin
                if(SCLKEdgeFlg && ~WordFlg)
                begin
                    if(~Endiannes)      //Little Endian
                        RXReg <= {MOSI,RXReg[WordLen-1:1]};
                    else                //Big Endian
                        RXReg <= {RXReg[WordLen-2:0],MOSI};
                end
            end
        end
    end

    assign MOSI = (TristateMode) ? ((~Endiannes) ? TXReg[0] : TXReg[WordLen-1]) : 1'bz;
    assign HBReceviedData = RXReg;

endmodule