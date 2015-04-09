ABS_PATH = debug.getinfo(1,"S").source:sub(2):match("(.*/)") or ''
package.path = package.path..";"..ABS_PATH.."?.lua"

require './tg_bot/vars'
require './tg_bot/utils'
require './tg_bot/bot'

function on_msg_receive(msg)
  if started == 0 then
    return
  end
  --if msg.out then
  --  return
  --end
  if msg.text ~= nil and -- not empty text
     msg.date > PITIME then -- not old msg
    bot(msg)
  end
end

function ok_cb(extra, success, result)
end

function on_our_id(id)
  our_id = id
end

function on_user_update(user, what)
  --vardump (user)
end

function on_chat_update(chat, what)
  --vardump (chat)
end

function on_secret_chat_update(schat, what)
  --vardump (schat)
end

function on_get_difference_end()
end

function cron()
  --do something
  postpone (cron, false, 1.0)
end

function on_binlog_replay_end ()
  started = 1
  postpone (cron, false, 1.0)
end
