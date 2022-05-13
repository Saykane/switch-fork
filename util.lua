local module = {}

function module.wrap(F, ...)
    local Args = {...}
    return function(...)
        local __Args = {...}
        for i, Value in ipairs(Args) do
            table.insert(__Args, i, Value)
        end
        return F(unpack(__Args))
    end
end

function module.getNextCase(S, Cases)
    for i = S, #Cases do
        if typeof(Cases[i]) == "table" and Cases[i].Case then
            return Cases[i].Case
        end
    end
end

return module
