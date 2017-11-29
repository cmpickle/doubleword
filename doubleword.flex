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
		tape[cursor] = c;
	}
	private char getTape() {
		//msg("getTape() at " + cursor + " is: " + tape[cursor]);
		return tape[cursor];
	}
	private int left() {
		if (cursor == 0)
			return -1;
		else {
			cursor--;
			return 0;
		}
	}
	private void right() {
		int was = cursor;
		cursor++;
		//msg("right: cursor was " + was + " and now is " + cursor);
	}
	private void msg(String str) {
		System.out.println(str); 
		return;
	}
		
%}

%eof{
	//System.out.println("EOF!");
%eof}

%state START S2 S3 S4 FAILURE
%%
<YYINITIAL> {
	[^\r\n]+ { 
		/* msg("tape length: " + tape.length); */
		original = yytext();
		java.util.Arrays.fill(tape, '\0');
		for (int i = 0; i < original.length(); i++) {
			tape[i] = original.charAt(i);
		}
		/* msg("tape length now: " + tape.length); */
		String outStr = new String(tape);
		/* msg(outStr); */
		cursor = 0;	
		yybegin(START);
	}
	[^] {
		//System.out.println("YYINITIAL Fallthrough!"); 
		yybegin(FAILURE);
	}
}

<START> {
	[\r\n]+ {
		//msg("START");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'a': 
				right();
				yybegin(S2);
				break;
			case 'b':
				right();
				yybegin(S2);
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

<S2> {
	[\r\n]+ {
		//msg("S2");
		yypushback(yytext().length());
		switch (getTape()) {
			case 'a': 
				yybegin(FAILURE);
				break;
			case 'b':
				right();
				yybegin(S3);
				break;
			case 0:
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
		//msg("S3");
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
		//msg("S4");
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

