local utf8validator = require("utf8validator")
local tested = require("tested")

-- all tests below are adapted from Markus Kuhn' utf8_invalid.txt

--Markus Kuhn <http://www.cl.cam.ac.uk/~mgk25/> - 2003-02-19
--License: https://www.cl.cam.ac.uk/~mgk25/short-license.html

tested.test("1 Some correct UTF-8 text", function()
    local test_str = "κόσμε"
    tested.assert({given=test_str, should="be valid utf-8", expected=true, actual=utf8validator(test_str)})
end)

tested.test("2.1 First possible sequence of a certain length", function()
    local test_strs = {"\x00", "\xC2\x80", "ࠀ", "𐀀"}
    -- 5 and 6 byte are _not_ valid utf-8

    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be valid utf-8", expected=true, actual=utf8validator(test_str)})
    end
end)


tested.test("2.1 Last possible sequence of a certain length", function()
    local test_strs = {"\x7F", "߿", "\xEF\xBF\xBF", "\xF4\x8F\xBF\xBF"}
    -- 5 and 6 byte are _not_ valid utf-8
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be valid utf-8", expected=true, actual=utf8validator(test_str)})
    end
end)


tested.test("3.1 Unexpected continuation bytes", function()
    local test_strs = {
        "\x80",
        "\xBF",
        "\x80\xBF",
        "\x80\xBF\x80",
        "\x80\xBF\x80\xBF",
        "\x80\xBF\x80\xBF\x80",
        "\x80\xBF\x80\xBF\x80\xBF",
        
        "\x80",
        "\x81",
        "\x82",
        "\x83",
        "\x84",
        "\x85",
        "\x86",
        "\x87",
        "\x88",
        "\x89",
        "\x8A",
        "\x8B",
        "\x8C",
        "\x8D",
        "\x8E",
        "\x8F",
        "\x90",
        "\x91",
        "\x92",
        "\x93",
        "\x94",
        "\x95",
        "\x96",
        "\x97",
        "\x98",
        "\x99",
        "\x9A",
        "\x9B",
        "\x9C",
        "\x9D",
        "\x9E",
        "\x9F",
        "\xA0",
        "\xA1",
        "\xA2",
        "\xA3",
        "\xA4",
        "\xA5",
        "\xA6",
        "\xA7",
        "\xA8",
        "\xA9",
        "\xAA",
        "\xAB",
        "\xAC",
        "\xAD",
        "\xAE",
        "\xAF",
        "\xB0",
        "\xB1",
        "\xB2",
        "\xB3",
        "\xB4",
        "\xB5",
        "\xB6",
        "\xB7",
        "\xB8",
        "\xB9",
        "\xBA",
        "\xBB",
        "\xBC",
        "\xBD",
        "\xBE",
        "\xBF",
    }

    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end

end)

tested.test("3.2.1  All 32 first bytes of 2-byte sequences", function()
    local test_strs = {
        "\xC0",
        "\xC0",
        "\xC1",
        "\xC2",
        "\xC3",
        "\xC4",
        "\xC5",
        "\xC6",
        "\xC7",
        "\xC8",
        "\xC9",
        "\xCA",
        "\xCB",
        "\xCC",
        "\xCD",
        "\xCE",
        "\xCF",

        "\xD0",
        "\xD0",
        "\xD1",
        "\xD2",
        "\xD3",
        "\xD4",
        "\xD5",
        "\xD6",
        "\xD7",
        "\xD8",
        "\xD9",
        "\xDA",
        "\xDB",
        "\xDC",
        "\xDD",
        "\xDE",
        "\xDF",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("3.2.2 All 16 first bytes of 3-byte sequences", function ()
    local test_strs = {
        "\xE0",
        "\xE1",
        "\xE2",
        "\xE3",
        "\xE4",
        "\xE5",
        "\xE6",
        "\xE7",
        "\xE8",
        "\xE9",
        "\xEA",
        "\xEB",
        "\xEC",
        "\xED",
        "\xEE",
        "\xEF",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("3.2.3 All 8 first bytes of 4-byte sequences", function ()
    -- not a list because one of these throws a attempt to index a nil value

    local test_str = "\xF0"
    tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})

    local test_str = "\xF1"
    tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})

    local test_str = "\xF2"
    tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})

    local test_str = "\xF3"
    tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})

    local test_str = "\xF4"
    tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})

    local test_str = "\xF5"
    tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})

    local test_str = "\xF6"
    tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})

    local test_str = "\xF7"
    tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})

end)

tested.test("3.2.4 All 8 first bytes of 4-byte sequences", function()
    local test_strs = {
        "\xF8",
        "\xF9",
        "\xFA",
        "\xFB",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("3.2.5 All 2 first bytes of 6-byte sequences", function()
    local test_strs = {
        "\xFC",
        "\xFD",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("3.3 Sequences with last continuation byte missing", function()
    local test_strs = {
        "\xC0",
        "\xE0\x80",
        "\xF0\x80\x80",
        "\xF8\x80\x80\x80",
        "\xFC\x80\x80\x80\x80",
        "\xDF",
        "\xEF\xBF",
        "\xF7\xBF\xBF",
        "\xFB\xBF\xBF\xBF",
        "\xFD\xBF\xBF\xBF\xBF",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("3.5 Impossible bytes", function()
    local test_strs = {
        "\xFE",
        "\xFF",
        "\xFE\xFE\xFF\xFF",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("4.1 Examples of an overlong ASCII character", function()
    local test_strs = {
        "\xC0\xAF",
        "\xE0\x80\xAF",
        "\xF0\x80\x80\xAF",
        "\xF8\x80\x80\80\xAF",
        "\xFC\x80\x80\80\80\xAF",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("4.2 Maximum overlong sequences", function()
    local test_strs = {
        "\xC1\xBF",
        "\xE0\x9F\xBF",
        "\xF0\x8F\xBF\xBF",
        "\xF8\x87\xBF\xBF\xBF",
        "\xFC\x83\xBF\xBF\xBF\xBF",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("4.3 Overlong representation of the NUL character", function()
    local test_strs = {
        "\xC0\x80",
        "\xE0\x80\x80",
        "\xF0\x80\x80\x80",
        "\xF8\x80\x80\x80\x80",
        "\xFC\x80\x80\x80\x80\x80",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("5.1 Single UTF-16 Surrogates", function()
    local test_strs = {
        "\xED\xA0\x80",
        "\xED\xAD\xBF",
        "\xED\xAE\x80",
        "\xED\xAF\xBF",
        "\xED\xB0\x80",
        "\xED\xBE\x80",
        "\xED\xBF\xBF",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

tested.test("5.2 Paired UTF-16 Surrogates", function()
    local test_strs = {
        "\xED\xA0\x80\xED\xB0\x80",
        "\xED\xA0\x80\xED\xBF\xBF",
        "\xED\xAD\xBF\xED\xB0\x80",
        "\xED\xAD\xBF\xED\xBF\xBF",
        "\xED\xAE\x80\xED\xB0\x80",
        "\xED\xAE\x80\xED\xBF\xBF",
        "\xED\xAF\xBF\xED\xB0\x80",
        "\xED\xAF\xBF\xED\xBF\xBF",
    }
    for _, test_str in ipairs(test_strs) do
        tested.assert({given=test_str, should="be invalid utf-8", expected=false, actual=utf8validator(test_str)})
    end
end)

return tested
