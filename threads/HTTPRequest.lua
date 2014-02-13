

	require("love.filesystem")

	local http	= require("socket.http");
	local json	= require("ext.json.json");

	local input, output	= ...

	local function doWork()

		print("Thread starting up")
		local url	= input:demand()
		print("URL: ".. url)
		local content, code, headers	= http.request(url)
		local result	= {
			code = code,
			headers = json.encode(headers),
			content = content,
			}

		print("HTTP request OK")
		output:supply(result)
		print("Result supplied, bye")
	end

	doWork()
