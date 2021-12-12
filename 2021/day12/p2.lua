local name = "/Users/kpcraig/workspace/advent/2021/day12/input"

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

-- has_value returns the count of such values now
local has_value = function(t, val) 
    local total = 0
    for _, v in pairs(t) do
        if v == val then
            total = total + 1
        end
    end
    return total
end

-- doubled is if we've already doubled a small
Visit = function(paths, visited, current, nodes, doubled)
    -- print("visiting", current.name)
    local v2 = {}
    for k, v in pairs(visited) do
        v2[k] = v
    end
    -- v2[current.name] = true
    table.insert(v2, current.name)
    for nm, nd in pairs(current.neighbors) do
        -- for every node in neighbors
        if nm == "end" then
            -- table.insert(v2, "end")
            paths[table.concat(v2, ",")..",end"] = true
        elseif nm == "start" then
            -- no -- i'm not sure how this is happening
        elseif isBig(nm) then
            -- if big
            Visit(paths, v2, nd, nodes, doubled)
        elseif has_value(v2, nm) == 0 then
            -- if not big and not visited
            Visit(paths, v2, nd, nodes, doubled)
        elseif not doubled and has_value(v2, nm) == 1 then
            -- not doubled yet and visited once
            -- visit this node and pass doubled as true
            Visit(paths, v2, nd, nodes, true)
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
Visit(paths, {}, nodes.start, nodes)

-- print("paths", paths)
local count = 0
for k, v in pairs(paths) do
    print(k, v)
    count = count+1
end
print(count, "should be 3509")
-- how some stuff looks
--[[
local fact = function(n)
    if n == 0 then
        return 1
    end

    return n * fact(n - 1)
end
--]]

