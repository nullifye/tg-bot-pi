return function(msg)
  cmd = "pi:bot"
  if admintobot(msg) and command(msg,cmd) then
    phoneno = "+"..msg.to.phone
    send_msg (target, phoneno, ok_cb, false)
    return true
  end
end
