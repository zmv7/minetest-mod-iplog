local s = core.get_mod_storage()

core.register_on_authplayer(function(name, ip, is_success)
    local date = os.date()
    local hist = s:get_string(name)
    s:set_string(name,hist..date.." - "..ip..(is_success and "\n" or " /!\\ FAIL\n"))
end)

core.register_chatcommand("iplog",{
  description = "Get your IP history or another player's",
  privs = {interact=true},
  params = "[playername] [--purge] [--purge-all]",
  func = function(name,param)
    local nick = name
    local admin = core.check_player_privs(name,{server=true})
    if param and param ~= "" and admin then
        nick = param:match("^%S+")
    end
    if param:match("%-%-purge$") and admin then
        s:set_string(nick,"")
        return true, "IPLog of "..nick.." purged"
    elseif param:match("%-%-purge%-all") and admin then
        local stable = s:to_table().fields
        local count = 0
        for nick,hist in pairs(stable) do
            s:set_string(nick,"")
            count = count + 1
        end
        return true, "IPLog totally purged, there were "..count.." entries"
    end
    local lines = s:get_string(nick):split("\n")
    if not lines then
        return false, "Eror getting IPLog of "..nick
    end
    for _,line in ipairs(lines) do
        core.chat_send_player(name,line)
    end
    return true, "IPLog of "..nick.." listed"
end})
