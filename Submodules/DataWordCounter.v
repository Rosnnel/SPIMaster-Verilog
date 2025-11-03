module DataWordCounter #(parameter WordLen=8)
(clk,EnCount,SCLKEdgeFlg,WordFlg);

    input clk;
    input EnCount;
    input SCLKEdgeFlg;
    output reg WordFlg;
    
    reg [7:0] Count;
    
    always@(posedge clk)
    begin
        if(EnCount)
        begin
            if(SCLKEdgeFlg)
            begin
                if(Count>=WordLen-1)
                begin
                    Count <= 8'b0;
                    WordFlg <= 1'b1;
                end
                else
                begin
                    Count <= Count+1;
                    WordFlg <= 1'b0;
                end
            end
            else
                WordFlg <= 1'b0;
        end
        else
        begin
            Count <= 8'b0;
            WordFlg <= 1'b0;
        end
    end
endmodule