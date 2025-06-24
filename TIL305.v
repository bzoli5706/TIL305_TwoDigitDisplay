module TIL305(CLK,D1,D2,D3,D4,D5,ANODE,CATHODE);
input CLK;
output D1,D2,D3,D4,D5;
output  [4:0] ANODE;
output  [6:0] CATHODE;
reg scheduler = 0;
reg [24:0] counter = 0;
reg [2:0] row;
reg [2:0] scroll = 0;
reg [2:0] scr1 = 0;
reg [2:0] scr10 = 0;
reg [3:0] tens = 0;
reg [3:0] units = 0;


localparam ROMFILE = "5x7KarGen.rom";
//-- ROM memory
reg [6:0] rom [0:59];
initial begin
    if (ROMFILE) $readmemh(ROMFILE, rom);
end

always @ (posedge CLK) begin
  counter <= counter + 1;
  if (counter == 12000000/16) begin
    counter <= 0;
    scheduler <= ~scheduler;
    end
end


always @(posedge scheduler) begin
  scroll = scroll + 1;
  if (scroll < 6) begin
    scr1 = scroll;
    if (units == 9) scr10 = scr1;
  end
  if (scroll == 6) begin
    scr1 = 0;
    scr10 = 0;
    units = units + 1;
    if (units == 10) begin
      units = 0;
      tens = tens + 1;
      if (tens == 10) tens = 0;
    end
  end
end



always @ (posedge counter[13]) begin
        row = (row + 1) % 5;
        CATHODE[6:0] = ~((rom[tens*6+scr10+row]&(7'h70)) | (rom[units*6+row+scr1]&(7'h0f)));
        ANODE[4:0] = 1 << row;
end

// Onboard LEDs OFF
assign D1 = 0;
assign D2 = 0;
assign D3 = 0;
assign D4 = 0;
assign D5 = 0;

endmodule
 
