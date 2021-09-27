  rem Kitten Katch by Seth Marinello 2021
  rem 
  rem Started from the base of the following game to learn how to deal with the multi-sprite kernal and bank switching 	
  rem Miss It 11
	rem a new batari Basic game by accousticguitar
  rem https://atariage.com/forums/topic/146120-a-new-game-miss-it-high-score-list-in-post-1/


   include div_mul.asm
   includesfile multisprite_bankswitch.inc
   set kernel multisprite
   set romsize 8k

  dim  player1Dir=a
  dim  player2Dir=b
  dim  player3Dir=c  
  dim  player4Dir=d
  dim  player0Timer=e     
  dim  scoreAmount=f
  dim kittenMovement=g     
  dim  ballDir=h    
  dim timerlo=i
  dim ballSpeed=j
  dim sfxplaying=k
  dim sfxtimer=l
  dim boxed = m
  dim round = n
  dim carrying=o
  rem inBox{1} = if player is in box, inBox{2} is if the player has released the fire button since delivering a kitten
  dim inBox=p
  dim  player1Timer=q
  dim  player2Timer=r
  dim  topLimit=s
  rem t is used for the timer
  dim  botLimit=x
  dim  player3Timer=v  
  dim  player4Timer=u
  dim ballTimer = w
  dim statusbarcolor = y
  dim titlescreencolor=z


  titlescreencolor = $00
  
  rem zones - in a strange order because of creating separation
  rem ----------------------
  rem |    4      |   1    |
  rem |-----------|--------|
  rem |    2      |   3    |
  rem ----------------------  
  rem defining the bounds of the kitten zones
  const _z1XMin = 100
  const _z1XMax = 139
  const _z1YMin = 60
  const _z1YMax = 83

  const _z2XMin = 30
  const _z2XMax = 70
  const _z2YMin = 15
  const _z2YMax = 40

  const _z3XMin = 100
  const _z3XMax = 139
  const _z3YMin = 15
  const _z3YMax = 40

  const _z4XMin = 30
  const _z4XMax = 70
  const _z4YMin = 60
  const _z4YMax = 83

  const _baseKittenSpeed = 8
  const _middleKittenSpeed = 4
  const _maxKittenSpeed = 1
  const _timerRate = 10

  const _baseTime = 200

  kittenMovement = _baseKittenSpeed
 
  round = 1
  timerlo=10

  ballSpeed = 2

  sfxplaying=0
  sfxtimer=0
  AUDV0=0 
 
  rem this sets if we start off with kitten 1 or 2
  if rand&1 = 1 then inBox{3} = 1 else inBox{3} = 0
titlepage
  gosub titledrawscreen bank2

  rem I know this looks crazy, but it was the only way I could get some sort of title song playing. 
  rem using ballTimer here since it gets cleanly setup with good values in the setupRound routine.
  if sfxplaying = 0 && ballTimer = 0 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 =16 : AUDV0 = 5 
  if sfxplaying = 0 && ballTimer = 1 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 16 : AUDV0 = 5 
  if sfxplaying = 0 && ballTimer = 2 then sfxplaying = 1 : AUDC0 = 4 : AUDF0 = 31 : AUDV0 = 5 
  if sfxplaying = 0 && ballTimer = 3 then sfxplaying = 1 : AUDC0 = 4 : AUDF0 = 24 : AUDV0 = 5 
  if sfxplaying = 0 && ballTimer = 4 then sfxplaying = 1 : AUDC0 = 4 : AUDF0 = 19 : AUDV0 = 5 
  if sfxplaying = 0 && ballTimer = 5 then sfxplaying = 1 : AUDC0 = 4 : AUDF0 = 24 : AUDV0 = 5 
  if sfxplaying = 0 && ballTimer = 6 then ballTimer = 0
  if sfxplaying = 1 then sfxtimer = sfxtimer + 1
  if sfxtimer = 30 then sfxplaying = 0 : sfxtimer = 0 : AUDV0 = 0 : ballTimer = ballTimer + 1
  
  if joy0fire || switchreset then sfxtimer = 0 : sfxplaying = 0: AUDV0 = 0 : goto gamestart
  goto titlepage


