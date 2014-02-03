
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Block	= LCS.class({ gridW= false, gridH = false, quad	= false })




	function Block:init(xPos, yPos, width, height, imageWidth, imageHeight, gridWidth, gridHeight)
		self.quad	= love.graphics.newQuad(xPos, yPos, width, height, imageWidth, imageHeight)
		self.gridW	= gridWidth
		self.gridH	= gridHeight

	end



	function Block:draw(top, left, x, y)

		love.graphics.draw(blockImage, self.quad, top + x * self.gridW, left + y * self.gridH)

	end


	return Block