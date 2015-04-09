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
  elseif type(value) == 'function' or 
      type(value) == 'thread' or 
      type(value) == 'userdata' or
      value == nil
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

-- http://unix.stackexchange.com/questions/176249/checking-urls-for-http-code-200
function http_code(url, codes)
  statuscode = exec('curl -I -s "'..url..'" -o /dev/null -w "%{http_code}"')
  return string.match(codes, statuscode) ~= nil
end

function filesize(myfile)
  local f = assert(io.open( myfile , 'r' ))
  output = f:seek('end')
  f:close()
  return output
end

-- http://stackoverflow.com/a/28665686
function getargs(text)
  local t = {}
  local e = 0

  while true do
    local b = e+1
    b = text:find("%S",b)
    if b == nil then break end
    if text:sub(b,b) == "'" then
      e = text:find("'",b+1)
      b = b+1
    elseif text:sub(b,b) == '"' then
      e = text:find('"',b+1)
      b = b+1
    else
      e = text:find("%s",b+1)
    end
    if e == nil then e = #text+1 end

    t[#t+1] = text:sub(b,e-1)

    if #t > 1 then
      --sanitize: remove $ except for the first arg
      t[#t] = string.gsub(t[#t], "%$", "")
    end
  end
  return t
end

function command(msg, cmd)
  return msg.text == cmd
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
  package.loaded['./tg_bot/vars'] = nil
  package.loaded['./tg_bot/utils'] = nil
  --package.loaded['./tg_bot/bot'] = nil
  require './tg_bot/vars'
  require './tg_bot/utils'
  --require './tg_bot/bot'
end

function isadmin(msg)
  return msg.from.id == our_id
end

function onlytobot(msg)
  return msg.to.id == our_id
end

function admintobot(msg)
  return isadmin(msg) and onlytobot(msg)
end

function replyto(msg)
  if msg.to.type == 'user' then
    if msg.to.id == our_id then
      return 'user#id'..msg.from.id
    else
      return 'user#id'..msg.to.id
    end
  end
  if msg.to.type == 'chat' then
    return 'chat#id'..msg.to.id
  end
end
