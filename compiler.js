var parser = require('./grammar.js').parser;
var fs = require('fs');


var inputText = fs.readFileSync('./test_data').toString();
var parsedTree = parser.parse(inputText);

var getObjectNames = function(array){
    return array.map(function(element){
        return element.OBJECT;
    });
}

var makePhrase = function(array, index){
    if(array.length <= 2) return getObjectNames(array).join(' and ');
    return array[index].OBJECT +', '+ makePhrase(array.slice(index+1), index);
};

var makeSentences = function(AST){
    return  Object.keys(AST).map(function(name){
      return Object.keys(AST[name]).map(function(verb){
        validateAdverb(name, verb, AST[name][verb]);
        return name +' '+ verb +' '+ makePhrase(AST[name][verb], 0);
      }).join('. ');
    }).join('\n');
};

var validateAdverb = function(name, verb, objects){
  var also = objects[0]['ADVERB'];
    if (also)
        throw "SEMANTIC ERROR\n" +
        [name, also, verb, objects[0]['OBJECT'],
        '<-', also, 'appeared before context.'].join(' ');
};

console.log(makeSentences(parsedTree));
