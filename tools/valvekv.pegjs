File = struct:Structure* {
    var o = {};
    struct.forEach(function(s) {
        Object.keys(s).forEach(function(k) {
            o[k] = s[k];
        });
    });
    return o;
}

Structure = name:MaybeQuoted Whitespace content:StructureContent Whitespace* { 
    var o = {}; 
    o[name] = content; 
    return o; 
}
EmptyStructure = "{" Whitespace* "}" { return {}; }
StructureContent = "{" lines:StructureLine* "}" { 
    var obj = {};
    lines.filter(function(l) { 
        return l; 
    }).forEach(function(l) {
        obj[l[0]] = l[1];
    });
    return obj;
}
StructureLine = Whitespace+ line:CommentOrLine? { return line; }
CommentOrLine = "//" [^\n]+ { return null; } / line:Line
Line = key:MaybeQuoted Whitespace* value:LineValue { 
    return [key,value];
}
LineValue = Quoted / EmptyStructure / StructureContent
MaybeQuoted = "\""? val:Value "\""? { return val }
Quoted = "\"" val:Value "\"" { return val }
Whitespace = [ \n\t\r]+
Value = chars:[A-Za-z0-9\-\_/ \.,*)(!@#$%^&*\\>\+\:\'\?\uFFFD]* { return chars.join(''); }