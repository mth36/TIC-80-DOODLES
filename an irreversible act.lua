-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

palhex(0,0x0d2b45)
palhex(1,0x203c56)
palhex(2,0x544e68)
palhex(3,0x8d697a)
palhex(4,0xd08159)
palhex(5,0xffaa5e)
palhex(6,0xffd4a3)
palhex(7,0xffecd6)

t=0
dt=1/60
ti=0
scrw=240
scrh=136

circs={}
k=64
for cir=0,7 do
	r=cir*(sin(t/8)*5+10)
	circs[cir]={}
	circ=circs[cir]
	for ang=0,1-1/k,1/k do
		local x=scrw/2+r*cos(ang)
		local y=scrh/2+r*sin(ang)
		table.insert(circ,{x,y})
	end
end

cls()
function TIC()
	--cls()
	t=t+dt
	ti=ti+1
	
	if rnd(1)<0.025 then
		_t=rnd(240)
		_t=_t-_t%16
		x1=-30+_t
		x2=0+_t
		
		c=(t/2)%8
		
		tri(x1,0,x1+16,0,x2,scrh,c)
		tri(x1,0,x2,scrh,x1+16,scrh,c)
	end
	
	if rnd(1)<0.15 then
		x=0
		y=rnd(scrh)
		while x<241 do
			nx=x+16
			ny=y+rnd(16)-8
			line(x,y,nx,ny,ti%8)
			x=nx
			y=ny
		end
	end
	
	for i=1,1000 do
		x,y=rnd(scrw),rnd(scrh)
		ang=atan2(x-scrw/2,y-scrh/2)
		r=2
		x2,y2=x+r*cos(ang),y+r*sin(ang)
		xset(x2,y2,pix(x,y))
	end
	
	for cir=1,#circs do
		circ=circs[cir]
		
		for i=1,20 do
			ix=flr(rnd(#circ))+1
			local p=circ[ix]
			if rnd(1)<0.2 then
				ang=(ix-1)/k
				r=cir*(sin(t/8)*5+10)
				p[1]=scrw/2+r*cos(ang)
				p[2]=scrh/2+r*sin(ang)
			else
				p[1]=p[1]+flr(rnd(5)-2)
				p[2]=p[2]+flr(rnd(5)-2)
			end
		end
		
		for i=1,#circ do
			if rnd(1)<0.75 then
				p1=circ[i]
				p2=circ[i%#circ+1]
				
				if rnd(1)<0.995 then
					c=(8-cir+t/2)%8
				else
					c=rnd(8)+8
				end
				
				line(p1[1],p1[2],p2[1],p2[2],c)
			end
		end
	end
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

function rads2turns(turns)
	return turns*2*pi
end

function abs(a)
	return math.abs(a)
end

function atan2(x,y)
	return (math.atan(y,x))/2/pi
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

function sgn(a)
	if a>0 then return 1
	elseif a<0 then return -1
	else return 0 end
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

-- <COVER>
-- 000:b25200007494648393160f00880077000012ffb0e45445353414055423e2033010000000129f40402000ff00c2000000000f00880078ff4d3ad0b25445e4860d1895ffaae5d896a702c365ffce6dd6aac22dd7c295d7ecd62cac2daa9958591aad4de5edee6d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080ff00108040010a0600108031a1c38c010800783032e089841b225c586170018d8b19227cf8d172210d83233a94b80235aac5912b22b42000e3a9400225529c297237aecc85060410300438a0d1a04308103ab03961c18b031a3d4a8012e3c183040eec0030032a40953d6675e8d377254a970e5a9d49a19467db9e5f4ea45b965cacd39d3b7a1810443f6054a745960028a4d9a086a703aa44aa43f426538957baccfa8690028ea165e2dc3ba2362a579e175a66b8983136e8b37b4354bb871faedcb64b8afd0cc01a6163c653472ec9c81ba3e198395ee6c9b396a66cc3a546cd2e5254bad7b4ad4b375d3175b4f7dfa70bc6485832ed6d9e7332743ec63565ffe5b3e57a072ef17837dedc9f56ade80f97f6eecfcf9fdd8e2d5f2579d501bf0e78ef5d655d55a4187c6df6fd9b59659733174135954c9a7c55b7cb5559918465d84135d4fe5b7dc5d7a3dd59f5e7bf565d4df7f794515d08bd564fa9175255880e77ce9c7c0ab492100016951394876dd4c9186ae5f8631c704207606e48428832e47bfd57f75452890730a94b8136821c8629c4be5784041073ea561e64708e8561f84042003168ebd5631d567bd6421ec93f1d8a0e292f18851da6aa93984116c01a8e0924f755968a54b8d00708e614629d95c731ed406af4ed12979d1055d38c3200908a911e562768a34ea95426803a19b5ab590ae9b76058fd47745fff5dfdc618524c2e449823a51d59b825489ac54369a06d4a5e95a3116a56a04766a9cc6a74a29a44e0720da921687ece662fdaa26dc7caa94d42f51b5165ba0051d679b5647002b104aba820b325149d60009e64066dbc02e465d1ba3e4bb9a7a34a991d2c43014be02a70a2c47c54ab356bd257b1d154fd6578d1064e29b8b514625aba13bbfbac581b18408cbab1db6fe4a95edaf666a562109c6f82deeb9eae8c2d4be9dcc3022cbd17b07569a0feca76391b60aff935e0dc598a54a1714d1b74a81eac37b46059c6273ad220cac6bc30b99b17cce2f049c61c1aecc91a64f9db7f8d3a23e9a76b6b5f10db790628d9626d1d7ca2abe22be1e54855f48512ff951ad850400187dbd0387d2a2ad236dad5ccb1b67115bc40f3b99ddcf8687b56d9d5e9dca205d7ea644b04b2a37abeab28fabc23e695d879633d08389b19cbc67c57837d56e6ab8b6c65fdeadd3b119dc45a9559e747fd7531585a977b2267e24d06e87b816eeaabd2ab8a2dc2faee4baa492d742710f653ca1ece98b0cace8fc87cc50c3edc3192e3dc63346a334622a10408cf51a1f6d3399a52f1ff15e87555f66f71b5c84f4a76ab3e929642aa32907f8077daeedce235e5be117d4b6e8b23d9f277bbbead952340c3c390f4443fb2c93a637c9bd39a62224e2a9cffe972b210eddce6d61c110701841a502305e43c191ac90968836ac38856a83dd950ff1007eb022fb606b146f9f60168639f590de46c37e0ede4252c65910ca2924f9cffc485491c925608d8981a5e614004098d0b18902915ebae6892f12146a740983e3ea175bb1fd2e06695b089382f8f2996dfe248ea23b920514a3992a7b68701b24159ec7392c49d5c53f42c85fd6c8eeb6e8ae033ae92b81e6d857b735c17b698b89ddd6084bbd797d2d5beac0ae1545dbb790f86c4b111a4842b5b0bc9812d22241db5ace6357146d10e72d2c4ac4f6a7deafb97f6d6b42b65a443616b4b944236dbb4a182bc7b534fd92de8bf2a61f154520b606ab4e4133090058d61bbdac78ad5b43c526c29778347e6ccb8f5c5847cef67ec555ad26493299d6a0627ffeb3e172196209fbcddc024ac475106a9c49411ee2499dc4f9215c71a26662e466fd1afdcfcb3e33c1d93b39882384905449e4772a271518b725a39e9c332d0b7023853bd111527242b5e2aed894bf2e43149105c362b077c2378af8cf804c0ae6aa6701a85e54119c030157c8e672909a2ae0a404fb01371543c2e9790d6a615e4b4e32e2535211fbae7c27df3d7540cd89035e973d2f9e8259b35666f4d7a0da682c48175dbbad73932e4cd01adc8412bee436ec5ab23d84dc4440dca47c0f65716dd788e59c9a2528a8ab74f9a6683945ac819e6898a45a114bca05d4ba437365d369d45047db3561e0b2857d539b5ba74f3dbec2964813c3d5fc79e4dc8ffd96a46a7b156d631b04a50ed69b7961101bb816dd442eee0c9bd91b654aca3ac18214f0a52deced453ba437beeb64b011f324e6d7ceb08d998420127350bed522b09537a32abada9c5696579031bbc4298de9085eb4f5aff55806688b3d1b9c56b295952b6c2acd5ee56b0ab9da9a4798aa536eae6b7a8d555a757d77ad8624a6f5e52e84fde57725f91d6f935bd2d8c7db40c5ba6f4095adc705e15d719d93155028b39fca95589155dde247da32d2073eee8ceb60373f8bae94b4d19573f223109769e2a61bfa017ec98196408b6cc5235aeb61d28066012a116dd108b09965ae6140aa8656c1cca6c4a3913b5b28dac3d61c6ac731739f7b13099309ad2ff3ad1563bc9bd5ee4b5ae09b55db7aa3e2ea9ebd32b217ca8399e1bcca06ed2b0e6a7b5e4a9e433b88691feb61229de3a993acf11c8dfa8694cb39d84edb0dbb2d5fe8cfb2e4f10798a8202a493cacd5703fecba9e3c2b087b616e58c1436d30d99ad5b6a63605a0495d6d43b40c8845e50fe7371b8252be169ec4d14714c0175b52e27989d463189582e4cfd45b4e82857c4076c44d673252da3a63b681b2d86c0bee2f43ff231c415b215c432961c40e5c75e8c99ac4c43d212959d8acfba65a5ccde0f048e62873c4dd3d1b93aa236888a574052ab436bcde671a59218b64357c5c635fc6446929224f08d2372fe58e2d439d16e826aea4bec78d2b11982ff956dcb73d20759658d749260aa8a01e73d5e2107ec89df67c352e194d5714149200cad2542409d1e0cb067dd36bc4393a939d222d889bce39f19fec46245dfea2c94c352a942843758f4d3929b5ae403f2b1fc7d0fcdcd96d08e0d96c84fe198c41022372a54de4d995975d5728b5e123d15ec3cf19725224f5ee1625c7b5397301bbec0f3632ecfa13e6d08b8ce21f0774216ce95ea1ab31c4aac87c420007f03e837ee7edd8fdfe7bea378de57e3dfb0c748a4c475ea65e51fb45c2d959f274106a667ce9eaeb43e90a4be7db2ea0f999dcb979150a7b4de0f33e7b4c6d791b519accf4e931fe098672564f5385cc339887fa7d6d3d48d28c15610049f98ffdeb531c4e2757fcea56fd7b49ea0952898ce4efcefbfe9d05cb15e35a46497706da546497af7a6cb0e5d62f6f56906c07c47d159412b26000e71e7041200741e08094ed7700ab7886525cb7867735774ef57125723779c12953d2491d12611253fc3592742594b62a63ff75c5375ea78d6807d07a819b1b01a08141e08f31e41241b952b28b6d375978e31e4037eb1a52a64d76844604dc7a546f25b4b28b44672ec6021de70164623c1918b353e1125a51e154b7e637413182170683977e7967f56fd43a2045826a856922957339722735c3385dc7161b046c4864516903678a91b57556914568f71985f249b5dd75384e7738600018ba1be214384126839ff7048114662f65766fb6a28e85f12da6bb44944284c2c985234f51e15d24f4db1c529e18263959535c5e35205d84b435024c7d58788a38e93e08ed7da1e88e87317236314907214848dc4fb6407821d53de45c6d47273528ea3ae38c74935c6861b32237208293aa81486627731e6e22294727688d08888901888341018988ed7241318908ab8967db87626c5296463ac41d63d77289c4d82492c489d3d319141c5dc8e12fd10d8f53c550c8ce3b35e55b533b6d16f13727971073e08c09bc39880b2f72255bb8ae89d4b23812f053d8f32d85d221f17e54716559117e1d32682de4516e651e5503ba58a8cb84080b62d3376dd7454441c09a38801dd86392bff8a88367255665003907d170332965072a72f1b26b75b153f87211035f6a422c6ba5bc49f44e3ae8e297957418b2852039fa2339b090e8641281422541b394685d4565753668a27ba7b76e51529b154f89311286a1c558e4ac4e91d53d650559065a3055094ab41850131e8ed83b80e8d08b09f093416884977583252594d40c75d3545bc89a7134c69aa2949ca2e23d07eb68a82592010d5706325995811067931738d090730e8589801500fd8600800a88497dc58179a46a4e56e95687c78433202972f81de4172a966a7a49992bc15334c8374c53062486605f071c4b314896395898a99a9ba9839ea9ca1d241475e6ae66743099d7fd4547ad48a25f6bbff91c9b12c755b4224f69e62361e48bf59e33091118c9fb4f371a9743e798b4ec99a9fc92d92003d9e085d94414e8601381f26886028d29f49b57d36b250e1d853c8a159637714c59f3261bb3006919557cb6c999e35f2319767784a099f9fd8cf932a343901df9639ff9b380e2f085b61f4c0091ac891e4de70373715957825938a211ac12184c77be99a8256193545b23a180867143f9166cc9911d3a12ab0972a12ada9af1d58506fd6c0010055a65ae053144d2c85fe3261fc35d7328bf311a3f39b4184c120a2ff26a8f21754754081ad9033786408ec55028b49a1911c4ae41fb4aa9ba91897a9d09ca14e809441750155a55ae352f9062ce66a252969ff9428a54b48dc17f17f1d11a719a1bb9b146619754019a6db8a678868e7ab2c939c361187ab7a3d9ba9c7a9a938908a18a1c4ed6be275af6ae836f25d7dc4c6473aec1478de5591cb136ac514412848f4663449b212f3274dc3314a67ab59c67f967a31187ac01e998aa8aaf4a32210aeaa5e61ba2954ba2871e9476723c128e9c02d98f1614649ae441926f4c289e1ae6e179cacb7800a37ed7654524801fca12a2836f232a0629f98a90696b86e6bca68a347644131dda6a863ac496e4c317c89d32ca1f7d33a0bbea9d6a578058b6600318e75627300e414aa5893839c8e4a72a9aa6000622410c4b71317e269c2dea95a1c7881ad38786942e9412c4931ff29ea0c2348bc44b96c9835f9aa5647a7f1d1bc1b511e41cfa8d112b52342a7a92e71e7d4b92ba2be869d54b1374c55e743d70356784f2e8a2f5d46964ec6a259c79613c30240370373197b69d67e64a3b00b004b7013513613c1b6fa871c0994b77b74be7af0982b0948b7e9500200237441557585bcd4503b75ec7a54678764479f5b69463426a8eaa26819462e3b5d4979faa100d6b5541d127b44bf596aa87b528c4abc300a8b7d1a133351a368695269f24ca5e2612029f8ac43287cd3a3ad528153f55ba441645ec223781b25851be55dc59431182aa624e1b0733da2ab3abdfa1e80181196b80d55054b9fe92982f282951af685e490bd495a7346d6ff9d8b515f51e1819955839b7174f93c400ada1a4a8f1f9b7fabcb94bcf99c85da339d71169f5875896bab680b7c5b851bb92373ab25521d98d82d8ac0a042749812cd3131d00d76be39c27e3ec51d5a2a9fbc77bc3f9baa94fb12b64b77b0d95abd081b8fb481b805ee95e3d78b1280947b4e2400d2ca751a120c446321b1c14280c9a2f439f4714e83d6a3e3b7488ad950d5889169688a4ac936132813fb500b00b7ac1cdcbf59489dd88fb1b25e8eb75d81d2303e438090f16fad2c20ce942c91bbe2c5890c9fe5d27b5507278a807d172f9d6c1a96cb71c64c3c3f1b5f2e1cd6be4c3fb0ab788dd8e1544195680601ce34d73b4123c37b27b9c1fd3df393ff40fbe2c0c97ba815c61be628b4423d5e3853817c654411d4af4c87cafa2530d983968980844c641155835e054585e5202c1bb11351b19b9206ca32476725699132c135847830a26ca0413d26158d4e28a532d55d5a4145c641eca67a24ba1cd9cb1c1ab3abf9c05cca93e81c40dbc71ed6304bf2d3c5a5021847552a14ac17bc265ae57f6f689bbf89fd557abac9712e3d3c084c2352c626a138c97061b971c6f9b1b68c5c3bcc94cccb97b22aca925ccf1ea1418b2b3180009dcfb8896265b26512c131a1445fda5085e41ea207725cbcd6aa82075dc3dd49b72f30a452b7e671bb7127c54b44b178fccbfa062b002abecbf098d105bc585b6474736a6986ff1a75923ff5e11cd6ad55b363797809c7c1f034f3a9a60ac766d6662d9534140dd8620d99ce1b9fc9c8e0082db2ddfa2e8fa9c589e81983013e43a24032c1d65576b52e0d331f626043c346a67adf703a2c17910b32056077879b7a130416e891b3a42691aad3afcabbacfcd1c32b7a9baa7fb2e227d918ad1fec099aa84d87b3df6be98ba0a19966273e4f81a6481d31416c5e52b60881d481bd1d068f00b889b79b891bd24d00d004c797da9cc7df1ce7de4a6890899014176b658d37d33ad28fb875b7537f62f8371d031f32eb2d6e3c3d675989d9417bda3255cf581b6f5837d44c7d90e8a3184c25d9ad97b4dab4b64ba71d09701faaa8d66219d33389ff44160ec97873c27c8455a89a6ce8123e6ad75d756c5bb3d1db653b7a95c1d9fbda1e08fcdacc2fbc7d5aa3b8f7a11821751bb53754a6add4ff75e9fda2343244a9d49af87a645140eb97951123d75205917fa3da45622f4467cb721720dea2b4ad1b8889fdccbbfda7c4ac5ac4cd30623dbc2356beacb1dc6a28d11bacf79a3101b726ad1df459521efa3fe65e51952033c43067e704bd7c9b49cbd5c8a9cfa9adbf9efcfc9d1e5e81c4081e29ef501cd2ef89a128f27191f8bbdd62ae3c84c84eab647bdc847498b83989bb7cd83aa62105c22ef1cf1bb4bcebe87b7181b1b6dd9cc4dc3f00f00787a17619e32479df30ea793712433cdaf5242121236e36ffede9ad192e2d41531b8febb3162a2ddc4ed4c22a71ccaa1681059c9d35be387e87e0a538768bee14295ec5f40b47d26f2a3bc21d6d9210b3e83c6540a37acd8d72261acb77b52bdfcc2d0dbb385cc04b8a4000f2aa57f65201f00000e9e5d4dc489a4a2b9843e68e1a175eadc503634b6d8344c160178e274a051b92e679c2aac9b721439e1ceccd7a4abec9cd8f724185d5500c00f2aceec0023aa92cfb33d2148e1f3daf73d73d2b3c80dc85cf5c2ebaeb0126eae68e676ea1e18a18366a9316beafc7396fb8f9381789f542fcd6cf06b32375d2948be235b35fec8de199523929f2651e5effb864b99aaefa37dea4441ee6a2faf076cc0d1341a6ebf92eff7ffc4eec59141f00f2d1dbd241fce6c1e3a1fb861e4707a1f36bfdd7ae494cf4c8db6d444ea37147e3e68a173482d37c5e020b955fbf6dcafdeec98be59ecfd87a73fa2af425f2d3f467dfea183583f6fd42778718f49f471a15913535fbc7ea5158249208a83fc22f2aca02d4f975f85ff795a952bc5faaad7a08f60083f11810a5881174063d37ed17f6870441412c3132dddbf5dbb5eb2d6c1fbb443a55e9ce03a2938175653d54cc7ccd4dd936a95ddf4ad4ecaa0175a3f8733d57497fd55458462b9d068e189320a73628eaf97163563bd22c2d9f498fe6a3ea3ef64097f26e711b2dc97f97383da42edad27e8084cc72e5d5d2975b5bd95329fa278bfffb5aae3a3aa11e4469aeba8e90bb4f7ee1d04ebd89197f8a88cf69c096e2fdc946b1e8cfa73953f189422a2bab63b99ca6bd7ed0016080c0c3040a0e044890100185800c1e24680060c44182052e4c102131264e88152a3cc8317362448308164c88621161c3842d52947880f12080070a6e10b91047ee4e910e26740a60608102a5498a003050a08104a6419a008ac45aa15aa60a7aec20a3daa10c9d007a30c9e03cecc78723229d2bf25d2a56b3478a0539c173205ab02f221019a2b4e9c6833542e40ca67d63c1846f6206c975972c5ab81b825caa20a0c357ac41ae3d5a55d8a2ed944b6a754c700088e1b46b06fd2b8a12a0e5dc6b0f248c40406c53ff9201f63eabf1b3e049b625579d0d83d022e1c3adce341d3a3437e00b5913dd7ea97ae47bc15196379eb9d3f5d30d0e078d0d3a5c31f58549f6ae19ebf5ec4291770a9f8b5176f08207bb1ffcf9eeb73d65fc0f0c001e24b1e4837929b0be53305ca4c2726e0e2d983a7cc1bce8a36a0b3fc433daa936ee330da6aa94930c8820f84ba806a892da4f6d349e4acba5c7bed23a60010873cda64a1bd39b81a98ef3cbceb1098b59cf31b462507ca4c634e96080042c0a6ba6a624b0b8a82da2da8a4ecab360d6a4eeb3c9c000044c30ccb5da03496cce13f27902a31de3cd8827b07ca19e2eda74835e4df0f2694048821c5885201962d9013f010be983a5213aff3492a1ac6a905ac925b342972faa72b900d0f0c33a443235123b462639e4898cc8318ae198263745c8c74db452b15f369604386c44e6c42d64bd961cc9a002477234b3a4471da9a1592335ea81d4a22d00cb35cc254c4c301b9d79e4b798451c0552555a91da2b635ddd6e4efa1b33902382d42278c59443f2d34e928b32f7df572af59b2fc2cc2a8e59e4bcda208ca83bd719c1fe255e6c51bccc75becc15dad6355486649c49c7717b355fa073e4f1f52bdac53ee5532175d2172d531be739444b3ad5d24a7f15ea6054659ab591cfee950f4c318fc2eb68b4f4ec4316bf82f3077425a49cd69ecafa005817cbde6c6114548a4c2778b682935e6d5d57aeff30e3eff0e5e518ef5b4ea73f5dc4b4d7972702081b9725a23be83c34ea659990b3115ba3b2e0251a0904a0902e6f0f22ab7ddd6f32068e2a5037986ba9dcc59a8c3110304f6aa98a6ba172f5f0d701157998daa2ccaa1c6e7f62d55e567b4b1fc9d3e4dc4d6cceda7c5de55ade1ae887639ae3af807abe16053749d507cd73de494ac359bebc0cc2f378cb75e55275c03cc4fce84505149bc998de7bdc400810ae577f11e63984bbad32bb72aee55a1a98edbd7578b7e6552ecd5426d4032e204ded65f98bc0d08a5252744b87d0baceca85465fdfc70d66d3b466769894248a7c002c0d8af3b22bb4be232921cfc30786a73cd01de167da0ac1c6429b360aff8ba52089500102489720d1d4e951824c0df2158fbba8cb8a45faef5bc8971c922d8526546179020b666d3f65dd082a19b8440f3238363d8f6c7413ef8050e231348de5c73ce91798b012b00029ade121f31e5c9e14b83c7d58ae7e936e8868251c14163be257348bdb6835d44422e5ee2f3cbb5d7ef627cbd88f6f62ebb65dece3a4c1ac994d7c644d1a8212d2199051f74c63f054def309bde5d8e32f1204d66234b1acc50a4e71cb00e91535d711c520984d6cdf436ec63a4488111f87acf3ec9226a82f3a2d888ee1e1ea5610b08d392ea2572cc9ce80048a204195ae5e23e9c04cc65921e5ad26643c384b6c39e9a5f4303f8e4ce1a368e33a425efc24ff29598dd9d267371881c2d59b79cb1af8992db01e94a7705301952719bd2b59f29f775148ce4000aba97a0f0c203ba1ad05d41aacd1be659cda1c1648869494a0535b9ad4fe58d4f53acd6e7beb51ea411435c92e4e72f5248b7a3b8f42f992c1e961d488c1ba04ec291f316265a655cc9510f2c3c1ca6d303d2da2e66637922b1a6663367ed3af06561ac0d551ba8e4baacb583d5941dc95c4ac9a6213e7470642c0e83253ab631d0080e7931208abc72adbfc5d0f970da532b45d3e94a89f15157639d494e88e0c96665af58dc1f14498a9e369ea5ec371d2c99053a0535c19ca64f454cdbfad5aecf01a4fb27925c5103693d223964c987ebe8821592f73ff552c15000089ca4649766b52d95bb51757b276136da9e49342e7269bbea3132d8cf1a3b80b755136e48362c31f08564443422dee6a534c4062c23846593a34932e09bc8567f51235ba6694533a8b6a293bce1281a68fa725e95749e7855fdd3fe977848de659d5022e491e2d45733b8f6bb9d111f595ff9319ac607d2ba055bae4d8bd19919777d7f6555a242d22f520ab66b76a5ab0571d96dd890165d6ff58de1009bb2a6269b47b172c3648ae223a9c8a7597c2b6f6e4fdb2004f25692bc1c2bcd9e18862f4de35a7e39271f9643c119e2086876646b041704e092657caaba5510a16d0b922394c7954b0e631c8cd45145f245a8b123451681a2408ace6ff81c9b71f7ae7eb78e311bd6d6cb63fd1a67193fb5468e80c64af115955b86921ad011c13dbd8e81637eda0636433a7dffc9d28c16322b5b28b84e32ba406386243d393f327d584008c54a33dc8705c75bdfa45f4a8e4caa6ca43a5adaecac95b6a46ed83a9595d11162868acbb9f89f8c8964e4622c1c56e4191db79142fde00a1268360ecebe7ee4964b960554daa8b19c84613e5504104eb6a49ac8e460a1e6648199c2be4738a2c3ad4932991aa8b54644e5af80914d58a425df086d813233c0fc01d19864c64be121749f536a98aa591824b6d2b6730358d61f0c0aa0540d67ac8c0c616f2898641c4be9d29dac60acd1523bf68a48af142deb0274e23ffe1e3a105d7abde43198b6bb9237b5beac585cb2cc2089ee03f89136c018d168f7b1fed61a2de86fecccb73fddc6f4b462adff6da10c7ad47993ffdc54c4c29c3459b12665f7b34c05519f8bda8117b56cc2dd6c1142b6a125f1ace2b73e77343b04d6af175a0143924de98cedaad52f9c41fc16a2f703e6c8c674ef0f8aebcdc5f134cfc8fd3f827a003fcd6d4cf1da5ee935c9ce28b7cac843efb50fa205495f638ab98f83e6d837d38bdedd71d44b6e112f5ddc570ce8ab17583ed48ba72d07bfcf6306ca98aab1e6ca1dd6f613964d24841cd463526cd89f8c99e9777034d3aedcee77ae9a406b1c3be0e53d6fb03857e87a2a1d7157da6cd53afdb78f1ff11085bafeb0476ea49e21a3eb4ec690c7f68ef8d23df9dd1dedfc118b1df8d11e00800aaf4910ca29c6291931fbe5ad7874cf43f4f5f10c4fdeb9515692a641774cd9d399bf7c40d1cfffbf3acac0fb493f43ef0d8035c6a65a9d0a7a5b7ba11d83739293be330c7a0a4100ade31495c95936939b338a7c19ea3f30d2331db0fe2fdb6f3fb0e99bcb91bf31501e42280f89aa18c25883bb9322902528c2ef3bd1413d527eb32a5a091c1513a8d71304d01b21b294047da29149b3d2d529b3c0bf8b6a2bd162394b882bda4caffa62b163c9a0eb91b3d832c4d9aa9f99431eda21c18832b48838aeb1989d19412eab8a37ca839ff82a8ca8ac1c1cb594045c0ffdc1bab831d83a24ba9101719451c1266aba1d1928017afd8b3b3a9fe933b2d10e33e82c80c0ed9834af8d2c3e3bfbc2468141c3f268a89b2fb1822a009323cd5a23c33c069e90d1c67106246170ca118c15a054b1e15593b05ea572ad3961319a9997b5d1d19f0b17a5aad4a954ecbfb9972d622e3d4951464442bfb9681bbbe99bd8cc9f9946b9cb6c857a2883696346c913ae1c81273cef295325ac310011b24d1fe9d80d595597592e3319f983a161973a4c220a0c02d1201ed93b3d34a82b6c280d516444e221c89adc2280af0a247a38b01a0482464b6c97966cfe057236286cba005cc7b834214212f24db8244a0ad6c179674981c04711539c117b9ff97a5b1a99202b5c784c2cafa7d1298874f641faf320099a191cdb3541d7c853909b01241e1ce896c1002f09099ef9199a1139caf89118d18c150a209a7c459a6c63b8844ca5d129cfaa1abb8c0893b34f05110c138b252bcac24644b54b449c34637b8c7c5a0c7b629ea95e05914c8154ff9c5158a812b619ab803f5c48cf4148143164ad52082fe24b229c20a7885ac9a9cf29fa90ab19dbcb5c7c2f5cfb46cb05c0d89a9f13269da4452334fc0a940c2f8915acc109958a849e79e8b02c64455c3596927f8db1ef26cb9747d9bd00437883bb7c25a84ac0b3b3b893998314f5c303f615ebd11c391c426469cf131d309b3695bad4cd9880426c83c903d9a5fe98d7948902b1887ca574a69d24793ad8db9d1b45193a5d067a271bb42884a41d49ba0749b10e2932689eda1aaf247f19dc182ca49628e8aa0699dd483bd92833edcf89d92a0b6f24fc9c193bacc3031eb76ad2cb9218aa91d0a97cb9c90a2dc1218e90a3274584f412539ac214584d5a2fb0e04637128eb2fcaa03b9fdcc017e0a4c8045910cb3f45c81e4afc171bfc22c41ccf4f34ccc961b690d21d4fbcd5c105f414f9884aca6dc2e431db446050bccc1712819831c09841fa1ce0fd4a6afac18cca110cfbb77c6c44ec41c9c3e493812b067211382a51d324cd9b04815981f6cefc8b81cc6ab811805ea4741469e1571a080000b3
-- </COVER>

