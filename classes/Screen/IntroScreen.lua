
	-- Require Lua Class System
	LCS	= require("classes.LCS")


	-- Create class
	IntroScreen	= Screen:extends({ animStart = 1, animTime = 3, animEnd = 1})


	--- Callback for updating this screen.
	-- @param dt Delta-time in seconds since last update
	function IntroScreen:update(dt)

		if gTimer > (self.animStart + self.animTime + self.animEnd) then
			changeScreen('titleScreen')
		end

	end


	--- Callback for drawing this screen
	-- Draw our fancy logo and some animations
	function IntroScreen:draw()

		local c	= 0
		local brightness	= 255
		if gTimer < self.animStart then
			c	= (gTimer) / self.animStart * brightness
			love.graphics.setBackgroundColor(c, c, c)
		elseif gTimer > (self.animStart + self.animTime) then
			c	= brightness - ((gTimer - (self.animStart + self.animTime)) / self.animEnd * brightness)
			love.graphics.setBackgroundColor(c, c, c)

		else
			c	= brightness
		end

		local sOffset	= (c / brightness) * 2 

		love.graphics.setColor(c, c, c, 60)
		love.graphics.draw(logoImage, 640 / 2 + sOffset, 480 / 4 + sOffset, 0, 1, 1, 276 / 2, 100 / 2)

		love.graphics.setColor(c, c, c)
		love.graphics.draw(logoImage, 640 / 2 - sOffset, 480 / 4 - sOffset, 0, 1, 1, 276 / 2, 100 / 2)

		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(fonts.big)
		--love.graphics.printf("~ rl logo ~", 0, 150, 640, "center")

		love.graphics.setFont(fonts.main)
		love.graphics.printf("(C) Xkeeper 2014\nhttp://rustedlogic.net", 0, 180, 640, "center")
		love.graphics.setColor(255, 255, 255)


	end


	--- Callback for handling keypresses.
	-- @param key Key pressed
	-- @param isRepeat If this is an auto-repeated keypress
	function IntroScreen:handleKeyPress(key, isRepeat)

		if key == "return" then
			love.graphics.setBackgroundColor(0, 0, 0)
			changeScreen("titleScreen")
		end

	end



	return IntroScreen


