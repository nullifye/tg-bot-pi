return function(msg)
  cmd = "pi:quran"
  if args[1]==cmd then
    if (#args == 1 or #args > 4) then
      send_msg (target, "usage: pi:quran 1..114 [<AYAT>] [my|en]", ok_cb, false)
    elseif surah[args[2]] == nil then
	  send_msg (target, "(pi:quran) invalid SURAH", ok_cb, false)
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
		  try = os.execute('wget -qO- http://www.surah.my/'..args[2]..lang..' | sed -n \'/<div class="post" id="'..args[3]..'">/,/<\\/div>/p\' > '..TMP_PATH..'/quran'..curr_time..'.out')

		  if try then
		    evidence = exec('cat '..TMP_PATH..'/quran'..curr_time..'.out | egrep "img" | sed -e \'s/<img .*src=[\'"\'"\'"]//\' -e \'s/["\'"\'"\'].*$//\' -e \'/^$/ d\' -e "s/^[ \t]*//"')
		    evidence = string.gsub(evidence, "\n", "") -- trim newline

		    getimg = os.execute('curl http://www.surah.my'..evidence..' -so '..TMP_PATH..'/ayat'..curr_time..'.png')

		    if getimg then
		      send_photo (target, TMP_PATH.."/ayat"..curr_time..".png", ok_cb, false)
			  tafseer = exec('cat '..TMP_PATH..'/quran'..curr_time..'.out | egrep "<p>" | sed -e "s/<[^>]*[>]//g"')
			  tafseer = string.gsub(tafseer, "&quot;", "'")
			  send_msg (target, tafseer, ok_cb, false)
		    end
		  end
		else
		  send_msg (target, outp, ok_cb, false)
		end
      end
    end
    return true
  end
end
