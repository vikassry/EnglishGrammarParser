var parser = require('./grammar.js').parser;
var fs = require('fs');


var inputText = fs.readFileSync('./test_data').toString();
var parsedTree = parser.parse(inputText);

var formatToString = function(array, index){
    if(array.length <= 2) return array.join(' and ');
    return array[index] +', '+ formatToString(array.slice(index+1));
};

var summerize = function(AST){
    return  Object.keys(AST).map(function(name){
        return Object.keys(AST[name]).map(function(verb){
            return name +' '+ verb +' '+ formatToString(AST[name][verb], 0);
        }).join('. ');
    }).join('\n');
};

console.log(summerize(parsedTree));
