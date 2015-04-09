return function(msg)
  cmd = "pi:mbsa"
  if args[1]==cmd then
    if #args == 2 then
      curr_ptt = os.time()
      try = os.execute('wget -qO- https://eps.mbsa.gov.my/pelawat/senarai_kompaun/ --post-data="no_akaun=&no_kenderaan='..args[2]..'&ic=&btn_submit=&submit=1&debug=" --no-check-certificate | sed -n \'/<table/,/<\\/table>/p\' | sed \'/<tr class="tr_title"/,/<\\/tr>/d\' | sed \'/<td colspan="7"/,/<\\/td>/d\' | sed -e "s/<[^>]*[>]//g" -e "s/^[ \t]*//" | sed -e \':a;N;$!ba;s/\\r\\n\\r\\n/\\n/g\' | sed -e \'s/-->//\' -e \'/&nbsp;/d\' -e \'s/Array*//\' > '..TMP_PATH..'/mbsa'..curr_ptt..'.out')

      if try then
        if filesize(TMP_PATH..'/mbsa'..curr_ptt..'.out') == 0 then
          send_msg (target, "("..cmd..") record NOT FOUND", ok_cb, false)
          return true
        end

        send_text (target, TMP_PATH.."/mbsa"..curr_ptt..".out", ok_cb, false)
      end
    else
      send_msg (target, "usage: "..cmd.." <VEHICLE-NO>", ok_cb, false)
    end
    return true
  end
end
