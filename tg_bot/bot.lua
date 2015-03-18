plugin_list = scandir(HOME..'/plugins')

function bot(msg)
  args = getargs(msg.text)

  for key,value in pairs(plugin_list) do
    loaded_chunk = assert(loadfile(HOME..'/plugins/'..value))
    run = loaded_chunk()

    if run(msg) then
      return
    end
  end
end
