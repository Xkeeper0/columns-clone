
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	InGame	= Screen:extends({ game = false })



	--- Callback for updating this screen.
	-- @param dt Delta-time in seconds since last update
	function InGame:update(dt)
		self.game:update(dt)

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
		self.game:draw(hidePlayfield)

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
			self.game:movePiece(keytable[key], false, isRepeat)
		end


		if key == "escape" then
			changeScreen("inGamePaused", true, true)
		end

	end



	function InGame:startNewGame(playfield, blocks)

		self.game	= Game:new(playfield, blocks)
	end



	return InGame


