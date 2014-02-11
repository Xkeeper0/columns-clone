
	-- Require Lua Class System
	LCS	= require("classes.LCS")


	http	= require("socket.http");
	json	= require("ext.json.json");

	-- Create class
	HighScores	= LCS.class({ scores = false, test = false })




	function HighScores:something()
		
		-- please don't abuse this url, that would be mean
		local content, code, headers	= http.request("http://pastebin.com/raw.php?i=UbbjkVYg")
		self.test	= {
			code = code,
			headers = headers,
			content = json.decode(content),
			}

	end


	-- Fetching a JSON library for Lua, please wait...


	function HighScores:somethingElse()

		local i	= 1
		for k,v in pairs(self.test.content) do

			love.graphics.print(k .. ": ", 0, 18 * i)
			if type(v) == "table" then
				for kk,vv in pairs(v) do

					love.graphics.print(kk .. ": ", 100, 18 * i)
					if type(vv) == "table" then
						for kkk,vvv in pairs(vv) do

							love.graphics.print(kkk .. ": " .. tostring(vvv), 200, 18 * i)
							i	= i + 1
						end
					else
						love.graphics.print(tostring(vv), 200, 18 * i)

					end
				end
			else
				love.graphics.print(tostring(v), 100, 18 * i)
			end

			i	= i + 1
		end

	end

	return HighScores