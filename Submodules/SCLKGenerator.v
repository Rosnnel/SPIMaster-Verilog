module SCLKGenerator #(parameter ClkFreq=100000000, SPIClkFreq=2000000)
(clk,CPHA,CPOL,ClkCntEn,SCLK,ClkCntFlg);

    localparam DIV=(ClkFreq/SPIClkFreq);

    input clk,CPHA,CPOL;
    input ClkCntEn;
    output reg ClkCntFlg;
    output SCLK;
    
    reg Flg;
    reg [20:0]Count;
    
    always@(posedge clk)
    begin
        if(ClkCntEn)
        begin
            Count <= Count+1;
            if(Count>=DIV-1)
            begin
                Flg <= ~Flg;
                Count <= 20'b0;
            end
        end 
        else
        begin
            Count<=20'b0;
            Flg <= 1'b0;
        end
    end
    
    assign SCLK = (CPOL) ? ~Flg:Flg;
    
    reg R0,R1;
    
    always@(posedge clk)
    begin
        R0<=SCLK;
        R1<=R0;
    end

    always@(*)
    begin
        case({CPOL,CPHA})
            2'b00, 2'b11:
            begin
                if(R0==0 && R1==1)
                    ClkCntFlg = 1'b1;
                else
                    ClkCntFlg = 1'b0;
            end
            2'b01,2'b10:
            begin
                if(R0==1 && R1==0)
                    ClkCntFlg = 1'b1;
                else
                    ClkCntFlg = 1'b0;
            end
        endcase
    end
endmodule
