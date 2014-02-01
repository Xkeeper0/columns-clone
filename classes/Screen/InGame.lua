
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	InGame	= Screen:extends()



	function InGame:update(dt)
		testGame:update(dt)

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
			testGame:movePiece(keytable[key])
		end


		if key == "escape" then
			changeScreen("inGamePaused")
		end

	end



	return InGame


	