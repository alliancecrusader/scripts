------------------------------------------------------------------------------

local function replace_delimiter(input, old_delimiter, new_delimiter)
    assert(type(input) == "string", "Expected string, got " .. type(input))
    assert(type(old_delimiter) == "string", "Expected string, got " .. type(old_delimiter))
    assert(type(new_delimiter) == "string", "Expected string, got " .. type(new_delimiter))

    local output = {}

    for line in input:gmatch("[^\r\n]+") do
        local new_line = line:gsub(old_delimiter, new_delimiter)
        table.insert(output, new_line)
    end

    return table.concat(output, "\n")
end

------------------------------------------------------------------------------

local function main(args)
    local target = args[1]
    local old_delimiter = args[2]
    local new_delimiter = args[3]

    assert(type(target) == "string", "Expected string, got " .. type(target))
    assert(type(old_delimiter) == "string", "Expected string, got " .. type(old_delimiter))
    assert(type(new_delimiter) == "string", "Expected string, got " .. type(new_delimiter))

    local input = io.open(target, "r"):read("*a")
    local output = replace_delimiter(input, old_delimiter, new_delimiter)
    io.open(target, "w"):write(output)

    print("Delimiter replaced in " .. target)
end

------------------------------------------------------------------------------

main(arg)

------------------------------------------------------------------------------