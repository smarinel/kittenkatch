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
  dim  ballDir=h    
  dim  timerlo=i
  dim  ballSpeed=j
  dim  sfxplaying=k
  dim  sfxtimer=l
  dim  boxed = m
  dim  round = n
  dim  carrying=o
  rem inBox{1} = if player is in box, inBox{2} is if the player has released the fire button since delivering a kitten
  rem inBox{3} is for setting which is the startng round 1 kitten
  rem inBox{6} is used for knowing if we have actived the top saucer
  dim  inBox=p
  dim  player1Timer=q
  dim  player2Timer=r
  dim  timer = t
  dim  player3Timer=v  
  dim  player4Timer=u
  dim  ballTimer = w
  dim  statusbarcolor = y
  dim  bmp_48x2_2_index=z

  ;```````````````````````````````````````````````````````````````
  ;  Remembers the high score until the game is turned off.
  ;
  dim _High_Score1 = g
  dim _High_Score2 = s
  dim _High_Score3 = x
  
  rem this is only used on the main menu where these should be free values
  dim _Score1_Mem = a
  dim _Score2_Mem = b
  dim _Score3_Mem = c


  dim topLimit=temp3
  dim botLimit=temp2
  dim currentSpeed=temp5

   
   ;```````````````````````````````````````````````````````````````
   ;  Converts 6 digit score to 3 sets of two digits.
   ;
   ;  The 100 thousands and 10 thousands digits are held by _sc1.
   ;  The thousands and hundreds digits are held by _sc2.
   ;  The tens and ones digits are held by _sc3.
   ;
   dim _sc1 = score
   dim _sc2 = score+1
   dim _sc3 = score+2


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

  const NE = 10
  const SE = 20
  const SW = 30
  const NW = 40

  _High_Score1 = 0
  _High_Score2 = 0
  _High_Score3 = 0

  _Score1_Mem = 0
  _Score2_Mem = 0
  _Score3_Mem = 0

  timerlo = 0
__start

   ;***************************************************************
   ;
   ;  Clears all normal variables (faster way).
   ;
   rem a = 0 : b = 0 : c = 0 :  <- this is now storing the old score so we don't reset
   d = 0 : e = 0 : f = 0  : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   t = 0 : u = 0 : v = 0 : w = 0 : y = 0 : z = 0 : temp5 = 0

  round = 1
  inBox = 0

  ballSpeed = 2

  sfxplaying=0
  sfxtimer=0
  AUDV0=0

  timer = 0
 
  rem this sets if we start off with kitten 1 or 2
  if rand&1 = 1 then inBox{3} = 1
  
  bmp_48x2_2_index=64

  rem scorecolor = $0C

titlepage
  
  
  rem I know this looks crazy, but it was the only way I could get some sort of title song playing. 
  rem using ballTimer here since it gets cleanly setup with good values in the setupRound routine.
  
  rem change the smaller menu graphic every round of music - putting it first to reduce if checks in this case
  if sfxplaying = 0 && ballTimer = 6 then ballTimer = 0 : bmp_48x2_2_index = bmp_48x2_2_index + 16 : gosub __High_Flip
  if bmp_48x2_2_index = 80 then bmp_48x2_2_index = 0 : goto __cont_menu

  if sfxplaying = 0 && ballTimer = 0 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 =16 : AUDV0 = 5 : goto __cont_menu
  if sfxplaying = 0 && ballTimer = 1 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 16 : AUDV0 = 5 : goto __cont_menu
  if sfxplaying = 0 && ballTimer = 2 then sfxplaying = 1 : AUDC0 = 4 : AUDF0 = 31 : AUDV0 = 5 : goto __cont_menu
  if sfxplaying = 0 && ballTimer = 3 then sfxplaying = 1 : AUDC0 = 4 : AUDF0 = 24 : AUDV0 = 5 : goto __cont_menu
  if sfxplaying = 0 && ballTimer = 4 then sfxplaying = 1 : AUDC0 = 4 : AUDF0 = 19 : AUDV0 = 5 : goto __cont_menu
  if sfxplaying = 0 && ballTimer = 5 then sfxplaying = 1 : AUDC0 = 4 : AUDF0 = 24 : AUDV0 = 5 : goto __cont_menu

__cont_menu
  if sfxplaying = 1 then sfxtimer = sfxtimer + 1
  if sfxtimer = 30 then sfxplaying = 0 : sfxtimer = 0 : AUDV0 = 0 : ballTimer = ballTimer + 1 
  
  if timer < 30 then timer = timer + 1

  if joy0fire && timer > 10 then sfxtimer = 0 : sfxplaying = 0: AUDV0 = 0 : goto gamestart
  
  gosub titledrawscreen bank2
  
  goto titlepage


