
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Block	= LCS.class({ gridW= false, gridH = false, quads = {}, animationTime = false })




	function Block:init(positions, width, height, imageWidth, imageHeight, gridWidth, gridHeight, animTime)

		for k, v in pairs(positions) do
			table.insert(self.quads, love.graphics.newQuad(v[1], v[2], width, height, imageWidth, imageHeight))
		end

		self.gridW			= gridWidth
		self.gridH			= gridHeight
		self.animationTime	= animTime or 1
	end



	function Block:draw(top, left, x, y, animationTimer)

		local animationTimer	= animationTimer or gTimer
		local animationFrame	= (#self.quads > 1) and (math.floor(math.fmod((animationTimer / self.animationTime), #self.quads)) + 1) or 1

		-- Offset because we start at 1-base
		x	= x - 1
		y	= y - 1

		love.graphics.draw(blockImage, self.quads[animationFrame], top + x * self.gridW, left + y * self.gridH)
		--love.graphics.print(animationFrame, 1, 1)

	end


	return Block