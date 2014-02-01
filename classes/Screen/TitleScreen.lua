
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	TitleScreen	= Screen:extends()


	function TitleScreen:update(dt)


	end


	function TitleScreen:draw()

		love.graphics.setFont(fonts.big)
		love.graphics.printf("Columns Clone", 0, 150, 640, "center")

		love.graphics.setFont(fonts.main)
		love.graphics.printf("Enter: start\n\nUp: Hard-drop\nLeft / Right: Move piece\nDown: Drop\n\nX: Rotate\n\nEscape: Pause", 0, 200, 640, "center")



	end


	function TitleScreen:handleKeyPress(key, isRepeat)

		if key == "return" then
			changeScreen("inGame")
		end

	end



	return TitleScreen


	