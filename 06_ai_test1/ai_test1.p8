pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- https://pico-8.fandom.com/wiki/GameLoop
-- _init(), _update(), _draw()
function _init()
	enemy = {}
	add_enemy(6, (8 * 5 + 3), (8 * 3 + 3), 0, 1, 1)
	add_enemy(6, (8 * 14 + 3), (8 * 1 + 3), 0, 1, 1)
	add_enemy(6, (8 * 1 + 3), (8 * 1 + 3), 0, 1, 1)

	shot = {}
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
		8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
		8, 0, 8, 0, 0, 0,10, 0, 0, 0, 0, 0, 0, 0, 0, 8,
		8, 0, 0, 0, 8, 0,10,10,10,10,10, 0,10,10, 0, 8,
		8, 0, 8, 0, 8, 0, 0, 0, 0,10, 0, 0, 0, 0, 0, 8,
		8, 0, 8, 0, 8, 0,10,10, 0, 0, 0, 0,10,10, 0, 8,
		8, 0, 0, 0, 8, 0,10, 0,10,10, 0, 0,10, 0, 0, 8,
		8, 0, 8, 0, 8, 0,10, 0, 0, 0, 0, 9, 0, 0, 0, 8,
		8, 0, 0, 0, 8, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 8,
		8, 8, 8, 0, 8, 8, 8, 0, 0, 0, 9, 0, 9, 9, 0, 8,
		8, 0, 8, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
		8, 0, 8, 0, 0, 0, 0, 0, 8, 0, 0, 9, 0, 0, 0, 8,
		8, 0, 8, 8, 0, 0, 8, 8, 8, 8, 0, 9, 0, 0, 0, 8,
		8, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 9, 0, 0, 8,
		8, 0, 0, 0, 8, 8, 8, 0, 9, 9, 0, 0, 9, 0, 0, 8,
		8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
		8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
	}

	map_col = {
		-1,-1, 0,-1, 1,-1,
		-1, 0, 0, 0, 1, 0,
		-1, 1, 0, 1, 1, 1
	}
	enemy_col ={
		4, 0,-1,
		5, 1, 0,
		6, 0, 1,
		7,-1, 0,
	}

	dbg = {}
	dbg.rnd = 0
end

function _update()
	input()
end

function _draw()
	draw_bg()
	spr(pc.s, (pc.x - 3), (pc.y - 3))
	foreach(shot, draw_shot)
	foreach(shot, update_shot)
	foreach(enemy, draw_enemy)
	foreach(enemy, update_enemy)

	--draw_dbg()
end

function draw_dbg()
	print(dbg.rnd, 0, 100, 9)	
end

function collision_enemy(cx, cy)
	local pr = get_pc_region(cx, cy)
	local m = get_pc_mpos(cx, cy)

	if sub_collision_map(m, pr) then 
		return true
	else
		return false
	end
end

function collision_pc(x, y)
	local cx = pc.x + x
	local cy = pc.y + y
	local pr = get_pc_region(cx, cy)
	local m = get_pc_mpos(cx, cy)

	if sub_collision_map(m, pr) then 
		pc.x = cx
		pc.y = cy
	end
end

function sub_collision_map(m, pr)
	for i=0,8 do
		local mx = m.mx + map_col[(i * 2 + 1)]
		local my = m.my + map_col[(i * 2 + 2)]
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
	local pr = {}
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
		del(shot, s) 
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
		add(shot, s)
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
		del(shot, s)
	end
end

function add_enemy(s, x, y, dx, dy, spd)
	local e = {}
	e.s = s
	e.x = x
	e.y = y
	e.dx = dx
	e.dy = dy
	e.spd = spd
	e.cnt = e.spd
	e.rnd = 0
	add(enemy, e)
end

function draw_enemy(e)
	spr(e.s, (e.x - 3), (e.y - 3))
end

function update_enemy(e)
	if e.cnt == 0 then		
		if collision_enemy((e.x + e.dx), (e.y + e.dy)) then
			e.x += e.dx
			e.y += e.dy
		else
			local lp = {}
			if e.rnd == 0 then
				lp = {3,1,0,2}
				e.rnd = 1
			elseif e.rnd == 1 then
				lp = {1,0,2,3}
				e.rnd = 2
			elseif e.rnd == 2 then
				lp = {2,1,3,0}
				e.rnd = 3
			elseif e.rnd == 3 then
				lp = {0,2,1,3}
				e.rnd = 4
			elseif e.rnd == 4 then
				lp = {0,1,2,3}
				e.rnd = 0
			end

			dbg.rnd = e.rnd

			for i=0,3 do
				local j = lp[(i + 1)]
				local s = enemy_col[(j * 3 + 1)]
				local dx = enemy_col[(j * 3 + 2)]
				local dy = enemy_col[(j * 3 + 3)]

				if collision_enemy((e.x + dx), (e.y + dy)) then
					e.s = s
					e.dx = dx
					e.dy = dy
					e.x += e.dx
					e.y += e.dy
					break
				end
			end
		end
		e.cnt = e.spd	
	else
		e.cnt -= 1
	end
	if (e.x < 0) or (e.x > 127) or (e.y < 0) or (e.y > 127) then 
		del(enemy, s) 
	end
end

__gfx__
000100001131100013000310001131100001000011c110001c000c100011c1105555555555555555dddddddd0000000000000000000000000000000000000000
0033300033333000133333100033333000ccc000ccccc0001ccccc1000ccccc05444445551111155d77777dd0000000000000000000000000000000000000000
133333100333330033363330033333001ccccc100ccccc00ccc7ccc00ccccc005444444551111115d777777d0000000000000000000000000000000000000000
133633100366331013363310133663001cc7cc100c77cc101cc7cc101cc77c005444444551111115d777777d0000000000000000000000000000000000000000
33363330033333001333331003333300ccc7ccc00ccccc001ccccc100ccccc005544444555111115dd77777d0000000000000000000000000000000000000000
133333103333300000333000003333301ccccc10ccccc00000ccc00000ccccc05555555555555555dddddddd0000000000000000000000000000000000000000
130003101131100000010000001131101c000c1011c11000000100000011c1105444445651111156d77777d60000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000065444445651111156d77777d0000000000000000000000000000000000000000
