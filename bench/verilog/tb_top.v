`timescale 1 ns/100ps
//////////////////////////////////////////////////////////////////////
////                                                              ////
////  tb_top.v                                                    ////
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
// Revision 1.1.1.1  2005/12/13 01:51:44  Administrator
// no message
// 

module tb_top (
);
//******************************************************************************
//internal signals                                                              
//******************************************************************************
				//system signals
reg				Reset					;
reg				Clk_125M				;
reg				Clk_user				;
reg				Clk_reg					;
				//user interface 
wire			Rx_mac_ra				;
wire			Rx_mac_rd				;
wire	[31:0]	Rx_mac_data				;
wire	[1:0]	Rx_mac_BE				;
wire			Rx_mac_pa				;
wire			Rx_mac_sop				;
wire			Rx_mac_eop				;
				//user interface 
wire			Tx_mac_wa	        	;
wire			Tx_mac_wr	        	;
wire	[31:0]	Tx_mac_data	        	;
wire 	[1:0]	Tx_mac_BE				;//big endian
wire			Tx_mac_sop	        	;
wire			Tx_mac_eop				;
				//Phy interface     	 
				//Phy interface			
wire			Gtx_clk					;//used only in GMII mode
wire			Rx_clk					;
wire			Tx_clk					;//used only in MII mode
wire			Tx_er					;
wire			Tx_en					;
wire	[7:0]	Txd						;
wire			Rx_er					;
wire			Rx_dv					;
wire 	[7:0]	Rxd						;
wire			Crs						;
wire			Col						;
				//Tx host interface 
wire	[4:0]	Tx_Hwmark				;
wire	[4:0]	Tx_Lwmark				;	
wire			pause_frame_send_en		;				
wire	[15:0]	pause_quanta_set		;
wire			MAC_tx_add_en			;				
wire			FullDuplex         		;
wire	[3:0]	MaxRetry	        	;
wire	[5:0]	IFGset					;
wire	[7:0]	MAC_tx_add_prom_data	;
wire	[2:0]	MAC_tx_add_prom_add		;
wire			MAC_tx_add_prom_wr		;
wire			tx_pause_en				;
wire			xoff_cpu	        	;
wire			xon_cpu	            	;
				//Rx host interface 	
wire			MAC_rx_add_chk_en		;	
wire	[7:0]	MAC_rx_add_prom_data	;	
wire	[2:0]	MAC_rx_add_prom_add		;   
wire			MAC_rx_add_prom_wr		;   
wire			broadcast_filter_en	    ;
wire	[15:0]	broadcast_MAX	        ;				        
wire			RX_APPEND_CRC			;
wire			CRC_chk_en				;				
wire	[5:0]	RX_IFG_SET	  			;
wire	[15:0]	RX_MAX_LENGTH 			;//	1518
wire	[6:0]	RX_MIN_LENGTH			;//	64
				//RMON host interface
wire	[5:0]	CPU_rd_addr				;
wire			CPU_rd_apply			;
wire			CPU_rd_grant			;
wire	[31:0]	CPU_rd_dout				;
				//Phy int host interface     
wire			Line_loop_en			;
wire	[2:0]	Speed					;
				//MII to CPU 
wire   [7:0] 	Divider            		;// Divider for the host clock
wire  	[15:0] 	CtrlData           		;// Control Data (to be written to the PHY reg.)
wire   [4:0] 	Rgad               		;// Register Address (within the PHY)
wire   [4:0] 	Fiad               		;// PHY Address
wire         	NoPre              		;// No Preamble (no 32-bit preamble)
wire         	WCtrlData          		;// Write Control Data operation
wire         	RStat              		;// Read Status operation
wire         	ScanStat           		;// Scan Status operation
wire        	Busy               		;// Busy Signal
wire        	LinkFail           		;// Link Integrity Signal
wire        	Nvalid             		;// Invalid Status (qualifier for the valid scan result)
wire 	[15:0] 	Prsd               		;// Read Status Data (data read from the PHY)
wire        	WCtrlDataStart     		;// This signals resets the WCTRLDATA bit in the MIIM Command register
wire        	RStatStart         		;// This signal resets the RSTAT BIT in the MIIM Command register
wire        	UpdateMIIRX_DATAReg		;// Updates MII RX_DATA register with read data
				//MII interface signals
wire         	Mdio                	;// MII Management Data In
wire        	Mdc                		;// MII Management Data Clock	

//******************************************************************************
//internal signals                                                              
//******************************************************************************

initial 
	begin
			Reset	=1;
	#20		Reset	=0;
	end
always 
	begin
	#4		Clk_125M=0;
	#4		Clk_125M=1;
	end

always 
	begin
	#5		Clk_user=0;
	#5		Clk_user=1;
	end
	
always 
	begin
	#10		Clk_reg=0;
	#10		Clk_reg=1;
	end


initial	
	begin
	$shm_open("tb_top.shm",,900000000,);
	$shm_probe("AS");
	end


MAC_top U_MAC_top(
 //system signals     			(//system signals           ),
.Reset					        (Reset					    ),
.Clk_125M				        (Clk_125M				    ),
.Clk_user				        (Clk_user				    ),
.Clk_reg					    (Clk_reg					),
 //user interface               (//user interface           ),
.Rx_mac_ra				        (Rx_mac_ra				    ),
.Rx_mac_rd				        (Rx_mac_rd				    ),
.Rx_mac_data				    (Rx_mac_data				),
.Rx_mac_BE				        (Rx_mac_BE				    ),
.Rx_mac_pa				        (Rx_mac_pa				    ),
.Rx_mac_sop				        (Rx_mac_sop				    ),
.Rx_mac_eop				        (Rx_mac_eop				    ),
 //user interface               (//user interface           ),
.Tx_mac_wa	        	        (Tx_mac_wa	        	    ),
.Tx_mac_wr	        	        (Tx_mac_wr	        	    ),
.Tx_mac_data	        	    (Tx_mac_data	        	),
.Tx_mac_BE				        (Tx_mac_BE				    ),
.Tx_mac_sop	        	        (Tx_mac_sop	        	    ),
.Tx_mac_eop				        (Tx_mac_eop				    ),
 //Phy interface     	        (//Phy interface     	    ),
 //Phy interface			    (//Phy interface			),
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
 //Tx host interface            (//Tx host interface        ),
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
 //Rx host interface 	        (//Rx host interface 	    ),
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
 //RMON host interface          (//RMON host interface      ),
.CPU_rd_addr				    (CPU_rd_addr				),
.CPU_rd_apply			        (CPU_rd_apply			    ),
.CPU_rd_grant			        (CPU_rd_grant			    ),
.CPU_rd_dout				    (CPU_rd_dout				),
 //Phy int host interface       (//Phy int host interface   ),
.Line_loop_en			        (Line_loop_en			    ),
.Speed					        (Speed					    ),
 //MII to CPU                   (//MII to CPU               ),
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
 //MII interface signals        (//MII interface signals    ),
.Mdio                	        (Mdio                	    ),
.Mdc                		    (Mdc                		)
);

Phy_sim U_Phy_sim (
.Gtx_clk						(Gtx_clk		         	),
.Rx_clk		                    (Rx_clk		                ),
.Tx_clk		                    (Tx_clk		                ),
.Tx_er		                    (Tx_er		                ),
.Tx_en		                    (Tx_en		                ),
.Txd			                (Txd			            ),
.Rx_er		                    (Rx_er		                ),
.Rx_dv		                    (Rx_dv		                ),
.Rxd			                (Rxd			            ),
.Crs			                (Crs			            ),
.Col			                (Col			            ),
.Speed		                    (Speed		                )
);

User_int_sim U_User_int_sim( 
.Reset							(Reset						),
.Clk_user			            (Clk_user			        ),
 //user inputerface             (//user inputerface         ),
.Rx_mac_ra			            (Rx_mac_ra			        ),
.Rx_mac_rd			            (Rx_mac_rd			        ),
.Rx_mac_data			        (Rx_mac_data			    ),
.Rx_mac_BE			            (Rx_mac_BE			        ),
.Rx_mac_pa			            (Rx_mac_pa			        ),
.Rx_mac_sop			            (Rx_mac_sop			        ),
.Rx_mac_eop			            (Rx_mac_eop			        ),
 //user inputerface             (//user inputerface         ),
.Tx_mac_wa	                    (Tx_mac_wa	                ),
.Tx_mac_wr	                    (Tx_mac_wr	                ),
.Tx_mac_data	                (Tx_mac_data	            ),
.Tx_mac_BE			            (Tx_mac_BE			        ),
.Tx_mac_sop	                    (Tx_mac_sop	                ),
.Tx_mac_eop			            (Tx_mac_eop			        )
);

reg_int_sim U_reg_int_sim(
.Reset	               			(Reset	                  	),    
.Clk_reg                  		(Clk_reg                 	), 
 //Tx host interface            (//Tx host interface        ),
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
 //Rx host interface 	        (//Rx host interface 	    ),
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
 //RMON host interface          (//RMON host interface      ),
.CPU_rd_addr				    (CPU_rd_addr				),
.CPU_rd_apply			        (CPU_rd_apply			    ),
.CPU_rd_grant			        (CPU_rd_grant			    ),
.CPU_rd_dout				    (CPU_rd_dout				),
 //Phy int host interface       (//Phy int host interface   ),
.Line_loop_en			        (Line_loop_en			    ),
.Speed					        (Speed					    ),
 //MII to CPU                   (//MII to CPU               ),
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
.UpdateMIIRX_DATAReg		    (UpdateMIIRX_DATAReg		)
);
endmodule
