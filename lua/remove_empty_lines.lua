---------------------------------------------------------------------------

local function strip(s)
    return s:match("^%s*(.-)%s*$")
end

---------------------------------------------------------------------------

local function remove_empty_lines(input)
    assert(type(input) == "string", "Expected string, got " .. type(input))

    local output = {}

    for line in input:gmatch("[^\r\n]+") do
        local strippedLine = strip(line)
        if strippedLine ~= "" then
            table.insert(output, strippedLine)
        end
    end

    return table.concat(output, "\n")
end

---------------------------------------------------------------------------

local function main(args)
    local target = args[1]

    assert(type(target) == "string", "Expected string, got " .. type(target))

    local input = io.open(target, "r"):read("*a")
    local output = remove_empty_lines(input)
    
    io.open(target, "w"):write(output)

    print("Empty lines removed from " .. target)
end

---------------------------------------------------------------------------

main(arg)

---------------------------------------------------------------------------