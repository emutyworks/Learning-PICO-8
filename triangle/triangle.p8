pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
function _init()
	tr = {}
	tr.x0,tr.y0,tr.x1,tr.y1,tr.x2,tr.y2 = 0,-10,-10,5,10,10
	tr.ang = 0
	tr.cl = 10

	ca = {}
	ca.cx,ca.cy = 60,60
end

function _draw()
	cls()
	print("draw and rotate triangle",0,0,7)
	print("move: cursor keys",0,6,6)

	rotate_triangle(tr.ang,ca.cx,ca.cy,tr.cl)
end

function _update60()
	input()
end

function rotate(ang,x,y)
	local p = {}
	p.x = flr(x*cos(ang) - y*sin(ang))
	p.y = flr(x*sin(ang) + y*cos(ang))
	return p
end

function rotate_triangle(ang,cx,cy,cl)
	local p = rotate(ang,tr.x0,tr.y0)
	local x0,y0 = p.x+cx,p.y+cy
	p = rotate(ang,tr.x1,tr.y1)
	local x1,y1 = p.x+cx,p.y+cy
	p = rotate(ang,tr.x2,tr.y2)
	local x2,y2 = p.x+cx,p.y+cy

	_triangle(x0,y0,x1,y1,x2,y2,cl)
end

function _triangle(x0,y0,x1,y1,x2,y2,cl)
	local t = {}
	if y0<y1 and y0<y2 then
		if y1<y2 then
			t.tx,t.ty,t.mx,t.my,t.bx,t.by = x0,y0,x1,y1,x2,y2
		else
			t.tx,t.ty,t.mx,t.my,t.bx,t.by = x0,y0,x2,y2,x1,y1
		end
	elseif y1<y0 and y1<y2 then
		if y0<y2 then
			t.tx,t.ty,t.mx,t.my,t.bx,t.by = x1,y1,x0,y0,x2,y2
		else
			t.tx,t.ty,t.mx,t.my,t.bx,t.by = x1,y1,x2,y2,x0,y0
		end
	else
		if y0<y1 then
			t.tx,t.ty,t.mx,t.my,t.bx,t.by = x2,y2,x0,y0,x1,y1
		else
			t.tx,t.ty,t.mx,t.my,t.bx,t.by = x2,y2,x1,y1,x0,y0
		end
	end

	local l0 = _line(t.tx,t.ty,t.bx,t.by,cl)
	local l1 = _line(t.tx,t.ty,t.mx,t.my,cl)
	local l2 = _line(t.mx,t.my,t.bx,t.by,cl)

	local p = {}

	for k,v in pairs(l0) do
		if p[v.y] and p[v.y].x0 > v.x then 
			p[v.y] = {x0=v.x,y0=v.y,x1=0,y1=0}
		else
			p[v.y] = {x0=v.x,y0=v.y,x1=0,y1=0}
		end
	end

	for k,v in pairs(l1) do
		if p[v.y] and p[v.y].x1 < v.x then
			p[v.y] = {x0=p[v.y].x0,y0=p[v.y].y0,x1=v.x,y1=v.y}
		end
  end

	for k,v in pairs(l2) do
		if p[v.y] and p[v.y].x1 < v.x then
			p[v.y] = {x0=p[v.y].x0,y0=p[v.y].y0,x1=v.x,y1=v.y}
		end
  end

	local ad = 1
	if t.tx > t.mx then
		ad = -1
	end	

	for k,v in pairs(p) do
		for x=v.x0,v.x1,ad do
			pset(x,k,cl)
		end
	end

end

function _line(x0,y0,x1,y1,cl)
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
			add(l,{x=x,y=y})
			pset(x,y,cl)
		end
	end
	return l
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
