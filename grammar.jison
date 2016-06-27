
/* description: Parses and executes english grammar sentences. */


%{

var hasName = function(oldSubject, newSubject){
    return oldSubject[Object.keys(newSubject)[0]];
};

var first_key = function(old_name){
    return Object.keys(old_name)[0];
};

function addVerb(oldSubject, newSubject){
    if(hasName(oldSubject, newSubject)){
        var old_name = oldSubject[first_key(newSubject)];
        var new_name = newSubject[first_key(newSubject)];
        if(hasName(old_name, new_name))
            old_name[first_key(new_name)].push(new_name[first_key(new_name)][0]);
        else
            old_name[first_key(new_name)] = new_name[first_key(new_name)];
        return oldSubject;
    }
    oldSubject[first_key(newSubject)] = newSubject[first_key(newSubject)];
    return oldSubject;
};

%}


/* lexical grammar */
%lex
%%

\s+                               /* skip whitespace */
ram|sita                                        return 'NAME'
likes|hates                                     return 'VERB'
tea|coffee|butter|cheese|biscuits|sita          return 'THING'
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
    : NAME VERB OBJECT DOT
      {
        var subject = {};
        subject[$1]={};
        subject[$1][$2] = [$3];
        $$ = subject;
      }
    ;

OBJECT : THING | NAME ;
