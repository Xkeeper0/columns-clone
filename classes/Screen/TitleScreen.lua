
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	TitleScreen	= Screen:extends()


	function TitleScreen:update(dt)


	end


	function TitleScreen:draw()

		love.graphics.setFont(fonts.big)
		love.graphics.printf("Columns Clone", 0, 480 / 4 - 20, 640, "center")

		love.graphics.setFont(fonts.main)
		love.graphics.printf("Enter: start\n\nUp: Hard-drop\nLeft / Right: Move piece\nDown: Drop\n\nX: Rotate\n\nEscape: Pause", 0, 200, 640, "center")

		love.graphics.setColor(160, 140, 255)
		love.graphics.printf("Version ".. version, 0, 465, 634, "right")
		love.graphics.printf("http://rustedlogic.net/\nhttps://github.com/Xkeeper0/columns-clone", 5, 452, 620, "left")
		love.graphics.setColor(255, 255, 255)



	end


	function TitleScreen:handleKeyPress(key, isRepeat)

		if key == "return" then
			changeScreen("inGame")
		end

	end



	return TitleScreen


