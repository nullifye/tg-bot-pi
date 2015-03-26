function vardump(value, depth, key)
  local linePrefix = ""
  local spaces = ""

  if key ~= nil then
    linePrefix = "["..key.."] = "
  end

  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do spaces = spaces .. "  " end
  end

  if type(value) == 'table' then
    mTable = getmetatable(value)
    if mTable == nil then
      print(spaces ..linePrefix.."(table) ")
    else
      print(spaces .."(metatable) ")
        value = mTable
    end		
    for tableKey, tableValue in pairs(value) do
      vardump(tableValue, depth, tableKey)
    end
  elseif type(value)	== 'function' or 
      type(value)	== 'thread' or 
      type(value)	== 'userdata' or
      value		== nil
  then
    print(spaces..tostring(value))
  else
    print(spaces..linePrefix.."("..type(value)..") "..tostring(value))
  end
end

function exec(cmd)
  local f = assert(io.popen( cmd , 'r' ))
  output = f:read('*all')
  f:close()
  return output
end

function getargs(msgtext)
  local t = {}
  for i in string.gmatch(msgtext, "%S+") do
    t[#t+1] = i
    if #t > 1 then
      --sanitize: remove $ except for the first arg
      t[#t] = string.gsub(t[#t], "%$", "")
    end
  end
  return t
end

function command(msg, cmd)
  return msg.text==cmd
end

function explode(d,p)
  local t, ll
  t={}
  ll=0
  if(#p == 1) then return {p} end
    while true do
      l=string.find(p,d,ll,true) -- find the next d in the string
      if l~=nil then -- if "not not" found then..
        table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
        ll=l+1 -- save just after where we found it for searching next time.
      else
        table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
        break -- Break at end, as it should be, according to the lua manual.
      end
    end
  return t
end

function splitfilename(strfilename)
  -- Returns the Path, Filename, and Extension as 3 values
  return string.match(strfilename, "(.-)([^\\]-([^\\%.]+))$")
end

-- Lua implementation of PHP scandir function / http://stackoverflow.com/a/9102300
function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  for filename in popen('ls "'..directory..'"'):lines() do
    i = i + 1
    t[i] = filename
  end
  return t
end

-- deprecated
function reload_plugins()
  --package.loaded['./tg_bot/vars'] = nil
  package.loaded['./tg_bot/utils'] = nil
  package.loaded['./tg_bot/bot'] = nil
  --require './tg_bot/vars'
  require './tg_bot/utils'
  require './tg_bot/bot'
end

function isadmin(msg)
  return msg.from.id == our_id
end

function onlyme(msg)
  return msg.from.id == our_id and msg.to.id == our_id
end

function replyto(msg)
  if msg.to.type == 'user' then
    return 'user#id'..msg.from.id
  end
  if msg.to.type == 'chat' then
    return 'chat#id'..msg.to.id
  end
end
