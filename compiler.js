var parser = require('./grammar.js').parser;
var fs = require('fs');

var inputText = fs.readFileSync('./test_data').toString();
var parsedTree = parser.parse(inputText);

var getNames = function(wordObjects){
    return wordObjects.map(function(word){
        return word.OBJECT;
    });
}

var makePhrase = function(words, index){
    if(index >= words.length-2 && index<words.length)
      return getNames(words.slice(index)).join(' and ');
    return words[index].OBJECT +', '+ makePhrase(words, index+1);
};

var checkSemanticsForAdverb = function(name, verb, objects){
  var also = objects[0]['ADVERB'];
    if (also)
        throw "SEMANTIC ERROR\n" +
        [name, also, verb, objects[0]['OBJECT'],
        '<-', also, 'appeared before context.'].join(' ');
};

var makeSentences = function(AST){
    return  Object.keys(AST).map(function(name){
      return Object.keys(AST[name]).map(function(verb){
        checkSemanticsForAdverb(name, verb, AST[name][verb]);
        return name +' '+ verb +' '+ makePhrase(AST[name][verb], 0);
      }).join('\n');
    }).join('\n');
};


console.log(makeSentences(parsedTree));
