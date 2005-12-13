//////////////////////////////////////////////////////////////////////
////                                                              ////
////  duram.v                                                     ////
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
module duram(
data_a,
data_b,
wren_a,
wren_b,
address_a,
address_b,
clock_a,
clock_b,
q_a,
q_b);   //synthesis syn_black_box

parameter DATA_WIDTH 	= 32; 
parameter ADDR_WIDTH 	= 5;  
parameter BLK_RAM_TYPE  = "AUTO";
parameter DURAM_MODE	= "BIDIR_DUAL_PORT";
parameter ADDR_DEPTH 	= 2**ADDR_WIDTH;



input	[DATA_WIDTH -1:0]  	data_a;
input	  					wren_a;
input	[ADDR_WIDTH -1:0]  	address_a;
input	 					clock_a;
output	[DATA_WIDTH -1:0] 	q_a;
input	[DATA_WIDTH -1:0]  	data_b;
input	  					wren_b;
input	[ADDR_WIDTH -1:0]  	address_b;
input	  					clock_b;
output	[DATA_WIDTH -1:0] 	q_b;
 
 

altsyncram U_altsyncram (
.wren_a			(wren_a),
.wren_b			(wren_b),
.data_a			(data_a),
.data_b			(data_b),
.address_a		(address_a),
.address_b		(address_b),
.clock0			(clock_a),
.clock1			(clock_b),
.q_a			(q_a),
.q_b			(q_b),
// synopsys translate_off
.aclr0 (),
.aclr1 (),
.addressstall_a (),
.addressstall_b (),
.byteena_a (),
.byteena_b (),
.clocken0 (),
.clocken1 (),
.rden_b ()
// synopsys translate_on
);
	defparam
		U_altsyncram.intended_device_family = "Stratix",
		U_altsyncram.ram_block_type = BLK_RAM_TYPE,
		U_altsyncram.operation_mode = DURAM_MODE,
		U_altsyncram.width_a = DATA_WIDTH,
		U_altsyncram.widthad_a = ADDR_WIDTH,
//		U_altsyncram.numwords_a = 256,
		U_altsyncram.width_b = DATA_WIDTH,
		U_altsyncram.widthad_b = ADDR_WIDTH,
//		U_altsyncram.numwords_b = 256,
		U_altsyncram.lpm_type = "altsyncram",
		U_altsyncram.width_byteena_a = 1,
		U_altsyncram.width_byteena_b = 1,
		U_altsyncram.outdata_reg_a = "UNREGISTERED",
		U_altsyncram.outdata_aclr_a = "NONE",
		U_altsyncram.outdata_reg_b = "UNREGISTERED",
		U_altsyncram.indata_aclr_a = "NONE",
		U_altsyncram.wrcontrol_aclr_a = "NONE",
		U_altsyncram.address_aclr_a = "NONE",
		U_altsyncram.indata_reg_b = "CLOCK1",
		U_altsyncram.address_reg_b = "CLOCK1",
		U_altsyncram.wrcontrol_wraddress_reg_b = "CLOCK1",
		U_altsyncram.indata_aclr_b = "NONE",
		U_altsyncram.wrcontrol_aclr_b = "NONE",
		U_altsyncram.address_aclr_b = "NONE",
		U_altsyncram.outdata_aclr_b = "NONE",
		U_altsyncram.power_up_uninitialized = "FALSE";
 
endmodule 


