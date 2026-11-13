-- Runs one test suite for test_harness.lua. Suites get the environment shipped code gets in
-- Garry's Mod: no ffi, no C modules, no precompiled chunks and no debug library.
local root, interpreter, testPath, tokenFile = ...

local tokenHandle = assert(io.open(tokenFile, "rb"))
local runToken = tokenHandle:read("*a")
tokenHandle:close()
os.remove(tokenFile)
arg = nil

local EXIT_LOAD_FAILED = 1

-- Runs on Lua 5.1 as well as LuaJIT, so it uses neither xpcall arguments nor load modes.
local BYTECODE_SIGNATURE = "\27"

local assert, error, pcall, xpcall, tostring, type = assert, error, pcall, xpcall, tostring, type
local format = string.format
local concat = table.concat
local traceback = debug.traceback
local rawLoadString = loadstring
local open = io.open
local exit = os.exit
local stdout, stderr = io.stdout, io.stderr
local write, flush = stdout.write, stdout.flush

local function textOnlyLoadString(source, name)
	if source:sub(1, 1) == BYTECODE_SIGNATURE then
		return nil, "precompiled chunks are not allowed in tests"
	end

	return rawLoadString(source, name)
end

local function textOnlyLoad(chunk, name)
	if type(chunk) == "string" then
		return textOnlyLoadString(chunk, name)
	end

	local pieces = {}
	for piece in chunk do
		if piece == "" then break end
		pieces[#pieces + 1] = piece
	end

	return textOnlyLoadString(concat(pieces), name)
end

local function textOnlyLoadFile(path)
	local handle, err = open(path, "rb")
	if handle == nil then
		return nil, "cannot open " .. err
	end

	local source = handle:read("*a")
	handle:close()
	return textOnlyLoadString(source, "@" .. path)
end

local function searchProjectFile(name)
	local path = root .. "/" .. name:gsub("%.", "/") .. ".lua"
	local chunk, err = textOnlyLoadFile(path)
	if chunk == nil and err:find("cannot open", 1, true) then
		return "\n\tno file '" .. path .. "'"
	end

	return chunk or error(err, 0)
end

debug = nil
load = textOnlyLoad
loadfile = textOnlyLoadFile
loadstring = textOnlyLoadString
dofile = function(path)
	return assert(textOnlyLoadFile(path))()
end
package.loaded.debug = nil
package.loaded.ffi = nil
package.loaded["jit.util"] = nil
package.preload = {}
package.loadlib = nil
package.cpath = ""
package.path = ""
package.loaders = {
	searchProjectFile,
}

local function report(status, name)
	-- Starts on a fresh line so a test's unfinished output cannot run into the result.
	write(stdout, "\n", runToken, " ", status, " ", name, "\n")
	flush(stdout)
end

local function withTrace(err)
	return traceback(tostring(err), 2)
end

local function failLoad(trace)
	write(stderr, testPath, " did not load\n", trace, "\n")
	exit(EXIT_LOAD_FAILED)
end

local tests = {}
local T = {
	Root = root,
	Interpreter = interpreter,
}

function T.Test(name, fn)
	tests[#tests + 1] = {
		name = name,
		fn = fn,
	}
end

function T.Equal(actual, expected, label)
	if actual == expected then return end

	local message = format("expected %s, got %s", tostring(expected), tostring(actual))
	error(label and label .. ": " .. message or message, 2)
end

function T.True(value, label)
	if value == true then return end

	error(label or "expected true, got " .. tostring(value), 2)
end

function T.Raises(fn, label)
	if pcall(fn) == false then return end

	error(label or "expected an error", 2)
end

local chunk, loadError = textOnlyLoadFile(testPath)
if chunk == nil then
	failLoad(loadError)
end

local loaded, registerTrace = xpcall(function() return chunk(T) end, withTrace)
if loaded == false then
	failLoad(registerTrace)
end

for index = 1, #tests do
	local test = tests[index]
	local passed, trace = xpcall(test.fn, withTrace)

	if passed then
		report("PASS", test.name)
	else
		write(stderr, "FAIL ", test.name, "\n", trace, "\n")
		report("FAIL", test.name)
	end
end
