//////////////////////////////////////////////////////////////////////
////                                                              ////
////  tb_top.v                                                   ////
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

module tb_top (
);
//******************************************************************************
//internal signals                                                              
//******************************************************************************
				//system signals
input			Reset					,
input			Clk_125M				,
input			Clk_user				,
input			Clk_reg					,
				//user interface 
output			Rx_mac_ra				,
input			Rx_mac_rd				,
output	[31:0]	Rx_mac_data				,
output	[1:0]	Rx_mac_BE				,
output			Rx_mac_pa				,
output			Rx_mac_sop				,
output			Rx_mac_eop				,
				//user interface 
output			Tx_mac_wa	        	,
input			Tx_mac_wr	        	,
input	[31:0]	Tx_mac_data	        	,
input 	[1:0]	Tx_mac_BE				,//big endian
input			Tx_mac_sop	        	,
input			Tx_mac_eop				,
				//Phy interface     	 
				//Phy interface			
output			Gtx_clk					,//used only in GMII mode
input			Rx_clk					,
input			Tx_clk					,//used only in MII mode
output			Tx_er					,
output			Tx_en					,
output	[7:0]	Txd						,
input			Rx_er					,
input			Rx_dv					,
input 	[7:0]	Rxd						,
input			Crs						,
input			Col						,
				//Tx host interface 
input	[4:0]	Tx_Hwmark				,
input	[4:0]	Tx_Lwmark				,	
input			pause_frame_send_en		,				
input	[15:0]	pause_quanta_set		,
input			MAC_tx_add_en			,				
input			FullDuplex         		,
input	[3:0]	MaxRetry	        	,
input	[5:0]	IFGset					,
input	[7:0]	MAC_tx_add_prom_data	,
input	[2:0]	MAC_tx_add_prom_add		,
input			MAC_tx_add_prom_wr		,
input			tx_pause_en				,
input			xoff_cpu	        	,
input			xon_cpu	            	,
				//Rx host interface 	
input			MAC_rx_add_chk_en		,	
input	[7:0]	MAC_rx_add_prom_data	,	
input	[2:0]	MAC_rx_add_prom_add		,   
input			MAC_rx_add_prom_wr		,   
input			broadcast_filter_en	    ,
input	[15:0]	broadcast_MAX	        ,				        
input			RX_APPEND_CRC			,
input			CRC_chk_en				,				
input	[5:0]	RX_IFG_SET	  			,
input	[15:0]	RX_MAX_LENGTH 			,//	1518
input	[6:0]	RX_MIN_LENGTH			,//	64
				//RMON host interface
input	[5:0]	CPU_rd_addr				,
input			CPU_rd_apply			,
output			CPU_rd_grant			,
output	[31:0]	CPU_rd_dout				,
				//Phy int host interface     
input			Line_loop_en			,
input	[2:0]	Speed					,
				//MII to CPU 
input   [7:0] 	Divider            		,// Divider for the host clock
input  	[15:0] 	CtrlData           		,// Control Data (to be written to the PHY reg.)
input   [4:0] 	Rgad               		,// Register Address (within the PHY)
input   [4:0] 	Fiad               		,// PHY Address
input         	NoPre              		,// No Preamble (no 32-bit preamble)
input         	WCtrlData          		,// Write Control Data operation
input         	RStat              		,// Read Status operation
input         	ScanStat           		,// Scan Status operation
output        	Busy               		,// Busy Signal
output        	LinkFail           		,// Link Integrity Signal
output        	Nvalid             		,// Invalid Status (qualifier for the valid scan result)
output 	[15:0] 	Prsd               		,// Read Status Data (data read from the PHY)
output        	WCtrlDataStart     		,// This signals resets the WCTRLDATA bit in the MIIM Command register
output        	RStatStart         		,// This signal resets the RSTAT BIT in the MIIM Command register
output        	UpdateMIIRX_DATAReg		,// Updates MII RX_DATA register with read data
				//MII interface signals
inout         	Mdio                	,// MII Management Data In
output        	Mdc                		,// MII Management Data Clock	

//******************************************************************************
//internal signals                                                              
//******************************************************************************

