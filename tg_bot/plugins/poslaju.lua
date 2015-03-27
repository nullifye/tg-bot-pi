return function(msg)
  cmd = "pi:poslaju"
  if args[1]==cmd then
    if #args == 2 then
      curr_ptt = os.time()
      try = os.execute('wget -qO- --post-data \'ParcelNo='..args[2]..'\' http://www.pos.com.my/TrackAndTrace/viewDetailMelTrack/viewDetailMelTrack | sed -n \'/<table  class="QueryTableDetails">/,/<\\/table>/p\' | sed -e "s/^[ \t]*//" -e "s/&nbsp;//g" -e "/.*tr>/d" -e "/.*table>/d" -e "s/<[^>]*[>]//g" -e "s/^.$/----------/" > '..TMP_PATH..'/ppos'..curr_ptt..'.out')

      if try then
	    send_text (target, TMP_PATH.."/ppos"..curr_ptt..".out", ok_cb, false)
      end

	  send_msg (target, "--end of request", ok_cb, false)
    else
      send_msg (target, "usage: pi:poslaju <TRACKING-NO>", ok_cb, false)
    end
    return true
  end
end
