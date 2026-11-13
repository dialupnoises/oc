local T = ...

T.Test("fails with boom", function()
	error("boom")
end)

T.Test("runs after the failure", function()
	T.True(true)
end)