gamestart
  rem Set values that need to be applied every round
  gosub setupRound
  lives = 0   
  
  rem reset the score
  score = 0

main

   rem Set so there is a single verison of P0 and the missle0 is 2 px
   NUSIZ0=$10
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
  
  if round = 99 then gosub __Check_High_Score

  if round = 99 && !joy0fire then round = 100
  if round = 100 && joy0fire then timer = timer + 1 
  if round = 100 && timer > 10 && !joy0fire then goto __start 
  if switchreset then goto __start

  if switchbw || round > 98 then player0Timer = player0Timer + 1 : COLUBK = $0A : COLUPF = $06 : drawscreen : goto pauseloop 

  pfheight=1
 
  playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X..XX..XX..XX..XX..XX..XX..XX..X
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
 ..X............XX............X..
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
 X..XX..XX..XX..XX..XX..XX..XX..X
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

  rem Testing if we touched the milk saucer (player 5) which only appears when both 1 & 4 are collected
  temp5 = 0
  if boxed{2} && boxed{3} && player0y < 50 then temp5 = 1
  if boxed{1} && boxed{4} && player0y > 50 then temp5 = 1
  if collision(player0, player1) && temp5=1 && carrying = 0 then player0Timer = 30 : score = score + 25 : player5x = 0 : player5y = 0 : sfxplaying = 1 : AUDC0 = 2 : AUDF0 = 10 : AUDV0 = 10
  rem Hitting Kittens
  if collision(player0,player1) && joy0fire && carrying = 0 && !inBox{1} && !inBox{2} then gosub subGrab
  rem if collision(player0,player1) && carrying = 0 && !inBox{1} && !inBox{2} then AUDV0 = 0 : gosub subGrab


  rem if we hit the player with a ball and we aren't already stunned 
  if collision(player0,ball) && player0Timer = 0 then AUDV0 = 0 : gosub ballStunPlayer

  timer = timer + 1  
  if timer=_timerRate && scoreAmount > 0 then timer = 0 : scoreAmount = scoreAmount - 1 
  rem if scoreAmount < 40 then statusbarcolor = statusbarcolor + 1
  if scoreAmount < 20 then statusbarcolor = statusbarcolor + 1 : sfxplaying = 1 : AUDC0 = 7 : AUDF0 = timer + 10 : AUDV0 = 1
  if scoreAmount = 0 then statusbarcolor = 0 : round = 99 : timer = 0 : sfxplaying = 1 : AUDC0 = 7 : AUDF0 = 20 : AUDV0 = 5: goto pauseloop
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
  player5x=0
  player5y=0

  if round = 1 && inBox{3}  then player1x=0 : player1y=0
  if round = 1 && !inBox{3} then player2x=0 : player2y=0

  scorecolor = $00
  statusbarcolor = $00
  
  rem nuke all the upper bits of this var we use for saucer stuff
  inBox = inBox & %00001111

  rem CUT ALL THIS STUFF FOR THE BONUS MARKER
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

  if round = 10 then lives = lives + 32 : ballSpeed = 3 : goto _skipInitExtras
  if round = 15 then lives = lives + 32 : ballSpeed = 4 : goto _skipInitExtras
  rem moved this logic to a temp var in the main loop where we check timers
  rem if round = 7 then kittenMovement = _maxKittenSpeed : goto _skipInitExtras
  rem if round = 5 then kittenMovement = _middleKittenSpeed :goto _skipInitExtras
_skipInitExtras

  ballx=75
  bally=88
  missile0x=75
  missile0y=5
  missile1x=75
  missile1y=6

  player1Dir=NE
  player2Dir=NW
  player3Dir=SW
  player4Dir=NE
  ballDir=SE

  carrying = 0
  boxed = 0

  timer = 0
  AUDV0 = 0

  bmp_48x2_2_index = 0

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
  score = score - 10
  sfxplaying = 1 : AUDC0 = 5 : AUDF0 = 10 : AUDV0 = 10
  return

