-----------------------------------------------------------------------------------------------------------

local lfs = require("lfs")

-----------------------------------------------------------------------------------------------------------

local DEFAULT_OUTPUT_FILE_NAME = "output.txt"
local DEFAULT_DELIMITER = "\n\n"

--------------------------------------------------------------------------------------------------------------

local function  if_then_else(condition, if_true, if_false)
    if condition then
        return if_true
    else
        return if_false
    end
    
end

local function  to_bool(str)
    if str == "true" then
        return true
    elseif str == "false" then
        return false
    else
        return nil
    end
end

--------------------------------------------------------------------------------------------------------------

local function read_file(path)
    assert(type(path) == "string", "Expected string, got " .. type(path))

    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

---@diagnostic disable-next-line: unused-local, unused-function
local function _read_file_lines(path)
    assert(type(path) == "string", "Expected string, got " .. type(path))

    local file = io.open(path, "r")
    if not file then return nil end
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    return lines
end

local function write_file(path, content, return_file)
    assert(type(path) == "string", "Expected string, got " .. type(path))
    assert(type(content) == "string", "Expected string, got " .. type(content))

    local file = io.open(path, "w")
    if not file then return false end
    file:write(content)
    if return_file then
        return file
    end
    file:close()
end

---@diagnostic disable-next-line: unused-local, unused-function
local function _append_file(path, content)
    assert(type(path) == "string", "Expected string, got " .. type(path))
    assert(type(content) == "string", "Expected string, got " .. type(content))

    local file = io.open(path, "a")
    if not file then return false end
    file:write(content)
    file:close()
end

---@diagnostic disable-next-line: unused-local, unused-function
local function _copy_file(src, dest)
    assert(type(src) == "string", "Expected string, got " .. type(src))
    assert(type(dest) == "string", "Expected string, got " .. type(dest))

    local content = read_file(src)
    if not content then return false end
    return write_file(dest, content)
end

---@diagnostic disable-next-line: unused-local, unused-function
local function _delete_file(path)
    assert(type(path) == "string", "Expected string, got " .. type(path))

    os.remove(path)
end

-----------------------------------------------------------------------------------------------------------

local function get_all_files_of_ext(dir, extension)
    local files = {}
    
    for file in lfs.dir(dir) do
        if file ~= "." and file ~= ".." then
            local path = dir.."/"..file
            local attr = lfs.attributes(path)
            
            if attr.mode == "directory" then
                local subdir_files = get_all_files_of_ext(path, extension)
                for _, subdir_file in ipairs(subdir_files) do
                    table.insert(files, subdir_file)
                end
            elseif string.match(file, "%."..extension.."$") then
                table.insert(files, path)
            end
        end
    end
    
    return files
end

local function concatenate_files(dir, extension, delimiter, include_path, relative_path)
    local output = ""
    local files = get_all_files_of_ext(dir, extension)
    
    for _, file in ipairs(files) do
        local content = read_file(file)
        if content then
            output = output..if_then_else(include_path, if_then_else(relative_path, file:match(".*/(.*)"), file), "")..delimiter..content..delimiter
        end
    end
    
    return output
end

-----------------------------------------------------------------------------------------------------------
--[[
    How to type booleans?
    Type as "true" or "false", quotes not included.

    Arguments:
        1. directory: string
        2. extension: string
        3. output_file_name: string (optional) -- if not specified, the default output file name will be used
        4. delimiter: string (optional) -- if specified, the delimiter will be used to separate the files
        5. include_path: boolean (optional) -- if true, the path will be included in the output
        6. relative_path: boolean (optional) -- if true, the path will be relative to the directory

    Defaults:
        output_file_name = "output.txt"
        delimiter = "\n\n"
        include_path = false
        relative_path = false

    Example:

        lua file_concatenate.lua "C:/Users/JohnDoe/Desktop" "txt" "output.txt" "\n\n" true false
    
    This will concatenate all .txt files in the directory "C:/Users/JohnDoe/Desktop" and write the output to "output.txt". The files will be separated by "\n\n" and the absolute paths will be included in the output.
]]

-----------------------------------------------------------------------------------------------------------

local function main(args)
    local directory = args[1]
    local extension = args[2]

    local output_file_name = args[3] or DEFAULT_OUTPUT_FILE_NAME
    local delimiter = args[4] or DEFAULT_DELIMITER
    local include_path = to_bool(args[5]) or false
    local relative_path = to_bool(args[6]) or false

    assert(directory, "No directory specified")
    assert(extension, "No extension specified")

    local output_content = concatenate_files(directory, extension, delimiter, include_path, relative_path)
    write_file(output_file_name, output_content)

    print("Files concatenated in " .. output_file_name)
end

-----------------------------------------------------------------------------------------------------------

main(arg)

-----------------------------------------------------------------------------------------------------------