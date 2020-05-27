-- title:  game title
-- author: game developer
-- desc:   short description
-- script: moon

export TIC
local *

palhex(0,0x000011)
palhex(1,0x111122)
palhex(2,0x222233)
palhex(3,0x333344)
palhex(4,0x444455)
palhex(5,0x555566)
palhex(6,0x666677)
palhex(7,0x777788)
palhex(8,0x888899)
palhex(9,0x9999aa)
palhex(10,0xaaaabb)
palhex(11,0xbbbbcc)
palhex(12,0xccccdd)
palhex(13,0xddddee)
palhex(14,0xEEEEff)
palhex(15,0xFFFFFF)

SCRW=240
SCRH=136
DT=1/60

T=0
TF=0

cls()
ox=rnd(SCRW)
oy_init=40
oy=oy_init
oy_max=SCRH*4/5
wi=4
wf=12
w=6

xi=0
TIC=->
	--cls()
	T+=DT
	TF+=1

	if btnp(4)
		cls()
		oy=oy_init
		xi=0
	
	xs=[i for i=0,SCRW when i%13==0]
	for i=1,sqr(#xs)
		a=flr(1+rnd(#xs))
		b=flr(1+rnd(#xs))
		xs[a],xs[b]=xs[b],xs[a]
	
	trace("")
	trace(#xs)
	while xi<#xs and oy<SCRH-20
		xi+=1
		ox=xs[xi]+flr(rnd(7))-3
		oy=oy+rnd(5)+2
	
		trace(xi)
		
		x,y=ox,oy
		w=(wf-wi)/oy_max*y + wi
	
		cc=1+(oy)/(16+rnd(3)-1+(SCRH-oy))
		leandir=rnd(1)<0.5 and 1 or -1
		leanchance=rnd(0.05)+0.025
		while y>=0
			ca = cc + 4/(max(0,oy-y))/(#xs-xi)
			line(x,y,x+w-1,y,ca)
			if rnd(1)<0.01 and w>4
				w-=1
				x+=rnd(1)
			if rnd(1)<leanchance
				w-=0.2
				x+=0.1
				x=x+leandir
			y-=1
	
	
	
	xs=[i for i=0,SCRW when i%12==0]
	t=xs
	for i=1,#xs*2
		a=flr(1+rnd(#xs))
		b=flr(1+rnd(#xs))
		xs[a],xs[b]=xs[b],xs[a]
	
	
	

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

