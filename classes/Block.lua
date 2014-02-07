
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Block	= LCS.class({ gridW= false, gridH = false, quads = {}, animationTime = false })



	--- Initialize a new block type
	-- @param	positions	Table of positions for this block's animations
	-- @param	width		Width of this block graphic
	-- @param	height		Height of this block graphic
	-- @param	imageWidth	Width of the base image
	-- @param	imageHeight	Height of the base image
	-- @param	gridWidth	Width of the playfield grid
	-- @param	gridHeight	Height of the playfield grid
	-- @param	animTime	Time each frame should be displayed
	function Block:init(positions, width, height, imageWidth, imageHeight, gridWidth, gridHeight, animTime)

		for k, v in pairs(positions) do
			table.insert(self.quads, love.graphics.newQuad(v[1], v[2], width, height, imageWidth, imageHeight))
		end

		self.gridW			= gridWidth
		self.gridH			= gridHeight
		self.animationTime	= animTime or 1
	end


	--- Draw a block somewhere on the screen
	-- @param	left			Leftmost X position
	-- @param	top				Topmost Y position
	-- @param	x				X position within grid
	-- @param	y				Y position within grid
	-- @param	animationTimer	Position in this block's animation series
	function Block:draw(left, top, x, y, animationTimer)

		local animationTimer	= animationTimer or gTimer
		local animationFrame	= (#self.quads > 1) and (math.floor(math.fmod((animationTimer / self.animationTime), #self.quads)) + 1) or 1

		-- Offset because we start at 1-base
		x	= x - 1
		y	= y - 1

		love.graphics.draw(blockImage, self.quads[animationFrame], left + x * self.gridW, top + y * self.gridH)
		--love.graphics.print(animationFrame, 1, 1)

	end


	return Block