gamestart
  rem Set values that need to be applied every round
  gosub setupRound
  lives = 0   
main

   rem Set so there is a single verison of P0 and the missle0 is 2 px
   NUSIZ0=$10
   NUSIZ1=$10
   _NUSIZ1=$10

   CTRLPF=$25
  
pauseloop

  if sfxplaying = 1 then sfxtimer = sfxtimer + 1
  if sfxtimer = 30 then sfxplaying = 0 : sfxtimer = 0 : AUDV0 = 0

  rem %%%%%%%%%%%%%%%%%%%
  rem COLOR TOWN!
  rem %%%%%%%%%%%%%%%%%%%
  rem player color changes when carrying a kitten
  if carrying = 0 then COLUP0= $00 else COLUP0= $04 

  rem in multisprite kernel we use this to change the color of player 1
  _COLUP1=$1E

  rem other sprites colors are set in their update function

  rem Background Color
  COLUBK=$C8
  rem Playfield Foreground Color - also deteremines the ball sprite color
  COLUPF=$F2

  if switchreset then reboot

  if switchbw || round = 99 then COLUBK = $02 : COLUPF = $06 : drawscreen : AUDV0 = 0: goto pauseloop 

  pfheight=1
 
  playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 XXX............XX............XXX
 XXX............XX............XXX
 XXX............XX............XXX
 XXX............XX............XXX
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 ...............XX...............
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

 player0:
 %00111111
 %01011110
 %01001110
 %01001110
 %01000111
 %10000101
end

   lives:
   %11111111
   %11000011
   %11011011
   %11000011
   %11011011
   %11000011
   %11011111
   %00000000
end

 drawscreen
  rem test the player location to determine if they are in the box
  if player0x > 65 && player0x < 85 && player0y > 50 && player0y < 65 then inBox{1} = 1 else inBox{1} = 0
 
  if !joy0fire && inBox{2} then inBox{2} = 0 

  rem Hitting Kittens
  if collision(player0,player1) && joy0fire && carrying = 0 && !inBox{1} && !inBox{2} then AUDV0 = 0 : gosub subGrab

  rem if we hit the player with a ball and we aren't already stunned 
  if collision(player0,ball) && player0Timer = 0 then AUDV0 = 0 : gosub ballStunPlayer

  if player0Timer > 0 then player0Timer = player0Timer - 1 : goto __skipPlayerInput   
  if joy0right then player0x=player0x+1 : REFP0 = 0
  if joy0left then player0x=player0x-1 : REFP0 = 8
  if joy0up then player0y=player0y+1
  if joy0down then player0y=player0y-1  
__skipPlayerInput

  rem HERE IS THE TIMER
  t=t+1  
  if scoreAmount = 0 then round = 99 : goto pauseloop
  if t=_timerRate && scoreAmount > 0 then t=0 : scoreAmount = scoreAmount - 1
  rem if round < 7 then lifecolor = $00
  statusbarcolor = $00
  statusbarlength = scoreAmount

  gosub updateKittens

  rem the timer updates and player bounds limits have been moved to the vblank section in BANK2 to save some cycles

  rem putting the carry logic to avoid a gosub here. 
  if carrying > 1 || carrying = 0 then goto __skipCarry1 
    player1x = player0x + 10
    player1y = player0y - 4
__skipCarry1
   if carrying > 2 || carrying < 2 then goto __skipCarry2 
    player2x = player0x + 10
    player2y = player0y - 4
__skipCarry2
  if carrying > 3 || carrying < 3 then goto __skipCarry3 
    player3x = player0x + 10
    player3y = player0y - 4
__skipCarry3
  if carrying > 4 || carrying < 4 then goto __skipCarry4 
    player4x = player0x + 10
    player4y = player0y - 4
__skipCarry4

  if inBox{1} && carrying > 0 then gosub scoreKitten

  goto main

