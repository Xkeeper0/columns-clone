
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Options	= Screen:extends({ options = {}, cursorPosition = 1 })


	--- Set up the title screen
	function Options:init()
		self.options	= {
			{ text = "Start game (again)",		func = self.startGame		},
			{ text = "Oh no!",					func = self.startOptions	},
			{ text = "Back",					func = self.goBackToTitle	},
			}

	end



	--- Callback for drawing this screen
	function Options:draw()

		drawTestBackground()

		love.graphics.setFont(fonts.big)
		love.graphics.printf("Options", 0, 480 / 4 - 20, 640, "center")

		love.graphics.setFont(fonts.main)
		love.graphics.printf("totally not a bad titlescreen hack, nope", 0, 200, 640, "center")


		self:drawOptions(640 / 2, 18 * 18)
	end


	--- Draw the options on the screen
	-- @param x X position on screen
	-- @param y Y position on screen
	function Options:drawOptions(x, y)

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


	--- Callback for handling keypresses.
	-- @param key Key pressed
	-- @param isRepeat If this is an auto-repeated keypress
	function Options:handleKeyPress(key, isRepeat)

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



	--- Start the game screen
	function Options:startGame()
		changeScreen("inGame")
	end

	--- Start the options screen
	function Options:startOptions()
		changeScreen("options")
	end

	--- Quit the game (oh no!)
	function Options:goBackToTitle()
		changeScreen("titleScreen")
	end



	--- Callback for when this screen is switched in
	function Options:switchIn()
		self.cursorPosition	= 1
	end


	return Options


