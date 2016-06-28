
/* description: Parses and executes english grammar sentences. */


%{

var hasName = function(oldSubject, newSubject){
    return oldSubject[Object.keys(newSubject)[0]];
};

var firstKey = function(old_name){
    return Object.keys(old_name)[0];
};

function addVerb(oldSubject, newSubject){
    if(hasName(oldSubject, newSubject)){
        var old_name = oldSubject[firstKey(newSubject)];
        var new_name = newSubject[firstKey(newSubject)];
        if(hasName(old_name, new_name)){
          old_name[firstKey(new_name)].push(new_name[firstKey(new_name)][0]);
        }
        else
            old_name[firstKey(new_name)] = new_name[firstKey(new_name)];
        return oldSubject;
    }
    oldSubject[firstKey(newSubject)] = newSubject[firstKey(newSubject)];
    return oldSubject;
};

%}


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
    { $$ = addVerb($1,$2); }
    | SENTENCE
      { $$ = $1; }
    ;

SENTENCE
    : NAME VERB_PHRASE OBJECT DOT
      {
        var subject = {};
        subject[$1]={};
        subject[$1][$2[0]] = [{ OBJECT: $3}];
        if ($2.length == 2)
          subject[$1][$2[0]][0]['ADVERB'] = $2[1];
        $$ = subject;
      }
    ;

VERB_PHRASE : VERB { $$ = [$1] } | ADVERB VERB { $$ = [$2,$1] };

OBJECT : THING | NAME ;