setupRound
  rem ****************** 
  rem STARTING POSITIONS
  rem ******************
  player0x=75
  player1x=120
  player2x=40
  player0y=25
  player1y=65
  player2y=25
 
  rem we use lives to show what round we are on up to 6, then we loop  
  rem lives = lives + 32
  rem if lives > 223 then lives = lives + 32
  
  
  rem RAMP - the whole time we get less on the clock each round
  rem round 1 = 1 kitten
  rem round 2 = 2 kittens
  rem round 3 = 4 kittens
  rem round 4 = 4 kittens, ball
  rem round 5 = 4 kittens medium, 
  rem round 6 = repeat 5 with less time
  rem round 7 = 4 kittens fast, ball
  rem round 8 = repeat 7 with less time
  rem round 9 = 4 kittens fast, ball fast
  rem round 10 = same as 9 but you start getting a bonus 10 for each cat since the time will be really short

  if round < 3 then player3x = 0 : player4x=0 : player3y = 0 : player4y =0 : goto _skipInitExtras
  player3x=120
  player4x=40 
  player3y=25
  player4y=55

  if round = 9 then lives = lives + 32 : ballSpeed = 3 : goto _skipInitExtras
  if round = 7 then kittenMovement = _maxKittenSpeed : goto _skipInitExtras
  if round = 5 then kittenMovement = _middleKittenSpeed :goto _skipInitExtras
_skipInitExtras

  ballx=75
  bally=88
  missile0x=75
  missile0y=5
  missile1x=75
  missile1y=6

  player1Dir=10
  player2Dir=40
  player3Dir=30
  player4Dir=10
  ballDir=10

  carrying = 0
  boxed = 0

  t = 0
  AUDV0 = 0

  rem using temp5 here to store the amount we want to lower the overall time limit. 
  rem temp5 = _timerRate
  rem temp5 = temp5 * ballSpeed
  timerlo = timerlo + _timerRate
  if timerlo < _baseTime  then scoreAmount = _baseTime - timerlo : goto __protectScoreAmount
  scoreAmount = 10
__protectScoreAmount

  player1Timer = 0
  player2Timer = 2
  player3Timer = 3
  player4Timer = 4
  ballTimer = 5
  return

ballStunPlayer
  player0Timer = 50
  score = score - 1
  sfxplaying = 1 : AUDC0 = 5 : AUDF0 = 10 : AUDV0 = 10

  return

scoreKitten
  rem we set playerXTimer to 1 here so we don't tick it and it won't count down because that logic tests the boxed var
  if carrying = 1 then player1x = 10 : player1y = 90 : player1Timer = 1 : boxed{1} = 1 
  if carrying = 2 then player2x = 10 : player2y = 90 : player2Timer = 1 : boxed{2} = 1 
  if carrying = 3 then player3x = 10 : player3y = 90 : player3Timer = 1 : boxed{3} = 1 
  if carrying = 4 then player4x = 10 : player4y = 90 : player4Timer = 1 : boxed{4} = 1
  carrying = 0

  rem if on the first round then we set both round complete bools to true and skip the rest
  if round = 1 then temp2 = 1: temp3 = 1 : goto __endRound
  rem for all other rounds we have 2 or more kittens so test if we got both of them.
  if boxed{1} && boxed{2} then temp2 = 1
  rem if we are on the second round then the above line was enough to end, so we set temp3 to true and skip to end
  if round = 2 && temp2 = 1 then temp3 = 1 : goto __endRound
  rem in further rounds we test if we boxed everyone
  if boxed{3} && boxed{4} then temp3 = 1
__endRound
  sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
  score = score + 15
  if round > 9 then score = score + 10
  if temp2 = 1 && temp3 = 1 then round = round +1 : t = 0 : goto roundScore
  return

  rem when we finish a round, give the player 5 points for every "block" of 10 they had left on the timer.
roundScore
  t=t+1
  if t < 4 then drawscreen : goto roundScore
  if scoreAmount > 9 then scoreAmount = scoreAmount - 10 : score = score + 5 : statusbarlength = scoreAmount : drawscreen : goto roundScore
  gosub setupRound
  return

