	rem Miss It 11
	rem a new batari Basic game by accousticguitar
     
  rem https://atariage.com/forums/topic/146120-a-new-game-miss-it-high-score-list-in-post-1/
     
     dim  player1Dir=a
     dim  player2Dir=b
     dim  player3Dir=c  
     dim  player4Dir=d
     dim  player0Timer=e     
     dim  bonusFactor=f     
     dim  ballDir=h    
     dim timerlo=i
     dim timerhi=j
     dim sfxplaying=k
     dim sfxtimer=l
     dim boxed = m
     dim round = n
     dim carrying=o
     dim inBox=p
     dim  player1Timer=q
     dim  player2Timer=r
     dim  player3Timer=s  
     dim  player4Timer=u
     dim TextIndex = z    
     
   includesfile multisprite_bankswitch.inc
   set kernel multisprite
   set romsize 8k


  rem Text Stuff
  const scorebkcolor = $C8
  const textbkcolor = $20
  TextColor = $0F ; Set starting text color to white
  rem const fontstyle = SQUISH
  const t_Title = 0
  const t_P1 = 12
  const t_P2 = 24
  const t_P3 = 36
  const t_P4 = 48
  const t_Round = 48
  const blank_text = 60
  
  rem zones - in a strange order because of creating separation
  rem ----------------------
  rem |    4      |   1    |
  rem |-----------|--------|
  rem |    2      |   3    |
  rem ----------------------  
  rem defining the bounds of the kitten zones
  const _z1XMin = 100
  const _z1XMax = 139
  const _z1YMin = 50
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
  const _z4YMin = 50
  const _z4YMax = 83

  const _baseKittenSpeed = 8

 
  round = 1

  rem Set values that need to be applied every round
  gosub setupRound
   
main

  timerlo=timerlo+1 
  if timerlo=0 then timerhi=timerhi+1

   rem Set so there is a single verison of P0 and the missle0 is 2 px
   NUSIZ0=$10
   NUSIZ1=$10
   _NUSIZ1=$10

   CTRLPF=$25

  if switchreset then reboot
  
pauseloop

  rem %%%%%%%%%%%%%%%%%%%
  rem COLOR TOWN!
  rem %%%%%%%%%%%%%%%%%%%
  rem player color changes when carrying a kitten
  if carrying = 0 then COLUP0= 0 else COLUP0= $04 

  rem in multisprite kernel we use this to change the color of player 1
  _COLUP1=$1E

  rem other sprites colors are set in their update function

  rem Background Color
  COLUBK=$C8
  rem Playfield Foreground Color - also deteremines the ball sprite color
  COLUPF=$F2
 
  if switchbw then drawscreen : AUDV0 = 0: goto pauseloop
  

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
 XXX............XX............XXX
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

 drawscreen
  if player0x > 70 && player0x < 80 && player0y > 50 && player0y < 60 then inBox = 1 else inBox = 0

  rem if joy0fire then carrying = 1 else carrying = 0
  if carrying > 0 && !joy0fire then carrying = 0
 
  rem PLAYER0 COLLISIONS
  if collision(player0,player1) then AUDV0 = 0 : gosub grabKitten
  if collision(player0,ball) then AUDV0 = 0 : gosub ballStunPlayer
  rem if collision(player0,missile0) then AUDV0 = 0 : goto main
  rem if collision(player0,missile1) then AUDV0 = 0 : goto main

  if player0Timer > 0 then player0Timer = player0Timer - 1 : goto __skipPlayerInput   
  if joy0right then player0x=player0x+1 : REFP0 = 0
  if joy0left then player0x=player0x-1 : REFP0 = 8
  if joy0up then player0y=player0y+1
  if joy0down then player0y=player0y-1  
