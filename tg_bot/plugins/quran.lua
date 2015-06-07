return function(msg)
  cmd = "pi:quran"
  if args[1]==cmd then
    if (#args == 1 or #args > 5) then
      send_msg (target, "usage: "..cmd.." 1..114 [<AYAT>] [my|en] [!]", ok_cb, false)
    elseif surah[args[2]] == nil then
      send_msg (target, "("..cmd..") invalid SURAH", ok_cb, false)
    else
      outp = surah[args[2]].." "..args[2]..":"..ayat[args[2]]

      if #args == 2 then
        send_msg (target, outp, ok_cb, false)
      else
        cc = tonumber(args[3])

        if cc > 0 and cc <= ayat[args[2]] then
          if args[4] == "en" then
            lang = "?l=en"
          else
            lang = ""
          end

          curr_time = os.time()
          try = os.execute('wget -qO- http://www.surah.my/'..args[2]..lang..' --connect-timeout='..TIMEOUT..' | sed -n \'/<div class="post" id="'..args[3]..'">/,/<\\/div>/p\' > '..TMP_PATH..'/quran'..curr_time..'.out')

          if try then
            if filesize(TMP_PATH..'/quran'..curr_time..'.out') == 0 then
              send_msg (target, "("..cmd..") service temporarily unavailable", ok_cb, false)
              return true
            end

            evidence = exec('cat '..TMP_PATH..'/quran'..curr_time..'.out | egrep "img" | sed -e \'s/<img .*src=[\'"\'"\'"]//\' -e \'s/["\'"\'"\'].*$//\' -e \'/^$/ d\' -e "s/^[ \t]*//"')
            evidence = string.gsub(evidence, "\n", "") -- trim newline

            getimg = os.execute('curl http://www.surah.my'..evidence..' -so '..TMP_PATH..'/ayat'..curr_time..'.png')

            if getimg then
              send_photo (target, TMP_PATH.."/ayat"..curr_time..".png", ok_cb, false)

              tafseer = exec('cat '..TMP_PATH..'/quran'..curr_time..'.out | egrep "<p>" | sed -e "s/<[^>]*[>]//g"')
              tafseer = string.gsub(tafseer, "&quot;", "'")
              send_msg (target, tafseer, ok_cb, false)

              if args[5] == "!" then
                audioname = string.format("%03d%03d", args[2], args[3])..".mp3"
                getaudio = os.execute('curl -s http://everyayah.com/data/Alafasy_64kbps/'..audioname..' -so '..TMP_PATH..'/'..curr_time..audioname)

                if getaudio then
                  send_audio (target, TMP_PATH..'/'..curr_time..audioname, ok_cb, false)
                end
              end
            end
          else
            send_text (target, "("..cmd..") server takes too long to respond.\ntry again", ok_cb, false)
          end
        else
          send_msg (target, outp, ok_cb, false)
        end
      end
    end
    return true
  end
end
