local websocket = require "resty.websocket.server"

local wb, err = websocket:new({
    timeout = 5000,
    max_payload_len = 65535,
})
if not wb then
    ngx.log(ngx.ERR, "failed to new websocket: ", err)
    return ngx.exit(444)
end

while true do
    local data, typ, err = wb:recv_frame()
    if not data then
        if not string.find(err, "timeout", 1, true) then
            ngx.log(ngx.ERR, "failed to receive frame: ", err)
        end
        break
    end

    if typ == "close" then
        break
    elseif typ == "ping" then
        local ok, err = wb:send_pong()
        if not ok then
            ngx.log(ngx.ERR, "failed to send pong: ", err)
            break
        end
    elseif typ == "text" or typ == "binary" then
        local ok, err = wb:send_frame(true, typ, data)
        if not ok then
            ngx.log(ngx.ERR, "failed to send frame: ", err)
            break
        end
    end
end

wb:send_close()
