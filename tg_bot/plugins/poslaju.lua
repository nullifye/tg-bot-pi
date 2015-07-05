return function(msg)
  cmd = "pi:poslaju"
  if args[1]==cmd then
    if #args == 2 then
      curr_ptt = os.time()
      try = os.execute('wget -qO- "http://api.pos.com.my/TrackNTraceWebApi/api/Details/'..args[2]..'" --connect-timeout='..TIMEOUT..' | grep -Po \'"date":.*?[^\\\\]",|"process":.*?[^\\\\]",|"office":.*?[^\\\\]",|},{\' | awk -F\'"[:]"\' \'{print $2}\' | sed -e "s/\\",//" | sed -e \':a;N;$!ba;s/\\n\\n/\\n----------\\n/g\' > '..TMP_PATH..'/ppos'..curr_ptt..'.out')

      if try then
        if filesize(TMP_PATH..'/ppos'..curr_ptt..'.out') == 0 then
          send_msg (target, "("..cmd..") record NOT FOUND", ok_cb, false)
          return true
        end

        send_text (target, TMP_PATH.."/ppos"..curr_ptt..".out", ok_cb, false)
      else
        send_text (target, "("..cmd..") server takes too long to respond.\ntry again", ok_cb, false)
      end
    else
      send_msg (target, "📝 "..cmd.." <TRACKING-NO>", ok_cb, false)
    end
    return true
  end
end
