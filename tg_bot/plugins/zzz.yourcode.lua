return function(msg)
  if msg.from.phone == '42777' then
    fwd_msg ('user#id2529650', msg.id, ok_cb, false)
    return true
  end
end
