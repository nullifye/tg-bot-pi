return function(msg)
  cmd = "pi:alexa"
  if args[1]==cmd then
    if (#args == 1 or #args > 2) then
      send_msg (target, "usage: "..cmd.." <URL>", ok_cb, false)
    else
      curr_time = os.time()
      try = os.execute('wget -qO- "http://www.alexa.com/siteinfo/'..args[2]..'" | sed -n \'/<div class="rank-row"/,/<\\/div>/p\' | sed \'/<span class="middle">/,/<\\/span>/d\' | sed \'/<span class="align-vmiddle change-wrapper.*<\\/span>/d\' | sed -e "s/<[^>]*[>]//g" -e "s/^[ \t]*//" -e "s/&nbsp;//g" | sed -e \':a;N;$!ba;s/\\n\\n\\n\\n//g\' | sed -e \':a;N;$!ba;s/\\n\\n/\\n/g\' > '..TMP_PATH..'/alexa'..curr_time..'.out')

      if try then
        -- check if file is empty
        if filesize(TMP_PATH..'/alexa'..curr_time..'.out') == 0 then
          send_msg (target, "("..cmd..") please check your URL.", ok_cb, false)
          return true
        end

        send_text (target, TMP_PATH..'/alexa'..curr_time..'.out', ok_cb, false)
      else
        send_text (target, "("..cmd..") server take too long to respond.\ntry again", ok_cb, false)
      end
    end
    return true
  end
end