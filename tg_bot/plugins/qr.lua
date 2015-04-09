return function(msg)
  cmd = "pi:qr"
  if args[1]==cmd then
    if #args == 3 then
      if string.match("text url phone", args[2]) == nil then
        send_msg (target, "("..cmd..") '"..args[2].."' is INVALID", ok_cb, false)
        return true
      end

      curr_time = os.time()
      try = os.execute('wget -qO- "http://qrcode.mutationevent.com/qr.php" --post-data="type='..args[2]..'&content='..args[3]..'&size=10&level=H" | sed -n \'s/.*src="\\([^"]*\\).*/\\1/p\' > '..TMP_PATH..'/qr'..curr_time..'.out')

      if try then
        qrlink = exec('cat '..TMP_PATH..'/qr'..curr_time..'.out')
        qrlink = string.gsub(qrlink, "\n", "") -- trim newline
        getqr = os.execute('curl -s "http://qrcode.mutationevent.com/'..qrlink..'" -so '..TMP_PATH..'/qr'..curr_time..'.png')

        if getqr then
          send_photo (target, TMP_PATH.."/qr"..curr_time..".png", ok_cb, false)
        end
      end
    else
      send_msg (target, "usage: "..cmd.." text|url|phone <CONTENT>", ok_cb, false)
    end
    return true
  end
end
