-- title:  game title                     -- Briefly shows the name of the cart.
-- author: game developer                 -- Briefly shows who made the cart.
-- desc:   short description
-- script: moon

export TIC
local *

palhex(0, 0x0d2b45)
palhex(1, 0x203c56)
palhex(2, 0x544e68)
palhex(3, 0x8d697a)
palhex(4, 0xd08159)
palhex(5, 0xffaa5e)
palhex(6, 0xffd4a3)
palhex(7, 0xffecd6)

SCRW=240
SCRH=136
DT=1/60

T=0
TF=0

player =
	x:SCRW/2
	y:SCRH/2

k=64
r=16
rmod=0.9
d=64
c1=[{SCRW/2-d/2+r*cos(ang), SCRH/2+r*sin(ang)} for ang=0,1,1/k]
c2=[{SCRW/2+d/2+r*cos(ang), SCRH/2+r*sin(ang)} for ang=0,1,1/k]
c11=[{SCRW/2-d/2+r*rmod*cos(ang), SCRH/2+r*rmod*sin(ang)} for ang=0,1,1/k]
c22=[{SCRW/2+d/2+r*rmod*cos(ang), SCRH/2+r*rmod*sin(ang)} for ang=0,1,1/k]

cls(0)
TIC=->
	T+=DT
	TF+=1

	cens={{-d/2,0},{d/2,0}}
	for ci,c in pairs {c1,c2}
		for i,p in pairs(c)
			if rnd(1)<0.1
				ang=(i-1)/k
				p[1]=SCRW/2 + cens[ci][1] + r*cos(ang)
				p[2]=SCRH/2+r*sin(ang)
			else
				p[1]+=rnd(4)-1.5
				p[2]+=rnd(4)-1.5

	c=(T*8)/8%7+1

	look=vec(1,2)\norm(2)

	for i=1,2000 do
		x,y=rnd(SCRW),rnd(SCRH)
		p=pix(x,y)
		p=rnd(1)<0.1 and max(0,p-1) or p
		if p>-1 then xset(x+look.x,y+look.y,p)

	y=TF-TF%16
	y=y%(2*SCRH)
	rect(0,y,SCRW,y+64,0)

	poly(c1,nil,(x1,y1,x2,y2,i,tbl)->(T*4+i)/8%7+1)
	poly(c2,nil,(x1,y1,x2,y2,i,tbl)->(T*4+i)/8%7+1)

	polyf(c11,0)
	polyf(c22,0)

-- <CODE6>
-- STRUCTURE / LIB

export *

class eventemitter
	new:=>
		@listeners={}
		@queue={}
	on:(t,h)=>
		if (@listeners[t]==nil)
			@listeners[t]={}
		add(@listeners[t], h)
	off:(t,h)=>
		table.remove(@listeners[t], h)
	emit:(t,e)=>
		foreach(
			@listeners[t],
			(h)->h(e)
		)
	enqueue:(t,e,priority)=>
		priority=flr(max(0, priority or 0))
		add(@queue, {:t, :e, :priority})
	dequeue:(comp,filter)=>
		comp=comp or (a,b)->a<b
		has_filter=filter==true
		filter=filter or (a)->true

		qsort(@queue,comp)
		for item in *@queue
			if filter(item)
				@emit(item.t,item.h)
			if has_filter
				del(@queue, item)
		if not has_filter
			@noqueue!
	noqueue:=>
		@queue={}
class vec
	new:(x,y,z)=>
		@x=x or 0
		@y=y or 0
		@z=z or 0
	setc:(x,y,z)=>
		@x=x or 0
		@y=y or 0
		@z=z or 0
	set:(v)=>
		@setc(v.x,v.y,v.z)
	norm:=>
		@/#@
	unpack:=>
		@x,@y,@z
	constrain:(anchor,dist,cond)=>
		cond=cond or (-> true)
		if cond(@,anchor,dist)
			(@ - anchor)\norm! * dist + anchor
		else
			@copy!
	constrain_min:(anchor,dist)=>
		@constrain(anchor,dist,(anchor,dist)=>
			#(@ - anchor) < dist
		)
	constrain_max:(anchor,dist)=>
		@constrain(anchor,dist,(anchor,dist)=>
			#(@ - anchor) > dist
		)
	copy:=>
		vec(@x,@y,@z)
	cross:(v)=>
		vec(
			@y*v.z - @z*v.y,
			@z*v.x - @x*v.z,
			@x*v.y - @y*v.x
		)
	dot:(w)=>
		@x*w.x + @y*w.y + @z*w.z

	__add:(a,b)->
		vec(a.x+b.x,a.y+b.y,a.z+b.z)
	__sub:(a,b)->
		vec(a.x-b.x,a.y-b.y,a.z-b.z)
	__mul:(v,a)->
		if type(a)=='number'
			vec(v.x*a,v.y*a,v.z*a)
	__div:(v,a)->
		if type(a)=='number'
			vec(v.x/a,v.y/a,v.z/a)
	__unm:=>
		return vec(-@x,-@y,-@z)
	__len:=>
		sqrt(sqr(@x)+sqr(@y)+sqr(@z))
