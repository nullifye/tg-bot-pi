return function(msg)
  cmd = "/start"
  if command(msg,cmd) then
	if msg.from.last_name==nil then
      last_name = ""
    else
      last_name = " "..msg.from.last_name
    end

    send_msg (target, "Hi, "..msg.from.first_name..last_name..". What can I help you with?\nType pi:help", ok_cb, false)
    return true
  end
end
