//////////////////////////////////////////////////////////////////////
////                                                              ////
////  afifo.v                                                     ////
////                                                              ////
////  This file is part of the Ethernet IP core project           ////
////  http://www.opencores.org/projects.cgi/web/ethernet_tri_mode/////
////                                                              ////
////  Author(s):                                                  ////
////      - Jon Gao (gaojon@yahoo.com)                      	  ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2001 Authors                                   ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//                                                                    
// CVS Revision History                                               
//                                                                    
// $Log: not supported by cvs2svn $
module afifo(
din,
wr_en,
wr_clk,
rd_en,
rd_clk,
ainit,
dout,
full,
almost_full,
empty,
wr_count,
rd_count,
rd_ack,
wr_ack);  
    
//////////////////////////////////////////////////////
parameter 		DATA_WIDTH 			=32; 
parameter 		ADDR_WIDTH 			=5; 
parameter		COUNT_DATA_WIDTH 	=5;
parameter		ALMOST_FULL_DEPTH	=8;
parameter		BLK_RAM_TYPE		="M4K";
parameter		DUAL_PORT_TYPE		="DUAL_PORT";// DUAL_PORT=simple dual port or BIDIR_DUAL_PORT=true dual_port 
//////////////////////////////////////////////////////
input 	[DATA_WIDTH-1:0] 			din;
input 								wr_en;
input 								wr_clk;
input 								rd_en;
input 								rd_clk;
input 								ainit;
output 	[DATA_WIDTH-1:0] 			dout;
output 								full;
output 								almost_full;
output 								empty;
output 	[COUNT_DATA_WIDTH-1:0] 		wr_count /* synthesis syn_keep=1 */;
output 	[COUNT_DATA_WIDTH-1:0] 		rd_count /* synthesis syn_keep=1 */;
output 								rd_ack;
output 								wr_ack;
//////////////////////////////////////////////////////  
//local signals
////////////////////////////////////////////////////// 
reg		[ADDR_WIDTH-1:0] 			Add_wr;
reg		[ADDR_WIDTH-1:0] 			Add_wr_ungray;
reg		[ADDR_WIDTH-1:0] 			Add_wr_gray;
reg		[ADDR_WIDTH-1:0] 			Add_wr_gray_dl1;
    	                        	
reg		[ADDR_WIDTH-1:0] 			Add_rd;
wire	[ADDR_WIDTH-1:0] 			Add_rd_pluse;
reg		[ADDR_WIDTH-1:0] 			Add_rd_gray;
reg		[ADDR_WIDTH-1:0] 			Add_rd_gray_dl1;
reg		[ADDR_WIDTH-1:0] 			Add_rd_ungray;   
wire	[ADDR_WIDTH-1:0]			Add_wr_pluse;
integer								i;
reg 								full /* synthesis syn_keep=1 */;
reg 								empty;
wire	[ADDR_WIDTH-1:0] 			ff_used_wr;     
wire	[ADDR_WIDTH-1:0] 			ff_used_rd;
reg 								rd_ack;
reg 								rd_ack_tmp;
reg		 							almost_full;
wire 	[DATA_WIDTH-1:0] 			dout_tmp;

//////////////////////////////////////////////////////  
//Write clock domain
//////////////////////////////////////////////////////
assign wr_ack	   =0;	
assign ff_used_wr  =Add_wr-Add_rd_ungray;

assign wr_count	=ff_used_wr[ADDR_WIDTH-1:ADDR_WIDTH-COUNT_DATA_WIDTH];



	
always @ (posedge ainit or posedge wr_clk)
	if (ainit)
		Add_wr_gray			<=0;
	else 
		begin
		Add_wr_gray[ADDR_WIDTH-1]	<=Add_wr[ADDR_WIDTH-1];
		for (i=ADDR_WIDTH-2;i>=0;i=i-1)
		Add_wr_gray[i]			<=Add_wr[i+1]^Add_wr[i];
		end

//读地址进行反gray编码.

always @ (posedge wr_clk or posedge ainit)
	if (ainit)
		Add_rd_gray_dl1			<=0;
	else
		Add_rd_gray_dl1			<=Add_rd_gray;
					
always @ (posedge wr_clk or posedge ainit)
	if (ainit)
		Add_rd_ungray			=0;
	else
		begin
		Add_rd_ungray[ADDR_WIDTH-1]	=Add_rd_gray_dl1[ADDR_WIDTH-1];	
		for (i=ADDR_WIDTH-2;i>=0;i=i-1)
			Add_rd_ungray[i]	=Add_rd_ungray[i+1]^Add_rd_gray_dl1[i];	
		end

assign			Add_wr_pluse=Add_wr+1;


/*
always @ (Add_wr_pluse or Add_rd_ungray)
	if (Add_wr_pluse==Add_rd_ungray)
		full	=1;
	else
		full	=0;

*/
always @ (posedge wr_clk or posedge ainit)
	if (ainit)
		full	<=0;
	else if(Add_wr_pluse==Add_rd_ungray&&wr_en)
		full	<=1;
	else if(Add_wr!=Add_rd_ungray)
		full	<=0;
		
	
always @ (posedge wr_clk or posedge ainit)
	if (ainit)
		almost_full		<=0;
	else if (wr_count>=ALMOST_FULL_DEPTH)
		almost_full		<=1;
	else
		almost_full		<=0;
				
