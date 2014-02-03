
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	IntroScreen	= Screen:extends({ animStart = .5, animTime = 2, animEnd = .5})


	function IntroScreen:update(dt)

		if gTimer > (self.animStart + self.animTime + self.animEnd) then
			changeScreen('titleScreen')
		end

	end


	function IntroScreen:draw()

		if gTimer < self.animStart then
			local c	= (gTimer) / self.animStart * 127
			love.graphics.setBackgroundColor(c, c, c)
		elseif gTimer > (self.animStart + self.animTime) then
			local c	= 127 - ((gTimer - (self.animStart + self.animTime)) / self.animEnd * 127)
			love.graphics.setBackgroundColor(c, c, c)
		end

		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(fonts.big)
		love.graphics.printf("~ rl logo ~", 0, 150, 640, "center")

		love.graphics.setFont(fonts.main)
		love.graphics.printf("(C) Xkeeper 2014", 0, 200, 640, "center")
		love.graphics.setColor(255, 255, 255)



	end


	function IntroScreen:handleKeyPress(key, isRepeat)

		if key == "return" then
			love.graphics.setBackgroundColor(0, 0, 0)
			changeScreen("titleScreen")
		end

	end



	return IntroScreen


