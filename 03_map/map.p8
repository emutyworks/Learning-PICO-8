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
		pc.x -= 1
		pc.s = 3
		pc.dx = -2
		pc.dy = 0
	elseif (btn(1) and pc.x < 127) then -- Right
		pc.x += 1
		pc.s = 1
		pc.dx = 2
		pc.dy = 0
	elseif (btn(2) and pc.y > 0) then -- Top
		pc.y -= 1
		pc.s = 0
		pc.dx = 0
		pc.dy = -2
	elseif (btn(3) and pc.y < 127) then -- Bottom
		pc.y += 1
		pc.s = 2
		pc.dx = 0
		pc.dy = 2
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
