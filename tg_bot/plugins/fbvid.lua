-- send_document, send_video fix!
-- https://github.com/vysheng/tg/issues/428#issuecomment-79404788

return function(msg)
  cmd = "pi:fbvid"
  if args[1]==cmd then
    if (#args == 1 or #args > 3) then
      send_msg (target, "📝 "..cmd.." <FB-VIDEO-URL> [!]", ok_cb, false)
    else
      NOTFB = (string.find(args[2], "facebook.com/video.php?v=", nil, true) == nil) and 
              (string.find(args[2], "facebook.com/[%w%.]+/videos/%w+") == nil)
      if NOTFB or not http_code(args[2], "200 301 302") then
        send_msg (target, "("..cmd..") check your FB video URL", ok_cb, false)
        return true
      end

      args[2] = string.gsub(args[2], "https://www.", "https://m.") -- switch to mobile fb

      curr_time = os.time()
      try = os.execute('wget -qO- "'..args[2]..'" | grep -oh -e \'href="/video_redirect/.*target="_blank"><img\' | grep -ohe \'src=.*&amp;s\' | sed \'s/src=//\' | sed \'s/&amp;s//\' > '..TMP_PATH..'/fbvid'..curr_time..'.out')

      if try then
        -- check if file is empty
        if filesize(TMP_PATH..'/fbvid'..curr_time..'.out') == 0 then
          send_msg (target, "("..cmd..") this video might be PRIVATE (not public)", ok_cb, false)
          return true
        end

        vidlink = exec('cat '..TMP_PATH..'/fbvid'..curr_time..'.out')
        vidlink = string.gsub(vidlink, "\n", "") -- trim newline
        vidlink = decodeURI(vidlink)

        if args[3] == "!" then
          send_msg (target, "("..cmd..") processing... may take a moment", ok_cb, false)
          getvid = os.execute('curl -s "'..vidlink..'" -so '..TMP_PATH..'/video'..curr_time..'.mp4')

          if getvid then
            send_msg (target, "("..cmd..") sending...", ok_cb, false)
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
