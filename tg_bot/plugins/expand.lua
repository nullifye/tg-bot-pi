return function(msg)
  cmd = "pi:expand"
  if args[1]==cmd then
    if (#args == 1 or #args > 2) then
      send_msg (target, "usage: "..cmd.." <SHORTENED-URL>", ok_cb, false)
    else
      curr_time = os.time()
      try = os.execute('curl -I -s --connect-timeout 3 "'..args[2]..'" -o /dev/null -w "%{redirect_url}" > '..TMP_PATH..'/expand'..curr_time..'.out')

      if try then
        -- check if file is empty
        if filesize(TMP_PATH..'/expand'..curr_time..'.out') == 0 then
          send_msg (target, "("..cmd..") not a valid shortened URL", ok_cb, false)
          return true
        end

        send_text (target, TMP_PATH..'/expand'..curr_time..'.out', ok_cb, false)
      else
        send_msg (target, "("..cmd..") URL not accessible", ok_cb, false)
      end
    end
    return true
  end
end
