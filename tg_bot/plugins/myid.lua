return function(msg)
  cmd = "pi:myid"
  if command(msg,cmd) then
    send_msg (replyto(msg), msg.from.print_name..' is '..msg.from.id, ok_cb, false)
    return true
  end
end
