local print_problem = function(p) 
  local s = "("
  for k,v in ipairs(p) do
    s = s.." "..v
  end
  s = s.." "..p["op"]..")"
  return s
end

local evaluate_problem = function(p)
  local op = p["op"]
  local val
  if op == "+" then
    val = 0
  else
    val = 1
  end

  for _, v in ipairs(p) do
    if op == "+" then
      val = val + v
    else
      val = val * v
    end
  end
  return val
end

local p1 = function()
  local problems = {}
  -- read one line
  local l = io.read("l")

  while l do
    local i = 1
    for str in string.gmatch(l, "%S+") do
      if string.match(str, "[%+*]") then
        -- operator line
        problems[i]["op"] = str
      else
        local problem = problems[i] or {}
        problem[#problem+1] = tonumber(str)
        problems[i] = problem
      end
        i = i + 1
    end
    l = io.read("l")
  end

  for k,p in pairs(problems) do
      print(k.." = "..print_problem(p))
  end

  local total = 0
  for k,p in pairs(problems) do
      local t = evaluate_problem(p)
      print(k.." = "..t)
      total = total + t
  end
  print("total", total)
end

local p2 = function()
  local lines = {}
  local l = io.read("l")
  -- this time read the lines in first
  while l do
    local line = {}
    for i = 1, #l do
      -- usual caveat about unicode
      line[i] = l:sub(i, i)
    end

    lines[#lines+1] = line
    l = io.read("l")
  end

  -- read by columns (sorry pager)
  local maxCol = #lines[1] -- the numbers lines are all this length it turns out, the operator line is shorter
  local numProblems = #lines - 1 -- last line is the operator line
  local problemNum = 1
  local problems = {}
  local operatorLine = true
  for col = 1, maxCol do
    -- print("col: "..col)
    -- val is the number we're reading on the column
    local val = 0
    -- for each line except the last one, which is the operator line
    for i = 1, numProblems do
      local ch = lines[i][col]
      if ch ~= " " then
        val = val * 10 + tonumber(ch)
      end
    end
    if val == 0 then
      -- print("end of problem "..problemNum)
      -- print(print_problem(problems[problemNum]))
      -- blank line between numbers
      problemNum = problemNum + 1
      operatorLine = true
    else 
      local problem = problems[problemNum] or {}
      problem[#problem+1] = val
      -- print("appending "..val.." to problem")
      problems[problemNum] = problem

      -- now operator
      if operatorLine then
        problem.op = lines[#lines][col]
        -- print("set operator to "..problem.op)
        operatorLine = false
      end
    end

    col = col + 1
  end

  local total = 0
  for i, p in pairs(problems) do
    print(i.." = "..print_problem(p))
    total = total + evaluate_problem(p)
  end

  print(total)

end

if arg[1] == "1" then
  p1()
elseif arg[1] == "2" then
  p2()
else
  print("no")
end
