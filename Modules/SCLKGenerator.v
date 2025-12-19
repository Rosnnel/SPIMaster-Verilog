// SPDX-License-Identifier: CERN-OHL-S-2.0
// © 2025 Rosnnel Moncada

module SCLKGenerator #(parameter SysClk=100000000, SPIClkFreq=2000000)
(clk,CPHA,CPOL,EnSCLK,SCLK,ShiftEdge,SampleEdge);

    localparam DIV=(SysClk/(2*SPIClkFreq));

    input clk,CPHA,CPOL;
    input EnSCLK;
    output ShiftEdge;
    output SampleEdge;
    output SCLK;
    
    reg Flg;
    reg [20:0]Count;
    
    always@(posedge clk)
    begin
        if(EnSCLK)
        begin            
            if(Count>=DIV-1)
            begin
                Flg <= ~Flg;
                Count <= 20'b0;
            end
            else
            begin
                Count <= Count+1;
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
    wire RsgnEdge, FllEdge;
    assign RsgnEdge = (R0 && ~R1) ? 1'b1 : 1'b0,
           FllEdge  = (~R0 && R1) ? 1'b1 : 1'b0;

    wire leadigngEdge, trailingEdge;
    assign leadigngEdge = (~CPOL) ? RsgnEdge : FllEdge,
           trailingEdge = (~CPOL) ? FllEdge : RsgnEdge;

    assign ShiftEdge = (~CPHA) ? trailingEdge : leadigngEdge;
    assign SampleEdge = (CPHA) ? trailingEdge : leadigngEdge;

endmodule
