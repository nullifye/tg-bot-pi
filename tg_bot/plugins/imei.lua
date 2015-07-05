return function(msg)
  cmd = "pi:imei"
  if args[1]==cmd then
    if (#args == 1 or #args > 2) then
      send_msg (target, "📝 "..cmd.." <DEVICE-IMEI>", ok_cb, false)
    else
      curr_time = os.time()
      try = os.execute('curl -s "http://ecomm.sirim.my/SirimEnquiry/search_IMEI.aspx" -H "Cookie: ASP.NET_SessionId=aelbho5525uvwa4522wleg45" -H "Origin: http://ecomm.sirim.my" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.105 Safari/537.36 Vivaldi/1.0.162.9" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Cache-Control: no-cache" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" -H "X-MicrosoftAjax: Delta=true" -H "DNT: 1" -H "Referer: http://ecomm.sirim.my/SirimEnquiry/search_IMEI.aspx" --data "ctl00"%"24ContentPlaceHolder1"%"24TSM1=ctl00"%"24ContentPlaceHolder1"%"24UpdatePanel2"%"7Cctl00"%"24ContentPlaceHolder1"%"24btnSubmit&ctl00_ContentPlaceHolder1_TSM1_HiddenField=&ctl00"%"24userid=&ctl00"%"24screenname=&ctl00"%"24ContentPlaceHolder1"%"24txtSearch1='..args[2]..'&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE="%"2FwEPDwULLTE4MTEyNTk5MjgPFggeB1NvcnRFeHAFBE51bGweCVNvcnRPcmRlcmUeEWN1cnJlbnRQYWdlTnVtYmVyAgEeBklNRUlObwUPMDEzMTg2MDAxNTE5NTU0FgJmD2QWAgIDD2QWAgIND2QWAgIDD2QWAmYPZBYGAgcPDxYCHgRUZXh0ZWRkAg0PFgIeB1Zpc2libGVnFgJmD2QWAmYPZBYQAgEPPCsADQEADxYEHgtfIURhdGFCb3VuZGceC18hSXRlbUNvdW50AgFkFgJmD2QWBAIBD2QWDGYPZBYCAgEPDxYCHwQFATFkZAIBD2QWAgIBDw8WAh8EBRQwMTMxODYwMDE1MTk1NTQgICAgIGRkAgIPZBYCAgEPDxYCHwQFGFJBWEYvODVBLzExMTEvUygxMS0xODU1KWRkAgMPZBYCAgEPDxYCHwQFI1NBTUFSVCBJLU1PQklMRSAoTUFMQVlTSUEpIFNETi4gQkhEZGQCBA9kFgICAQ8PFgIfBAU8QTEzODcgW1N1cHBvcnQgODAyLjExYi9nL24gLCBCbHVldG9vdGggJiBHUFNdWzEgU0lNLCAxIElNRUldZGQCBQ9kFgICAQ8PFgIfBAUFQVBQTEVkZAICDw8WAh8FaGRkAgMPDxYCHwVoZGQCBQ8PFgQeB0VuYWJsZWRoHwVoZGQCBw8PFgQfBAUBMR8FaGRkAgsPDxYCHwVoZGQCDQ8PFgQfBAUBMR8FaGRkAg8PDxYEHwhoHwVoZGQCEQ8PFgIfBWhkZAIPDw8WAh8FZ2RkGAEFIWN0bDAwJENvbnRlbnRQbGFjZUhvbGRlcjEkZ3ZfSU1FSQ88KwAKAQgCAWRSkqaIZcqfvFd63tDDe3GqweDUWA"%"3D"%"3D&__VIEWSTATEGENERATOR=4F4485D1&__ASYNCPOST=true&ctl00"%"24ContentPlaceHolder1"%"24btnSubmit=Search" --compressed | sed -n \'/<tr class="gvrow">/,/<\\/tr>/p\' | sed -e "s/<[^>]*[>]//g" -e "s/^[ \t]*//" -e "s/View Details//g" | sed -e \':a;N;$!ba;s/\\r\\n\\r\\n/\\n/g\' > '..TMP_PATH..'/imei'..curr_time..'.out')

      if try then
        -- check if file is empty
        if filesize(TMP_PATH..'/imei'..curr_time..'.out') == 0 then
          send_msg (target, "("..cmd..") no record found.\nmaybe this is an Approved Products (AP) set.", ok_cb, false)
          return true
        end

        send_text (target, TMP_PATH..'/imei'..curr_time..'.out', ok_cb, false)
      else
        send_text (target, "("..cmd..") server takes too long to respond.\ntry again", ok_cb, false)
      end
    end
    return true
  end
end