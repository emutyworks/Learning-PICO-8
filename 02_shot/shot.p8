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
end

function _update()
	input()
end

function _draw()
	cls()
	rectfill(0,0,127,127,127)
	spr(pc.s, pc.x, pc.y)
	foreach(shots, draw_shot)
	foreach(shots, update_shot)
end

function input()
	if (btn(0) and pc.x > 0) then -- Left
		pc.x -= 1
		pc.s = 3
		pc.dx = -2
		pc.dy = 0
	end
	if (btn(1) and pc.x < 127) then -- Right
		pc.x += 1
		pc.s = 1
		pc.dx = 2
		pc.dy = 0
	end
	if (btn(2) and pc.y > 0) then -- Top
		pc.y -= 1
		pc.s = 0
		pc.dx = 0
		pc.dy = -2
	end
	if (btn(3) and pc.y < 127) then -- Bottom
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
		end
		if pc.s == 1 then  -- Right
			sx += 10
			sy += 3
		end
		if pc.s == 0 then  -- Top
			sx += 3
			sy -= 4
		end
		if pc.s == 2 then -- Bottom
			sx += 3
			sy += 10
		end
		add_shot(sx, sy, pc.dx, pc.dy)
	end
end

function update_shot(s)
	s.x += s.dx
	s.y += s.dy
	s.life-=1
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
	rectfill(s.x, s.y, (s.x + 1), (s.y + 1),8)
end

__gfx__
00011000113311001333333100113311000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333300333333001333333100333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13333331333333303336633303333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13366331336663313336633313366633000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33366333336663311336633113366633000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33366333333333301333333103333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13333331333333000033330000333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13333331113311000001100000113311000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
