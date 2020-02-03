`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
--	(c) Thao Nguyen and Rajesh Panicker
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vi) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/
module test_Wrapper #(
	   parameter N_LEDs_OUT	= 8,					
	   parameter N_DIPs		= 16,
	   parameter N_PBs		= 4 
	)
	(
	);
	
	// Signals for the Unit Under Test (UUT)
	reg  [N_DIPs-1:0] DIP = 0;		
	reg  [N_PBs-1:0] PB = 0;			
	wire [N_LEDs_OUT-1:0] LED_OUT;
	wire [6:0] LED_PC;			
	wire [31:0] SEVENSEGHEX;	
	wire [7:0] CONSOLE_OUT;
	reg  CONSOLE_OUT_ready = 0;
	wire CONSOLE_OUT_valid;
	reg  [7:0] CONSOLE_IN = 0;
	reg  CONSOLE_IN_valid = 0;
	wire CONSOLE_IN_ack;
	reg  RESET = 0;					
	reg  CLK_undiv = 0;				
	
	// Instantiate UUT
	Wrapper dut(DIP, PB, LED_OUT, LED_PC, SEVENSEGHEX, CONSOLE_OUT, CONSOLE_OUT_ready, CONSOLE_OUT_valid, CONSOLE_IN, CONSOLE_IN_valid, CONSOLE_IN_ack, RESET, CLK_undiv) ;
	
	// STIMULI
    initial
    begin
		RESET = 1; #10; RESET = 0; //hold reset state for 10 ns.
		// 1st set
		CONSOLE_OUT_ready = 1'h1; // ok to keep it high continously in the testbench. In reality, it will be high only if UART is ready to send a data to PC
        CONSOLE_IN = 8'h49;// '1'. Will be read and ignored by the processor
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
        CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "A";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 2nd set
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "B";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 3rd set
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "C";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 4th set
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "3";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "D";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 5th set
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "E";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 6th set
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "3";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "F";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 7th set
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "G";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 8th set
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "5";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "H";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 9th set
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "I";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 10th set
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "5";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "J";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105; 
        // 11th set
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "K";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 12th set
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "5";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "L";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;        
        // 13th set
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "M";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 14th set
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "5";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "N";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;        
        // 15th set
        CONSOLE_IN = "2";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "O";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        // 16th set
        CONSOLE_IN = "1";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = " ";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "5";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;
        CONSOLE_IN = "P";
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;
        #105;        
//        CONSOLE_IN = 8'h0D;// '\r'
//        CONSOLE_IN_valid = 1'h1;
//        wait(CONSOLE_IN_ack); // should print "Welcome to CG3207" following this.
//        wait(~CONSOLE_IN_ack);
//        CONSOLE_IN_valid = 1'h0;
        
//        // added by JY
//        #105;
//        CONSOLE_IN = 8'h33;// '3'
//        CONSOLE_IN_valid = 1'h1;
//        wait(CONSOLE_IN_ack);
//        wait(~CONSOLE_IN_ack);
//		CONSOLE_IN_valid = 1'h0;
//        #105;
//        CONSOLE_IN = 8'h20;// ' '
//        CONSOLE_IN_valid = 1'h1;
//        wait(CONSOLE_IN_ack);
//        wait(~CONSOLE_IN_ack);
//		CONSOLE_IN_valid = 1'h0;
//        #105;
//        CONSOLE_IN = 8'h34;// '4'
//        CONSOLE_IN_valid = 1'h1;
//        wait(CONSOLE_IN_ack);
//        wait(~CONSOLE_IN_ack);
//		CONSOLE_IN_valid = 1'h0;
//        #105;
//        CONSOLE_IN = 8'h4D;// 'M'
//        CONSOLE_IN_valid = 1'h1;
//        wait(CONSOLE_IN_ack);
//        wait(~CONSOLE_IN_ack);
//		CONSOLE_IN_valid = 1'h0;


		//insert rest of the stimuli here
        /*#105;
        CONSOLE_IN = "A";// 
        CONSOLE_IN_valid = 1'h1;
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
        CONSOLE_IN = "B";// 
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
        CONSOLE_IN = "Y";// 
        wait(CONSOLE_IN_ack);
        wait(~CONSOLE_IN_ack);
		CONSOLE_IN_valid = 1'h0;*/

    end
	
	// GENERATE CLOCK       
    always          
    begin
       #5 CLK_undiv = ~CLK_undiv ; // invert clk every 5 time units 
    end
    
endmodule