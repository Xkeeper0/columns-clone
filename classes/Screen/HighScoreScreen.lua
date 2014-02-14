
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	HighScoreScreen	= Screen:extends({ scores = false, cursorPosition = 1, menu = false, list = "Easy" })


	--- Set up the title screen
	function HighScoreScreen:init()
		self.options	= {
			{ pos = 0,	text = "Easy",		ret = { func	= self.switchList, args = { "Easy"		}	}	},
			{ pos = 1,	text = "Normal",	ret = { func	= self.switchList, args = { "Normal"	}	}	},
			{ pos = 2,	text = "Hard",		ret = { func	= self.switchList, args = { "Hard"		}	}	},
			{ pos = 4,	text = "Back",		ret = { func	= self.goBackToTitle, args = {}	} },
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
	function HighScoreScreen:draw()

		drawTestBackground()

		love.graphics.setFont(fonts.big)
		love.graphics.printf("High Scores", 0, 480 / 4 - 20, 640, "center")

		love.graphics.setFont(fonts.main)

		if not self.scores then
			if testScores:fetchHighScores() then
				self.scores	= testScores:getHighScores()
			end
			love.graphics.printf("loading high scores", 0, 200, 640, "center" )
		else

			if self.scores[self.list] and #self.scores[self.list] > 0 then

				for k, v in pairs(self.scores[self.list]) do
					love.graphics.printf(k, 120, 150 + 18 * k, 40, "right")
					love.graphics.printf(v.name, 170, 150 + 18 * k, 300, "left")
					love.graphics.printf(v.score, 170, 150 + 18 * k, 300, "right")
				end
			else
				love.graphics.printf("no ".. self.list .." high scores", 0, 200, 640, "center" )

			end

		end


		self.menu:draw()



		love.graphics.setColor(255, 255, 255)

	end



	--- Callback for handling keypresses.
	-- @param key Key pressed
	-- @param isRepeat If this is an auto-repeated keypress
	function HighScoreScreen:handleKeyPress(key, isRepeat)

		local ret	= self.menu:handleKeyPress(key)
		if ret then
			ret.func(self, ret.args)
		end

	end


	function HighScoreScreen:switchList(args)
		local list	= unpack(args)
		self.list	= list

	end



	--- Quit the game (oh no!)
	function HighScoreScreen:goBackToTitle()
		changeScreen("titleScreen")
	end



	--- Callback for when this screen is switched in
	function HighScoreScreen:switchIn()
		self.menu:setCursorPosition(1)
	end


	return HighScoreScreen


