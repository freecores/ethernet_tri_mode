//////////////////////////////////////////////////////////////////////
////                                                              ////
////  MAC_rx_add_chk.v                                            ////
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

module MAC_rx_add_chk (     
Reset				,                                
Clk	                ,                                
Init	            ,                                
data	            ,                                
MAC_add_en	        ,                                
MAC_rx_add_chk_err	,                                
//From CPU                                         
MAC_rx_add_chk_en	,	                             
MAC_add_prom_data	,		
MAC_add_prom_add	,    	
MAC_add_prom_wr		    	

);
input		Reset				;
input		Clk	                ;
input		Init	            ;
input[7:0]	data	            ;
input		MAC_add_en	        ;
output		MAC_rx_add_chk_err	;
			//From CPU
input		MAC_rx_add_chk_en	;	
input[7:0]	MAC_add_prom_data	;	
input[2:0]	MAC_add_prom_add	;   
input		MAC_add_prom_wr		;   

//******************************************************************************   
//internal signals                                                              
//******************************************************************************
reg[2:0]	addra;
wire[2:0] 	addrb;
wire[7:0] 	dinb;
wire[7:0] 	douta;
wire 		web;

reg			MAC_rx_add_chk_err;
reg			MAC_add_prom_wr_dl1;
reg			MAC_add_prom_wr_dl2;
//******************************************************************************   
//write data from cpu to prom                                                              
//******************************************************************************
always @ (posedge Clk or posedge Reset)
	if (Reset)
		begin
		MAC_add_prom_wr_dl1		<=0;
		MAC_add_prom_wr_dl2		<=0;
		end
	else
		begin
		MAC_add_prom_wr_dl1		<=MAC_add_prom_wr;
		MAC_add_prom_wr_dl2		<=MAC_add_prom_wr_dl1;
		end		
assign web		=MAC_add_prom_wr_dl1&!MAC_add_prom_wr_dl2;
assign addrb	=MAC_add_prom_add;
assign dinb		=MAC_add_prom_data;

//******************************************************************************   
//mac add verify                                                             
//******************************************************************************
always @ (posedge Clk or posedge Reset)
	if (Reset)
		addra		<=0;
	else if (Init)
		addra		<=0;
	else if (MAC_add_en)
		addra		<=addra + 1;
		
always @ (posedge Clk or posedge Reset)
	if (Reset)
		MAC_rx_add_chk_err	<=0;
	else if (Init)
		MAC_rx_add_chk_err	<=0;
	else if (MAC_rx_add_chk_en&&MAC_add_en&&douta!=data)
		MAC_rx_add_chk_err	<=1;
		

//******************************************************************************   
//a port for read ,b port for write .
//******************************************************************************     
duram #(8,3,"M512","DUAL_PORT") U_duram(
.data_a     	(dinb		),
.wren_a         (web        ),
.address_a      (addra      ),
.address_b      (addrb      ),
.clock_a        (Clk        ),
.clock_b        (Clk        ),
.q_b            (douta      ));

endmodule
