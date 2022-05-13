local Util = loadstring(syn.request({Url = "https://raw.githubusercontent.com/Saykane/switch-fork/main/util.lua", Method = "GET"}).Body)()

getgenv().run = function(Case, Cases)
    local BreakIt = false
    local default
    local function Stop()
        BreakIt = true
    end
    for i, It in ipairs(Cases) do
        local isFunc = typeof(It) == "function"
        if BreakIt then
            return
        elseif isFunc == false and It.Sentence_Type == "default" then
            default = It.Case
            continue
        end
        It = isFunc and It() or It
        if It.Condition ~= Case then
            continue
        end
        It.Case = It.Case or util.getNextCase(i, Cases)
        It.Case(Stop)
    end
    if default then
        default()
    end
end

getgenv().return_it = function(Sentence_Type, Condition, Case)
    local Case_Type = typeof(Case) == "table"
    Case = Case_Type and Case[1] or Case
    assert(Case_Type ~= "function", "You must provide a function.")
    return {
        Sentence_Type = Sentence_Type,
        Condition = Condition,
        Case = Case
    }
end

getgenv().switch = function(Value)
    return Util.wrap(run, Value)
end

getgenv().default = function(Case)
    return return_it("default", 0, Case)
end

getgenv().case = function(Condition)
    assert(Condition ~= nil, "You must provide a condition.")
    return Util.wrap(return_it, "case", Condition)
end

local module = {}
function module.getFunctions()
    return switch, case, default
end

return module
