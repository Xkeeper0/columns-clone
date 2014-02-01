
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Screen	= LCS.class()



	function Screen:update(dt)


	end


	function Screen:draw()
		love.graphics.print("Default screen", 300, 200)

	end


	function Screen:handleKeyPress(key, isRepeat)

	end




	return Screen