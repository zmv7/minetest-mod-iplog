local s = minetest.get_mod_storage()

minetest.register_on_authplayer(function(name, ip, is_success)
    local date = os.date()
    local hist = s:get_string(name)
    s:set_string(name,hist..date.." - "..ip..(is_success and "\n" or " /!\\ FAIL\n"))
end)

minetest.register_chatcommand("iplog",{
  description = "Get your IP history or another player's",
  privs = {interact=true},
  params = "[[playername] [latest_count] | [/purge]] | [/purge-all]",
  func = function(name,param)
    local nick = name
    local admin = minetest.check_player_privs(name,{server=true})
    local params = param:split(" ")
    if admin and params[1] then
        nick = params[1]
    end
    if admin and params[2] == "/purge" then
        s:set_string(nick,"")
        return true, "IPLog of "..nick.." purged"
    end
    if admin and params[1] == "/purge-all" then
        local count = 0
        for nick,hist in pairs(s:to_table().fields) do
            s:set_string(nick,"")
            count = count + 1
        end
        return true, "IPLog totally purged, there were "..count.." entries"
    end
    local lines = s:get_string(nick):split("\n")
    if not lines or #lines == 0 then
        return false, "There is no IPLog of "..nick
    end
    for i,line in ipairs(lines) do
        if not tonumber(params[2]) or i > #lines - tonumber(params[2]) then
            minetest.chat_send_player(name,line)
        end
    end
    return true, "IPLog of "..nick.." listed"
end})