scoreKitten
  rem we set playerXTimer to 1 here so we don't tick it and it won't count down because that logic tests the boxed var
  if carrying = 1 then player1x = 10 : player1y = 90 : player1Timer = 1 : boxed{1} = 1 
  if carrying = 2 then player2x = 10 : player2y = 90 : player2Timer = 1 : boxed{2} = 1 
  if carrying = 3 then player3x = 10 : player3y = 90 : player3Timer = 1 : boxed{3} = 1 
  if carrying = 4 then player4x = 10 : player4y = 90 : player4Timer = 1 : boxed{4} = 1
  carrying = 0

  rem make sure we must release the button before we can grab another kitten
  inBox{2} = 1

  rem if on the first round then we set both round complete bools to true and skip the rest
  if round = 1 then temp2 = 1: temp3 = 1 : goto __endRound
  rem for all other rounds we have 2 or more kittens so test if we got both of them.
  if boxed{1} && boxed{2} then temp2 = 1
  rem if we are on the second round then the above line was enough to end, so we set temp3 to true and skip to end
  if round = 2 && temp2 = 1 then temp3 = 1 : goto __endRound
  rem in further rounds we test if we boxed everyone
  if boxed{3} && boxed{4} then temp3 = 1
__endRound
  rem using the var from the main menu here to count and increase the freq of the score audio since it was free
  bmp_48x2_2_index = bmp_48x2_2_index + 1
  temp6 = 18 - bmp_48x2_2_index
  sfxplaying = 1 : AUDC0 = 12 : AUDF0 = temp6 : AUDV0 = 10
  score = score + 15
  if round > 9 then score = score + 10
  if round > 14 then score = score + 10
  rem testing if we should summon the saucer
  if boxed{3} && boxed{2} && !inBox{6} then inBox{6} = 1 : player5y = 30
  if boxed{1} && boxed{4} && !inBox{6} then inBox{6} = 1 : player5y = 80
  
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

    if player0y > 50 && boxed{1} && !boxed{4} then carrying = 4 : goto __endGrab
    if player0y > 50 && boxed{4} && !boxed{1} then carrying = 1 : goto __endGrab

    if player0y < 50 && boxed{3} && !boxed{2} then carrying = 2 : goto __endGrab
    if player0y < 50 && boxed{2} && !boxed{3} then carrying = 3 : goto __endGrab

    if player0x > 90 && player0y > 50 && !boxed{1} then carrying = 1
    if player0x > 90 && player0y < 50 && !boxed{2} then carrying = 3
    if player0x < 70 && player0y < 50 && !boxed{3} then carrying = 2
    if player0x < 60 && player0y > 50 && !boxed{4} then carrying = 4
__endGrab
    return

updateKittens
    rem this is nonsense, but we are using temp5 to determine if we are using k1 or k2 as our starting kitten
    temp5 = 3
    if round = 1 && inBox{3} then temp5 = 1
    if round = 1 && !inBox{3} then temp5 = 0

    if player1Timer > 0 || temp5 = 1 then goto __skipUpdate1
    if carrying > 1 || carrying = 0 then gosub player1_limitcheck
__skipUpdate1

    if player2Timer > 0 || temp5 = 0 then goto __skipUpdate2
    if carrying > 2 || carrying < 2 then gosub player2_limitcheck
__skipUpdate2

    if player3Timer > 0 || round < 3 then goto __skipUpdate3
    if carrying > 3 || carrying < 3 then gosub player3_limitcheck
__skipUpdate3

    if player4Timer > 0 || round < 3 then goto __skipUpdate4
    if carrying > 4 || carrying < 4 then gosub player4_limitcheck
__skipUpdate4

    if ballTimer = 0 && round > 3 then gosub ball_limitcheck

    gosub player5_draw

    return

player1_limitcheck
 player1:
 %0011010
 %0101110
 %1000111
 %1000101
end
 
 NUSIZ1=$10

 botLimit = _z1XMin
 if boxed{4} || round < 3 then botLimit = _z4XMin

 if player1Dir = NE && player1y > _z1YMax then player1Dir=player1Dir+10
 if player1Dir = NE && player1x > _z1XMax then player1Dir=player1Dir+30

 if player1Dir = SE && player1x > _z1XMax then player1Dir=player1Dir+10
 if player1Dir = SE && player1y < _z1YMin then player1Dir=player1Dir-10

 if player1Dir = SW && player1y < _z1YMin then player1Dir=player1Dir+10
 if player1Dir = SW && player1x < botLimit then player1Dir=player1Dir-10
 
 if player1Dir = NW && player1y > _z1YMax then player1Dir=player1Dir-10
 if player1Dir = NW && player1x < botLimit then player1Dir=player1Dir-30
 
 if player1Dir < NE then player1Dir=NE
 if player1Dir > NW then player1Dir=NE
 
 rem MovePlayer1
 if player1Dir = NE || player1Dir = SE then player1x = player1x + 1 : goto _skipP1PosX
 player1x = player1x - 1
 _NUSIZ1{3} = 1
