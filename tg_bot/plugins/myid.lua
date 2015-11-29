return function(msg)
  cmd0 = "/me"
  cmd1 = "pi:myid"
  if command(msg,cmd0) or command(msg,cmd1) then
    send_msg (target, msg.from.print_name.." is "..msg.from.id, ok_cb, false)
    return true
  end
end
