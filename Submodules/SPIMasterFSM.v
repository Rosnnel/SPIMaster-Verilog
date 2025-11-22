module SPIMasterFSM 
(clk,reset,SPIGo,EnSCLK,EnCounter,WordFlg,LoadPISO,EnPISO,EnSIPO,EnReceivedReg,SPIMode,
TxBusy,SS,RxBusy,TristateMode,SCLKEdgeFlg);

    input clk,reset,SPIGo,WordFlg,SPIMode,SCLKEdgeFlg;
    output reg EnSCLK,EnCounter,LoadPISO,EnPISO,EnSIPO,EnReceivedReg,TxBusy,RxBusy,SS,
        TristateMode;

    localparam idle=3'b000,
                FBS0=3'b001,
                FBS1=3'b010,
                HBS0=3'b011,
                HBS1=3'b100,
                HBS2=3'b101;

    reg[2:0] CS,NS;
    always@(posedge clk or posedge reset)
    begin
        if(reset)
            CS <= idle;
        else
            CS <= NS;
    end

    always@(*)
    begin
        case(CS)
            idle:
            begin
                if(SPIGo)
                    NS = (SPIMode) ? HBS0 : FBS0;
                else
                    NS = idle;
            end
            FBS0:
                if(~SPIGo)
                    NS= idle;
                else
                    NS = FBS1;
            FBS1:
                if(~SPIGo)
                    NS= idle;
                else if(WordFlg)
                    NS = FBS0;
                else
                    NS = FBS1;
            HBS0:
                if(~SPIGo)
                    NS= idle;
                else if (SCLKEdgeFlg)
                    NS = HBS1;
                else
                    NS = HBS0;
            HBS1:
                if(~SPIGo)
                    NS= idle;
                else if(WordFlg)
                    NS = HBS2;
                else
                    NS = HBS1;
            HBS2:
                if(~SPIGo)
                    NS= idle;
                else if(WordFlg)
                    NS = HBS0;
                else
                    NS = HBS2;
            default:
                NS = idle;
        endcase
    end

    always@(*)
    begin
        case(CS)
            idle:
            begin
                EnSCLK = (SPIGo) ? 1'b1 : 1'b0;
                EnCounter = (SPIGo) ? 1'b1 : 1'b0;
                LoadPISO = 1'b0;
                EnPISO = 1'b0;
                EnSIPO = 1'b0;
                EnReceivedReg = 1'b0;
                TxBusy = 1'b0;
                RxBusy = 1'b0;
                SS = (SPIGo) ? 1'b0 : 1'b1;
                TristateMode = 1'b1;
            end
            FBS0:
            begin
                EnSCLK = 1'b1;
                EnCounter = 1'b1;
                LoadPISO = 1'b1;
                EnPISO = 1'b1;
                EnSIPO = 1'b0;
                EnReceivedReg = 1'b1;
                TxBusy = 1'b1;
                RxBusy = 1'b1;
                SS = 1'b0;
                TristateMode = 1'b1;
            end
            FBS1:
            begin
                EnSCLK = 1'b1;
                EnCounter = 1'b1;
                LoadPISO = 1'b0;
                EnPISO = 1'b1;
                EnSIPO = 1'b1;
                EnReceivedReg = 1'b0;
                TxBusy = 1'b1;
                RxBusy = 1'b1;
                SS = 1'b0;
                TristateMode = 1'b1;
            end
            HBS0:
            begin
                EnSCLK = 1'b1;
                EnCounter = 1'b1;
                LoadPISO = 1'b1;
                EnPISO = 1'b1;
                EnSIPO = 1'b0;
                EnReceivedReg = 1'b1;
                TxBusy = 1'b0;
                RxBusy = 1'b0;
                SS = 1'b0;
                TristateMode = 1'b1;
            end  
            HBS1:
            begin
                EnSCLK = 1'b1;
                EnCounter = 1'b1;
                LoadPISO = 1'b0;
                EnPISO = 1'b1;
                EnSIPO = 1'b0;
                EnReceivedReg = 1'b0;
                TxBusy = 1'b1;
                RxBusy = 1'b0;
                SS = 1'b0;
                TristateMode = 1'b1;
            end  
            HBS2:
            begin
                EnSCLK = 1'b1;
                EnCounter = 1'b1;
                LoadPISO = 1'b0;
                EnPISO = 1'b1;
                EnSIPO = 1'b0;
                EnReceivedReg = 1'b0;
                TxBusy = 1'b0;
                RxBusy = 1'b1;
                SS = 1'b0;
                TristateMode = 1'b0;
            end
            default:
            begin
                EnSCLK = (SPIGo) ? 1'b1 : 1'b0;
                EnCounter = (SPIGo) ? 1'b1 : 1'b0;
                LoadPISO = 1'b0;
                EnPISO = 1'b0;
                EnSIPO = 1'b0;
                EnReceivedReg = 1'b0;
                TxBusy = 1'b0;
                RxBusy = 1'b0;
                SS = (SPIGo) ? 1'b0 : 1'b1;
                TristateMode = 1'b1;
            end
        endcase
    end

endmodule