_skipP1PosX
 if player1Dir = NE || player1Dir = NW then player1y = player1y + 1 : goto _skipP1PosY
 player1y = player1y - 1
_skipP1PosY
 return
 

player2_limitcheck

  COLUP2=98
  NUSIZ2=$10

 player2:
 %0011010
 %0101110
 %1000111
 %1000101
end

 topLimit = _z2XMax
 if boxed{3} || round < 3 then topLimit = _z3XMax

 if player2Dir = NE && player2y > _z2YMax then player2Dir=player2Dir+10
 if player2Dir = NE && player2x > topLimit then player2Dir=player2Dir+30

 if player2Dir = SE && player2x > topLimit then player2Dir=player2Dir+10
 if player2Dir = SE && player2y < _z2YMin then player2Dir=player2Dir-10

 if player2Dir = SW && player2y < _z2YMin then player2Dir=player2Dir+10
 if player2Dir = SW && player2x < _z2XMin then player2Dir=player2Dir-10
 
 if player2Dir = NW && player2y > _z2YMax then player2Dir=player2Dir-10
 if player2Dir = NW && player2x < _z2XMin then player2Dir=player2Dir-30
 
 if player2Dir < NE then player2Dir=NE
 if player2Dir > NW then player2Dir=NE

 rem Move Player2
 if player2Dir = NE || player2Dir = SE then player2x = player2x + 1 : goto _skipP2PosX
 player2x = player2x - 1
 NUSIZ2{3} = 1
_skipP2PosX
 if player2Dir = NE || player2Dir = NW then player2y = player2y + 1 : goto _skipP2PosY
 player2y = player2y - 1
_skipP2PosY
 return


player3_limitcheck

  COLUP3=$0E
  NUSIZ3=$10   
   
 player3:
 %0011010
 %0101110
 %1000111
 %1000101
end


 botLimit = _z3XMin
 if boxed{2} then botLimit = _z2XMin

 if player3Dir = NE && player3y > _z3YMax then player3Dir=player3Dir+10
 if player3Dir = NE && player3x > _z3XMax then player3Dir=player3Dir+30

 if player3Dir = SE && player3x > _z3XMax then player3Dir=player3Dir+10
 if player3Dir = SE && player3y < _z3YMin then player3Dir=player3Dir-10

 if player3Dir = SW && player3y < _z3YMin then player3Dir=player3Dir+10
 if player3Dir = SW && player3x < botLimit then player3Dir=player3Dir-10
 
 if player3Dir = NW && player3y > _z3YMax then player3Dir=player3Dir-10
 if player3Dir = NW && player3x < botLimit then player3Dir=player3Dir-30
 
 if player3Dir < NE then player3Dir=NE
 if player3Dir > NW then player3Dir=NE
 
 rem Move Player3
 if player3Dir = NE || player3Dir = SE then player3x = player3x + 1 : goto _skipP3PosX
 player3x = player3x - 1
 NUSIZ3{3} = 1
_skipP3PosX
 if player3Dir = NE || player3Dir = NW then player3y = player3y + 1 : goto _skipP3PosY
 player3y = player3y - 1
_skipP3PosY
 return
 
player4_limitcheck

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

 if player4Dir = NE && player4y > _z4YMax then player4Dir=player4Dir+10
 if player4Dir = NE && player4x > topLimit then player4Dir=player4Dir+30

 if player4Dir = SE && player4x > topLimit then player4Dir=player4Dir+10
 if player4Dir = SE && player4y < _z4YMin then player4Dir=player4Dir-10

 if player4Dir = SW && player4y < _z4YMin then player4Dir=player4Dir+10
 if player4Dir = SW && player4x < _z4XMin then player4Dir=player4Dir-10
 
 if player4Dir = NW && player4y > _z4YMax then player4Dir=player4Dir-10
 if player4Dir = NW && player4x < _z4XMin then player4Dir=player4Dir-30
 
 if player4Dir < NE then player4Dir=NE
 if player4Dir > NW then player4Dir=NE
 
 rem Move Player4
 if player4Dir = NE || player4Dir = SE then player4x = player4x + 1 : goto _skipP4PosX
 player4x = player4x - 1
 NUSIZ4{3} = 1
_skipP4PosX
 if player4Dir = NE || player4Dir = NW then player4y = player4y + 1 : goto _skipP4PosY
 player4y = player4y - 1
_skipP4PosY
 return

