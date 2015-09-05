return function(msg)
  cmd = "pi:gst"
  if args[1]==cmd then
    if (#args ~= 3) then
      send_msg (target, "📝 "..cmd.." incl|excl <VALUE>", ok_cb, false)
    else
      RM = tonumber(args[3])

      if RM then
        if args[2] == 'excl' then
          GST = 0.06*RM
          outp = "before GST\t: RM "..string.format("%.2f", RM).."\nGST (6%)\t: RM "..string.format("%.2f", GST).."\nafter GST\t: RM "..string.format("%.2f", RM+GST)
        elseif args[2] == 'incl' then
          GST = 6*RM/106
          outp = "after GST\t: RM "..string.format("%.2f", RM).."\nGST (6%)\t: RM "..string.format("%.2f", GST).."\nbefore GST\t: RM "..string.format("%.2f", RM-GST)
        else
          outp = "("..cmd..") valid arg is either 'incl' (inclusive) or 'excl' (exclusive)"
        end

        send_msg (target, outp, ok_cb, false)
      else
        send_msg (target, "("..cmd..") '"..args[3].."' is NOT a valid amount", ok_cb, false)
      end
    end
    return true
  end
end