always @ (posedge wr_clk or posedge ainit)
	if (ainit)
		Add_wr	<=0;
	else if (wr_en&&!full)
		Add_wr	<=Add_wr +1;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
//******************************************************************************
//read clock domain
//******************************************************************************
always @ (posedge rd_clk or posedge ainit)
	if (ainit)
		rd_ack		<=0;
	else if (rd_en&&!empty)
		rd_ack		<=1;
	else
		rd_ack		<=0;



assign ff_used_rd  	=Add_wr_ungray-Add_rd;
assign rd_count		=ff_used_rd[ADDR_WIDTH-1:ADDR_WIDTH-COUNT_DATA_WIDTH];
assign Add_rd_pluse	=Add_rd+1;

		
always @ (posedge rd_clk or posedge ainit)
	if (ainit)
		Add_rd		<=0;
	else if (rd_en&&!empty)  //出EOP后就不读了。
		Add_rd		<=Add_rd + 1;

//读地址进行gray码变换.
always @ (posedge ainit or posedge rd_clk)
	if (ainit)
		Add_rd_gray			<=0;
	else 
		begin
		Add_rd_gray[ADDR_WIDTH-1]	<=Add_rd[ADDR_WIDTH-1];
		for (i=ADDR_WIDTH-2;i>=0;i=i-1)
		Add_rd_gray[i]			<=Add_rd[i+1]^Add_rd[i];
		end
/*		Add_rd_gray			<={	Add_rd[8],
								Add_rd[8]^Add_rd[7],
								Add_rd[7]^Add_rd[6],
								Add_rd[6]^Add_rd[5],
								Add_rd[5]^Add_rd[4],
								Add_rd[4]^Add_rd[3],
								Add_rd[3]^Add_rd[2],
								Add_rd[2]^Add_rd[1],
								Add_rd[1]^Add_rd[0]};
*/
//写地址进行反gray编码.

always @ (posedge rd_clk or posedge ainit)
	if (ainit)
		Add_wr_gray_dl1		<=0;
	else
		Add_wr_gray_dl1		<=Add_wr_gray;
			
always @ (posedge rd_clk or posedge ainit)
	if (ainit)
		Add_wr_ungray		=0;
	else	
		begin
		Add_wr_ungray[ADDR_WIDTH-1]	=Add_wr_gray_dl1[ADDR_WIDTH-1];	
		for (i=ADDR_WIDTH-2;i>=0;i=i-1)
			Add_wr_ungray[i]	=Add_wr_ungray[i+1]^Add_wr_gray_dl1[i];	
		end

/*		Add_wr_ungray   <={
		Add_wr_gray_dl1[8],
		Add_wr_gray_dl1[8]^Add_wr_gray_dl1[7],
		Add_wr_gray_dl1[8]^Add_wr_gray_dl1[7]^Add_wr_gray_dl1[6],
		Add_wr_gray_dl1[8]^Add_wr_gray_dl1[7]^Add_wr_gray_dl1[6]^Add_wr_gray_dl1[5],
		Add_wr_gray_dl1[8]^Add_wr_gray_dl1[7]^Add_wr_gray_dl1[6]^Add_wr_gray_dl1[5]^Add_wr_gray_dl1[4],
		Add_wr_gray_dl1[8]^Add_wr_gray_dl1[7]^Add_wr_gray_dl1[6]^Add_wr_gray_dl1[5]^Add_wr_gray_dl1[4]^Add_wr_gray_dl1[3],
		Add_wr_gray_dl1[8]^Add_wr_gray_dl1[7]^Add_wr_gray_dl1[6]^Add_wr_gray_dl1[5]^Add_wr_gray_dl1[4]^Add_wr_gray_dl1[3]^Add_wr_gray_dl1[2],
		Add_wr_gray_dl1[8]^Add_wr_gray_dl1[7]^Add_wr_gray_dl1[6]^Add_wr_gray_dl1[5]^Add_wr_gray_dl1[4]^Add_wr_gray_dl1[3]^Add_wr_gray_dl1[2]^Add_wr_gray_dl1[1],
		Add_wr_gray_dl1[8]^Add_wr_gray_dl1[7]^Add_wr_gray_dl1[6]^Add_wr_gray_dl1[5]^Add_wr_gray_dl1[4]^Add_wr_gray_dl1[3]^Add_wr_gray_dl1[2]^Add_wr_gray_dl1[1]^Add_wr_gray_dl1[0] };
*/					
//empty信号产生	
/*	
always @ (Add_rd or Add_wr_ungray)
	if (Add_rd==Add_wr_ungray)
		empty	=1;
	else
		empty	=0;
*/
always @ (posedge rd_clk or posedge ainit)
	if (ainit)
		empty	<=1;
	else if (Add_rd_pluse==Add_wr_ungray&&rd_en)
		empty	<=1;	
	else if (Add_rd!=Add_wr_ungray)
		empty	<=0;

	
			
//////////////////////////////////////////////////////  
//instant need change for your own dpram
////////////////////////////////////////////////////// 
duram #(
DATA_WIDTH,
ADDR_WIDTH,
BLK_RAM_TYPE,
DUAL_PORT_TYPE) 
U_duram 		(
.data_a     (din       		),
.wren_a     (wr_en          ),
.address_a  (Add_wr         ),
.address_b  (Add_rd         ),
.clock_a    (wr_clk         ),
.clock_b    (rd_clk         ),
.q_b        (dout	       ));

endmodule