local utf8validator = require("utf8validator")
local tested = require("tested")

local utf8char = function(cp)
  if cp < 128 then
     return string.char(cp)
  end
  local suffix = cp % 64
  local c4 = 128 + suffix
  cp = (cp - suffix) / 64
  if cp < 32 then
     return string.char(192 + (cp), (c4))
  end
  suffix = cp % 64
  local c3 = 128 + suffix
  cp = (cp - suffix) / 64
  if cp < 16 then
     return string.char(224 + (cp), c3, c4)
  end
  suffix = cp % 64
  cp = (cp - suffix) / 64
  return string.char(240 + (cp), 128 + (suffix), c3, c4)
end


tested.test("should support ascii", function()
   local start_seq = tonumber("00000000", 2)
   local end_seq = tonumber("01111111", 2)

   for i = start_seq, end_seq do
      tested.assert({given="string.char " .. i, should="support ascii char", expected=true, actual=utf8validator(string.char(i))})
   end
   
end)

tested.test("should support two bytes", function()
   local start_seq = tonumber("11000010", 2)
   local end_seq = tonumber("11011111", 2)

   local start_seq_2nd = tonumber("10000000", 2)
   local end_seq_2nd = tonumber("10111111", 2)
   for i = start_seq, end_seq do
      for j = start_seq_2nd, end_seq_2nd do
         tested.assert({given = "string.char " .. i .. " " .. j, should = "support two bytes", expected=true, actual=utf8validator(string.char(i, j))})
      end
   end
end)

tested.test("should fail two bytes out of range", function()
   local start_seq = tonumber("11000010", 2)
   local end_seq = tonumber("11011111", 2)

   local start_seq_2nd = tonumber("00000000", 2)
   local end_seq_2nd = tonumber("10000000", 2) - 1
   for i = start_seq, end_seq do
      for j = start_seq_2nd, end_seq_2nd do
         tested.assert({given="string.char " .. i .. " " .. j, should = "be invalid utf8", expected=false, actual=utf8validator(string.char(i, j))})
      end
   end
end)

tested.test("should fail two bytes out of range", function()
   local start_seq = tonumber("11000010", 2)
   local end_seq = tonumber("11011111", 2)

   local start_seq_2nd = tonumber("10111111", 2) + 1
   local end_seq_2nd = tonumber("11111111", 2) 
   for i = start_seq, end_seq do
      for j = start_seq_2nd, end_seq_2nd do
         tested.assert({given="string.char " .. i .. " " .. j, should = "be invalid utf8", expected=false, actual=utf8validator(string.char(i, j))})
      end
   end
end)

return tested

