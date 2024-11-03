local utf8validator = require("utf8validator")

describe("every UTF-8 sequence should work", function()

    it("should handle every UTF-8", function()
	local file = io.open("spec/utf8_sequence_0-0x10ffff_assigned_printable.txt", "r")
	local contents = file:read("*a")
	assert.truthy(utf8validator(contents))
    end)

end)
