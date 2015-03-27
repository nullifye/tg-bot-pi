return function(msg)
  cmd = "pi:$"
  if args[1]==cmd then
    local cV, cF, ct, outp

    if #args == 4 then
      cV = args[2]
      cF = args[3]
      cT = args[4]
    elseif #args == 2 then
      cV = args[2]
      cF = 'usd'
      cT = 'myr'
    else
      cV = 'args_no_valid'
    end

    if cV == 'args_no_valid' then
      outp = 'usage: pi:$ <VALUE> [<CURRENCY_FROM> <CURRENCY_TO>]'
    else
      outp = exec("wget -qO- 'http://www.google.com/finance/converter?a="..cV.."&from="..cF.."&to="..cT.."' |  sed '/res/!d;s/<[^>]*>//g'")
    end 

    send_msg (target, outp, ok_cb, false)
    return true
  end
end
