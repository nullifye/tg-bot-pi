return function(msg)
  cmd = "pi:webshot"
  if args[1]==cmd then
    if #args == 2 then
      if not http_code(args[2], "200 301 302") then
        send_msg (target, "("..cmd..") '"..args[2].."' is not available", ok_cb, false)
        return true
      end

      send_msg (target, "("..cmd..") processing... may take a moment", ok_cb, false)
      curr_time = os.time()
      try = os.execute('curl -s https://screenshotmachine.com/processor.php --connect-timeout '..TIMEOUT..' -d "urlparam='..args[2]..'&size=FULL" -H "Referer: https://screenshotmachine.com/" -H "DNT: 1" -H "Origin: https://screenshotmachine.com" -H "User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.101 Safari/537.36" | sed -n "s/.*href=\'\\([^\']*\\).*/\\1/p" > '..TMP_PATH..'/webshot'..curr_time..'.out')

      if try then
        imglink = exec('cat '..TMP_PATH..'/webshot'..curr_time..'.out')
        imglink = string.gsub(imglink, "\n", "") -- trim newline
        getvid = os.execute('curl -s "https://screenshotmachine.com/'..imglink..'" -so '..TMP_PATH..'/webshot'..curr_time..'.png')
        send_document (target, TMP_PATH.."/webshot"..curr_time..".png", ok_cb, false)
      else
        send_text (target, "("..cmd..") server take too long to respond.\ntry again", ok_cb, false)
      end
    else
      send_msg (target, "usage: "..cmd.." <URL>", ok_cb, false)
    end
    return true
  end
end
