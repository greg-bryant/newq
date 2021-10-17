%{
/* newq.l - lexical definition for the new query language --
	basically relational queries with braces and some 
	specific keywords and conditions. See newq.y and pdq.c */

/* Greg Bryant, 1986. */

unsigned char newq_getc();
# define output(c)
# define input() (\
	(\
		(\
			yytchar=\
				yysptr>yysbuf?\
					U(*--yysptr)\
					:newq_getc()\
		)==10?\
		(yylineno++,yytchar)\
		:yytchar\
	)==(unsigned char)EOF?\
		0\
		:yytchar\
)
#define LMV 	yylval=strcpy(malloc(strlen(yytext)+1),yytext)

noshare int line = 1;	/* line count for tests with linefeeds */
noshare int desc_state = OFF;

%}

%%
[ \r\t]*	        ;
\n	                {line++;}
[0-9]*(\.[0-9]+)?[ \t\n]*[eE][ \t\n]*[+-]?[ \t\n]*[0-9]+  
	                {LMV; return NUMBER;}
[0-9]+\.[0-9]+	        {LMV; return NUMBER;}
[0-9]+\.	        {LMV; return NUMBER;}
\.[0-9]+	        {LMV; return NUMBER;}
[0-9]+		        {LMV; return NUMBER;}
[nN][oO][tT]	        {LMV; return NOT;}
[aA][nN][dD]	        {LMV; return AND;}
[oO][rR]	        {LMV; return OR;}
[wW][hH][eE][rR][eE]	{LMV; return WHERE;}
[bB][yY]	        {LMV; return BY;}
[sS][oO][rR][tT]	{LMV; return SORT;}
">="|"=>"	        {LMV; return GTE;}
"<="|"=<"	        {LMV; return LTE;}
"!="		        {LMV; return NEQ;}
"**"		        {LMV; return TO_THE;}
\"([^"]|\\\")*\" 	{LMV; return STRING;}
[_a-zA-Z][_a-zA-Z0-9]*	{LMV; return NAME;}
.		        {return yytext[0];}
%%

yywrap()
{
	return 1;
}
