return function(msg)
  cmd = "pi:shorten"
  if args[1]==cmd then
    if (#args == 1 or #args > 2) then
      send_msg (target, "usage: "..cmd.." <URL>", ok_cb, false)
    else
      if not http_code(args[2], "200 301 302") then
        send_msg (target, "("..cmd..") check your URL", ok_cb, false)
        return true
      end

      curr_time = os.time()
      try = os.execute('wget -qO- "https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyBnWXwtN1xjPU2xRwAGiIugbBkPMGBhpIA" --header=\'Content-Type: application/json\' --post-data=\'{"longUrl": "'..args[2]..'"}\' | grep -Po \'"id":.*?[^\\\\]",|},{\' | awk -F\'"[:] "\' \'{print "👉 " $2}\' | sed -e "s/\\",//"  > '..TMP_PATH..'/shorten'..curr_time..'.out')

      if try then
        -- check if file is empty
        if filesize(TMP_PATH..'/shorten'..curr_time..'.out') == 0 then
          send_msg (target, "("..cmd..") goo.gl processing error", ok_cb, false)
          return true
        end

        send_text (target, TMP_PATH..'/shorten'..curr_time..'.out', ok_cb, false)
      end
    end
    return true
  end
end
