--this file must be on top of file hierarchy in plugins directory

return function(msg)
  cmd = "pi:reload"
  if isadmin(msg) and command(msg,cmd) then
    plugin_list = scandir(HOME..'/plugins')
    send_msg (replyto(msg), #plugin_list..' plugins reload:ed', ok_cb, false)
    return true
  end
end
