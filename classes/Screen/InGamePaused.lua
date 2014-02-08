
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	InGamePaused	= InGame:extends()



	function InGamePaused:update(dt)


	end


	function InGamePaused:draw()

		-- Draw the InGame screen while we're here
		--self:super('draw')
		--screens.inGame:draw()

		self:getClass():draw(true)

		love.graphics.setFont(fonts.big)
		love.graphics.printf("Paused", 18 * 4, 18 * 7, 18 * 6, "center")
		love.graphics.setFont(fonts.main)
		love.graphics.printf("Enter:\nContinue", 18 * 4, 18 * 12, 18 * 6, "center")


	end


	function InGamePaused:handleKeyPress(key, isRepeat)


		if key == "escape" then
			changeScreen("inGame", true, true)
		end

	end



	return InGamePaused


