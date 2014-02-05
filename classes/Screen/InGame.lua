
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	InGame	= Screen:extends()



	function InGame:update(dt)
		testGame:update(dt)

		if keysHeld['down'] then
			self:handleKeyPress("down", true)
		end

	end


	function InGame:draw(hidePlayfield)

		testGame:draw(hidePlayfield)

		local i	= 0
		for k, v in pairs(keysHeld) do
			love.graphics.print(string.format("%s = %.2f", k, v), 0, 15 * i)
		end

	end


	function InGame:handleKeyPress(key, isRepeat)

		keytable	= {
			up		= "harddrop",
			left	= "left",
			right	= "right",
			down	= "down",
			x		= "cycle"
			}

		if keytable[key] then
			testGame:movePiece(keytable[key], false, isRepeat)
		end


		if key == "escape" then
			changeScreen("inGamePaused")
		end

	end



	return InGame


