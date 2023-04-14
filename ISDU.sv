//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
									Reset,
									J_Press,
									K_Press,
				  
				// Need Standing still => punch1 => punch2 => punch3
				output logic        IDLE,
									PUNCH_1,
									PUNCH_2,
									PUNCH_3,
									HIT3_1,
									HIT3_2,
									HIT3_3,
									HIT3_4,
									CRJAB_1,
									CRJAB_2,
									CRJAB_3,
									KICK_1,
									KICK_2,
									KICK_3,
									UPCUT_1,
									UPCUT_2,
									FAIL_1,
									FAIL_2,
									FAIL_3
				);

	enum logic [4:0] {  Halted, 
						Idle, 
						P_1, 
						P_2, 
						P_3, 
						H3_1,
						H3_2,
						H3_3,
						H3_4,
						C_1,
						C_2,
						C_3,
						C_4,
						C_5,
						C_6,
						C_7,
						C_8,
						C_9,
						C_10,
						Hold
						}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		IDLE = 1'b0;	// Idle animation

		PUNCH_1 = 1'b0; // Full punch
		PUNCH_2 = 1'b0;	// Fist slightly back
		PUNCH_3 = 1'b0; // Fist almost all the way back

		HIT3_1 = 1'b0;	// Extends right punch
		HIT3_2 = 1'b0;	// Same punch without motion marks
		HIT3_3 = 1'b0;	// Pulls back punch
		HIT3_4 = 1'b0;	// Pulls back punch fully

		CRJAB_1 = 1'b0;	// First crouch
		CRJAB_2 = 1'b0;	// Next crouch
		CRJAB_3 = 1'b0; // Final crouch

		KICK_1 = 1'b0;	// Kick
		KICK_2 = 1'b0;	// Kick w/ motion
		KICK_3 = 1'b0;	// Kick w/ fist

		UPCUT_1 = 1'b0;	// Uppercut with motion
		UPCUT_2 = 1'b0;	// Uppercut without motion

		FAIL_1 = 1'b0;	// Slip
		FAIL_2 = 1'b0;	// Slip rotated
		FAIL_3 = 1'b0;	// Slip rotated again

		// Any states involving SRAM require more than one clock cycles.
		// Assign next state
		unique case (State)
			Halted : 
				if (J_Press & K_Press) 
					Next_state = C_1;
				else if(J_Press)
					Next_state = P_1;
				else
					Next_state = I_1;

			P_1 :
				Next_state = P_2;
			P_2 :
				Next_state = P_3;
			P_3 :
				Next_state = Hold;

			H3_1 :
				Next_state = H3_2;
			H3_2 :
				Next_state = H3_3;
			H3_3 :
				Next_state = H3_4;
			H3_4 :
				Next_state = Hold;

			C_1 :
				if(J_Press & K_Press)
					Next_state = C_2;
				// else
				// 	Next_state = FAIL_1;
			C_2 :
				if(J_Press & K_Press)
					Next_state = C_3;
				// else
				// 	Next_state = FAIL_1;
			C_3 :
				if(J_Press & K_Press)
					Next_state = C_4;
				// else
				// 	Next_state = FAIL_1;
			C_4 :
				if(J_Press & K_Press)
					Next_state = C_5;
				// else
				// 	Next_state = FAIL_1;
			C_5 :
				if(J_Press & K_Press)
					Next_state = C_6;
				// else
				// 	Next_state = FAIL_1;
			C_6 :
				if(J_Press & K_Press)
					Next_state = C_7;
				// else
				// 	Next_state = FAIL_1;
			C_7 :
				if(J_Press & K_Press)
					Next_state = C_8;
				else
					Next_state = FAIL_1;
			C_8 :
				if((J_Press & K_Press)) // Will need to be let go here
					Next_state = C_9;
				// else
				// 	Next_state = FAIL_1;
			C_9 :
				Next_state = C_10;
			C_10 :
				Next_state = Hold;

			I_1 :
				if (J_Press & K_Press) 
					Next_state = C_1;
				else if(J_Press)
					Next_state = P_1;
				else
					Next_state = Halted;

			Hold :
				if(J_Press || (J_Press & K_Press))
					Next_state = Hold;
				else
					Next_state = Halted;

			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: 
				IDLE = 1'b1;
			P_1 : 
				PUNCH_1 = 1'b1;
			P_2 : 
				PUNCH_2 = 1'b1;
			P_3 : 
				PUNCH_3 = 1'b1;

			H3_1 :
				HIT3_1 = 1'b1;
			H3_2 :
				HIT3_2 = 1'b1;
			H3_3 :
				HIT3_3 = 1'b1;
			H3_4 :
				HIT3_4 = 1'b1;

			C_1 : 
				PUNCH_1 = 1'b1;
			C_2 : 
				HIT3_1 = 1'b1;
			C_3 : 
				CRJAB_1 = 1'b1;
			C_4 : 
				KICK_1 = 1'b1;
			C_5 : 
				KICK_2 = 1'b1;
			C_6 : 
				KICK_3 = 1'b1;
			C_7 : 
				CRJAB_2 = 1'b1;
			C_8 : 
				CRJAB_3 = 1'b1;
			C_9 : 
				UPCUT_1 = 1'b1;
			C_10 : 
				UPCUT_2 = 1'b1;	
			Idle :
				IDLE = 1'b1;

			default : ;
		endcase
	end 

	
endmodule
