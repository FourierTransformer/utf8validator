local tested = require("tested")
local utf8validator = require("utf8validator")

tested.test("every UTF-8 sequence should work", function()
	local file = io.open("tests/utf8_sequence_0-0x10ffff_assigned_printable.txt", "r")
	local contents = file:read("*a")

	tested.assert({
		given="utf8_sequence_0-0x10ffff_assigned_printable.txt",
		should="be fully valid UTF-8",
		expected=true,
		actual=utf8validator(contents)
	})

	file:close()
end)

return tested
