
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	InGame	= Screen:extends()



	--- Callback for updating this screen.
	-- @param dt Delta-time in seconds since last update
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


	--- Callback for drawing this screen
	-- @param hidePlayfield If the playfield should be hidden from view
	function InGame:draw(hidePlayfield)

		drawTestBackground()
		testGame:draw(hidePlayfield)

	end


	--- Callback for handling keypresses.
	-- @param key Key pressed
	-- @param isRepeat If this is an auto-repeated keypress
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
			changeScreen("inGamePaused", true, true)
		end

	end



	return InGame


