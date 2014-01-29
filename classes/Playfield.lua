
	-- Require Lua Class System
	LCS	= require("classes.LCS")

	-- Create class
	Playfield	= LCS.class({ w = 6, h = 20, layers = 1, field = {} })


	--- Initialize an empty playfield
	-- Sets up playfield of specified size and layer count
	-- @param width		Width of playfield
	-- @param height	Height of playfield
	-- @param layers	Layers in playfield (generally 1 but who knows)
	function Playfield:init(width, height, layers)

		-- Check arguments
		if width then
			self.w	= width
		end

		if height then
			self.h	= height
		end

		if layers then
			self.layers	= layers
		end


		-- Initialize loop vars
		local i, x, y	= 0, 0, 0

		-- Fill all fields with 0s
		for i = 1, self.layers do

			-- Create empty field
			self.field[i]	= {}

			for x = 1, self.w do
				-- Create empty row
				self.field[i][x]	= {}

				for y = 1, self.h do
					-- Fill row value with 0
					self.field[i][x][y]	= 0;
				end
			end
		end

	end


	--- Prints out a text representation of a playfield
	--
	function Playfield:describe()

		-- Loop variables
		local i, x, y	= 0, 0, 0

		local output	= ""

		-- Build string of playfield values
		for i = 1, self.layers do
			output	= output .. string.format("Field #%d:\n", i)
			for y = 1, self.h do
				for x = 1, self.w do
					output	= output .. string.format("%2d, ", self.field[i][x][y])
				end
				output	= output .. "\n"
			end

			output	= output .. "\n"
		end

		return output
	end




	--- Checks if a piece can fit in the playfield at a certain position.
	--
	-- @param piece		Piece to place
	-- @param x			X position
	-- @param y			Y position
	-- @param layer		Layer
	-- @return	true/false if the place can be placed in the playfield
	function Playfield:canPlacePiece(piece, x, y, layer)

		local layer	= layer or 1
		local pieceBlocks	= piece:getLayout()

		for k, v in pairs(pieceBlocks) do

			
			-- Is the piece inbounds?
			if not (self.field[layer] and self.field[layer][x + v['x']] and self.field[layer][x + v['x']][y + v['y']]) then
				return false
			
			-- Is the spot this piece would occupy empty?
			elseif self.field[layer][x + v['x']][y + v['y']] ~= 0 then
				-- Something's there already, sorry
				return false
			end
		end

		-- All blocks of this piece can be placed, everything is OK.
		return true

	end


	--- Places a piece into the playfield.
	--
	-- @param piece		Piece to place
	-- @param x			X position
	-- @param y			Y position
	-- @param layer		Layer
	-- @return	true/false if piece was placed into the playfield
	function Playfield:placePiece(piece, x, y, layer)

		local layer	= layer or 1

		if not self:canPlacePiece(piece, x, y, layer) then
			-- Error
			return false
		end

		local pieceBlocks	= piece:getLayout()
		for k, v in pairs(pieceBlocks) do
			self.field[layer][x + v['x']][y + v['y']]	= v['b']
		end

		return true
	end


	--- Checks if a piece can fit in the playfield at a certain position
	-- Maybe returns an array of matches + X/Y pairs or nil if none?
	-- @return ?
	function Playfield:checkForClears(layer)

		local layer			= layer or 1
		local x, y			= 0, 0
		local clearBlocks	= {}

		for x = 1, self.w do
			for y = self.h, 1, -1 do

				-- Check for clears here.
				-- This should maybe be split out into a different function or something, lots of duplicate code?
				if x <= self.w - 2 and y > 2 then
					local chain, blocks	= self:checkForClearAt(layer, x, y, 1, -1)		-- Diagonal /
					if chain then
						table.insert(clearBlocks, blocks)
					end

				end
				if x <= self.w - 2 and y then
					local chain, blocks	= self:checkForClearAt(layer, x, y, 1, 1)		-- Diagonal \
					if chain then
						table.insert(clearBlocks, blocks)
					end

				end
				if x <= self.w - 2 then
					local chain, blocks	= self:checkForClearAt(layer, x, y, 1, 0)		-- Horizontal
					if chain then
						table.insert(clearBlocks, blocks)
					end
				
				end
				if y > 2 then
					local chain, blocks	= self:checkForClearAt(layer, x, y, 0, -1)		-- Vertical
					if chain then
						table.insert(clearBlocks, blocks)
					end

				end

			end

			-- Do something with the chains here later
		end
		return (#clearBlocks > 0 and clearBlocks or false)


	end


	-- All of these start from the bottom-left of a potential clear
	-- Returns false or length of cleared blocks??

	--- Check for a specific clear from a given position
	-- All values are from the bottom-left-most block
	-- @param	l	layer to check
	-- @param	x	Bottom-left X position
	-- @param	y	Bottom-left Y position
	-- @param	xs	X step (0 or 1, generally) (maybe higher values if you're weird)
	-- @param	ys	Y step (0 or 1) (don't be weird)
	-- @return	false if no clear at this location+step
	-- @return	chain length, table of block locations
	function Playfield:checkForClearAt(l, x, y, xs, ys)

		if xs == 0 and ys == 0 then
			error("Some idiot tried to checkForClearAt with zero xs and ys. Bad. No biscuit.")
		end

		-- While we expect YS to be either 0 or 1, we actually end up using -1 because of the whole bottom-left thing
		-- (The reason we use bottom-left is because the clear-check will scan from bottom-to-top left-to-right)

		-- Quick abort if it'd go out of bounds
		if (xs > 0 and x + (xs * 2) > self.w) or (ys < 0 and y + (ys * 2) < 1) then
			return false
		end

		-- Set up local varaibles for checking stuff
		local cx, cy		= x, y
		local startBlock	= self.field[l][cx][cy]
		local currentBlock	= startBlock
		local chain			= 0
		local chainBlocks	= {}


		-- Look to see if the next block matches the block we started with
		-- If so, keep going until it, uh, doesn't.
		while currentBlock ~= 0 and startBlock == currentBlock and cx <= self.w and cy >= 1 and cy <= self.h do

			-- Check if the block behind this is the same color; if so we've already scanned this
			-- and it can be safely ignored
			if chain == 0 and (x - xs) >= 1 and (y - ys) <= self.h then
				if self.field[l][x-xs][y-ys] == startBlock then
					break
				end
			end 

			currentBlock	= self.field[l][cx][cy]
			if (startBlock == currentBlock) then
				chain	= chain + 1
				table.insert(chainBlocks, { x = cx, y = cy })
			end

			cx	= cx + xs
			cy	= cy + ys
		end

		-- Return the length + position of the chain if it's over 3
		-- ... or false if there is no chain
		if chain >= 3 then
			return chain, chainBlocks
		else
			return false
		end

	end



	--- Clear the playfield of cleared blocks
	-- This function is a huge work-in-progress that might be changed a lot later
	-- @param	layer		Layer to clear blocks from
	-- @param	clearBlocks	Array of blocks to clear from
	function Playfield:clearClears(clearBlocks, layer)

		local layer	= layer or 1

		if not clearBlocks then
			return
		end

		for k, v in pairs(clearBlocks) do
			for kk, vv in pairs(v) do
				self.field[layer][vv.x][vv.y]	= 0
			end
		end

	end








	--- Do gravity
	--
	function Playfield:doGravity()

		local l, x, y	= 0, 0, 0

		for l = 1, self.layers do
			for x = 1, self.w do

				-- Lowest row with a 0
				local lowestRow	= 0

				for y = self.h, 2, -1 do

					if self.field[l][x][y] == 0 then
						lowestRow	= math.max(lowestRow, y)
						-- this probably doesn't matter because I'm sure my logic somewhere is completely hosed.
					end

					if self.field[l][x][y] == 0 and self.field[l][x][y - 1] ~= 0 then
						--print(string.format("Gravity for L=%d X=%d Y=%d...oh no! FLOATING BLOCK ALERT", l, x, y))

						self.field[l][x][lowestRow]	= self.field[l][x][y - 1]
						lowestRow					= lowestRow - 1
						self.field[l][x][y - 1]	= 0
					end

				end
			end
		end

	end





	--- Quick hacky way to draw a playfield
	--
	function Playfield:draw(xPosition, yPosition, layer)

		local layer	= layer or 1

		-- Loop variables
		local i, x, y	= 0, 0, 0

		local output	= ""

		-- Build string of playfield values
		for y = 1, self.h do
			for x = 1, self.w do
				love.graphics.setColor(blockColors[self.field[layer][x][y]])

				love.graphics.print(string.format("%2d", self.field[layer][x][y]), xPosition + ((x - 1) * 20), yPosition + ((y - 1) * 20))
			end
			output	= output .. "\n"
		end

	end




	-- Return class/module

	return Playfield