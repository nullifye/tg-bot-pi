-- send_document, send_video fix!
-- https://github.com/vysheng/tg/issues/428#issuecomment-79404788

return function(msg)
  cmd = "pi:fbvid"
  if args[1]==cmd then
    if (#args == 1 or #args > 4) then
      send_msg (target, "usage: pi:fbvid <FB-VIDEO-URL> [low|hi] [!]", ok_cb, false)
	else
	  NOTFB = string.find(args[2], "facebook.com/video.php?v=", nil, true) == nil
      if NOTFB or not http_code(args[2], "200 301 302") then
	    send_msg (target, "(pi:fbvid) '"..args[2].."' is INVALID", ok_cb, false)
		return true
	  end

	  if args[3] == "low" or args[3] == nil then
        args[3] = "head -1"
	  elseif args[3] == "hi" then
        args[3] = "tail -1"
	  else
	    send_msg (target, "(pi:fbvid) '"..args[3].."' is INVALID", ok_cb, false)
		return true
	  end

	  curr_time = os.time()
      try = os.execute('wget -qO- http://www.fbdown.net/down.php --post-data="URL='..args[2]..'" | egrep "Download Video in " | sed -n \'s/.*href="\\([^"]*\\).*/\\1/p\' > '..TMP_PATH..'/fbvid'..curr_time..'.out')

      if try then
        vidlink = exec('cat '..TMP_PATH..'/fbvid'..curr_time..'.out | '..args[3])
        vidlink = string.gsub(vidlink, "\n", "") -- trim newline

        if args[4] == "!" then
		  send_msg (target, "(pi:fbvid) processing... may take a moment", ok_cb, false)
          getvid = os.execute('curl "'..vidlink..'" -so '..TMP_PATH..'/video'..curr_time..'.mp4')

          if getvid then
		    send_video (target, TMP_PATH.."/video"..curr_time..".mp4", ok_cb, false)
		  end
		else
          send_msg (target, "📥 Download link\n"..vidlink, ok_cb, false)
        end
      end
    end
	return true
  end
end
