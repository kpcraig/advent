local name = "/Users/kpcraig/workspace/advent/2021/day12/sample3"

local get_lines = function(filename)
    local f = io.open(filename)
    local lines = {}
    for l in f:lines() do
        lines[#lines + 1] = l
    end
    return lines
end

local split = function (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local isBig = function(name)
    local ucase = string.upper(name)
    return ucase == name
end

local has_value = function(t, val) 
    for _, v in pairs(t) do
        if v == val then
            return true
        end
    end
    return false
end

-- visit
Visit = function(paths, visited, current, nodes)
    print("visiting", current.name)
    local v2 = {}
    for k, v in pairs(visited) do
        v2[k] = v
    end
    table.insert(v2, current.name)
    for nm, nd in pairs(current.neighbors) do
        -- for every node in neighbors
        if nm == "end" then
            paths[table.concat(v2, ",")..",end"] = true
        elseif isBig(nm) or not has_value(v2, nm) then
            -- if big or not visited
            Visit(paths, v2, nd, nodes)
        end
    end
end
-- string.byte("input", index) - 1 indexed

-- say we create a node with table values "name", "isBig", "neighbors" = {}


local ls = get_lines(name)
local nodes = {}
-- enumerate all sources
for _, v in ipairs(ls) do
    local desc = split(v, "-")
    -- print(desc[1], desc[2])
    local source = desc[1]
    local target = desc[2]
    nodes[source] = nodes[source] or {name=source, neighbors={}}
    nodes[target] = nodes[target] or {name=target, neighbors={}} 
end
-- link sources
for _, v in ipairs(ls) do
    local desc = split(v, "-")
    local source = desc[1]
    local target = desc[2]
    -- if target ~= "start" then 
        nodes[source].neighbors[target] = nodes[target] 
    -- end
    -- if source ~= "end" then 
        nodes[target].neighbors[source] = nodes[source] 
    -- end
end

local paths = {}
-- local visited = {}
-- local queue = {}
-- push table.insert(table, value)
-- remove table.remove(table, 1)

-- push start node onto queue
-- table.insert(queue, nodes.start) 
-- we visited start
-- visited["start"] = true
-- while(queue[1]) do
--     local node = table.remove(queue)
--     print("visiting", node.name)
--     visited[node.name] = true
--     for nm, v in pairs(node.neighbors) do
--         if nm == "end" then
--             paths = paths + 1
--         elseif (visited[nm] == nil or isBig(nm)) then
--             -- willing to visit again bc (not visited or isBig) and is not the start node
--             print("pushing", nm)
--             table.insert(queue, v)
--         end
--     end
-- end
Visit(paths, {}, nodes.start, nodes)

-- print("paths", paths)
local count = 0
for k, v in pairs(paths) do
    print(k, v)
    count = count+1
end
print(count)
-- how some stuff looks
--[[
local fact = function(n)
    if n == 0 then
        return 1
    end

    return n * fact(n - 1)
end
--]]

