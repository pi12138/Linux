function BinaryExists(binary)
    local handle = io.popen("command -v " .. binary)
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end
