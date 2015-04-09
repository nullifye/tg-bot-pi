return function(msg)
  cmd = "pi:cputemp"
  if isadmin(msg) and command(msg,cmd) then
    myvar = exec("sed 's/\\(...\\)$/.\\1°C/' < /sys/class/thermal/thermal_zone0/temp")
    send_msg (target, "cputemp="..myvar, ok_cb, false)
    return true
  end
end
