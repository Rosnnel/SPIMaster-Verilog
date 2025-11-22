module SIPOReg #(parameter WordLen=8)
(clk,SCLKEdgeFlg,EnSIPO,Endiannes,MISO,ReceivedData);

    input clk,SCLKEdgeFlg,EnSIPO,Endiannes;
    input MISO;
    output [WordLen-1:0] ReceivedData;

    reg [WordLen-1:0] Reg;

    always@(posedge clk)
    begin
        if(EnSIPO)
        begin
            if(SCLKEdgeFlg)
            begin
                if(~Endiannes)      //Little Endian
                    Reg <= {MISO,Reg[WordLen-1:1]};
                else                //Big Endian
                    Reg <= {Reg[WordLen-2:0],MISO};
            end
        end
    end

    assign ReceivedData = Reg;

endmodule