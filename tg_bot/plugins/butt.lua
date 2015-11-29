return function(msg)
  cmd = "pi:butt"
  if isadmin(msg) and command(msg,cmd) then
    curr_time = os.time()
    try = os.execute('wget -qO- "http://api.obutts.ru/noise/1" --connect-timeout='..TIMEOUT..' | grep -Po \'"preview":.*?[^\\\\]",|},{\' | awk -F\'"[:] "\' \'{print $2}\' | sed -e "s/\\",//" > '..TMP_PATH..'/butt'..curr_time..'.out')

    if try then
      if filesize(TMP_PATH..'/butt'..curr_time..'.out') == 0 then
        send_msg (target, "("..cmd..") no FOUND!", ok_cb, false)
        return true
      end

      imglink = exec('cat '..TMP_PATH..'/butt'..curr_time..'.out')
      imglink = string.gsub(imglink, "\n", "") -- trim newline

      getimg = os.execute('curl "http://media.obutts.ru/'..imglink..'" -so '..TMP_PATH..'/butt'..curr_time..'.jpg')

      if getimg then
        send_photo (target, TMP_PATH.."/butt"..curr_time..".jpg", ok_cb, false)
      end
    else
      send_text (target, "("..cmd..") server takes too long to respond.\ntry again", ok_cb, false)
    end
    return true
  end
end
