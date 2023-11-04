`timescale 1 ns / 100 ps

module alu_1_bit (A, B, CIN, LESS, AINV, BINV, Opr, RESULT, COUT, ADD_R);

input A, B, CIN, LESS, AINV, BINV;
input [1:0] Opr;
output RESULT, ADD_R, COUT;

reg RESULT, COUT, ADD_R;
         
always @(*) // same as   always @(A, B, Ainv, Binv, CIN, Opr, LESS) 
  
	  begin  : combinational_logic // named procedural block
	  // local declarations in the named procedural block
	  reg RESULT_AND, RESULT_OR, RESULT_ADD_SUB, RESULT_SLT;
	  reg Am, Bm; // Am is the A at the output of the mux controlled by AINV; Similarly Bm
  
		Am = AINV ? ~A : A;  	//  fill-in   ~A : A    or  A : ~A  
		Bm = BINV ? ~B : B;		//  fill-in   ~B : B    or  B : ~B 

		// fill-in the following lines using Am, Bm, CIN
		RESULT_AND = Am & Bm;
		RESULT_OR  = Am | Bm;
		ADD_R = Am ^ Bm ^ CIN;
		RESULT_ADD_SUB = ADD_R;
		RESULT_SLT = LESS;
		COUT   = (Am & CIN) | (Bm & CIN) | (Am & Bm); // (Am & Bm) | (CIN & (Am ^ Bm));
		
		case (Opr)
				0	: // 2'b00 Logical AND Function
				  begin
					RESULT = RESULT_AND; 
				  end
				1	: // 2'b01 Logical OR Function
				  begin
					RESULT = RESULT_OR; 
				  end 
				 2	: // 2'b10 Arithmatic addition or subtract depending on the value of BINV
					begin        
					 RESULT = RESULT_ADD_SUB;
					end
				 3	: // 2'b11 for the SLT A, B instruction ( if A < B, RESULT =1)
					begin
					 RESULT = RESULT_SLT;
					end
						
		  endcase
	   end 
endmodule
//-------------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module alu_4_bit (A, B, AINV, BNEG, Opr, RESULT, OVERFLOW, ZERO, COUT);

input [3:0] A, B;
input  AINV, BNEG;
input [1:0] Opr;

output[3:0] RESULT;
output OVERFLOW, ZERO, COUT;

//LOCAL SIGNALS;
wire COUT1, COUT2, COUT3, COUT4;
wire BINV, SET, LESS_0;
wire [3:0] ADD_R;

assign BINV = BNEG;
assign CIN = BNEG;
 
 
assign COUT = COUT4; // ^ BNEG;
assign OVERFLOW = COUT3 ^ COUT4; // fill-in this line
assign SET = ADD_R[3];
assign LESS_0 = OVERFLOW ? ~SET : SET; // fill-in this line
assign ZERO = 	~( RESULT[0] | RESULT[1] | RESULT[2] | RESULT[3] );  // correct this line !!!! *****





// instantiate the alu_1_bit. Follow the order carefully if you are using positional association (positional mapping)
// module alu_1_bit (A, B, CIN, LESS, AINV, BINV, Opr, RESULT, COUT, ADD_R);
alu_1_bit alu0 (A[0], B[0],   CIN, LESS_0, AINV, BINV, Opr, RESULT[0], COUT1, ADD_R[0]); // fill-in this line
alu_1_bit alu1 (A[1], B[1], COUT1,   1'b0, AINV, BINV, Opr, RESULT[1], COUT2, ADD_R[1]);
alu_1_bit alu2 (A[2], B[2], COUT2,   1'b0, AINV, BINV, Opr, RESULT[2], COUT3, ADD_R[2]);
alu_1_bit alu3 (A[3], B[3], COUT3,   1'b0, AINV, BINV, Opr, RESULT[3], COUT4, ADD_R[3]);
        
endmodule