return function(msg)
  cmd = "pi:gst"
  if args[1]==cmd then
    if #args == 2 then
      curr_ptt = os.time()
	  args[2] = string.format("%012d", args[2])

      try = os.execute('wget -qO- "http://arsyan.com/gst/'..args[2]..'" | grep -Po \'"id":.*?[^\\\\]",|"DataCompanyName":.*?[^\\\\]",|"DataCommenceDate":.*?[^\\\\]",|"DataStatus":.*?[^\\\\]",|},{\' | awk -F\'"[:] "\' \'{print $2}\' | sed -e "s/\\",//" > '..TMP_PATH..'/gst'..curr_ptt..'.out')

      if try then
	    if filesize(TMP_PATH..'/gst'..curr_ptt..'.out') == 0 then
	      send_msg (target, "(pi:gst) incorrect GST number", ok_cb, false)
          return true
	    end

	    send_text (target, TMP_PATH.."/gst"..curr_ptt..".out", ok_cb, false)
      end
    else
      send_msg (target, "usage: pi:gst <GST-ID>", ok_cb, false)
    end
    return true
  end
end
