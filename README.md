# UTF-8 Validator for Lua
This is an example of the "branchy" algorithm in Lua as described in Daniel Lemire's paper on [Validating UTF-8 In Less Than One Instruction Per Byte](https://arxiv.org/pdf/2010.03090).

I needed a fast UTF-8 validator that portably works in all versions of Lua. Since I don't have access to SIMD instructions using plain Lua, the "branchy" algorithm described in the paper was used.

The standard Lua (and Teal) versions in the repo will work in Lua 5.1-5.4 and LuaJIT 2.0/2.1. There are some notes below regarding potential optimizations for Lua 5.2+

## Notes
This code will mark the UTF-16 surrogates (U+D800 through U+DFFF) as invalid. If you are using Lua 5.3+'s `utf8.len` for validation, it will mark these as valid.

- [Wikipedia Section on this](https://en.wikipedia.org/wiki/UTF-8#Surrogates)
- [Lua mailing list discussion on this](https://www.lua-users.org/lists/lua-l/2015-08/msg00517.html)

## Potential Optimizations
Examples of both optimizations are commented in the `utf8validator.lua` file.

### `find` in the right spot
After `nil`/range checking the second/third/fourth bytes, a `find()` pattern match can offload some processing to C for all the ASCII characters in regular Lua. This drastically improves the speed of validation and still passes all the tests (tests run in 52% of the original time)
```lua
_, i = input:find(".*", i)
i = i + 1
```

Note: This slows down LuaJIT (tests run in 160% of the time without it)

### Adding `goto` for a small speedup
A simple speedup in Lua 5.2+ is just adding labels to the `nil` checks on the bytes after the branches. The tests run in 88% of the original time.

```lua
::fourth:: if fourth == nil or fourth < 128 or fourth > 191 then return false, code_points end
::third:: if third == nil or third < 128 or third > 191 then return false, code_points end
::second:: if second == nil or second < 128 or second > 191 then return false, code_points end
::none::
```

and then adding the goto in the respective byte checks:

```lua
if byte <= 127 then
	i = i + 1
	goto none

elseif byte >= 194 and byte <= 223 then
	second = sbyte(input, i + 1)
	i = i + 2
	goto second

-- you can see all the goto's commented in utf8validator.lua/tl
```

## Licenses

- The source code (utf8validator.lua) is MIT Licensed, feel free to modify and use it.
- Tests in spec/invalid_spec.lua are adapted from [Markus Kuhn](http://www.cl.cam.ac.uk/~mgk25/)
  - Short License: https://www.cl.cam.ac.uk/~mgk25/short-license.html
- The file utf8_sequence_0-0x10ffff_assigned_printable.txt is from https://github.com/bits/UTF-8-Unicode-Test-Documents
  - BSD-3 Clause: https://github.com/bits/UTF-8-Unicode-Test-Documents/blob/master/LICENSE
