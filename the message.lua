-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua
t=0
ti=0

scrw=240
scrh=136
size=16

cls(0)

pal(0,0x08,0x14,0x1e)
pal(1,0x0f,0x2a,0x3f)
pal(2,0x20,0x39,0x4f)
pal(3,0x4e,0x49,0x5f)
pal(4,0x81,0x62,0x71)
pal(5,0x99,0x75,0x77)
pal(6,0xc3,0xa3,0x8a)
palhex(7,0xf6d6bd)

px,py=scrw/2,scrh/2
pang=rnd(1)

lightning=false
light_t=0

function TIC()
	t=t+1/60
	ti=ti+1

	for i=1,500 do
		ox,oy=rnd(scrw),rnd(scrh)
		x,y=abs(ox-scrw/2)+scrw/2,abs(oy-scrh/2)+scrh/2
		y=y+flr(sin(x/scrw*(10+sin(t)*16)-scrw*3/4)*64)
		c=-y/10-1.2+17-t
		c=abs(flr(c))
		c=max(-16,c)
		c=wave(c)
		circb(ox,oy,1,c)
	end
	
	for i=1,1500 do
		ox,oy=rnd(scrw),rnd(scrh)
		x,y=ox,oy
		a=atan2(x,y,scrw/2,scrh/2)
		nx,ny=x-1*cos(a),y+1*sin(a)
		nx=abs(nx-scrw/2)+scrw/2
		p=pix(nx,ny)
		xset(x,y,p)
	end
	
	for i=1,150 do
		x,y=flr(rnd(scrw)),flr(rnd(scrh))
		w=1
		count=sqr(2*w+1)
		sum=0
		for mx=x-w,x+w,1 do
			for my=y-w,y+w,1 do
				sum=sum+pix(mx,my)
			end
		end
		avg=sum/count
		xset(x,y,avg)
	end
	
	if ti%120==0 then
		lightning=true
		light_t=0
	end
	
	if lightning then
		line(-30+light_t*10,0,0+light_t*10,scrh,7)
		light_t=light_t+1
	end
	
	if ti%1==0 then
		px = px + rnd(2)-1
		py=py+rnd(2)-1
		c1x=rnd(2)-1+px+size*cos(pang)
		c1y=rnd(2)-1+py+size*sin(pang)
		c2x=rnd(2)-1+px-size*sin(pang)
		c2y=rnd(2)-1+py+size*cos(pang)
		c3x=rnd(2)-1+c2x+c1x-px
		c3y=rnd(2)-1+c2y+c1y-py
		
		if rnd(1)<0.5 then
			local px=ih(px,scrw/2)
			local py=ih(py,scrh/2)
			local c1x=ih(c1x,scrw/2)
			local c1y=ih(c1y,scrh/2)
			local c2x=ih(c2x,scrw/2)
			local c2y=ih(c2y,scrh/2)
			local c3x=ih(c3x,scrw/2)
			local c3y=ih(c3y,scrh/2)
			
			tri(px,py,c1x,c1y,c3x,c3y,1)
			tri(px,py,c3x,c3y,c2x,c2y,1)
		
			line(px,py,c1x,c1y,7)
			line(px,py,c2x,c2y,7)
			line(c2x,c2y,c3x,c3y,7)
			line(c3x,c3y,c1x,c1y,7)
		
			circb(rnd(2)-1+px+(c3x-px)/2,rnd(2)-1+py+(c3y-py)/2,size*sqrt(2)/2+5+rnd(0.5),6)
		else
			tri(px,py,c1x,c1y,c3x,c3y,1)
			tri(px,py,c3x,c3y,c2x,c2y,1)
		
			line(px,py,c1x,c1y,7)
			line(px,py,c2x,c2y,7)
			line(c2x,c2y,c3x,c3y,7)
			line(c3x,c3y,c1x,c1y,7)
		
			circb(rnd(2)-1+px+(c3x-px)/2,rnd(2)-1+py+(c3y-py)/2,size*sqrt(2)/2+5+rnd(0.5),6)
		end
		if ti%flr(12+rnd(4)-2)==0 then
			r=flr(rnd(4))
			if r==0 then
				px=px+c1x-px
				py=py+c1y-py
			elseif r==1 then
				px=px-c1x+px
				py=py-c1y+py
			elseif r==2 then
				px=px+c2x-px
				py=py+c2y-py
			elseif r==3 then
				px=px-c2x+px
				py=py-c2y+py
			end
		end
	end
	if ti%60==0 then
		px=scrw/2+rnd(50)
		py=scrh/2+rnd(20)
		pang=rnd(1)
		size=16+rnd(8)
	end
end

function ih(x,c)
	return -(x-c)+c
end

function wave(x)
	local a=7.9
	local b = 3.95
	local p = 16
	return 2*a*abs((x/p)%1-1/2)-a/2+b
end
-- <CODE7>
-- UTIL

pi=3.14159

function xset(x,y,c)
	circb(x,y,1,c)
end

function xfill(x,y,c)
	circ(x,y,1,c)
end

function pal(i,r,g,b)
	--sanity checks
	if i<0 then i=0 end
	if i>15 then i=15 end
	--returning color r,g,b of the color
	if r==nil and g==nil and b==nil then
		return peek(0x3fc0+(i*3)),peek(0x3fc0+(i*3)+1),peek(0x3fc0+(i*3)+2)
	else
		if r==nil or r<0 then r=0 end
		if g==nil or g<0 then g=0 end
		if b==nil or b<0 then b=0 end
		if r>255 then r=255 end
		if g>255 then g=255 end
		if b>255 then b=255 end
		poke(0x3fc0+(i*3)+2,b)
		poke(0x3fc0+(i*3)+1,g)
		poke(0x3fc0+(i*3),r)
	end
end

function palhex(i,rgb)
	pal(
		i,
		flr(rgb/65536)%256,
		flr(rgb/256)%256,
		flr(rgb/1)%256
	)
end

function palbank(i,bi)
	pal(i,colorbank[bi])
end

function frames(sec)
	return sec*60
end

function secs(frames)
	return frames/60
end

function rads2turns(rads)
	return rads/(2*pi)
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

function flr(a)
	return math.floor(a)
end

function max(a,b)
	return math.max(a,b)
end

function min(a,b)
	return math.min(a,b)
end

function mid(a,b,c)
	x=a
	if a<b then
		x=b
	elseif x>c then
		x=c
	end
	
	return x
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

function sqrdist(x1,y1,x2,y2)
	return sqr(x2-x1)+sqr(y2-y1)
end
-- </CODE7>

-- <TILES>
-- 000:0002200000022000000000000022220002222220202222020020020000200200
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
-- 000:08141e0f2a3f30346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

