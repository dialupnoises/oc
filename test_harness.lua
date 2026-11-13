-- Runs every *_test.lua in tests/ (or the folder given) and reports how many passed.
-- Usage: luajit test_harness.lua [folder]
--
-- The count belongs to this process, not to the tests. The total is every T.Test("literal name")
-- written in a test file, and a test passes only when its file's child process reports it
-- with a nonce the test code never sees. A test that exits early, forges output, or registers
-- under a computed name counts as failed.

local EXIT_PASSED = 0
local EXIT_FAILED = 1
local NONCE_BYTES = 16
local RULE_WIDTH = 60

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

local function newNonceFile()
	local random = assert(io.open("/dev/urandom", "rb"))
	local bytes = random:read(NONCE_BYTES)
	random:close()

	local nonce = bytes:gsub(".", function(byte)
		return string.format("%02x", byte:byte())
	end)
	local path = os.tmpname()
	local handle = assert(io.open(path, "wb"))
	handle:write(nonce)
	handle:close()

	return nonce, path
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
	local nonce, nonceFile = newNonceFile()
	local command = table.concat({
		shellQuote(interpreter),
		shellQuote(root .. "/tests/harness/child.lua"),
		shellQuote(root),
		shellQuote(interpreter),
		shellQuote(path),
		shellQuote(nonceFile),
	}, " ")

	local results = {}
	local child = io.popen(command)
	for line in child:lines() do
		local status, name
		if line:sub(1, #nonce + 1) == nonce .. " " then
			status, name = line:sub(#nonce + 2):match(RESULT_LINE)
		end

		if name ~= nil then
			results[name] = results[name] == nil and status or "FAIL"
			print(string.format("%s %s > %s", status, label, name))
		elseif line ~= "" then
			print("| " .. line)
		end
	end
	child:close()
	os.remove(nonceFile)

	return results
end

local root = scriptRoot()
local interpreter = interpreterName()
local folder = arg[1] or root .. "/tests"

local passed, total = 0, 0
local failures = {}

for _, file in ipairs(listTestFiles(folder)) do
	local path = folder .. "/" .. file
	local results = runFile(root, interpreter, path, file)

	for _, name in ipairs(declaredTests(readFile(path))) do
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
end

print(string.rep("-", RULE_WIDTH))
print(string.format("%d of %d tests passed", passed, total))
for _, failure in ipairs(failures) do
	print("  failed: " .. failure)
end

os.exit((total > 0 and passed == total) and EXIT_PASSED or EXIT_FAILED)
