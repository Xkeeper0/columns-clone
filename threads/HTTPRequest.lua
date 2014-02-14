
	require("love.filesystem")
	require("love.timer")

	local http	= require("socket.http");
	local json	= require("ext.json.json");

	local input, output	= ...

	local function doWork()

		local url	= input:demand()
		local content, code, headers	= http.request(url)
		local result	= {
			code = code,
			headers = json.encode(headers),
			content = content,
			}

		love.timer.sleep(1)
		output:supply(result)
	end

	doWork()
