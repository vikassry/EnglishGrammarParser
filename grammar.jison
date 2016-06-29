
/* description: Parses and executes english grammar sentences. */


/* lexical grammar */
%lex
%%

\s+                                             /* skip whitespace */
ram|sita                                        return 'NAME'
likes|hates                                     return 'VERB'
also                                            return 'ADVERB'
tea|coffee|butter|cheese|biscuits               return 'THING'
<<EOF>>                                         return 'EOF'
'.'                                             return 'DOT'

/lex

%start expressions

%%

/* language grammar */

expressions
    : e EOF { return $$; };

e
    : e SENTENCE
    {
      var addChoice = require('./treeConstructor.js')
      $$ = addChoice($1,$2);
    }

    | SENTENCE
    { $$ = $1; }
    ;

SENTENCE
    : NAME VERB_PHRASE OBJECT DOT
      {
        var subject = {};
        subject[$1]={};
        subject[$1][$2[0]] = [ {CHOICE: $3} ];
        ($2.length == 2) && (subject[$1][$2[0]][0].ADVERB = $2[1]);
        $$ = subject;
      };


VERB_PHRASE
    : VERB { $$ = [$1] } | ADVERB VERB { $$ = [$2,$1] };

OBJECT : THING | NAME ;