subGrab
    if round = 1 && !inBox{3} then carrying = 1 : goto __endGrab
    if round = 1 && inBox{3} then carrying = 2 : goto __endGrab

    if round = 2 && player0y > 50 then carrying = 1 : goto __endGrab
    if round = 2 && player0y < 50 then carrying = 2 : goto __endGrab

    if player0y > 50 && boxed{1} then carrying = 4 : goto __endGrab
    if player0y > 50 && boxed{4} then carrying = 1 : goto __endGrab

    if player0y < 50 && boxed{3} then carrying = 2 : goto __endGrab
    if player0y < 50 && boxed{2} then carrying = 3 : goto __endGrab

    if player0x > 90 && player0y > 50 then carrying = 1
    if player0x > 90 && player0y < 50 then carrying = 3
    if player0x < 70 && player0y < 50 then carrying = 2
    if player0x < 60 && player0y > 50 then carrying = 4
__endGrab
    return

updateKittens
    rem this is nonsense, but we are using temp5 to determine if we are using k1 or k2 as our starting kitten
    temp5 = 3
    if round = 1 && inBox{3} then temp5 = 1
    if round = 1 && !inBox{3} then temp5 = 0

    if player1Timer > 0 || temp5 = 1 then goto __skipUpdate1
    if carrying > 1 || carrying = 0 then gosub player1collision
__skipUpdate1

    if player2Timer > 0 || temp5 = 0 then goto __skipUpdate2
    if carrying > 2 || carrying < 2 then gosub player2collision
__skipUpdate2

    if player3Timer > 0 || round < 3 then goto __skipUpdate3
    if carrying > 3 || carrying < 3 then gosub player3collision
__skipUpdate3

    if player4Timer > 0 || round < 3 then goto __skipUpdate4
    if carrying > 4 || carrying < 4 then gosub player4collision
__skipUpdate4

    if ballTimer = 0 && round > 3 then gosub ballcollision
    return

player1collision
 player1:
 %0011010
 %0101110
 %1000111
 %1000101
end

 botLimit = _z1XMin
 if boxed{4} || round < 3 then botLimit = _z4XMin

 if player1Dir = 10 && player1y > _z1YMax then player1Dir=player1Dir+10
 if player1Dir = 10 && player1x > _z1XMax then player1Dir=player1Dir+30

 if player1Dir = 20 && player1x > _z1XMax then player1Dir=player1Dir+10
 if player1Dir = 20 && player1y < _z1YMin then player1Dir=player1Dir-10

 if player1Dir = 30 && player1y < _z1YMin then player1Dir=player1Dir+10
 if player1Dir = 30 && player1x < botLimit then player1Dir=player1Dir-10
 
 if player1Dir = 40 && player1y > _z1YMax then player1Dir=player1Dir-10
 if player1Dir = 40 && player1x < botLimit then player1Dir=player1Dir-30
 
 if player1Dir < 10 then player1Dir=10
 if player1Dir > 40 then player1Dir=10
 
MovePlayer1
 if player1Dir = 10 then gosub moveupandright
 if player1Dir = 20 then gosub movedownandright
 if player1Dir = 30 then gosub movedownandleft
 if player1Dir = 40 then gosub moveupandleft
 return

player2collision

  COLUP2=98
  NUSIZ2=$10

 player2:
 %0011010
 %0101110
 %1000111
 %1000101
end

 topLimit = _z2XMax
 if boxed{3} || round = 2 then topLimit = _z3XMax

 if player2Dir = 10 && player2y > _z2YMax then player2Dir=player2Dir+10
 if player2Dir = 10 && player2x > topLimit then player2Dir=player2Dir+30

 if player2Dir = 20 && player2x > topLimit then player2Dir=player2Dir+10
 if player2Dir = 20 && player2y < _z2YMin then player2Dir=player2Dir-10

 if player2Dir = 30 && player2y < _z2YMin then player2Dir=player2Dir+10
 if player2Dir = 30 && player2x < _z2XMin then player2Dir=player2Dir-10
 
 if player2Dir = 40 && player2y > _z2YMax then player2Dir=player2Dir-10
 if player2Dir = 40 && player2x < _z2XMin then player2Dir=player2Dir-30
 
 if player2Dir < 10 then player2Dir=10
 if player2Dir > 40 then player2Dir=10

