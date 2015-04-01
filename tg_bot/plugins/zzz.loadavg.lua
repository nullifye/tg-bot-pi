return function(msg)
  cmd = "pi:loadavg"
  if isadmin(msg) and command(msg,cmd) then
    myvar = exec("uptime | awk '{print \"loadavg=\"$(NF-2)\" \"$(NF-1)\" \"$(NF-0)}'")
    send_msg (target, myvar, ok_cb, false)
    return true
  end
end
