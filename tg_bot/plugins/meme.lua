return function(msg)
  cmd = "pi:meme"
  if args[1]==cmd then
    local command, iid, text1, text2, outp
    if #args == 5 and args[2] == "caption" then
      command = args[2]
      iid = args[3]
      text1 = args[4]
      text2 = args[5]
    elseif #args == 2 and args[2] == "list" then
      command = args[2]
    else
      command = 'args_no_valid'
    end

    if command == 'args_no_valid' then
      outp = 'usage: pi:meme list\npi:meme caption <IID> <TEXT_TOP> <TEXT_BOTTOM>'
    elseif command == 'list' then
      outp = exec(HOME.."/scripts/meme list")
    elseif command == 'caption' then
      imgfile = exec(HOME.."/scripts/meme caption "..iid.." "..text1..
        " "..text2.." "..replyto(msg))
      outp = ""
      postpone (send_ph, false, 3.0)
    end 

    send_msg (replyto(msg), outp, ok_cb, false)
    return true
  end
end
