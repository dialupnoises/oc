var fs       = require('fs'),
    DataView = require('buffer-dataview');

var HEADER_LUMPS = 64;

function parse(file)
{
	var data = fs.readFileSync(file);
	var view = new DataView(data);
	var counter = 0;
	if(view.getUint32(counter, true) != 0x50534256)
	{
		console.log('invalid file');
		process.exit(1);
	}
	counter += 4;
	// skip BSP version
	counter += 4;

	var lumps = [];
	for(var i = 0; i < HEADER_LUMPS; i++)
	{
		var lump = {};
		lump.offset = view.getUint32(counter, true);
		counter += 4;
		lump.length = view.getUint32(counter, true);
		counter += 4;
		lump.version = view.getUint32(counter, true);
		counter += 4;
		var str = '';
		for(var j = 0; j < 4; j++)
		{
			str += String.fromCharCode(view.getUint8(counter + j, true));
		}
		lump.type = str;
		counter += 4;
		lumps.push(lump);
	}

	// jump to entities
	counter = lumps[0].offset;
	var text = "";
	for(var i = 0; i < lumps[0].length; i++)
	{
		text += String.fromCharCode(view.getUint8(counter + i, true));
	}
	var firstEnt = text.substr(0, text.indexOf('}')).substr(text.indexOf('{') + 1).trim();
	var info = {};
	firstEnt.split("\n").forEach(function(line) {
		var parts = line.split(" ");
		var key = parts[0].substr(1).substr(0, parts[0].length - 2);
		var value = parts[1].substr(1).substr(0, parts[1].length - 2);
		info[key] = value;
	});
	return info;
}

module.exports = parse;