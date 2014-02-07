
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	InGame	= Screen:extends()



	function InGame:update(dt)
		testGame:update(dt)

		if keysHeld['down'] then
			self:handleKeyPress("down", true)
		end

		if keysHeld['left'] then
			self:handleKeyPress("left", true)
		end

		if keysHeld['right'] then
			self:handleKeyPress("right", true)
		end

	end


	function InGame:draw(hidePlayfield)

		testGame:draw(hidePlayfield)

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