class coroutinemanager
	new:=>
		@coroutines={}
		@s=@coroutines
	update:=>
		for cor in *@s
			if @status(cor)=='dead'
				del(@s,cor)
			else
				@resume(cor)
	create:(f)=>
		cor=coroutine.create(f)
		@register(cor)
		cor
	register:(cor)=>
		add(@s,cor)
		cor
	resume:(cor)=>
		coroutine.resume(cor)
	status:(cor)=>
		coroutine.status(cor)

-- </CODE6>

-- <CODE7>
-- PICO-8 API

export *

PI=3.14159

foreach=(t,func)->
	for k,e in pairs(t)
		func(e)

add=(t,e)->
	table.insert(t,e)

lerp=(a,b,t)->
	a+t*(b-a)

lerp2d=(x1,y1,x2,y2)->
	lerp(x1,x2,t),lerp(y1,y2,t)

approach=(a,b,t) ->
	if a<b
		min a+t,b
	else
		max a-t,b

approach2d = (x1,y1,x2,y2,t) ->
	dd = dist x1,y1,x2,y2
	t = t/dd
	lx = lerp x1,x2,t
	ly = lerp y1,y2,t
	lx,ly

xset = (x,y,c) ->
	circb x,y,1,c

xfill = (x,y,c) ->
	circ x,y,1,c

rads2turns = (rads) ->
	rads / (2*PI)

turns2rads = (turns) ->
	turns * 2 * PI

abs=(a)->
	math.abs a

atan2=(x,y)->
	rads2turns(math.atan(x,y))

cos = (a) ->
	math.cos(turns2rads(a))

sin = (a) ->
	math.sin(turns2rads(a))

rnd = (a) ->
	math.random! * a

flr = (a) ->
	math.floor a

fflr = (a,unit) ->
	a - a%unit

max = (a,b) ->
	math.max(a,b)

min = (a,b) ->
	math.min(a,b)

mid = (a,b,c) ->
	x=a
	if a<b
		x=b
	elseif x>c
		x=c
	x

sqrt = (a) ->
	math.sqrt(a)

sqr = (a) ->
	a*a

dist = (x1,y1,x2,y2) ->
	sqrt(sqrdist(x1,y1,x2,y2))

sqrdist = (x1,y1,x2,y2) ->
	sqr(x2-x1) + sqr(y2-y1)

frames = (sec) ->
	sec*60

secs = (frames) ->
	frames / 60

palrgb = (i,r,g,b) ->
	i = mid(0,i,15)
	if r==nil and g==nil and b==nil
		return peek(0x3fc0+(i*3)),peek(0x3fc0+(i*3)+1),peek(0x3fc0+(i*3)+2)
	else
		if r==nil or r<0 then r=0
		if g==nil or g<0 then g=0
		if b==nil or b<0 then b=0
		r=min(r,255)
		g=min(g,255)
		g=min(g,255)
		poke(0x3fc0+(i*3)+2,b)
		poke(0x3fc0+(i*3)+1,g)
		poke(0x3fc0+(i*3),r)
		nil

palhex = (i,hex) ->
	palrgb(
		i,
		flr(hex/65536)%256,
		flr(hex/256)%256,
		flr(hex/1)%256
	)

poly = (tbl,c,cfunc) ->
	c=c or 15
	for i=1,#tbl do
		p1=tbl[i]
		p2=tbl[i%#tbl+1]
		x1,y1=p1[1],p1[2]
		x2,y2=p2[1],p2[2]
		line(x1,y1,x2,y2,cfunc and cfunc(x1,y1,x2,y2,i,tbl) or c)

polyf = (tbl,c,cfunc) ->
	c=c or 15
	p1=tbl[1]
	if #tbl==1
		pix(p1[1],p1[2])
	elseif #tbl==2
		p2=tbl[2]
		x1,y1=p1[1],p1[2]
		x2,y2=p2[1],p2[2]
		line(x1,y1,x2,y2,c)
	else
		for i=0,#tbl-2-1 do
			ix=i+2
			p2=tbl[ix]
			p3=tbl[ix+1]

			x1,y1=p1[1],p1[2]
			x2,y2=p2[1],p2[2]
			x3,y3=p3[1],p3[2]
			tri(x1,y1,x2,y2,x3,y3,
				cfunc and cfunc(x1,y1,x2,y2,x3,y3,i) or c
			)

choose = (cond,a,b) ->
	cond and a or b
-- </CODE7>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

