
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
		love.graphics.print("Paused", 110, 150)
		love.graphics.setFont(fonts.main)
		love.graphics.printf("Press Escape to continue", 115, 200, 100, "center")


	end


	function InGamePaused:handleKeyPress(key, isRepeat)


		if key == "escape" then
			changeScreen("inGame")
		end

	end



	return InGamePaused


