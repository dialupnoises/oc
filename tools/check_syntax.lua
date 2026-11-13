-- Parses every .lua file as plain Lua 5.1/LuaJIT and reports the ones that do not compile.
-- GMod-only syntax (// and /* */ comments, !=, &&, ||, !) counts as an error.
-- Usage: luajit tools/check_syntax.lua [path ...]
-- With no paths it checks gamemode/, entities/ and tests/ from the repository root,
-- skipping the fixtures that are broken on purpose.

local EXIT_PASSED = 0
local EXIT_FAILED = 1
local RULE_WIDTH = 60

local DEFAULT_PATHS = {
	"gamemode",
	"entities",
	"tests",
}
local DEFAULT_SKIPPED_PREFIX = "tests/fixtures/broken/"

local function shellQuote(text)
	return "'" .. text:gsub("'", "'\\''") .. "'"
end

local function exists(path)
	return os.rename(path, path) == true
end

local function luaFilesUnder(base, path)
	local listing = io.popen(string.format(
		"cd %s && find %s -type f -name '*.lua'", shellQuote(base), shellQuote(path)
	))
	local files = {}
	for file in listing:lines() do
		files[#files + 1] = file
	end
	listing:close()
	table.sort(files)

	return files
end

local function parseError(base, file)
	local handle = assert(io.open(base .. "/" .. file, "rb"))
	local source = handle:read("*a")
	handle:close()

	local _, err = loadstring(source, "@" .. file)
	return err
end

local function repositoryRoot()
	local scriptFolder = arg[0]:match("^(.*)/[^/]*$") or "."
	return scriptFolder .. "/.."
end

local base, paths, skippedPrefix
if #arg == 0 then
	base, paths, skippedPrefix = repositoryRoot(), DEFAULT_PATHS, DEFAULT_SKIPPED_PREFIX
else
	base, paths = ".", arg
end

local parsed, total = 0, 0

for _, path in ipairs(paths) do
	if exists(base .. "/" .. path) == false then
		total = total + 1
		print("MISSING " .. path)
	end

	for _, file in ipairs(luaFilesUnder(base, path)) do
		local skipped = skippedPrefix ~= nil and file:sub(1, #skippedPrefix) == skippedPrefix
		if skipped == false then
			total = total + 1
			local err = parseError(base, file)

			if err == nil then
				parsed = parsed + 1
			else
				print("FAIL " .. err)
			end
		end
	end
end

print(string.rep("-", RULE_WIDTH))
print(string.format("%d of %d files parsed", parsed, total))

os.exit((total > 0 and parsed == total) and EXIT_PASSED or EXIT_FAILED)
