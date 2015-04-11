return function(msg)
  cmd = "pi:yt"
  if args[1]==cmd then
    if (#args < 2) then
      send_msg (target, "usage: "..cmd.." <KEYWORD1> [<KEYWORD2>] [<KEYWORD3>] ...", ok_cb, false)
    else
      table.remove(args, 1)
      searchq = table.concat(args, "+")

      curr_time = os.time()
      try = os.execute('wget -qO- "https://www.youtube.com/results?filters=video&search_query='..searchq..'" --no-check-certificate | sed -n \'/<div class="yt-lockup-content">/,/<\\/div>/p\' | sed -n \'/<h3 class="yt-lockup-title"><a href="/,/<\\/h3>/p\' | grep -oP \'(?<=<h3 class="yt-lockup-title">).*(?=</h3)\' -m 3 | awk -F\\" \'{print $8 "\\nhttps://www.youtube.com"$2" 🎬\\n"}\' > '..TMP_PATH..'/yt'..curr_time..'.out')

      if try then
        -- check if file is empty
        if filesize(TMP_PATH..'/yt'..curr_time..'.out') == 0 then
          send_msg (target, "("..cmd..") no results found", ok_cb, false)
          return true
        end
        send_text (target, TMP_PATH.."/yt"..curr_time..".out", ok_cb, false)
      end
    end
    return true
  end
end
