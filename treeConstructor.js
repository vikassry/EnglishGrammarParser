var hasName = function(oldSubject, newSubject){
    return oldSubject[Object.keys(newSubject)[0]];
};

var firstKey = function(old_name){
    return Object.keys(old_name)[0];
};

var addChoice = function (oldSubject, newSubject){
    if(hasName(oldSubject, newSubject)){
        var old_name = oldSubject[firstKey(newSubject)];
        var new_name = newSubject[firstKey(newSubject)];
        if(hasName(old_name, new_name))
            old_name[firstKey(new_name)].push(new_name[firstKey(new_name)][0]);
        else
            old_name[firstKey(new_name)] = new_name[firstKey(new_name)];
        return oldSubject;
    }
    oldSubject[firstKey(newSubject)] = newSubject[firstKey(newSubject)];
    return oldSubject;
};

module.exports = addChoice;