__skipPlayerInput

  if player0y = 88 then player0y = 87
  if player0y = 12 then player0y = 13
  if player0x = 133 then player0x = 132
  if player0x = 15 then player0x = 16

  if inBox = 1 && carrying > 0 then gosub scoreKitten
  
  
  rem HERE IS THE TIMER
  t=t+1  
  if t=60 then t=0 : bonusFactor = bonusFactor - 1
  

  gosub updateKittens

  rem Keep the kittens from moving every single frame  
  if player1Timer > 0 && !boxed{1} then player1Timer = player1Timer - 1 else player1Timer = _baseKittenSpeed 
  if player2Timer > 0 && !boxed{2} then player2Timer = player2Timer - 1 else player2Timer = _baseKittenSpeed 
  if player3Timer > 0 && !boxed{3} then player3Timer = player3Timer - 1 else player3Timer = _baseKittenSpeed 
  if player4Timer > 0 && !boxed{4} then player4Timer = player4Timer - 1 else player4Timer = _baseKittenSpeed

  if carrying > 0 then gosub carryKitten

  rem if player2y=7 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
  rem if player3y=7 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
  rem if player4y=7 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
  rem if player5y=7 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
  rem if missile0y=5 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
  rem if missile1y=5 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
  rem if bally=6 then sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
 
  rem gosub player5collision

  if sfxplaying = 1 then sfxtimer = sfxtimer + 1
  if sfxtimer = 30 then sfxplaying = 0 : sfxtimer = 0 : AUDV0 = 0
  
  goto main

setupRound
  rem ****************** 
  rem STARTING POSITIONS
  rem ******************
  player0x=75
  player1x=120
  player2x=40
  player3x=120
  player4x=40
 
  player0y=25
  player1y=65
  player2y=25
  player3y=25
  player4y=65


  ballx=75
  bally=4
  missile0x=75
  missile0y=5
  missile1x=75
  missile1y=6


  timerlo=1
  timerhi=0

  sfxplaying=0
  sfxtimer=0
  AUDV0=0 

  player1Dir=10
  player2Dir=40
  player3Dir=30
  player4Dir=10
  ballDir=10

  carrying = 0
  boxed = 0

  TextIndex = t_Title

  bonusFactor = 100

  player1Timer = 0
  player2Timer = 0
  player3Timer = 0
  player4Timer = 0
  return

ballStunPlayer
  player0Timer = 50
  return

scoreKitten
  rem score = score + 1
  temp1 = (rand&3) + 1
  temp1 = temp1 * 100
  temp1 = 100

  if carrying = 1 then player1x = 80 : player1y = 55 : player1Timer = temp1 : boxed{1} = 1 : TextIndex = t_P1
  if carrying = 2 then player2x = 80 : player2y = 55 : player2Timer = temp1 : boxed{2} = 1 : TextIndex = t_P2
  if carrying = 3 then player3x = 80 : player3y = 55 : player3Timer = temp1 : boxed{3} = 1 : TextIndex = t_P3
  if carrying = 4 then player4x = 80 : player4y = 55 : player4Timer = temp1 : boxed{4} = 1 : TextIndex = t_P4
  rem player1Dir = (rand&3) + 1
  rem player1Dir = player1Dir * 10
  carrying = 0
  if round = 1 && boxed{1} then temp2 = 1: temp3 = 1 : goto __endRound
  if boxed{1} && boxed{2} then temp2 = 1
  if round = 2 && temp2 then temp3 = 1 : goto __endRound
  if boxed{3} && boxed{4} then temp3 = 1
__endRound
  sfxplaying = 1 : AUDC0 = 12 : AUDF0 = 18 : AUDV0 = 10
  temp4 = bonusFactor * 10
  dec temp5  = temp4 + $00
  if temp2 = 1 && temp3 = 1 then score = score + temp5 : round = round + 1 :  goto setupRound
  return

carryKitten
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
    return 

grabKitten
    if joy0fire && carrying = 0 && inBox = 0 then gosub subGrab
    return

subGrab
    if player0x > 90 && player0y > 50 then carrying = 1
    if player0x > 90 && player0y < 50 then carrying = 3
    if player0x < 75 && player0y < 50 then carrying = 2
    if player0x < 75 && player0y > 50 then carrying = 4
    return

