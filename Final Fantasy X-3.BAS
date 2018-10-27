'FINAL FANTASY X-3 by Cameron Armstrong

'Squaresize default=20
squaresize=20
squaresizememory=squaresize
'2 square length barrier perimeter on each map

gosub setup
gosub mainmenu

label setup

open window 640,512
window origin "lb"
gil=500
yunalevel=1
rikkulevel=1
painelevel=1
maxclouds=4
dim mapx(20),mapy(15),clouds(maxclouds),cloudx(maxclouds),cloudy(maxclouds),density(100),red(maxclouds),green(maxclouds),blue(maxclouds)
for a=1 to maxclouds
	cloudx(a)=ran(640)
	cloudy(a)=ran(512)
	density(a)=ran(100)
	red(a)=ran(255)
	green(a)=ran(255)
	blue(a)=ran(255)
next a
command=1
return
	
label mainmenu
setdrawbuf dw
clear window
sfx=sfx+.01
setrgb 1,255*sin(sfx),255*cos(sfx),255*sin(sfx)
fill rectangle 0,0 to 640,512
for a=1 to maxclouds
  for thickness=1 to density(a)
    setrgb 1,red(a),green(a),blue(a)
    fill rectangle cloudx(a),cloudy(a) to cloudx(a)+density(a),cloudy(a)+.5*density(a)
    cloudx(a)=cloudx(a)-.5
    if cloudx(a)<0 then
      cloudx(a)=640
      cloudy(a)=ran(512)
      density(a)=ran(100)
      red(a)=ran(255)
      green(a)=ran(255)
      blue(a)=ran(255)
    fi
  next thickness
next a

setrgb 1,0,0,0
fill rectangle 240,250 to 400,300
setrgb 1,255,0,255
rectangle 240,250 to 400,300
setrgb 1,255-255*sin(sfx),255-255*cos(sfx),255-255*sin(sfx)
text 235,400,"FINAL FANTASY X-3"
setrgb 1,255,255,0
text 280,280,"NEW GAME"
text 280,260,"CONTINUE"
setrgb 1,0,255,0

if command=1 text 255,280,"=>"
if command=2 text 255,260,"=>"
if peek("port1")=16 and command=2 then
  beep
  command=1
fi
if peek("port1")=64 and command=1 then
  beep
  command=2
fi
if peek("port1")=16384 and command=1 then
  beep
  goto newgame
fi
if peek("port1")=16384 and command=2 then
  beep
  goto cont
fi
setdispbuf dw
dw=1-dw
goto mainmenu
      
label newgame
dim map(20,25)
yunaxs=squaresize/2
yunays=squaresize/2
yunaxl=10
yunayl=10
restore map1lower
currentmap=1

label main
gosub setbuffer
gosub lowermapsetter
gosub drawlowermap
gosub uppermapsetter
gosub drawuppermap
gosub controls
gosub drawyuna
gosub cpu
gosub displaybuffer
goto main
      
label setbuffer
setdrawbuf dw
clear window
return
      
label lowermapsetter
if currentmap=1 restore map1lower
if currentmap=2 restore map2lower
if currentmap=3 restore map3lower
if currentmap=4 restore map4lower
if currentmap=5 restore map5lower
return
								
label drawlowermap
'Data values:
'0=blank
'1=
'2=grass high detail
'3=grass low detail
for h=1 to 20
  for w=1 to 25
    read map(h, w)
  next
next
scry=60
for h=20 to 1 step -1
  scrx=80
  for w=1 to 25
    if map(h,w)=2 then
      setrgb 1,0,155,0
      fill rectangle scrx, scry to scrx+squaresize, scry+squaresize 
      setrgb 1,10*effect,200,0
      for grass=0 to squaresize step 2
        for lawn=0 to squaresize/4
          line scrx+grass,scry+4*lawn to scrx+grass+ran(1)-.5,scry+4*(lawn+1)-1+10*effect
        next lawn
      next grass
    fi
    if map(h,w)=3 then
      setrgb 1,0,155,10*effect
      fill rectangle scrx, scry to scrx+squaresize, scry+squaresize 
    fi
    scrx=scrx+squaresize
  next w
  scry=scry+squaresize
next h
return
            
label uppermapsetter
if currentmap=1 restore map1upper
if currentmap=2 restore map2upper
if currentmap=3 restore map3upper
if currentmap=4 restore map4upper
if currentmap=5 restore map5upper
return
														
label drawuppermap
'0=nothing
'1=water
'2=rock
for h=1 to 20
  for w=1 to 25
    read map(h, w)
  next