ball_limitcheck
 if ballDir = NE && bally > 84 then ballDir=ballDir+10
 if ballDir = NE && ballx > 136 then ballDir=ballDir+30

 if ballDir = SE && ballx > 136 then ballDir=ballDir+10
 if ballDir = SE && bally < 9 then ballDir=ballDir-10

 if ballDir = SW && bally < 9 then ballDir=ballDir+10
 if ballDir = SW && ballx < 22 then ballDir=ballDir-10
 
 if ballDir = NW && bally > 84 then ballDir=ballDir-10
 if ballDir = NW && ballx < 22 then ballDir=ballDir-30
 
 if ballDir < NE then ballDir=NE
 if ballDir > NW then ballDir=NE
 

 rem MoveBall

 if ballDir = NE || ballDir = SE then ballx = ballx + ballSpeed : goto _skipBallPosX
 ballx = ballx - ballSpeed
_skipBallPosX
 if ballDir = NE || ballDir = NW then bally = bally + ballSpeed : goto _skipBallPosY
 bally = bally - ballSpeed
_skipBallPosY
 
 missile1x = ballx + 1
 missile0x = ballx + 1
 missile1y = bally - 1
 missile0y = bally
 return

player5_draw

  COLUP5=$0E
  NUSIZ5=$10

 player5:
 %1111111
 %0101110
 %1000111
 %1111111
end
 return

__Check_High_Score

  rem stash the curren score
  _Score1_Mem = _sc1 : _Score2_Mem = _sc2 : _Score3_Mem = _sc3  
   ;***************************************************************
   ;
   ;  High score check.
   ;
   ;  Checks for a new high score.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Checks first byte.
   ;
   if _sc1 > _High_Score1 then goto __New_High_Score
   if _sc1 < _High_Score1 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  First byte equal. Checks second byte.
   ;
   if _sc2 > _High_Score2 then goto __New_High_Score
   if _sc2 < _High_Score2 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  Second byte equal. Checks third byte.
   ;
   if _sc3 > _High_Score3 then goto __New_High_Score
   if _sc3 < _High_Score3 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  All bytes equal. Skips high score.
   ;
   goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  All bytes not equal. New high score!
   ;
__New_High_Score
   _High_Score1 = _sc1 : _High_Score2 = _sc2 : _High_Score3 = _sc3

__Skip_High_Score
  return
 
__High_Flip
  if _sc3 = _Score3_Mem && _sc2 = _Score2_Mem && _sc1 = _Score1_Mem then _sc1 = _High_Score1 : _sc2 = _High_Score2 : _sc3 = _High_Score3 : return
  _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem
  return   

 bank 2
  
  rem moving some logic into the vblank time because there is a small amount of it leftover and we need all we can get
  vblank
  
  if player0Timer > 0 then player0Timer = player0Timer - 1 : goto __skipPlayerInput   
  if joy0right then player0x=player0x+1 : REFP0 = 0
  if joy0left then player0x=player0x-1 : REFP0 = 8
  if joy0up then player0y=player0y+1
  if joy0down then player0y=player0y-1  
__skipPlayerInput
   
  if player0y = 86 then player0y = 85
  if player0y = 13 then player0y = 14
  if player0x = 133 then player0x = 132
  if player0x = 19 then player0x = 20 

  if !inBox{6} || inBox{7} then goto __SkipSaucer
  rem if we are ready for the saucer randomly choose if it appears
  temp5 = rand : if temp5 < 64 then player5y = 0 : inBox{7} = 1 : goto __SkipSaucer
 
  rem saucer either are on the right or left side of the field.
  temp6 = 120
  if temp5 > 218 then temp6 = 35
  player5x = temp6
  
  inBox{7} = 1
  
__SkipSaucer
  
  rem Keep the kittens from moving every single frame 
  rem Set a temp var for the speed of the kittens. Used to be kittenSpeed but this saves a var
  currentSpeed = _baseKittenSpeed
  if round > 4 then currentSpeed = _middleKittenSpeed 
  if round > 6 then currentSpeed = _maxKittenSpeed

  if player1Timer > 0 && !boxed{1} then player1Timer = player1Timer - 1 else player1Timer = currentSpeed
  if player2Timer > 0 && !boxed{2} then player2Timer = player2Timer - 1 else player2Timer = currentSpeed
  if player3Timer > 0 && !boxed{3} then player3Timer = player3Timer - 1 else player3Timer = currentSpeed
  if player4Timer > 0 && !boxed{4} then player4Timer = player4Timer - 1 else player4Timer = currentSpeed
  if ballTimer > 0 then ballTimer = ballTimer - 1 else ballTimer = _maxKittenSpeed
  return 

 inline 6lives_statusbar.asm

 asm
 include "titlescreen/asm/titlescreen.asm"
end

     rem ===============================================================================
