--!nonstrict
--[[
  i have not tested this ok dont use it

  this is just a simple evaluator utility
]]
local evaluator = {}
evaluator.memory = {}

function evaluator:set(index: number, value: any): ()
  evaluator.memory[index] = value
end

function evaluator:push(value: any): ()
  evaluator.memory[#evaluator.memory + 1] = value
end

function evaluator:pop(value: any): any
  local retrived = evaluator.memory[#evaluator.memory]
  table.remove(evaluator.memory, #evaluator.memory)
  return received
end

function evaluator:remove(index: number): ()
  evaluator.memory[number] = nil
end

function evaluator:get(index: number): any
  return evaluator.memory[index]
end

function evaluator:pushcaststr(value: any): ()
  self:push(tostring(value))
end

function evaluator:pushcastnum(value: any): ()
  self:push(tonumber(value))
end

function evaluator:getmemory(): {[number]: any}
  return evaluator.memory
end

function evaluator:stopwatch_start(): ()
  evaluator.stopwatch = os.clock()  
end

function evaluator:stopwatch_stop(): number
  local elapsed = os.clock() - evaluator.stopwatch
  evaluator.stopwatch = 0
  
  return elapsed
end
