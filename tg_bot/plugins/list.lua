
return function(msg)
  cmd0 = "pi:list"
  cmd1 = "pi:help"
  if command(msg,cmd0) or command(msg,cmd1) then
    outp = [[
      PI: COMMANDS
      pi:$
      pi:9gag
      pi:expand
      pi:fbvid
      pi:gold
      pi:gst
      pi:kastam
      pi:list
      pi:mbsa
      pi:meme
      pi:myid
      pi:poslaju
      pi:qr
      pi:quran
      pi:shorten
      pi:spr
      pi:time
      pi:webshot
      pi:yt
    * pi:boottime
    * pi:cputemp
    * pi:loadavg
    * pi:ramusg
    * pi:reload
    * pi:uptime
    ]]
    send_msg (target, outp, ok_cb, false)
    return true
  end
end