MAC_top U_MAC_top(
.//system signals     			(//system signals           ),
.Reset					        (Reset					    ),
.Clk_125M				        (Clk_125M				    ),
.Clk_user				        (Clk_user				    ),
.Clk_reg					    (Clk_reg					),
.//user interface               (//user interface           ),
.Rx_mac_ra				        (Rx_mac_ra				    ),
.Rx_mac_rd				        (Rx_mac_rd				    ),
.Rx_mac_data				    (Rx_mac_data				),
.Rx_mac_BE				        (Rx_mac_BE				    ),
.Rx_mac_pa				        (Rx_mac_pa				    ),
.Rx_mac_sop				        (Rx_mac_sop				    ),
.Rx_mac_eop				        (Rx_mac_eop				    ),
.//user interface               (//user interface           ),
.Tx_mac_wa	        	        (Tx_mac_wa	        	    ),
.Tx_mac_wr	        	        (Tx_mac_wr	        	    ),
.Tx_mac_data	        	    (Tx_mac_data	        	),
.Tx_mac_BE				        (Tx_mac_BE				    ),
.Tx_mac_sop	        	        (Tx_mac_sop	        	    ),
.Tx_mac_eop				        (Tx_mac_eop				    ),
.//Phy interface     	        (//Phy interface     	    ),
.//Phy interface			    (//Phy interface			),
.Gtx_clk					    (Gtx_clk					),
.Rx_clk					        (Rx_clk					    ),
.Tx_clk					        (Tx_clk					    ),
.Tx_er					        (Tx_er					    ),
.Tx_en					        (Tx_en					    ),
.Txd						    (Txd						),
.Rx_er					        (Rx_er					    ),
.Rx_dv					        (Rx_dv					    ),
.Rxd						    (Rxd						),
.Crs						    (Crs						),
.Col						    (Col						),
.//Tx host interface            (//Tx host interface        ),
.Tx_Hwmark				        (Tx_Hwmark				    ),
.Tx_Lwmark				        (Tx_Lwmark				    ),
.pause_frame_send_en		    (pause_frame_send_en		),
.pause_quanta_set		        (pause_quanta_set		    ),
.MAC_tx_add_en			        (MAC_tx_add_en			    ),
.FullDuplex         		    (FullDuplex         		),
.MaxRetry	        	        (MaxRetry	        	    ),
.IFGset					        (IFGset					    ),
.MAC_tx_add_prom_data	        (MAC_tx_add_prom_data	    ),
.MAC_tx_add_prom_add		    (MAC_tx_add_prom_add		),
.MAC_tx_add_prom_wr		        (MAC_tx_add_prom_wr		    ),
.tx_pause_en				    (tx_pause_en				),
.xoff_cpu	        	        (xoff_cpu	        	    ),
.xon_cpu	            	    (xon_cpu	            	),
.//Rx host interface 	        (//Rx host interface 	    ),
.MAC_rx_add_chk_en		        (MAC_rx_add_chk_en		    ),
.MAC_rx_add_prom_data	        (MAC_rx_add_prom_data	    ),
.MAC_rx_add_prom_add		    (MAC_rx_add_prom_add		),
.MAC_rx_add_prom_wr		        (MAC_rx_add_prom_wr		    ),
.broadcast_filter_en	        (broadcast_filter_en	    ),
.broadcast_MAX	                (broadcast_MAX	            ),
.RX_APPEND_CRC			        (RX_APPEND_CRC			    ),
.CRC_chk_en				        (CRC_chk_en				    ),
.RX_IFG_SET	  			        (RX_IFG_SET	  			    ),
.RX_MAX_LENGTH 			        (RX_MAX_LENGTH 			    ),
.RX_MIN_LENGTH			        (RX_MIN_LENGTH			    ),
.//RMON host interface          (//RMON host interface      ),
.CPU_rd_addr				    (CPU_rd_addr				),
.CPU_rd_apply			        (CPU_rd_apply			    ),
.CPU_rd_grant			        (CPU_rd_grant			    ),
.CPU_rd_dout				    (CPU_rd_dout				),
.//Phy int host interface       (//Phy int host interface   ),
.Line_loop_en			        (Line_loop_en			    ),
.Speed					        (Speed					    ),
.//MII to CPU                   (//MII to CPU               ),
.Divider            		    (Divider            		),
.CtrlData           		    (CtrlData           		),
.Rgad               		    (Rgad               		),
.Fiad               		    (Fiad               		),
.NoPre              		    (NoPre              		),
.WCtrlData          		    (WCtrlData          		),
.RStat              		    (RStat              		),
.ScanStat           		    (ScanStat           		),
.Busy               		    (Busy               		),
.LinkFail           		    (LinkFail           		),
.Nvalid             		    (Nvalid             		),
.Prsd               		    (Prsd               		),
.WCtrlDataStart     		    (WCtrlDataStart     		),
.RStatStart         		    (RStatStart         		),
.UpdateMIIRX_DATAReg		    (UpdateMIIRX_DATAReg		),
.//MII interface signals        (//MII interface signals    ),
.Mdio                	        (Mdio                	    ),
.Mdc                		    (Mdc                		)


);
endmodule
