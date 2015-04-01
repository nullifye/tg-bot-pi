return function(msg)
  cmd = "pi:boottime"
  if isadmin(msg) and command(msg,cmd) then
    myvar = exec("cat /proc/stat | grep --color=never btime | cut -d ' ' -f 2")
    send_msg (target, os.date("%d/%m/%Y (%H:%M:%S)", myvar), ok_cb, false)
    return true
  end
end
