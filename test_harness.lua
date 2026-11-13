-- The release gate for Scripted NextBots (SNB) and everything else in this gamemode.
-- Usage: lua5.1 test_harness.lua (or luajit) [folder]
--
-- SNB is the flagship of this codebase: the AI library server communities are built on, and
-- the reason those servers can run classic Obsidian Conflict maps with modern NextBots. A
-- pathfinding regression does not stay on a dev box; it ships to every server at once and
-- shows up as actors stuck on doors in front of players. Nothing merges unless this file
-- prints "N of N tests passed" and exits 0.
--
-- A suite is any tests/*_test.lua. It receives the test API as its chunk argument:
--
--   local T = ...
--   T.Test("finds a path around a closed door", function()
--       T.Equal(actual, expected)
--   end)
--
-- T.Equal, T.True and T.Raises are the assertions. The footer lists every suite that ran with
-- its own count. An optional tests/expected_counts.lua sets the fewest tests a suite must have.
-- Garry's Mod runs LuaJIT, which speaks Lua 5.1, so run this with lua5.1 or luajit.

local EXPECTED_COUNTS_FILE = "expected_counts.lua"
local EXIT_PASSED = 0
local EXIT_FAILED = 1
local TOKEN_BYTES = 16
local RULE_WIDTH = 60

if _VERSION ~= "Lua 5.1" then
	io.stderr:write(arg[0], " needs Lua 5.1 or LuaJIT, the Lua that Garry's Mod runs; this is ", _VERSION, "\n")
	os.exit(EXIT_FAILED)
end

local DECLARED_TEST = "T%.Test%(%s*\"([^\"]+)\""
local TEST_FILE = "_test%.lua$"
local RESULT_LINE = "^(%u+) (.+)$"

local function scriptRoot()
	return arg[0]:match("^(.*)/[^/]*$") or "."
end

local function interpreterName()
	local index = -1
	while arg[index - 1] ~= nil do
		index = index - 1
	end

	return arg[index]
end

local function shellQuote(text)
	return "'" .. text:gsub("'", "'\\''") .. "'"
end

local function readFile(path)
	local handle = assert(io.open(path, "rb"))
	local contents = handle:read("*a")
	handle:close()
	return contents
end

local function newRunTokenFile()
	local random = assert(io.open("/dev/urandom", "rb"))
	local bytes = random:read(TOKEN_BYTES)
	random:close()

	local runToken = bytes:gsub(".", function(byte)
		return string.format("%02x", byte:byte())
	end)
	local path = os.tmpname()
	local handle = assert(io.open(path, "wb"))
	handle:write(runToken)
	handle:close()

	return runToken, path
end

local function listTestFiles(folder)
	local listing = io.popen("ls -1 " .. shellQuote(folder))
	local files = {}
	for name in listing:lines() do
		if name:match(TEST_FILE) then
			files[#files + 1] = name
		end
	end
	listing:close()
	table.sort(files)

	return files
end

local function declaredTests(source)
	local names = {}
	for name in source:gmatch(DECLARED_TEST) do
		names[#names + 1] = name
	end

	return names
end

local function runFile(root, interpreter, path, label)
	local runToken, tokenFile = newRunTokenFile()
	local command = table.concat({
		shellQuote(interpreter),
		shellQuote(root .. "/tests/harness/child.lua"),
		shellQuote(root),
		shellQuote(interpreter),
		shellQuote(path),
		shellQuote(tokenFile),
	}, " ")

	local results = {}
	local child = io.popen(command)
	for line in child:lines() do
		local status, name
		if line:sub(1, #runToken + 1) == runToken .. " " then
			status, name = line:sub(#runToken + 2):match(RESULT_LINE)
		end

		if name ~= nil then
			results[name] = results[name] == nil and status or "FAIL"
			print(string.format("%s %s > %s", status, label, name))
		elseif line ~= "" then
			print("| " .. line)
		end
	end
	child:close()
	os.remove(tokenFile)

	return results
end

local function expectedCounts(folder)
	local path = folder .. "/" .. EXPECTED_COUNTS_FILE
	local handle = io.open(path, "rb")
	if handle == nil then
		return {}
	end

	local source = handle:read("*a")
	handle:close()
	return assert(loadstring(source, "@" .. path))()
end

local function suiteFiles(folder, expected)
	local files = listTestFiles(folder)
	local listed = {}
	for _, file in ipairs(files) do
		listed[file] = true
	end

	for file in pairs(expected) do
		if listed[file] == nil then
			files[#files + 1] = file
		end
	end
	table.sort(files)

	return files
end

local root = scriptRoot()
local interpreter = interpreterName()
local folder = arg[1] or root .. "/tests"

local passed, total = 0, 0
local failures = {}
local suites = {}
local expected = expectedCounts(folder)

for _, file in ipairs(suiteFiles(folder, expected)) do
	local path = folder .. "/" .. file
	local present = io.open(path, "rb")
	local declared = {}
	local results = {}

	if present ~= nil then
		present:close()
		declared = declaredTests(readFile(path))
		results = runFile(root, interpreter, path, file)
	end

	local passedBefore, totalBefore = passed, total
	local missing = (expected[file] or 0) - #declared
	if missing > 0 then
		local label = string.format("%s > %d of %d expected tests missing", file, missing, expected[file])
		total = total + missing
		failures[#failures + 1] = label
		print("FAIL " .. label)
	end

	for _, name in ipairs(declared) do
		total = total + 1
		local status = results[name]

		if status == "PASS" then
			passed = passed + 1
		else
			failures[#failures + 1] = file .. " > " .. name
			if status == nil then
				print(string.format("FAIL %s > %s (no result: the file stopped before reporting it)", file, name))
			end
		end
	end

	suites[#suites + 1] = string.format("  %s: %d of %d passed", file, passed - passedBefore, total - totalBefore)
end

print(string.rep("-", RULE_WIDTH))
print(string.format("Suites run: %d", #suites))
for _, suite in ipairs(suites) do
	print(suite)
end
print(string.format("%d of %d tests passed", passed, total))
for _, failure in ipairs(failures) do
	print("  failed: " .. failure)
end

os.exit((total > 0 and passed == total) and EXIT_PASSED or EXIT_FAILED)
