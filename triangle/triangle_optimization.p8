pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
function _init()
	tr ={
		c = {
			{x=0,y=-10},
			{x=-10,y=5},
			{x=10,y=10},
		},
		ang=0,
		cl=10
	}

	ca = {
		cx=60,
		cy=60
	}
end

function _draw()
	cls()
	print("draw and rotate triangle",0,0,7)
	print("move: cursor keys",0,6,6)

	rotate_triangle()
end

function _update60()
	input()
end

function rotate(ang,x,y)
	local rx,ry
	rx = flr(x*cos(ang) - y*sin(ang))
	ry = flr(x*sin(ang) + y*cos(ang))
	return rx,ry
end

function rotate_triangle()
	local tc = {}
	for k,v in pairs(tr.c) do
		local rx,ry = rotate(tr.ang,v.x,v.y)
		add(tc,{x=rx+ca.cx,y=ry+ca.cy})
	end

	if tc[1].y > tc[2].y then
		tc[1],tc[2] = tc[2],tc[1]
	end
	if tc[2].y > tc[3].y then
		tc[2],tc[3] = tc[3],tc[2]
	end
	if tc[2].y < tc[1].y then
		tc[1],tc[2] = tc[2],tc[1]
	end

	local p = {}
	_calc_line(tc[1].x,tc[1].y,tc[3].x,tc[3].y,tr.cl,p,0)
	_calc_line(tc[1].x,tc[1].y,tc[2].x,tc[2].y,tr.cl,p,1)
	_calc_line(tc[2].x,tc[2].y,tc[3].x,tc[3].y,tr.cl,p,2)

	local ad = 1
	if tc[1].x > tc[2].x then
		ad = -1
	end	

	for k,v in pairs(p) do
		line(v.x0,k,v.x1,k,tr.cl)
	end
end

function _calc_line(x0,y0,x1,y1,cl,p,flg)
	line(x0,y0,x1,y1,cl)

	if (x0>=x1 and y0>=y1) or y0>=y1 then
		x0,y0,x1,y1 = x1,y1,x0,y0
	end

	local dx,ax
	local dy = y1-y0

	if x0<=x1 and y0<=y1 then
		dx = x1-x0
		ax = 1
	else
		dx = x0-x1
		ax = -1
	end

	local dx2,dy2 = dx*2,dy*2
	local l = {}

	if dx > dy then
		local D,y = -dx,y0
		for x=x0,x1,ax do
			if D > 0 then
				y += 1
				D -= dx2
			end
			D += dy2
			add(l,{x=x,y=y})
		end
	else
		local D,x = -dy,x0
		for y=y0,y1 do
			if D > 0 then
				x += ax
				D -= dy2
			end
			D += dx2
			add(l,{x=x,y=y})
		end
	end
	
	if flg == 0 then
		for k,v in pairs(l) do
			if p[v.y] and p[v.y].x0 > v.x then 
				p[v.y] = {x0=v.x,y0=v.y,x1=0,y1=0}
			else
				p[v.y] = {x0=v.x,y0=v.y,x1=0,y1=0}
			end
		end		
	else
		for k,v in pairs(l) do
			if p[v.y] and p[v.y].x1 < v.x then
				p[v.y] = {x0=p[v.y].x0,y0=p[v.y].y0,x1=v.x,y1=v.y}
			end
		end
	end
end

function input()
	if btn(0) then -- Left
		tr.ang = set_angle(tr.ang, 0.01)
	elseif btn(1) then -- Right
		tr.ang = set_angle(tr.ang, -0.01)
	elseif btn(2) then -- Top
	elseif btn(3) then -- Bottom
	end
end

function set_angle(ang, inc)
	ang += inc
	if ang > 1 then 
		ang = 0 
	elseif ang < 0 then 
		ang = 1 
	end
	return ang
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
