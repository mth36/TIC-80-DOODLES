-- title:  game title                     -- Briefly shows the name of the cart.
-- author: game developer                 -- Briefly shows who made the cart.
-- desc:   short description
-- script: moon

export TIC
local *

EVT = EventEmitter()

palhex(0,0x08141e)
palhex(1,0x0f2a3f)
palhex(2,0x20394f)
palhex(3,0x4e495f)
palhex(4,0x816271)
palhex(5,0x997577)
palhex(6,0xc3a38a)
palhex(7,0xf6d6bd)

SCRW=240
SCRH=136
DT=1/60
SQRT2=sqrt(2)

T=0
TF=0

r=16

pos=vec(SCRW/2,SCRH/2)
vel=vec\frompolar(rnd(1),2)
acc=vec\frompolar(0,0.1)
useacc=true

ofs={}

cls!
TIC=->

	T+=DT
	TF+=1

	-- for i=1,200
	-- 	x,y=rnd(240),rnd(136)
	-- 	c=pix(x,y)-1
	-- 	c=max(c,0)
	-- 	xset(x,y,c)

	for i=1,1000
		x,y=rnd(240),rnd(136)
		xset(x,y,pix(x,y))

	for i=1,250
		p1 = vec\frompolar(rnd(1),sqrt(rnd(68*68)))
		p2 = vec\frompolar(p1\ang!+0.05, p1\r!+1)
		p1+=vec(SCRW/2,SCRH/2)
		p2+=vec(SCRW/2,SCRH/2)
		c=pix(p1.x,p1.y)
		if c>0
			xset(p2.x,p2.y,c)

	for i=1,1500
		x,y=rnd(240),rnd(136)
		xs=x + 1*sgn(x-SCRW/2)
		c=pix(x,y)
		if rnd(1)<0.075 then c = max(0, c-1)
		if c~=0
			xset(xs,y,c)

	ps={}
	k=4+sin(sin(T/8))+0.5
	r=16+sin((T/8))*32+16
	for ang=0,1,1/k
		ang=ang + ang*0 +  T/3 + sin(T/8)*0.8 + sin(k/64 - T/16)/16
		ox=pos.x + r*cos(ang)
		oy=pos.y + r*sin(ang)
		add(ps,{ox,oy})

	if rnd(1)<0.03
		x=0
		y=SCRH/2
		while x<SCRW
			nx=x+rnd(40)-19
			ny=y+rnd(12)-6
			line(x,y,nx,ny,(pix(nx,ny)+4)%8)
			line(x,y+1,nx,ny+1,pix(nx,ny))
			x,y=nx,ny

	ss={}
	k=4
	r=20
	for ang=0,1,1/k
		ang = ang - T/8
		ox= SCRW/2 + r*cos(ang)
		oy= SCRH/2 + r*sin(ang)
		add(ss,{ox,oy})

	r=(T*128%300)-150
	r=r-r%8
	circb(SCRW/2,SCRH/2,r,0)
	circb(SCRW/2,SCRH/2,r+1,0)

	polyf(ps,0)
	poly(ps,T*2%8)

	p1=vec(ss[1][1],ss[1][2])
	p2=vec(ss[2][1],ss[2][2])
	p3=vec(ss[3][1],ss[3][2])
	p4=vec(ss[4][1],ss[4][2])

	for i=0,1,1/7
		v1=lerpv(p1,p4,i + cos(T/11 - i/30))
		v2=lerpv(p2,p3,i*((sin(T/11)+1)/2+0.5))
		ws={}
		for j=0,1,1/16
			w=lerpv(v1,v2,j)

			ow=w\orth!

			tf=TF%400
			b1=80
			b2=270
			if tf>b1 and tf<b2
				bn=b2-b1
				tf=tf-b1
				tf=-2*abs(tf-bn/2)+bn
				w = w + (ow\norm(2)*sin(j*2 + i + T/2) * tf/bn )

			add(ws,w)

		c=0
		if pix(v1.x,v1.y)~=0 or pix(v2.x,v2.y)~=0
			c=min(i*8,7)
			c=max(c,1)
		
		for idx=1,#ws-1
			v1=ws[idx]
			v2=ws[idx + 1]

			line(v1.x,v1.y,v2.x,v2.y,c==0 and 7 or c)
			line(v1.x,v1.y+1,v2.x,v2.y+1,c)
			line(v1.x,v1.y+2,v2.x,v2.y+2,c)

	--poly(ss,15)

