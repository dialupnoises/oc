-- Runs one test file for test_harness.lua, which reads this process's stdout.
-- Each result goes out as "<nonce> PASS|FAIL <name>". The nonce is read and its file deleted
-- before test code loads, and everything test code could use to read it back (debug, ffi,
-- jit.util, C modules, bytecode) is removed, so a test cannot forge a result line.
local root, interpreter, testPath, nonceFile = ...

local nonceHandle = assert(io.open(nonceFile, "rb"))
local nonce = nonceHandle:read("*a")
nonceHandle:close()
os.remove(nonceFile)
arg = nil

local EXIT_LOAD_FAILED = 1

local error, pcall, xpcall, tostring = error, pcall, xpcall, tostring
local format = string.format
local traceback = debug.traceback
local rawLoad, rawLoadFile = load, loadfile
local exit = os.exit
local stdout, stderr = io.stdout, io.stderr
local write, flush = stdout.write, stdout.flush

local function textOnlyLoad(chunk, name, _, env)
	return rawLoad(chunk, name, "t", env)
end

local function textOnlyLoadFile(path, _, env)
	return rawLoadFile(path, "t", env)
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
loadstring = function(source, name)
	return textOnlyLoad(source, name)
end
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
	-- The leading newline keeps a test's unterminated output from swallowing the nonce.
	write(stdout, "\n", nonce, " ", status, " ", name, "\n")
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

local loaded, registerTrace = xpcall(chunk, withTrace, T)
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
