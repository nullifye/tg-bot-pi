return function(msg)
  cmd = "pi:kastam"
  if args[1]==cmd then
    if #args == 2 then
      curr_ptt = os.time()
      args[2] = string.format("%012d", args[2])

      try = os.execute('wget -qO- "http://arsyan.com/gst/'..args[2]..'" --connect-timeout='..TIMEOUT..' | grep -Po \'"id":.*?[^\\\\]",|"DataCompanyName":.*?[^\\\\]",|"DataCommenceDate":.*?[^\\\\]",|"DataStatus":.*?[^\\\\]",|},{\' | awk -F\'"[:] "\' \'{print $2}\' | sed -e "s/\\",//" > '..TMP_PATH..'/gst'..curr_ptt..'.out')

      if try then
        if filesize(TMP_PATH..'/gst'..curr_ptt..'.out') == 0 then
          send_msg (target, "("..cmd..") API error", ok_cb, false)
          return true
        end

        send_text (target, TMP_PATH.."/gst"..curr_ptt..".out", ok_cb, false)
      else
        send_text (target, "("..cmd..") server take too long to respond.\ntry again", ok_cb, false)
      end
    else
      send_msg (target, "usage: "..cmd.." <GST-ID>", ok_cb, false)
    end
    return true
  end
end
