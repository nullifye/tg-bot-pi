return function(msg)
  cmd = "pi:uptime"
  if isadmin(msg) and command(msg,cmd) then
    myvar = exec("uptime | sed 's/^.\\+up\\ \\+\\([^,]*\\).*/\\1/g'")
    send_msg (replyto(msg), 'uptime='..myvar, ok_cb, false)
    return true
  end
end
