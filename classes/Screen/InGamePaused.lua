
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	InGamePaused	= InGame:extends({ menu	= false })


	function InGamePaused:init()

		local options	= {
			{ pos = 0,	text = "Resume",	ret = { func	= self.resumeGame }	},
			{ pos = 2,	text = "Quit",		ret = { func	= self.quitToMenu }	},
			}

		self.menu	= SimpleMenu:new(
			options,
			1,
			18 * 4,
			18 * 12,
			18 * 6
			)
	end


	function InGamePaused:update(dt)


	end


	function InGamePaused:draw()

		-- Draw the InGame screen while we're here
		screens.inGame:draw(true)

		--self:getClass():draw(true)

		love.graphics.setFont(fonts.big)
		love.graphics.printf("Paused", 18 * 4, 18 * 7, 18 * 6, "center")
		love.graphics.setFont(fonts.main)
		--love.graphics.printf("Enter:\nContinue", 18 * 4, 18 * 12, 18 * 6, "center")

		self.menu:draw()


	end


	function InGamePaused:handleKeyPress(key, isRepeat)

		local ret	= self.menu:handleKeyPress(key)
		if ret then
			ret.func(self)
		end

		if key == "escape" then
			self:resumeGame()
		end

	end


	function InGamePaused:resumeGame()
		changeScreen("inGame", true, true)
	end


	function InGamePaused:quitToMenu()
		changeScreen("inGame", true, true)
		changeScreen("titleScreen")
	end


	function InGamePaused:switchIn()
		self.menu:setCursorPosition(1)
	end


	return InGamePaused