next
scry=60
for h=20 to 1 step -1
  scrx=80
  for w=1 to 25
    if map(h,w)=1 then
      setrgb 1,0,0,255
      fill rectangle scrx,scry to scrx+squaresize,scry+squaresize
      setrgb 1,0,255,255
      for sparkles=1 to int(ran(5))+1+effect
        sparklex=scrx+ran(squaresize)
        sparkley=scry+ran(squaresize)
        fill rectangle sparklex,sparkley to sparklex+2,sparkley+2
      next sparkles
    fi
    if map(h,w)=2 then
      setrgb 1,50+10*effect,15,0
      fill circle scrx+squaresize/2,scry+squaresize/2,squaresize/3
    fi
    scrx=scrx+squaresize
  next w
  scry=scry+squaresize
next h
return
																			
label controls
if currentmap=1 restore map1upper
if currentmap=2 restore map2upper
if currentmap=3 restore map3upper
if currentmap=4 restore map4upper
if currentmap=5 restore map5upper
for h=20 to 1 step -1
  for w=1 to 25
    read map(h, w)
  next
next
if and(peek("port1"),1)>0 encounter=1
if and(peek("port1"),16)>0 yunays=yunays+4
if and(peek("port1"),64)>0 yunays=yunays-4
if and(peek("port1"),128)>0 yunaxs=yunaxs-4
if and(peek("port1"),32)>0 yunaxs=yunaxs+4
if yunaxs>squaresize and map(yunayl+1,yunaxl+2)=0 and yunaxl<23 then
  yunaxs=0
  yunaxl=yunaxl+1
fi
if yunaxs>squaresize and (map(yunayl+1,yunaxl+2)>0 or yunaxl>=23) then
  yunaxs=squaresize
fi
if yunaxs<0 and map(yunayl+1,yunaxl)=0 and yunaxl>2 then
  yunaxs=squaresize
  yunaxl=yunaxl-1
fi
if yunaxs<0 and (map(yunayl+1,yunaxl)>0 or yunaxl<=2) then
  yunaxs=0
fi
if yunays>squaresize and map(yunayl+2,yunaxl+1)=0 and yunayl<18 then
  yunays=0
  yunayl=yunayl+1
fi
if yunays>squaresize and (map(yunayl+2,yunaxl+1)>0 or yunayl>=18) then
  yunays=squaresize
fi
if yunays<0 and map(yunayl,yunaxl+1)=0 and yunayl>2 then
  yunays=squaresize
  yunayl=yunayl-1
fi
if yunays<0 and (map(yunayl,yunaxl+1)>0 or yunayl>=2) then
  yunays=0
fi
return
        
label drawyuna
setrgb 1,150,50,100
fill circle yunaxl*squaresize+80+yunaxs,yunayl*squaresize+60+yunays+squaresize*.8,squaresize/4
line yunaxl*squaresize+80+yunaxs,yunayl*squaresize+60+yunays+squaresize*.8 to yunaxl*squaresize+80+yunaxs,yunayl*squaresize+60+yunays+squaresize*.3
line yunaxl*squaresize+80+yunaxs,yunayl*squaresize+60+yunays+squaresize*.3 to yunaxl*squaresize+80+yunaxs-.2*squaresize,yunayl*squaresize+60+yunays
line yunaxl*squaresize+80+yunaxs,yunayl*squaresize+60+yunays+squaresize*.3 to yunaxl*squaresize+80+yunaxs+.2*squaresize,yunayl*squaresize+60+yunays
line yunaxl*squaresize+80+yunaxs-.2*squaresize,yunayl*squaresize+60+yunays+squaresize*.5 to yunaxl*squaresize+80+yunaxs+.2*squaresize,yunayl*squaresize+60+yunays+squaresize*.5
return
																											
label cpu
'REMEMBER TO TURN TO 0 WHEN BATTLE OVER!!!!!!!!!!!
if encounter=0 batttran=pi/2
if encounter=1 then
  effect=squaresizememory*abs(sin(batttran))
  batttran=batttran+.1
  squaresize=effect
  if batttran>3*pi/2 goto battle
fi 
return

label displaybuffer
setdispbuf dw
dw=1-dw
return

label battle
goto battle


label map1lower
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3
data 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3

label map1upper
data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0
data 0,0,2,0,0,0,0,1,1,1,0,2,0,1,1,0,0,0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0
data 1,0,0,0,0,0,0,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0
data 1,1,1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,1,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data 0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

