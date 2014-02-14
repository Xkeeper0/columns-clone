
	-- Require Lua Class System
	LCS	= require("classes.LCS")


	http	= require("socket.http");
	json	= require("ext.json.json");

	-- Create class
	HighScores	= LCS.class({ scores = false, thread = false,  channels = {} })



	function HighScores:init()
		self.channels = {input = love.thread.newChannel(), output = love.thread.newChannel() }
	end


	function HighScores:fetchHighScores()

		if not self.thread and not self.scores then
			-- Haven't started the thread yet
			self.thread	= love.thread.newThread("threads/HTTPRequest.lua")
			self.channels.input:push("http://pastebin.com/raw.php?i=UbbjkVYg")
			self.thread:start(self.channels.input, self.channels.output)
			return false

		elseif not self.scores then
			local err	= self.thread:getError()
			if err then
				error(err)
			end

			local result	= self.channels.output:pop()
			if result then
				self.scores	= json.decode(result.content)
				return true
			end
		else
			return true
		end

	end


	function HighScores:getHighScores()
		return self.scores

	end



	return HighScores