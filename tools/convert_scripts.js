var parser     = require('./valvekv.js'),
    fs         = require('fs'),    
    doT        = require('./doT'),
    parseMap   = require('./parse_maps');

doT.templateSettings.strip = false;

console.log('Obsidian Conflict Script Converter V1.0');

var templateData = fs.readFileSync('weapon_template.lua', 'utf8');
var template = doT.compile(templateData);

function parseKvFile(fileName)
{
	var data = fs.readFileSync(fileName, 'utf8').trim();
	data = 
		data
		.split('\n')
		.map(function(l) { 
			l = l.replace(/\{/g, ' { ').replace(/\}/g, ' } ');
			var commentIndex = l.indexOf('//');
			if(commentIndex == -1) return l;
			if(commentIndex > 0 && l[commentIndex - 1] == '"') return l;
			return l.substr(0, commentIndex);
		})
		.filter(function(l) {
			return l.trim().length > 0;
		})
		.join('\n');
	fs.writeFileSync('test.txt', data);
	if(data.trim().length == 0) return {};
	return parser.parse(data);
}

var soundsUsed = {};
function convertSound(name)
{
	if(!name) return;
	if(!sounds[name.toLowerCase()]) return null;
	var sound = sounds[name.toLowerCase()];
	soundsUsed[name] = sound;
	return sound.name;
}

function convertObjectToTable(obj)
{
	if(!obj || Object.keys(obj).length == 0)
		return '{}';
	var out = '{';
	Object.keys(obj).forEach(function(k) {
		var val = obj[k];
		if(typeof val == 'object')
			out += '["' + k + '"] = ' + convertObjectToTable(val) + ', ';
		else
			out += '["' + k + '"] = "' + val + '", ';
	});
	return out.substr(0, out.length - 2) + ' }';
}

console.log('Building sound list...');
var sounds = {};
var scripts = fs.readdirSync('../scripts');
scripts
	.filter(function(f) { return f.indexOf('game_sounds') == 0; })
	.forEach(function(f) {
		console.log(f);
		var tree = parseKvFile('../scripts/' + f);
		Object.keys(tree).forEach(function(k) {
			var wave = tree[k];
			wave.name = k;
			sounds[k.toLowerCase()] = wave;
		});
	});

console.log('Parsing weapons...');

var weaponScripts = fs.readdirSync('../scripts/customweapons')
	.filter(function(f) { 
		return f != 'README.txt' && f.split('.').reverse()[0] == 'txt'; 
	});

weaponScripts.forEach(function(f) {
	console.log(f);
	var tree = parseKvFile('../scripts/customweapons/' + f);
	Object.keys(tree).forEach(function(k) { global[k] = tree[k]; });
	global.convertSound = convertSound;
	filledTemplate = template();
	fs.writeFileSync('../entities/weapons/' + f.split('.')[0] + '.lua', filledTemplate);
});

fs.writeFileSync('../gamemode/weapon_sounds.lua', 
	'-- This file is auto-generated. DO NOT TOUCH!\n' +
	Object.keys(soundsUsed)
	.sort()
	.map(function(k) { 
		var s = soundsUsed[k];
		var wave = s.wave;
		if(!s.wave)
			if(s.rndwave)
				wave = s.rndwave[0];
			else
				return '';
		if(!wave) return '';
		wave = wave.replace(')', '').replace('^', '');
		var pitch = s.pitch;
		if(!pitch)
			pitch = 1;
		else if(s.pitch.indexOf(',') > -1)
			pitch = '{' + pitch + '}';
		return 'sound.Add({ name="' + s.name + '", channel=' + s.channel + ', pitch=' + pitch + ', volume=' + s.volume +
			', level = ' + (s.soundlevel || 'SNDLVL_NORM').replace(')', '') + ', sound = "' + wave + '" })'; 
	})
	.join('\n'));

console.log('Parsing map config...');

var mapConfig = fs.readdirSync('map_cfg').filter(function(f) {
	return f.substr(-10) == 'modify.txt';
});

var mapConfigs = {};

var mapConfigFile = 
	'-- This file is auto-generated. DO NOT TOUCH!\n' +
	'MapConfigs = {}\n';

mapConfig.forEach(function(f) {
	console.log(f);
	var tree = parseKvFile('./map_cfg/' + f);
	var mapName = Object.keys(tree)[0];
	var config = tree[mapName];
	var luaName = 'MapConfigs["' + mapName + '"]'
	mapConfigFile += luaName + ' = {}\n';
	mapConfigFile += luaName + '["spawn_items"] = ' + convertObjectToTable(config["SpawnItems"]) + '\n';
	mapConfigFile += luaName + '["add"] = ' + convertObjectToTable(config["Add"]) + '\n';
	mapConfigFile += luaName + '["remove"] = ' + convertObjectToTable(config["Remove"]) + '\n';
	var mapFile = 'C:/Program Files (x86)/Steam/steamapps/sourcemods/obsidian/maps/' + mapName + '.bsp';
	if(!fs.existsSync(mapFile))
		mapFile = 'maps/' + mapName + '.bsp';
	if(fs.existsSync(mapFile))
	{
		var info = parseMap(mapFile);
		mapConfigFile += luaName + '["teamplay"] = ' + (info.teamplay == 1 ? "true" : "false") + "\n";
		mapConfigFile += luaName + '["numlives"] = ' + (info.numlives || 0) + "\n"; 
	}
});

fs.writeFileSync('../gamemode/server/map_configs.lua', mapConfigFile);