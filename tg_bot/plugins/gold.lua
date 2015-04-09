return function(msg)
  cmd = "pi:gold"
  if args[1]==cmd then
    if (#args == 1 or #args > 3) then
      send_msg (target, "usage: "..cmd.." 24h|3d|30d|6m|1y|2y|5y|10y [myr|usd]", ok_cb, false)
      return true
    end

    if gold[args[2]]==nil then
      send_msg (target, "("..cmd..") '"..args[2].."' is INVALID", ok_cb, false)
      return true
    end

    args[2] = gold[args[2]]

    if args[3]~='usd' then
      args[3]='myr'
    end

    curr_time = os.time()
    try = os.execute('curl http://goldprice.org/'..args[2]..args[3]..'.png -so '..TMP_PATH..'/gold'..curr_time..'.png')

    if try then
      send_photo (target, TMP_PATH.."/gold"..curr_time..".png", ok_cb, false)
    end
    return true
  end
end