MovePlayer2
 if player2Dir = 10 then gosub moveupandright2
 if player2Dir = 20 then gosub movedownandright2
 if player2Dir = 30 then gosub movedownandleft2
 if player2Dir = 40 then gosub moveupandleft2
 return


player3collision

  COLUP3=128
  NUSIZ3=$10   
   
 player3:
 %0011010
 %0101110
 %1000111
 %1000101
end


 botLimit = _z3XMin
 if boxed{2} then botLimit = _z2XMin

 if player3Dir = 10 && player3y > _z3YMax then player3Dir=player3Dir+10
 if player3Dir = 10 && player3x > _z3XMax then player3Dir=player3Dir+30

 if player3Dir = 20 && player3x > _z3XMax then player3Dir=player3Dir+10
 if player3Dir = 20 && player3y < _z3YMin then player3Dir=player3Dir-10

 if player3Dir = 30 && player3y < _z3YMin then player3Dir=player3Dir+10
 if player3Dir = 30 && player3x < botLimit then player3Dir=player3Dir-10
 
 if player3Dir = 40 && player3y > _z3YMax then player3Dir=player3Dir-10
 if player3Dir = 40 && player3x < botLimit then player3Dir=player3Dir-30
 
 if player3Dir < 10 then player3Dir=10
 if player3Dir > 40 then player3Dir=10
 
MovePlayer3
 if player3Dir = 10 then gosub moveupandright3
 if player3Dir = 20 then gosub movedownandright3
 if player3Dir = 30 then gosub movedownandleft3
 if player3Dir = 40 then gosub moveupandleft3
 return
 
player4collision

  COLUP4=192
  NUSIZ4=$10

 player4:
 %0011010
 %0101110
 %1000111
 %1000101
end

 topLimit = _z4XMax
 if boxed{1} then topLimit = _z1XMax

 if player4Dir = 10 && player4y > _z4YMax then player4Dir=player4Dir+10
 if player4Dir = 10 && player4x > topLimit then player4Dir=player4Dir+30

 if player4Dir = 20 && player4x > topLimit then player4Dir=player4Dir+10
 if player4Dir = 20 && player4y < _z4YMin then player4Dir=player4Dir-10

 if player4Dir = 30 && player4y < _z4YMin then player4Dir=player4Dir+10
 if player4Dir = 30 && player4x < _z4XMin then player4Dir=player4Dir-10
 
 if player4Dir = 40 && player4y > _z4YMax then player4Dir=player4Dir-10
 if player4Dir = 40 && player4x < _z4XMin then player4Dir=player4Dir-30
 
 if player4Dir < 10 then player4Dir=10
 if player4Dir > 40 then player4Dir=10
 
MovePlayer4
 if player4Dir = 10 then gosub moveupandright4
 if player4Dir = 20 then gosub movedownandright4
 if player4Dir = 30 then gosub movedownandleft4
 if player4Dir = 40 then gosub moveupandleft4
 return


player5collision

  COLUP5=98
  NUSIZ5=$10

 player5:
 %111111
 %111111
 %111111
 %111111
 %111111
 %111111
 %111111
 %111111
 %111111
 %111111
 %111111
end
   player5x = 10
   player5y = 10
   return

ballcollision
 if ballDir = 10 && bally > 84 then ballDir=ballDir+10
 if ballDir = 10 && ballx > 136 then ballDir=ballDir+30

 if ballDir = 20 && ballx > 136 then ballDir=ballDir+10
 if ballDir = 20 && bally < 9 then ballDir=ballDir-10

 if ballDir = 30 && bally < 9 then ballDir=ballDir+10
 if ballDir = 30 && ballx < 22 then ballDir=ballDir-10
 
 if ballDir = 40 && bally > 84 then ballDir=ballDir-10
 if ballDir = 40 && ballx < 22 then ballDir=ballDir-30
 
 if ballDir < 10 then ballDir=10
 if ballDir > 40 then ballDir=10
 
