
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	TitleScreen	= Screen:extends({ options = {}, cursorPosition = 1 })


	--- Set up the title screen
	function TitleScreen:init()
		self.options	= {
			{ text = "Play",		func = self.startGame		},
			{ text = "Crash!",		func = self.startOptions	},
			{ text = "Quit",		func = self.quit			},
			}

	end



	function TitleScreen:update(dt)


	end


	function TitleScreen:draw()

		drawTestBackground()

		love.graphics.setFont(fonts.big)
		love.graphics.printf("Columns Clone", 0, 480 / 4 - 20, 640, "center")

		love.graphics.setFont(fonts.main)
		love.graphics.printf("Up: Hard-drop\nLeft / Right: Move piece\nDown: Drop\nX: Rotate\n\nEscape: Pause", 0, 200, 640, "center")

		love.graphics.setColor(160, 140, 255)
		love.graphics.printf("Version ".. version, 0, 465, 634, "right")
		love.graphics.printf("http://rustedlogic.net/\nhttps://github.com/Xkeeper0/columns-clone", 5, 452, 620, "left")
		love.graphics.setColor(255, 255, 255)

		self:drawOptions(640 / 2, 18 * 18)

		love.graphics.print(self.cursorPosition, 0, 50)
	end


	function TitleScreen:drawOptions(x, y)

		for k, v in pairs(self.options) do
			love.graphics.printf(v.text, x - 50, y + (18 * k), 100, "center")
		end

		love.graphics.setColor(150, 120, 255, 60)
		love.graphics.polygon("fill", {
			x - 50, y + (18 * self.cursorPosition),
			x + 50, y + (18 * self.cursorPosition),
			x + 50, y + (18 * self.cursorPosition) + 18,
			x - 50, y + (18 * self.cursorPosition) + 18,
			})
		love.graphics.setColor(255, 255, 255)

	end


	function TitleScreen:handleKeyPress(key, isRepeat)

		if key == "up" or key == "down" then
			sounds.move:stop()
			sounds.move:play()
			local dir	= (key == "up") and -1 or 1
			self.cursorPosition		= math.fmod((self.cursorPosition - 1 + dir), #self.options) + 1
			if self.cursorPosition < 1 then
				self.cursorPosition	= #self.options
			end

		end


		if key == "return" then
			self.options[self.cursorPosition].func(self)
		end

	end


	function TitleScreen:startGame()
		changeScreen("inGame")
	end


	function TitleScreen:startOptions()
		changeScreen("options")
	end


	function TitleScreen:quit()
		love.event.quit()
	end




	function TitleScreen:switchIn()
		self.cursorPosition	= 1
	end


	return TitleScreen


