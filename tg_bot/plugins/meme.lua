return function(msg)
  cmd = "pi:meme"
  if args[1]==cmd then
    if (#args == 1 or #args > 4) then
      send_msg (target, "usage: "..cmd.." list\nusage: "..cmd.." <TEMPLATE> <TOP-TEXT> [<BOTTOM-TEXT>]", ok_cb, false)
    else
      if #args == 2 then
        if args[2]=='list' then
          outp = "TEMPLATE:\n"
          for key,value in sort_pairs(meme) do
            outp=outp..key.."   "
          end
        else
          outp = "usage: "..cmd.." list"
        end
        send_msg (target, outp, ok_cb, false)
        return true
      end

      if meme[args[2]]~=nil then
        args[2] = meme[args[2]]
      end

      args[4] = args[4] or " "

      local replacements = {
        ["&" ] = '%26', 
        ["%" ] = '%25'
      }
      args[3] = string.gsub(args[3], '[&<>\n]', replacements)
      args[4] = string.gsub(args[4], '[&<>\n]', replacements)

      curr_time = os.time()
      try = os.execute('wget -qO- https://api.imgflip.com/caption_image --post-data "template_id='..args[2]..'&username=PiABH&password=raspiabh&text0='..args[3]..'&text1='..args[4]..'" | grep -Po \'"http:.*?"\' | sed -e "s/\\"//g" | xargs -n 1 curl -so '..TMP_PATH..'/meme'..curr_time..'.jpg')

      if try then
        send_photo (target, TMP_PATH.."/meme"..curr_time..".jpg", ok_cb, false)
      end
    end
    return true
  end
end
