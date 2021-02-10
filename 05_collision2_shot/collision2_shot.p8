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
	pc.x = 67
	pc.y = 67
	pc.s = 0
	pc.dx = 0
	pc.dy = -2
	pc.sx = 0
	pc.sy = -4
	pc.smx = 0
	pc.smy = -1
	pc.int = 0

	bg_map = {
		4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
		4,0,4,0,0,0,6,0,0,0,0,0,0,0,0,4,
		4,0,0,0,4,0,6,6,6,6,6,0,6,6,0,4,
		4,0,4,0,4,0,0,0,0,6,0,0,0,0,0,4,
		4,0,4,0,4,0,6,6,0,0,0,0,6,6,0,4,
		4,0,0,0,4,0,6,0,6,6,0,0,6,0,0,4,
		4,0,4,0,4,0,6,0,0,0,0,5,0,0,0,4,
		4,0,0,0,4,0,0,0,0,0,5,0,0,0,0,4,
		4,4,4,0,4,4,4,0,0,0,5,0,5,5,0,4,
		4,0,4,0,0,4,0,0,0,0,0,0,0,0,0,4,
		4,0,4,0,0,0,0,0,4,0,0,5,0,0,0,4,
		4,0,4,4,0,0,4,4,4,4,0,5,0,0,0,4,
		4,0,0,0,0,0,4,0,0,0,0,0,5,0,0,4,
		4,0,0,0,4,4,4,0,5,5,0,0,5,0,0,4,
		4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,
		4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	}

	pc_col = {
		-1,-1, 0,-1, 1,-1,
		-1, 0, 0, 0, 1, 0,
		-1, 1, 0, 1, 1, 1
	}
end

function _update()
	input()
end

function _draw()
	draw_bg()
	spr(pc.s, (pc.x - 3), (pc.y - 3))
	foreach(shots, draw_shot)
	foreach(shots, update_shot)
end

function collision_pc(x, y)
	local cx = pc.x + x
	local cy = pc.y + y
	local pr = get_pc_region(cx, cy)
	local m = get_pc_mpos(cx, cy)

	if sub_collision_pc(m, pr) then 
		pc.x = cx
		pc.y = cy
	end
end

function sub_collision_pc(m, pr)
	for i=0,8 do
		local mx = m.mx + pc_col[(i * 2 + 1)]
		local my = m.my + pc_col[(i * 2 + 2)]
		if (mx < 0) then mx = 0 end
		if (my < 0) then my = 0 end

		if get_map(mx, my) ~= 0 then
			local mr = get_map_region(mx, my)

			if check_collision(mr, pr) then
				return false
			end
		end			
	end

	return true
end

function collision_shot(s)
	local m = get_shot_mpos(s.x, s.y)
	pr = {}
	pr.x0 = s.x
	pr.y0 = s.y
	pr.x1 = s.x
	pr.y1 = s.y
	if get_map(m.mx, m.my) ~= 0 then
		local mr = get_map_region(m.mx, m.my)
		if check_collision(mr, pr) then
			return false
		end
	end
	if get_map((m.mx + s.mx), (m.my + s.my)) ~= 0 then
		local mr = get_map_region((m.mx + s.mx), (m.my + s.my))
		if check_collision(mr, pr) then
			return false
		end
	end

	return true
end

-- https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
function check_collision(mr, pr)
	if (mr.x0 <= pr.x1) and (mr.x1 >= pr.x0) and (mr.y0 <= pr.y1) and (mr.y1 >= pr.y0) then
		return true
	else
		return false
	end 
end

function get_pc_region(x, y)
	local pr = {}
	pr.x0 = x - 3
	pr.y0 = y - 3
	pr.x1 = pr.x0 + 6
	pr.y1 = pr.y0 + 6
	return pr
end

function get_pc_mpos(x, y)
	local m = {}
	m.mx = flr((x - 3) / 8)
	m.my = flr((y - 3) / 8)
	return m
end

function get_shot_mpos(x, y)
	local m = {}
	m.mx = flr(x / 8)
	m.my = flr(y / 8)
	return m
end

function get_map_region(x, y)
	local mr = {}
	mr.x0 = x * 8
	mr.y0 = y * 8
	mr.x1 = mr.x0 + 7
	mr.y1 = mr.y0 + 7
	return mr
end

function get_map(x, y)
	return bg_map[(x + y * 16 + 1)]
end

function draw_bg()
	rectfill(0, 0, 127, 127, 6)	
	for yy=0,15 do
		for xx=0,15 do
			local s = get_map(xx, yy)
			if s ~= 0 then spr(s, (xx * 8), (yy * 8)) end
		end
	end
end

function input()
	if (btn(0) and (pc.x - 3) > 0) then -- Left
		pc.s = 3
		pc.dx = -2
		pc.dy = 0
		pc.sx = -4
		pc.sy = 0
		pc.smx = -1
		pc.smy = 0
		collision_pc(-1, 0)
	elseif (btn(1) and (pc.x + 3) < 127) then -- Right
		pc.s = 1
		pc.dx = 2
		pc.dy = 0
		pc.sx = 4
		pc.sy = 0
		pc.smx = 1
		pc.smy = 0
		collision_pc(1, 0)
	elseif (btn(2) and (pc.y - 3) > 0) then -- Top
		pc.s = 0
		pc.dx = 0
		pc.dy = -2
		pc.sx = 0
		pc.sy = -4
		pc.smx = 0
		pc.smy = -1
		collision_pc(0, -1)
	elseif (btn(3) and (pc.y + 3) < 127) then -- Bottom
		pc.s = 2
		pc.dx = 0
		pc.dy = 2
		pc.sx = 0
		pc.sy = 4
		pc.smx = 0
		pc.smy = 1
		collision_pc(0, 1)
	end
	if btn(4) then
		add_shot()
	end
end

function update_shot(s)
	s.x += s.dx
	s.y += s.dy
	s.life -= 1
	if (s.life < 1) or (s.x < 0) or (s.x > 127) or (s.y < 0) or (s.y > 127) then 
		del(shots, s) 
	end
end

function add_shot()
	if pc.int == 0 then
		local s = {}
		s.x = pc.x + pc.sx
		s.y = pc.y + pc.sy
		s.dx = pc.dx
		s.dy = pc.dy
		s.mx = pc.smx
		s.my = pc.smy
		s.life = shot_life
		add(shots, s)
		pc.int = shot_interval
	else
		pc.int -= 1
	end
end

function draw_shot(s)
	if collision_shot(s) then 
		pset(s.x, s.y, 8)
	else
		if s.mx ~= 0 then
			rectfill(s.x, (s.y - 1), (s.x + s.mx), (s.y + 1), 9)
		else
			rectfill((s.x - 1), s.y, (s.x + 1), (s.y + s.my), 9)
		end
		del(shots, s)
	end
end

__gfx__
000100001131100013000310001131105555555555555555dddddddd000000000000000000000000000000000000000000000000000000000000000000000000
003330003333300013333310003333305444445551111155d77777dd000000000000000000000000000000000000000000000000000000000000000000000000
133333100333330033363330033333005444444551111115d777777d000000000000000000000000000000000000000000000000000000000000000000000000
133633100366331013363310133663005444444551111115d777777d000000000000000000000000000000000000000000000000000000000000000000000000
333633300333330013333310033333005544444555111115dd77777d000000000000000000000000000000000000000000000000000000000000000000000000
133333103333300000333000003333305555555555555555dddddddd000000000000000000000000000000000000000000000000000000000000000000000000
130003101131100000010000001131105444445651111156d77777d6000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000065444445651111156d77777d000000000000000000000000000000000000000000000000000000000000000000000000