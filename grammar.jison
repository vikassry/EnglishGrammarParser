
/* description: Parses and executes english grammar sentences. */


%{

var hasName = function(oldSubject, newSubject){
    return oldSubject[Object.keys(newSubject)[0]] != undefined;
}
var hasVerb = function(oldSubject, newSubject){
    var old_name = oldSubject[Object.keys(newSubject)[0]]
    var new_name = newSubject[Object.keys(newSubject)[0]]
    return old_name[Object.keys(new_name)[0]] != undefined;
}


function addVerb(oldSubject, newSubject){
  console.log(oldSubject, ' ------- ', newSubject);
    if(hasName(oldSubject, newSubject)){
        if(hasVerb(oldSubject, newSubject)){
          oldSubject['VERB'][newSubject.VERB].push(newSubject.VERB);
        }
        else{
          oldSubject.VERB[newSubject.VERB] = [newSubject.VERB];
        }
        return oldSubject;
    }
    oldSubject[newSubject.SUB] = {};
    oldSubject[newSubject.SUB]['VERB']= newSubject.VERB;
    return oldSubject;
  }
%}

/* lexical grammar */
%lex
%%

\s+                               /* skip whitespace */
ram|sita                                     return 'NOUN'
likes|hates                             return 'VERB'
tea|coffee|butter|cheese                return 'OBJECT'
<<EOF>>                                 return 'EOF'
'.'                                     return 'DOT'

/lex

%start expressions

%%

/* language grammar */

expressions
    : e EOF
        { return $$; }
    ;

e
    : e SENTENCE
      {
        $$ = addVerb($1,$2);
      }
    | SENTENCE
      {$$ = $1
      }
    ;

SENTENCE
    : SUBJECT VERB OBJECT DOT
      {
        var subject = {};
        subject[$1]={};
        subject[$1][$2] = $3;
        $$ = subject;
      }
    ;

SUBJECT : NOUN {

  };
