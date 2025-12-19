// SPDX-License-Identifier: CERN-OHL-S-2.0
// © 2025 Rosnnel Moncada

module DataWordCounter #(parameter WordLen=8)
(clk,EnCount,SampleEdge,WordFlg);

    input clk;
    input EnCount;
    input SampleEdge;
    output reg WordFlg;
    
    reg [7:0] Count;
    
    always@(posedge clk)
    begin
        if(EnCount)
        begin
            if(SampleEdge)
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