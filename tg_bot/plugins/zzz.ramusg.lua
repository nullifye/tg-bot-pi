return function(msg)
  cmd = "pi:ramusg"
  if isadmin(msg) and command(msg,cmd) then
    myvar = exec("free | grep Mem | awk '{printf \"%s\", $3/1024}'")
    send_msg (replyto(msg), 'RAMusage='..myvar..' MB', ok_cb, false)
    return true
  end
end