-- <CODE6>
-- STRUCTURE / LIB

export *

class EventEmitter
	new:=>
		@listeners={}
		@queue={}
	on:(t,h)=>
		if (@listeners[t]==nil)
			@listeners[t]={}
		add(@listeners[t], h)
		if debug
			trace("EVT\\ON\\#{t}")
	off:(t,h)=>
		table.remove(@listeners[t], h)
	emit:(t,e)=>
		if debug
			trace("EVT\\EMIT\\#{t}")
		if @listeners[h]
			for h in *(@listeners[t])
				h(e)
	enqueue:(t,e,priority)=>
		priority=flr(max(0, priority~=nil or 100))
		add(@queue, {:t, :e, :priority})
	dequeue:(comp,filter)=>
		comp=comp or ((a,b)->a<b)
		has_filter= filter==true
		filter= filter or ((a)->true)

		for key,item in pairs @queue
			if filter(item)
				@emit(item.t,item.e)
			if has_filter
				table.remove(@queue, key)
		if not has_filter
			@noqueue!
	noqueue:=>
		@queue={}

class vec
	@frompolar:(ang,r)=>
		return vec(r*cos(ang),r*sin(ang))

	new:(x,y,z)=>
		@x=x or 0
		@y=y or 0
		@z=z or 0
	setc:(x,y,z)=>
		@x=x or @x
		@y=y or @y
		@z=z or @z
	set:(v)=>
		@setc(v.x,v.y,v.z)
	polar:=>
		@ang!,@magn!
	ang:=>
		atan2(@x,@y)
	r:=>#@
	magn:=>#@
	cmult:(a,b)->
		vec(
			a.x*b.x
			a.y*b.y
			a.z*b.z
		)
	setang:(ang)=>
		@setpolar(ang,#@)
	setr:(r)=>
		@setpolar(@ang!,r)
	setpolar:(ang,r)=>
		@setc(r*cos(ang), r*sin(ang))

	nonzero:=>
		not (@x==0 and @y==0 and @z==0)
	norm:(len)=>
		len=len or 1
		@nonzero! and  (@/#@ * len) or vec()
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
	perp:=>
		vec(-@y,@x)
	copy:=>
		vec(@x,@y,@z)
	cross:(v)=>
		vec(
			@y*v.z - @z*v.y,
			@z*v.x - @x*v.z,
			@x*v.y - @y*v.x
		)
	cmult:(a,b)->
		vec(
			a.x*b.x
			a.y*b.y
			a.z*b.z
		)
	dot:(w)=>
		@x*w.x + @y*w.y + @z*w.z
	distr:(f)=>
		vec(f(@x),f(@y),f(@z))
	fflr:(unit)=>
		@distr((a)->fflr(a,unit))
	fflrz:(unit)=>
		signs=@distr(sgn)
		fv=@distr(abs)\fflr(unit)
		return fv\cmult(signs)
	orth:=>vec(-@y,@x)
	tocam:=>CAM\tocam(@)
	fromcam:=>CAM\fromcam(@)
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
	__tostring_polar:=>
		ang=atan2(@x,@y)%1
		r=dist(@x,@y,0,0)
		"<a:#{fflr(ang,0.01)},r:#{fflr(r,0.01)}>"
	__tostring:=>
		x,y,z=@x,@y,@z
		return "<#{x},#{y},#{z}>"

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

sgn = (a) ->
	if a>0
		return 1
	elseif a<0
		return -1
	else
		return 0

foreach=(t,func)->
	for k,e in pairs(t)
		func(e)

add=(t,e)->
	table.insert(t,e)

lerp=(a,b,t)->
	a+t*(b-a)

lerpv=(v,w,t)->
	vec(lerp(v.x,w.x,t), lerp(v.y,w.y,t))

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

