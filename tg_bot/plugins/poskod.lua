return function(msg)
  cmd = "pi:poskod"
  if args[1]==cmd then
    if (#args == 1 or #args > 2) then
      send_msg (target, "usage: "..cmd.." <AREA-NAME>", ok_cb, false)
    else
      curr_time = os.time()
      try = os.execute('wget -qO- http://malaysiapostcode.com/search --post-data="keyword='..args[2]..'" | sed -n "/<tbody/,/<\\/tbody>/p" | sed -e "s/<[^>]*[>]//g" -e "s/^[ \t]*//" -e "s/&nbsp;//g" | sed -e ":a;N;$!ba;s/\\r\\n\\r\\n/\\n/g" > '..TMP_PATH..'/poskod'..curr_time..'.out')

      if try then
        send_text (target, TMP_PATH.."/poskod"..curr_time..".out", ok_cb, false)
      else
        send_text (target, "("..cmd..") server take too long to respond.\ntry again", ok_cb, false)
      end
    end
    return true
  end
end
