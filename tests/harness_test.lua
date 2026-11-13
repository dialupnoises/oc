local T = ...

local FOOTER = "^%d+ of %d+ tests passed"
local EXIT_PASSED = 0
local EXIT_FAILED = 1

local function shellQuote(text)
	return "'" .. text:gsub("'", "'\\''") .. "'"
end

local function runHarness(fixture)
	local command = string.format(
		"cd %s && %s test_harness.lua tests/fixtures/%s 2>&1; echo \"exit=$?\"",
		shellQuote(T.Root), shellQuote(T.Interpreter), fixture
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

T.Test("counts passes and failures across a suite", function()
	local run = runHarness("mixed")

	T.Equal(run.footer, "2 of 3 tests passed", run.output)
	T.Equal(run.exitCode, EXIT_FAILED, run.output)
end)

T.Test("names the failing test and prints its stack trace", function()
	local run = runHarness("mixed")

	T.True(contains(run.output, "FAIL fail_test.lua > fails with boom"), run.output)
	T.True(contains(run.output, "boom"), run.output)
	T.True(contains(run.output, "stack traceback"), run.output)
end)

T.Test("keeps running the tests after a failure", function()
	local run = runHarness("mixed")

	T.True(contains(run.output, "PASS fail_test.lua > runs after the failure"), run.output)
	T.True(contains(run.output, "PASS pass_test.lua > adds numbers"), run.output)
end)

T.Test("exits zero when every test passes", function()
	local run = runHarness("passing")

	T.Equal(run.footer, "1 of 1 tests passed", run.output)
	T.Equal(run.exitCode, EXIT_PASSED, run.output)
end)

T.Test("counts every test in a file that does not compile as failed", function()
	local run = runHarness("broken/syntax")

	T.Equal(run.footer, "0 of 2 tests passed", run.output)
	T.True(contains(run.output, "broken_test.lua:"), run.output)
	T.Equal(run.exitCode, EXIT_FAILED, run.output)
end)

T.Test("fails when there are no tests to run", function()
	local run = runHarness("empty")

	T.Equal(run.footer, "0 of 0 tests passed", run.output)
	T.Equal(run.exitCode, EXIT_FAILED, run.output)
end)

T.Test("Equal reports both values", function()
	local ok, err = pcall(T.Equal, 1, 2)

	T.Equal(ok, false)
	T.True(contains(err, "expected 2, got 1"), err)
end)

T.Test("Raises passes only when the function errors", function()
	T.Raises(function() error("expected") end)
	T.Equal(pcall(T.Raises, function() end), false)
end)
