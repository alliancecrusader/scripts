---------------------------------------------------------------------------

local function case_count(input, case)
    assert(type(input) == "string", "Expected string, got " .. type(input))
    assert(type(case) == "string", "Expected string, got " .. type(case))

    local count = 0

    for char in input:gmatch(case) do
        if char == "," then
            count = count + 1
        end
    end

    return count
end

---------------------------------------------------------------------------

local function main(args)
    local target = args[1]
    local case = args[2]
    local case_per_line_limit = args[3]

    local lines_that_exceed_limit = {}

    local input = io.open(target, "r"):read("*a")

    for line in input:gmatch("[^\r\n]+") do
        local comma_count_in_line = case_count(line, case)

        if comma_count_in_line > case_per_line_limit then
            table.insert(lines_that_exceed_limit, line)
        end
    end

    if #lines_that_exceed_limit > 0 then
        print("Lines that exceed the case limit in " .. target .. ":")
        
        for _, line in ipairs(lines_that_exceed_limit) do
            print(line)
        end
    else
        print("No lines exceed the case limit in " .. target)
    end
end

---------------------------------------------------------------------------

main(arg)

---------------------------------------------------------------------------