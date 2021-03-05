pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
function _init()
	sx,sy = 64,45
	x0,y0,x1,y1 = sx,sy,sx+7,sy-3
end

function _draw()
	cls()
	print("bresenham's line algorithm",0,0,7)
	print("operate with cursor keys",0,6,6)
	print("line()",0,40,12)
	print("_line()",0,60,10)
	print("x0,y0",0,66,9)
	print("-",20,66,6)
	print("x1,y1",24,66,11)

	line(x0,y0,x1,y1,12)
	_line(x0,y0+20,x1,y1+20,10)
end

function _update()
	input()
end

function _line(x0,y0,x1,y1,cl)
	-- Bresenham's line algorithm
	-- https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm

	if (x0 >= x1 and y0 >= y1) or y0 >= y1 then
		x0,y0,x1,y1 = x1,y1,x0,y0
	end

	local dx,ax
	local dy = y1-y0

	if x0 <= x1 and y0 <= y1 then
		dx = x1-x0
		ax = 1
	else
		dx = x0-x1
		ax = -1
	end

	local dx2,dy2 = dx*2,dy*2

	if dx > dy then
		local D,y = -dx,y0
		for x=x0,x1,ax do
			if D > 0 then
				y += 1
				D -= dx2
			end
			D += dy2
			pset(x,y,cl)
		end
	else
		local D,x = -dy,x0
		for y=y0,y1 do
			if D > 0 then
				x += ax
				D -= dy2
			end
			D += dx2
			pset(x,y,cl)
		end
	end
	--debug
	pset(x0,y0,9)
	pset(x1,y1,11)
end

function input()
	if btn(0) then -- Left
		x1 -= 1
	elseif btn(1) then -- Right
		x1 += 1
	elseif btn(2) then -- Top
		y1 -= 1
	elseif btn(3) then -- Bottom
		y1 += 1
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