MoveBall
 if ballDir = 10 then gosub moveupandright8
 if ballDir = 20 then gosub movedownandright8
 if ballDir = 30 then gosub movedownandleft8
 if ballDir = 40 then gosub moveupandleft8
 
 missile1x = ballx + 1
 missile0x = ballx + 1
 missile1y = bally - 1
 missile0y = bally

 return

moveupandright 
 player1x = player1x + 1
 player1y = player1y + 1
 return
 
 
moveupandleft
 player1x = player1x - 1
 player1y = player1y + 1
 _NUSIZ1{3} = 1
 return
 
 
movedownandright
 player1x = player1x + 1
 player1y = player1y - 1
 return
 
 
movedownandleft
 player1x = player1x - 1
 player1y = player1y - 1
 _NUSIZ1{3} = 1
 return
 
moveupandright2 
 player2x = player2x + 1
 player2y = player2y + 1
 return
 
 
moveupandleft2
 player2x = player2x - 1
 player2y = player2y + 1
 NUSIZ2{3} = 1
 return
 
 
movedownandright2
 player2x = player2x + 1
 player2y = player2y - 1
 return
 
 
movedownandleft2
 player2x = player2x - 1
 player2y = player2y - 1
 NUSIZ2{3} = 1
 return
 
 
moveupandright3 
 player3x = player3x + 1
 player3y = player3y + 1
 return
 
 
moveupandleft3
 player3x = player3x - 1
 player3y = player3y + 1
 NUSIZ3{3} = 1
 return
 
 
movedownandright3
 player3x = player3x + 1
 player3y = player3y - 1
 return
 
 
movedownandleft3
 player3x = player3x - 1
 player3y = player3y - 1
 NUSIZ3{3} = 1
 return
 
 
moveupandright4 
 player4x = player4x + 1
 player4y = player4y + 1
 return
 
 
moveupandleft4
 player4x = player4x - 1
 player4y = player4y + 1
 NUSIZ4{3} = 1
 return
 
 
movedownandright4
 player4x = player4x + 1
 player4y = player4y - 1
 return
 
 
movedownandleft4
 player4x = player4x - 1
 player4y = player4y - 1
 NUSIZ4{3} = 1
 return
 
moveupandright8 
 ballx = ballx + ballSpeed
 bally = bally + ballSpeed
 return
 
 
moveupandleft8
 ballx = ballx - ballSpeed
 bally = bally + ballSpeed
 return
 
 
movedownandright8
 ballx = ballx + ballSpeed
 bally = bally - ballSpeed
 return
 
 
movedownandleft8
 ballx = ballx - ballSpeed
 bally = bally - ballSpeed
 return
 
 bank 2
  
  rem moving some logic into the vblank time because there is a small amount of it leftover and we need all we can get
  vblank
  if player0y = 88 then player0y = 87
  if player0y = 13 then player0y = 14
  if player0x = 133 then player0x = 132
  if player0x = 19 then player0x = 20 
  
  rem Keep the kittens from moving every single frame  
  if player1Timer > 0 && !boxed{1} then player1Timer = player1Timer - 1 else player1Timer = kittenMovement
  if player2Timer > 0 && !boxed{2} then player2Timer = player2Timer - 1 else player2Timer = kittenMovement
  if player3Timer > 0 && !boxed{3} then player3Timer = player3Timer - 1 else player3Timer = kittenMovement
  if player4Timer > 0 && !boxed{4} then player4Timer = player4Timer - 1 else player4Timer = kittenMovement
  if ballTimer > 0 then ballTimer = ballTimer - 1 else ballTimer = _maxKittenSpeed
  return 

 inline 6lives_statusbar.asm

 asm
 include "titlescreen/asm/titlescreen.asm"
end
     rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!THIS IS THE END OF THE PROGRAM!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================
     rem ===============================================================================