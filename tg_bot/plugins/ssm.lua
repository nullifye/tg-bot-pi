return function(msg)
  cmd = "pi:ssm"
  if args[1]==cmd then
    if #args ~= 3 then
      send_msg (target, "📝 "..cmd.." number|name <SEARCH>", ok_cb, false)
    else
      if args[2] == 'number' then
        dfilter = 'search_number'
        startc, endc = args[3]:find('-')
        if startc ~= nil then
          args[3] = args[3]:sub(1, startc-1)
        end
      elseif args[2] == 'name' then
        dfilter = 'search_name'
      else
        send_msg (target, "("..cmd..") VALID VALUE EITHER number OR name", ok_cb, false)
        return true
      end

      curr_time = os.time()
      try = os.execute('wget -qO- --connect-timeout='..TIMEOUT..' "https://www.ssm-einfo.my/member/index.php?id=uni" --post-data="'..dfilter..'='..args[3]..'&sess_id=&submit=Search" --no-check-certificate | egrep \'<br><strong>| bgcolor="#F7F7F7"\' | sed -e "s/<[^>]*[>]//g" -e "s/^[ \t]*//" -e "s/&nbsp;//g" > '..TMP_PATH..'/ssm'..curr_time..'.out')

      if try then
        -- check if file is empty
        if filesize(TMP_PATH..'/ssm'..curr_time..'.out') == 0 then
          send_msg (target, "("..cmd..") record NOT FOUND", ok_cb, false)
          return true
        end

        myvar = exec("wc -l "..TMP_PATH.."/ssm"..curr_time..".out | awk '{print $1/6}' | cut -f1 -d\".\" | xargs echo -n")

        if tonumber(myvar) > 12 then
          try = os.execute('head -n 73 '..TMP_PATH..'/ssm'..curr_time..'.out > '..TMP_PATH..'/ssmpartial'..curr_time..'.out')
          if try then
            send_msg (target, "("..cmd..") "..myvar.." record(s) found.\nDisplaying first 12:\n", ok_cb, false)
            send_text (target, TMP_PATH..'/ssmpartial'..curr_time..'.out', ok_cb, false)
          end
        else
          send_text (target, TMP_PATH..'/ssm'..curr_time..'.out', ok_cb, false)
        end

      else
        send_text (target, "("..cmd..") server takes too long to respond.\ntry again", ok_cb, false)
      end
    end
    return true
  end
end
