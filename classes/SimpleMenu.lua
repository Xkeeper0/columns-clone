
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	SimpleMenu	= LCS.class({ options = {}, cursorPosition = 1, x = 0, y = 0, w = 0 })



	--- Initialize a new SimpleMenu
	-- @param options			Options list, as a table
	-- @param cursorPosition	Default cursor position
	-- @param x					X position
	-- @param y					Y position
	-- @param w					Width of menu
	function SimpleMenu:init(options, cursorPosition, x, y, w)

		self.options		= options
		self.cursorPosition	= math.inrange(cursorPosition, 1, #options) and cursorPosition or 1
		self.x				= x
		self.y				= y
		self.w				= w

	end



	--- Draw the options on the screen
	function SimpleMenu:draw()

		for k, v in pairs(self.options) do
			love.graphics.printf(v.text, self.x, self.y + (18 * v.pos) + 2, self.w, "center")
		end


		love.graphics.setColor(150, 120, 255, 60)
		love.graphics.polygon("fill", {
			self.x         , self.y + (18 * self.options[self.cursorPosition].pos),
			self.x + self.w, self.y + (18 * self.options[self.cursorPosition].pos),
			self.x + self.w, self.y + (18 * self.options[self.cursorPosition].pos) + 18,
			self.x         , self.y + (18 * self.options[self.cursorPosition].pos) + 18,
			})
		love.graphics.setColor(255, 255, 255)

	end


	--- Move the selection in the given direction
	-- @param direction	Direction to move (-1 or 1)
	function SimpleMenu:moveCursor(direction)

		sounds.move:stop()
		sounds.move:play()
		self.cursorPosition		= math.fmod((self.cursorPosition - 1 + direction), #self.options) + 1
		if self.cursorPosition < 1 then
			self.cursorPosition	= #self.options
		end

	end



	--- Move the selection in the given direction
	-- @param pos	New position to set to (default: 1)
	function SimpleMenu:setCursorPosition(pos)

		self.cursorPosition		= pos and (math.fmod(pos - 1, #self.options) + 1) or 1

	end





	--- Move the selection in the given direction
	-- @param direction	Direction to move (-1 or 1)
	function SimpleMenu:selectOption()
		return self.options[self.cursorPosition].ret

	end


	function SimpleMenu:handleKeyPress(key)

		if key == "up" or key == "down" then
			local dir	= (key == "up") and -1 or 1
			self:moveCursor(dir)
		elseif key == "return" then
			local ret	= self:selectOption()
			return ret
		end

		return nil
	end


	return SimpleMenu
