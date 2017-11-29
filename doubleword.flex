/*
 *  doubleword.flex: a sample Turing Machine JFlex program that matches
 *		double words.
 *	
 *		From the TM diagram on page 455 of Introduction to Computer Theory,
 *		2nd edition.
 */

%%

%public
%class test
%standalone

%{ 
	char[] tape = new char[1024];
	String original;
	int cursor = 0;

	private void setTape(char c) {
		// msg("Tape set to " + c);
		tape[cursor] = c;
	}
	private char getTape() {
		// msg("getTape() at " + cursor + " is: " + tape[cursor]);
		return tape[cursor];
	}
	private int left() {
		if (cursor == 0) {
			// msg("Left is going to fail!");
			return -1;
		}
		else {
			// msg("Cursor moved left");
			cursor--;
			return 0;
		}
	}
	private void right() {
		int was = cursor;
		cursor++;
		// msg("right: cursor was " + was + " and now is " + cursor);
	}
	private void msg(String str) {
		System.out.println(str); 
		return;
	}
		
%}

%eof{
	//System.out.println("EOF!");
%eof}

%state START S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 HALT FAILURE
%%
<YYINITIAL> {
	[^\r\n]+ { 
		// msg("tape length: " + tape.length);
		original = yytext();
		java.util.Arrays.fill(tape, '\0');
		tape[0] = '#';
		for (int i = 0; i < original.length(); i++) {
			tape[i+1] = original.charAt(i);
		}
		// msg("tape length now: " + tape.length);
		String outStr = new String(tape);
		//  msg(outStr); 
		cursor = 0;	
		yybegin(START);
	}
	[^] {
		// System.out.println("YYINITIAL Fallthrough!"); 
		yybegin(FAILURE);
	}
}

<START> {
	[\r\n]+ {
		// msg("START");
		yypushback(yytext().length());
		switch (getTape()) {
			case '#': 
				right();
				yybegin(S1);
				break;
			case 'a':
				yybegin(FAILURE);
				break;
			case 'b':
				yybegin(FAILURE);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in START");
				yybegin(FAILURE);
				break;
		}
	}
	[^] {
		msg("START: FALLTHROUGH");
	}
}

<S1> {
	[\r\n]+ {
		// msg("S1");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'a': 
				setTape('A');
				right();
				yybegin(S2);
				break;
			case 'b':
				setTape('B');
				right();
				yybegin(S2);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S1");
				break;
		}
	}

	[^] {
		msg("S1: FALLTHROUGH");
	}
}

<S2> {
	[\r\n]+ {
		// msg("S2");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'a': 
				right();
				yybegin(S3);
				break;
			case 'b':
				right();
				yybegin(S3);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			case 'Y':
				yybegin(FAILURE);
				break;
			case 'X':
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S2");
				break;
		}
	}

	[^] {
		msg("S2: FALLTHROUGH");
	}
}
	
<S3> {
	[\r\n]+ {
		// msg("S3");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'a': 
				right();
				yybegin(S3);
				break;
			case 'b':
				right();
				yybegin(S3);
				break;
			case 'X':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S4);
				break;
			case 'Y':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S4);
				break;
			case 0:
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S4);
				break;
			default:
				msg("Catastrophic failure in S3");
				yybegin(FAILURE);
				break;
		}
	}
	[^] {
		msg("S3: FALLTHROUGH");
	}
}

<S4> {
	[\r\n]+ {
		// msg("S4");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'a': 
				setTape('X');
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S5);
				break;
			case 'b':
				setTape('Y');
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S5);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S4");
				break;
		}
	}

	[^] {
		msg("S4: FALLTHROUGH");
	}
}

<S5> {
	[\r\n]+ {
		// msg("S5");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'a': 
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S6);
				break;
			case 'b':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S6);
				break;
			case 'A':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S7);
				break;
			case 'B':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S7);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S5");
				break;
		}
	}

	[^] {
		msg("S5: FALLTHROUGH");
	}
}

<S6> {
	[\r\n]+ {
		// msg("S6");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'a': 
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S6);
				break;
			case 'b':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S6);
				break;
			case 'A':
				right();
				yybegin(S1);
				break;
			case 'B':
				right();
				yybegin(S1);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S6");
				break;
		}
	}

	[^] {
		msg("S6: FALLTHROUGH");
	}
}

<S7> {
	[\r\n]+ {
		// msg("S7");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'A':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S7);
				break;
			case 'B':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S7);
				break;
			case '#':
				right();
				yybegin(S8);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S7");
				break;
		}
	}

	[^] {
		msg("S7: FALLTHROUGH");
	}
}

<S8> {
	[\r\n]+ {
		// msg("S8");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'A':
				setTape('#');
				right();
				yybegin(S10);
				break;
			case 'B':
				setTape('#');
				right();
				yybegin(S9);
				break;
			case '*':
				right();
				yybegin(S13);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S8");
				break;
		}
	}

	[^] {
		msg("S8: FALLTHROUGH");
	}
}

<S9> {
	[\r\n]+ {
		// msg("S9");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'A':
				right();
				yybegin(S9);
				break;
			case 'B':
				right();
				yybegin(S9);
				break;
			case '*':
				right();
				yybegin(S9);
				break;
			case 'Y':
				setTape('*');
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S11);
				break;
			case 'X':
				yybegin(FAILURE);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S9");
				break;
		}
	}

	[^] {
		msg("S9: FALLTHROUGH");
	}
}

<S10> {
	[\r\n]+ {
		// msg("S10");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'A':
				right();
				yybegin(S10);
				break;
			case 'B':
				right();
				yybegin(S10);
				break;
			case '*':
				right();
				yybegin(S10);
				break;
			case 'X':
				setTape('*');
				if(left() != 0) {
					msg("left failure");
					yybegin(FAILURE);
				}
				yybegin(S12);
				break;
			case 'Y':
				yybegin(FAILURE);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S10");
				break;
		}
	}

	[^] {
		msg("S10: FALLTHROUGH");
	}
}

<S11> {
	[\r\n]+ {
		// msg("S11");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'A':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S11);
				break;
			case 'B':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S11);
				break;
			case '*':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S11);
				break;
			case '#':
				right();
				yybegin(S8);
				break;
			case 0:
				yybegin(FAILURE);
				break;
			default:
				msg("Catastrophic failure in S11");
				break;
		}
	}

	[^] {
		msg("S11: FALLTHROUGH");
	}
}

<S12> {
	[\r\n]+ {
		// msg("S12");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'A':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S12);
				break;
			case 'B':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S12);
				break;
			case '*':
				if(left() != 0) {
					yybegin(FAILURE);
				}
				yybegin(S12);
				break;
			case '#':
				right();
				yybegin(S8);
				break;
			// case 0:
			// 	yybegin(FAILURE);
			// 	break;
			default:
				msg("Catastrophic failure in S12");
				break;
		}
	}

	[^] {
		msg("S12: FALLTHROUGH");
	}
}

<S13> {
	[\r\n]+ {
		// msg("S13");
		yypushback(yytext().length());
		switch (getTape()) {
			case '*':
				right();
				yybegin(S13);
				break;
			case 0:
				right();
				yybegin(HALT);
				break;
			default:
				msg("Catastrophic failure in S13");
				break;
		}
	}

	[^] {
		msg("S13: FALLTHROUGH");
	}
}

<HALT> {
	[\r\n]+ {
		// msg("HALT");
		msg("SUCCESS with " + original);
		yybegin(YYINITIAL);
	}
}

<FAILURE> {
	[\r\n]+ {
		msg("FAILURE with " + original);
		yybegin(YYINITIAL);
	}
}

