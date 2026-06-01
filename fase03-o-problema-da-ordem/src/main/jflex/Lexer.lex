package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
   
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* Macros */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%

<YYINITIAL> {
   
    /* Espaços em branco */
    {WhiteSpace}    { /* Ignora */ }

    /* Palavras Reservadas */
    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* Pontuação */
    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }
    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    /* Operadores Relacionais e Atribuição */
    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "="             { return symbol(sym.ASSIGN); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }

    /* Operadores Matemáticos */
    "+"             { return symbol(sym.ADD_OP, yytext()); }
    "-"             { return symbol(sym.ADD_OP, yytext()); }
    "*"             { return symbol(sym.MUL_OP, yytext()); }
    "/"             { return symbol(sym.MUL_OP, yytext()); }
    "%"             { return symbol(sym.MUL_OP, yytext()); }

    /* Expressões Regulares (Macros) */
    {Identifier}    { return symbol(sym.ID, yytext()); }
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    /* Erros */
    {OversizedIdentifier} { throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext()); }
    .                     { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

<<EOF>>             { return symbol(sym.EOF, ""); }
