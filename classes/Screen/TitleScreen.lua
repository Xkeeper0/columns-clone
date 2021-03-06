
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	TitleScreen	= Screen:extends({ options = {}, cursorPosition = 1, menu = false })


	--- Set up the title screen
	function TitleScreen:init()
		self.options	= {
			{ pos = 0,	text = "Easy",		ret = { func	= self.startGame, args	= { false, {1, 2, 3, 4}		}	}	},
			{ pos = 1,	text = "Normal",	ret = { func	= self.startGame, args	= { false, {1, 2, 3, 4, 5}		}	}	},
			{ pos = 2,	text = "Hard",		ret = { func	= self.startGame, args	= { false, {1, 2, 3, 4, 5, 6}	}	}	},
		--	{ pos = 1,	text = "Options",	ret = self.startOptions	},
			{ pos = 4,	text = "Quit",		ret = { func	= self.quit, args = {}	} },
			}

		self.menu	= SimpleMenu:new(
			self.options,
			1,
			18 * 14,
			18 * 18,
			18 * 7
			)

	end



	--- Callback for drawing this screen
	function TitleScreen:draw()

		drawTestBackground()

		love.graphics.setFont(fonts.big)
		love.graphics.printf("Columns Clone", 0, 480 / 4 - 20, 640, "center")

		love.graphics.setFont(fonts.main)
		love.graphics.printf("Up: Hard-drop\nLeft / Right: Move piece\nDown: Drop\nX: Rotate\n\nEscape: Pause", 0, 200, 640, "center")

		--self:drawOptions(640 / 2, 18 * 18)

		self.menu:draw()

		--[[
		if gTimer - self.introTimer	< self.fadeInTime then

			local	b	= 255 - ((gTimer - self.introTimer) / self.fadeInTime) * 255

			love.graphics.setColor(0, 0, 0, b)
			love.graphics.polygon("fill", {
				0,		0,
				640,	0,
				640,	480,
				0,		480,
				})

		end

		--]]

		love.graphics.setColor(255, 255, 255)

	end


	--- Draw the options on the screen
	-- @param x X position on screen
	-- @param y Y position on screen
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


	--- Callback for handling keypresses.
	-- @param key Key pressed
	-- @param isRepeat If this is an auto-repeated keypress
	function TitleScreen:handleKeyPress(key, isRepeat)

		local ret	= self.menu:handleKeyPress(key)
		if ret then
			ret.func(self, ret.args)
		end

	end



	--- Start the game screen
	function TitleScreen:startGame(args)
		screens.inGame:startNewGame(unpack(args))
		changeScreen("inGame")
	end

	--- Start the options screen
	function TitleScreen:startOptions()
		changeScreen("options")
	end

	--- Quit the game (oh no!)
	function TitleScreen:quit()
		love.event.quit()
	end



	--- Callback for when this screen is switched in
	function TitleScreen:switchIn()
		self.menu:setCursorPosition(1)
		self.introTimer		= gTimer
	end


	return TitleScreen


