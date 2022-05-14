if getgenv().switch then
    return getgenv().switch, getgenv().case, getgenv().default 
end

getgenv().util = loadstring(syn.request({Url = "https://raw.githubusercontent.com/TheHackerPuppy/LuaSwitch/main/src/Util.lua", Method = "GET"}).Body)()
local function run(case, cases)
	local breakIt = false
	local default 

	local function stop()
		breakIt = true
	end

	for i, it in ipairs(cases) do
		local isFunc = typeof(it) == "function"
		if breakIt then 
			return 
		elseif isFunc == false and it.sentence_type == "default" then
			default = it.case
			continue
		end

		it = isFunc and it() or it
		if it.condition ~= case then
			continue
		end

		it.case = it.case or util.getNextCase(i, cases)
		it.case(stop)
	end

	if default then
		default()
	end
end

local function return_it(sentence_type, condition, case)
	local case_type = typeof(case) == "table"
	
	case = case_type and case[1] or case
	assert(case_type ~= "function", "You must provide a function")

	return {
		sentence_type = sentence_type,
		condition = condition,
		case = case
	}
end

getgenv().switch = function(value)
    return util.wrap(run, value)
end

getgenv().default = function(case)
    return return_it("default", 0, case)
end

getgenv().case = function(condition)
    assert(condition ~= nil, "You must provide a condition")
    return util.wrap(return_it, "case", condition)
end

return getgenv().switch, getgenv().case, getgen().default
