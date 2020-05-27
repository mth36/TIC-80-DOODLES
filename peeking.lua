-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

t=0
dt=1/60
ti=0

cls()

function TIC()
	t=t+dt
	ti=ti+1
	cls(1)
	
	k=32
	for ox=0,240,k do
		x1=ox
		x2=ox+k
		for oy=0,136,k do
			y1=oy
			y2=oy+k
			
			local cx=(x2+x1)/2+cos(t*16*cos(x1/32+y1/32))*(sin(t*16)*4+5)
			local cy=(y2+y1)/2+sin(t*16*sin(flr(sin(y2/32))*2+y1/24+x1/64))*(sin(t*16)*4+5)
			
			local tx=(x2-x1)/2
			local ty=y1
			
			tri(cx,cy,x2,y2,x1,y2,1)
			tri(cx,cy,x1,y2,x1,y1,9)
			tri(cx,cy,x1,y1,x2,y1,12)
			tri(cx,cy,x2,y1,x2,y2,6)
			
			ps={
				{x1,y1},
				{x1,y2},
				{x2,y1},
				{x2,y2}
			}
			
			local r=4
			local vs={}
			for k,p in ipairs(ps) do
				ux=p[1]-cx
				uy=p[2]-cy
				local mm=magn(ux,uy)
				local r=min(r,mm)
				
				nx,ny=norm(ux,uy)
				
				vx,vy=mult(nx,ny,r)
				v={vx,vy}
				
				table.insert(vs,v)
			end
			tri(
				cx+vs[1][1],cy+vs[1][2],
				cx+vs[2][1],cy+vs[2][2],
				cx+vs[3][1],cy+vs[3][2],
				(t+cx/4+cy/16)%8+8
			)
			tri(
				cx+vs[3][1],cy+vs[3][2],
				cx+vs[4][1],cy+vs[4][2],
				cx+vs[2][1],cy+vs[2][2],
				(t+cx/4+cy/16)%8+8
			)
		end
	end
end

function norm(x,y)
	local m=magn(x,y)
	return x/m,y/m
end

function mult(x,y,a)
	return x*a,y*a
end

function magn(x,y)
	return dist(x,y,0,0)
end

function sqrt(a)
	return math.sqrt(a)
end

function sqr(a)
	return a*a
end

function dist(x1,y1,x2,y2)
	return sqrt(sqr(x2-x1)+sqr(y2-y1))
end
-- <CODE7>
function rads2turns(rads)
	return rads/(2*3.14159)
end

function abs(a)
	return math.abs(a)
end

function atan2(x,y)
	return rads2turns(math.atan(y,x))
end

function cos(a)
	return math.cos(rads2turns(a))
end

function sin(a)
	return -math.sin(rads2turns(a))
end

function rnd(a)
	return math.random()*a
end

function min(a,b)
	if a<b then return a 
	else return b end
end

function flr(a)
	return a-a%1
end
-- </CODE7>

-- <TILES>
-- 001:efffffffff222222f8888888f8222222f8fffffff8ff0ffff8ff0ffff8ff0fff
-- 002:fffffeee2222ffee88880fee22280feefff80fff0ff80f0f0ff80f0f0ff80f0f
-- 003:efffffffff222222f8888888f8222222f8fffffff8fffffff8ff0ffff8ff0fff
-- 004:fffffeee2222ffee88880fee22280feefff80ffffff80f0f0ff80f0f0ff80f0f
-- 017:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 018:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 019:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 020:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 100:0cc00000ccc66000cc6661100c66611000661110000011110000111100000110
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

