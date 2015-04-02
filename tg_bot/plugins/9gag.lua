return function(msg)
  cmd = "pi:9gag"
  if command(msg,cmd) then
    local found = false
	while not found do
	  rand = math.random(1,767800)
      found = http_code("http://m.9gag.com/gag/"..rand, "200")
	end

	if found then
      curr_time = os.time()
      try = os.execute('wget -qO- --load-cookies "'..HOME..'/cookies/9gag.cookie" http://m.9gag.com/gag/'..rand..' | sed -n \'/<div class="badge-entry-content">/,/<\\/div>/p\' > '..TMP_PATH..'/9gag'..curr_time..'.out')

      if try then
	    gettitle = exec('cat '..TMP_PATH..'/9gag'..curr_time..'.out | sed -n \'s/.*alt="\\([^"]*\\).*/\\1/p\'')
		gettitle = string.gsub(gettitle, "&#039;", "'")
		gettitle = string.gsub(gettitle, "&quot;", "\"")
        send_msg (target, ""..gettitle, ok_cb, false)

		imglink = exec('cat '..TMP_PATH..'/9gag'..curr_time..'.out | sed -n \'s/.*data-image="\\([^"]*\\).*/\\1/p\'') -- gif
		imglink2 = exec('cat '..TMP_PATH..'/9gag'..curr_time..'.out | sed -n \'s/.*src="\\([^"]*\\).*/\\1/p\'') -- jpg

		YT = string.find(imglink2, "youtube.com/embed/", nil, true) ~= nil -- youtube
        if YT then
		  send_msg (target, "(pi:9gag) the post is a video embedded from YouTube\n"..imglink2, ok_cb, false)
		  return true
		end

		if imglink == "" then
		  imglink = imglink2
		  imglink = string.gsub(imglink, "_460s", "_700b") -- change .jpg size
		else
		  send_msg (target, "(pi:9gag) GIF uploading...", ok_cb, false)
		end
		imglink = string.gsub(imglink, "\n", "") -- trim newline

		path,lnk,ext = string.match(imglink, "(.-)([^\\]-([^%.]+))$") -- get file extention
		getimg = os.execute('curl "'..imglink..'" -so '..TMP_PATH..'/9gag_'..rand..'.'..ext)
        if getimg then
          send_document (target, TMP_PATH..'/9gag_'..rand..'.'..ext, ok_cb, false)
		end

      end
	end
    return true
  end
end
