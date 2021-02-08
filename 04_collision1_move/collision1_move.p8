pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- https://pico-8.fandom.com/wiki/GameLoop
-- _init(), _update(), _draw()
function _init()
	shots = {}
	shot_life = 64
	shot_interval = 3

	pc = {}
	pc.x = 64
	pc.y = 64
	pc.s = 0
	pc.dx = 0
	pc.dy = -2
	pc.sint = 0

	bg_map = {
		4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
		4,1,4,1,1,1,6,1,1,1,1,1,1,1,1,4,
		4,1,1,1,4,1,6,6,6,6,6,1,6,6,1,4,
		4,1,4,1,4,1,1,1,1,6,1,1,1,1,1,4,
		4,1,4,1,4,1,6,6,1,1,1,1,6,6,1,4,
		4,1,1,1,4,1,6,1,6,6,1,1,6,1,1,4,
		4,1,4,1,4,1,6,1,1,1,1,5,1,1,1,4,
		4,1,1,1,4,1,1,1,1,1,5,1,1,1,1,4,
		4,4,4,1,4,4,4,1,1,1,5,1,5,5,1,4,
		4,1,4,1,1,4,1,1,1,1,1,1,1,1,1,4,
		4,1,4,1,1,1,1,1,4,1,1,5,1,1,1,4,
		4,1,4,4,1,1,4,4,4,4,1,5,1,1,1,4,
		4,1,1,1,1,1,4,1,1,1,1,1,5,1,1,4,
		4,1,1,1,4,4,4,1,5,5,1,1,5,1,1,4,
		4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,
		4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	}
end

function _update()
	input()
end

function _draw()
	draw_bg()
	spr(pc.s, pc.x, pc.y)
	foreach(shots, draw_shot)
	foreach(shots, update_shot)
	--draw_debug()
end

function draw_debug()
	print(pc.x, 0, 0, 8)
	print(flr(pc.x / 8), 12, 0, 9)
	print(ceil(pc.x / 8), 20, 0, 8)
	print((pc.x % 8), 28, 0, 9)
	print(pc.y, 0, 8, 8)
	print(flr(pc.y / 8), 12, 8, 9)
	print(ceil(pc.y / 8), 20, 8, 8)
	print((pc.y % 8), 28, 8, 9)
end

function draw_bg()
	rectfill(0, 0, 127, 127, 6)	
	for yy=0,15 do
		for xx=0,15 do
			local s = bg_map[(xx + yy * 16 + 1)]
			if s ~= 1 then spr(s, (xx * 8), (yy * 8)) end
		end
	end
end

function input()
	if (btn(0) and pc.x > 0) then -- Left
		pc.s = 3
		pc.dx = -2
		pc.dy = 0
		collision_pc()
		--pc.x -= 1
	elseif (btn(1) and pc.x < 127) then -- Right
		pc.s = 1
		pc.dx = 2
		pc.dy = 0
		collision_pc()
		--pc.x += 1
	elseif (btn(2) and pc.y > 0) then -- Top
		pc.s = 0
		pc.dx = 0
		pc.dy = -2
		collision_pc()
		--pc.y -= 1
	elseif (btn(3) and pc.y < 127) then -- Bottom
		pc.s = 2
		pc.dx = 0
		pc.dy = 2
		collision_pc()
		--pc.y += 1
	end
	if btn(4) then
		local sx = pc.x
		local sy = pc.y

		if pc.s == 3 then  -- Left
			sx -= 4
			sy += 3
		elseif pc.s == 1 then  -- Right
			sx += 10
			sy += 3
		elseif pc.s == 0 then  -- Top
			sx += 3
			sy -= 4
		elseif pc.s == 2 then -- Bottom
			sx += 3
			sy += 10
		end
		add_shot(sx, sy, pc.dx, pc.dy)
	end
end

function collision_pc()
	if pc.s == 3 then -- Left
		local xx = ceil((pc.x - 8) / 8)
		local y1 = ceil(pc.y / 8)
		local y2 = ceil((pc.y - 7) / 8)
		local s1 = bg_map[(xx + y1 * 16 + 1)]
		local s2 = bg_map[(xx + y2 * 16 + 1)]
		if (s1 == 1 and s2 == 1) then pc.x -= 1 end
	elseif pc.s == 1 then -- Right
		local xx = ceil((pc.x + 1) / 8)
		local y1 = ceil(pc.y / 8)
		local y2 = ceil((pc.y - 7) / 8)
		local s1 = bg_map[(xx + y1 * 16 + 1)]
		local s2 = bg_map[(xx + y2 * 16 + 1)]
		if (s1 == 1 and s2 == 1) then pc.x += 1 end
	elseif pc.s == 0 then -- Top
		local x1 = ceil(pc.x / 8)
		local x2 = ceil((pc.x - 7) / 8)
		local yy = ceil((pc.y - 8) / 8)
		local s1 = bg_map[(x1 + yy * 16 + 1)]
		local s2 = bg_map[(x2 + yy * 16 + 1)]
		if (s1 == 1 and s2 == 1) then pc.y -= 1 end
	elseif pc.s == 2 then -- Bottom
		local x1 = ceil(pc.x / 8)
		local x2 = ceil((pc.x - 7) / 8)
		local yy = ceil((pc.y + 1) / 8)
		local s1 = bg_map[(x1 + yy * 16 + 1)]
		local s2 = bg_map[(x2 + yy * 16 + 1)]
		if (s1 == 1 and s2 == 1) then pc.y += 1 end
	end
end

function update_shot(s)
	s.x += s.dx
	s.y += s.dy
	s.life -= 1
	if s.life < 1 then del(shots, s) end
end

function add_shot(x, y, dx, dy)
	if pc.sint == 0 then
		local s = {}
		s.x = x
		s.y = y
		s.dx = dx
		s.dy = dy
		s.life = shot_life
		add(shots, s)
		pc.sint = shot_interval
	else
		pc.sint -= 1
	end
end

function draw_shot(s)
	rectfill(s.x, s.y, (s.x + 1), (s.y + 1), 8)
end

__gfx__
000110001133110013333331001133115555555555555555dddddddd000000000000000000000000000000000000000000000000000000000000000000000000
003333003333330013333331003333335444445551111155d77777dd000000000000000000000000000000000000000000000000000000000000000000000000
133333313333333033366333033333335444444551111115d777777d000000000000000000000000000000000000000000000000000000000000000000000000
133663313366633133366333133666335444444551111115d777777d000000000000000000000000000000000000000000000000000000000000000000000000
333663333366633113366331133666335544444555111115dd77777d000000000000000000000000000000000000000000000000000000000000000000000000
333663333333333013333331033333335555555555555555dddddddd000000000000000000000000000000000000000000000000000000000000000000000000
133333313333330000333300003333335444445651111156d77777d6000000000000000000000000000000000000000000000000000000000000000000000000
1333333111331100000110000011331165444445651111156d77777d000000000000000000000000000000000000000000000000000000000000000000000000
