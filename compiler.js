var parser = require('./grammar.js').parser;
var fs = require('fs');
var _ = require('lodash');

var inputText = fs.readFileSync('./test_data').toString();
var parsedTree = parser.parse(inputText);

var getChoices = function(wordObjects){
    return wordObjects.map(function(word){
        return word.CHOICE;
    });
}

var makePhrase = function(words){
    if(words.length <= 2) return getChoices(words).join(' and ');
    return _.head(words).CHOICE +', '+ makePhrase(_.tail(words));
};

var checkSemanticsForAdverb = function(name, verb, objects){
  var also = objects[0]['ADVERB'];
  if (also)
      throw 'SEMANTIC ERROR\n' + [name, also, verb, objects[0].CHOICE,
      '<-', also, 'appeared before context.'].join(' ');
};

var makeSentences = function(AST){
    return  Object.keys(AST).map(function(name){
        return Object.keys(AST[name]).map(function(verb){
          checkSemanticsForAdverb(name, verb, AST[name][verb]);
          return name +' '+ verb +' '+ makePhrase(AST[name][verb], 0) + '.';
      }).join('\n');
    }).join('\n');
};


console.log(makeSentences(parsedTree));
