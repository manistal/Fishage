
-- 
-- Local utils
-- 
local function istable(t) return type(t) == 'table' end

-- Package namespace
FLL.table = {}

--
-- Applys Function 'fn' to Table 'tbl' as (k,v) pairs 
--  Depth first recursive application to all subtables as well
-- 
FLL.table.apply = function(tbl, fn) 
    for k, v in pairs(tbl) do
        if istable(v) then
            FLL.table.apply(v, fn)
        else
            fn(k, v)
        end
    end
end

FLL.table.copy = function(tbl)
  local copy_tbl = {}
  for k, v in pairs(tbl) do copy_tbl[k] = v end
  return setmetatable(copy_tbl, getmetatable(tbl))
end

FLL.table.length = function(tbl)
  if (tbl == nil) then return 0 end
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
end

FLL.table.print = function(tbl)
	for k, v in pairs(tbl) do
		print(k.."  "..v)
	end
end

FLL.table.sorted_iter = function(tbl, order)
    -- collect the keys
    local keys = {}
    for k in pairs(tbl) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(tbl, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], tbl[keys[i]]
        end
    end
end
