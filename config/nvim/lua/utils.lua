function BinaryExists(binary)
    local handle = io.popen("command -v " .. binary)
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end


function PrintTable(t, indent)
    indent = indent or 0
    for k, v in pairs(t) do
        local spacing = string.rep("  ", indent)
        if type(v) == "table" then
            print(spacing .. k .. ":")
            PrintTable(v, indent + 1)  -- 递归调用
        else
            print(spacing .. k .. ": " .. tostring(v))
        end
    end
end
