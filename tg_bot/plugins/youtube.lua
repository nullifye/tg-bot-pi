return function(msg)
  cmd = "pi:yt"
  if args[1]==cmd then
    if (#args < 2) then
      send_msg (target, "usage: "..cmd.." <KEYWORD1> [<KEYWORD2>] ... [+<1..20>]", ok_cb, false)
    else
      limit = 3
      if (#args > 2) then
        qno = tonumber(string.match(args[#args], "+%d+"))
        if qno ~= nil then
          table.remove(args, #args)
        end
        if qno == nil or qno == 0 then
          qno = 3
        end
        limit = qno
      end

      table.remove(args, 1)

      for k,v in pairs(args) do
        v = string.gsub(v, "%+", "%%2B")
        args[k] = string.gsub(v, "%&", "%%26")
      end
      searchq = table.concat(args, "+")

      curr_time = os.time()
      try = os.execute('wget -qO- "https://www.youtube.com/results?filters=video&search_query='..searchq..'" --connect-timeout='..TIMEOUT..' --no-check-certificate | sed -n \'/<div class="yt-lockup-content">/,/<\\/div>/p\' | sed -n \'/<h3 class="yt-lockup-title"><a href="/,/<\\/h3>/p\' | grep -oP \'(?<=<h3 class="yt-lockup-title">).*(?=</h3)\' -m '..limit..' | awk -F\\" \'{print $8 "\\nhttps://www.youtube.com"$2" 🎬\\n"}\' > '..TMP_PATH..'/yt'..curr_time..'.out')

      if try then
        -- check if file is empty
        if filesize(TMP_PATH..'/yt'..curr_time..'.out') == 0 then
          send_msg (target, "("..cmd..") no results found", ok_cb, false)
          return true
        end

        outp = exec('cat '..TMP_PATH..'/yt'..curr_time..'.out')
        outp = string.gsub(outp, "&#39;", "'")
        outp = string.gsub(outp, "&amp;", "&")
        send_msg (target, outp, ok_cb, false)
      else
        send_text (target, "("..cmd..") server take too long to respond.\ntry again", ok_cb, false)
      end
    end
    return true
  end
end
