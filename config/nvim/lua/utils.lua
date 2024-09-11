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

function MergeTables(tbl1, tbl2)
    local merged = {}

    -- 复制第一个表
    for k, v in pairs(tbl1) do
        merged[k] = v
    end

    -- 复制第二个表
    for k, v in pairs(tbl2) do
        merged[k] = v
    end

    return merged
end

local Debug = false

function DebugNotify(msg, level, opts)
    if Debug then
        vim.notify(msg, level, opts)
    end
end