updateKittens
    if player1Timer > 0 then goto __skipUpdate1
    if carrying > 1 || carrying = 0 then gosub player1collision
__skipUpdate1

    if player2Timer > 0 || round < 2 then goto __skipUpdate2
    if carrying > 2 || carrying < 2 then gosub player2collision
__skipUpdate2

    if player3Timer > 0 || round < 3 then goto __skipUpdate3
    if carrying > 3 || carrying < 3 then gosub player3collision
__skipUpdate3

    if player4Timer > 0 || round < 3 then goto __skipUpdate4
    if carrying > 4 || carrying < 4 then gosub player4collision
__skipUpdate4
    if round > 2 then gosub ballcollision
    return

player1collision
 player1:
 %0011010
 %0101110
 %1000111
 %1000101
end

 if player1Dir = 10 && player1y > _z1YMax then player1Dir=player1Dir+10
 if player1Dir = 10 && player1x > _z1XMax then player1Dir=player1Dir+30

 if player1Dir = 20 && player1x > _z1XMax then player1Dir=player1Dir+10
 if player1Dir = 20 && player1y < _z1YMin then player1Dir=player1Dir-10

 if player1Dir = 30 && player1y < _z1YMin then player1Dir=player1Dir+10
 if player1Dir = 30 && player1x < _z1XMin then player1Dir=player1Dir-10
 
 if player1Dir = 40 && player1y > _z1YMax then player1Dir=player1Dir-10
 if player1Dir = 40 && player1x < _z1XMin then player1Dir=player1Dir-30
 
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

 if player2Dir = 10 && player2y > _z2YMax then player2Dir=player2Dir+10
 if player2Dir = 10 && player2x > _z2XMax then player2Dir=player2Dir+30

 if player2Dir = 20 && player2x > _z2XMax then player2Dir=player2Dir+10
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

 if player3Dir = 10 && player3y > _z3YMax then player3Dir=player3Dir+10
 if player3Dir = 10 && player3x > _z3XMax then player3Dir=player3Dir+30

 if player3Dir = 20 && player3x > _z3XMax then player3Dir=player3Dir+10
 if player3Dir = 20 && player3y < _z3YMin then player3Dir=player3Dir-10

 if player3Dir = 30 && player3y < _z3YMin then player3Dir=player3Dir+10
 if player3Dir = 30 && player3x < _z3XMin then player3Dir=player3Dir-10
 
 if player3Dir = 40 && player3y > _z3YMax then player3Dir=player3Dir-10
 if player3Dir = 40 && player3x < _z3XMin then player3Dir=player3Dir-30
 
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

 if player4Dir = 10 && player4y > _z4YMax then player4Dir=player4Dir+10
 if player4Dir = 10 && player4x > _z4XMax then player4Dir=player4Dir+30

 if player4Dir = 20 && player4x > _z4XMax then player4Dir=player4Dir+10
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
 ballx = ballx + 1
 bally = bally + 1
 return
 
 
moveupandleft8
 ballx = ballx - 1
 bally = bally + 1
 return
 
 
movedownandright8
 ballx = ballx + 1
 bally = bally - 1
 return
 
 
movedownandleft8
 ballx = ballx - 1
 bally = bally - 1
 return
 
 bank 2

   data text_strings
   __K, __I, __T, __T, __E, __N, _sp, __K, __A, __T, __C, __H
   __B, __O, __X, __E, __D, _sp, __M, __I, __T, __T, __E, __N
   __C, __A, __U, __G, __H, __T, _sp, __M, __O, __D, _ex, _sp
   __N, __A, __B, __B, __E, __D, _sp, __T, __O, __T, __S, _ex
   __S, __T, __O, __W, __E, __D, _sp, __P, __I, __P, _ex, _sp
   __R, __O, __U, __N, __D, _sp, __D, __O, __N, __E, _ex, _sp
   _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp
end

  inline text12a.asm
  inline text12b.asm
 
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
     
  