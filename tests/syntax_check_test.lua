local T = ...

local EXIT_PASSED = 0
local EXIT_FAILED = 1
local FOOTER = "^%d+ of %d+ files parsed"

local function shellQuote(text)
	return "'" .. text:gsub("'", "'\\''") .. "'"
end

local function runCheck(arguments)
	local command = string.format(
		"cd %s && %s tools/check_syntax.lua %s 2>&1; echo \"exit=$?\"",
		shellQuote(T.Root), shellQuote(T.Interpreter), arguments
	)
	local handle = io.popen(command)
	local output = handle:read("*a")
	handle:close()

	local footer
	for line in output:gmatch("[^\n]+") do
		if line:match(FOOTER) then
			footer = line
		end
	end

	return {
		output = output,
		footer = footer,
		exitCode = tonumber(output:match("exit=(%d+)%s*$")),
	}
end

local function contains(text, part)
	return text:find(part, 1, true) ~= nil
end

T.Test("passes a folder of valid Lua, nested folders included", function()
	local run = runCheck("tests/fixtures/valid")

	T.Equal(run.footer, "2 of 2 files parsed", run.output)
	T.Equal(run.exitCode, EXIT_PASSED, run.output)
end)

T.Test("rejects GMod-only syntax with the file and line", function()
	local run = runCheck("tests/fixtures/broken/gmod_comment.lua")

	T.Equal(run.footer, "0 of 1 files parsed", run.output)
	T.True(contains(run.output, "tests/fixtures/broken/gmod_comment.lua:1:"), run.output)
	T.Equal(run.exitCode, EXIT_FAILED, run.output)
end)

T.Test("checks every file after a broken one", function()
	local run = runCheck("tests/fixtures/broken tests/fixtures/valid")

	T.True(contains(run.output, "gmod_comment.lua:1:"), run.output)
	T.True(contains(run.output, "broken_test.lua:"), run.output)
	T.Equal(run.footer, "2 of 4 files parsed", run.output)
end)

T.Test("fails on a path that does not exist", function()
	local run = runCheck("tests/fixtures/missing")

	T.True(contains(run.output, "tests/fixtures/missing"), run.output)
	T.Equal(run.exitCode, EXIT_FAILED, run.output)
end)
