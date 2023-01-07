# minetest-mod-iplog
Per-player IP logging at the moment of authenfication
### Usage
* `/iplog` - all players with `interact` priv can use it to view own IP history
* `/iplot <playername>` - admins(with `server` priv) can use it to view IP history of any player
* `/iplog <playername> --purge` - admins can purge IP history of any player
* `/iplog --purge-all` - admins can purge whole *mod_storage* of IPLog mod.
