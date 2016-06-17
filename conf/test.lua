-- @Author: lushijie
-- @Date:   2016-05-15 15:23:49
-- @Last Modified by:   lushijie
-- @Last Modified time: 2016-05-29 15:41:16
-- access_by_lua_file '/usr/local/lua_test/my_access_limit.lua';

ngx.req.read_body()

local redis = require "redis"
local red = redis.new()
red.connect(red, '127.0.0.1', '6379')

local myIP = ngx.req.get_headers()["X-Real-IP"]
if myIP == nil then
   myIP = ngx.req.get_headers()["x_forwarded_for"]
end
if myIP == nil then
   myIP = ngx.var.remote_addr
end

if ngx.re.match(ngx.var.uri,"^.*$") then
	-- local method = ngx.var.request_method
	local args = ngx.req.get_uri_args() 
	-- lua-nginx-module#name
	local hasIP = red:sismember('black.ip',myIP)
	local hasIMSI = red:sismember('black.imsi',args.imsi)
	local hasTEL = red:sismember('black.tel',args.tel)

	if hasIP==1 or hasIMSI==1 or hasTEL==1 then
	    ngx.say("This is a 'Black List' request")
	else
		ngx.say("Bingo")
	end

end
