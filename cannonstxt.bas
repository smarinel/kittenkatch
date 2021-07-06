    set romsize 4k
    const p0color = $9A
    const p1color = $4A
    const explode_color = $3F
    const bkcolor = $00
    const gameoverbkcolor = $E0
    const offscreen = 200
    const pfscore = 1
    const press_fire = 0
    const red_hits = 12
    const blue_hits = 24
    const red_wins = 36
    const blue_wins = 48
    const blank_text = 60
    const scorebkcolor = $60
    const textbkcolor = $12
    const fontstyle = SQUISH ; Shorter font to save lines
;    const noscoretxt = 1 ; set to disable built-in score

    ; dim "TextIndex" for text minikernel
    dim TextIndex = z ; Can use aux2 instead unless pfheights or pfcolors are used
    dim P0FlippedBit0 = a
    dim P1FlippedBit1 = a
    dim Prev0x = b
    dim Prev0y = c
    dim Prev1x = d
    dim Prev1y = e
    dim Loop = f
    dim Temp = g
    dim Temp2 = h
    dim TextCounter = i
    TextColor = $0F ; Set starting text color to white
    scorecolor = $DF
    score = 012345
    
    player0:
    %00100000
    %01010000
    %10001000
    %10101000
    %10001000
    %01010000
    %01111111
    %01111111
    %11111111
    %01111111
    %00010000
end


    player1:
    %00000100
    %00001010
    %00010001
    %00010101
    %00010001
    %00001010
    %11111110
    %11111110
    %11111111
    %11111110
    %00001000
end

ResetGame

    playfield:
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
end

    player0x = 20 : player0y = 50
    player1x = 130 : player1y = 50
    pfscorecolor = $68
    missile0y = offscreen : missile1y = offscreen
    missile0height = 2 : missile1height = 2
    Temp = 0 : Temp2 = 0 : AUDC0 = 0 : AUDV0 = 0
;    scorecolor = gameoverbkcolor
    
SubGameOver
    Loop = Loop + 1
    NUSIZ0 = $15 : NUSIZ1 = $15
    COLUPF = $08
    COLUP0 = p0color
    COLUP1 = p1color
    COLUBK = gameoverbkcolor
    temp1 = Loop / 16
    temp2 = temp1 * 16 + 15
    if TextIndex then TextColor = temp2
    drawscreen
    Temp = Temp + 1
    if Temp = 60 then Temp2 = 1
    if Temp2 = 0 then goto SubGameOver
    if !switchreset && !joy0fire && !joy1fire then goto SubGameOver
/* End SubGameOver */

    pfscore1 = 42 : pfscore2 = 42
;    TextColor = 0
    TextIndex = blank_text
;    scorecolor = bkcolor

MainLoop
    NUSIZ0 = $15 : NUSIZ1 = $15 ; Double-width tanks and missiles
    COLUBK = bkcolor
    COLUPF = $08
    COLUP0 = p0color
    COLUP1 = p1color
    pfscroll up
    Prev0x = player0x
    Prev0y = player0y
    Prev1x = player1x
    Prev1y = player1y
    if joy0left && player0x > 0 then player0x = player0x - 1
    if joy0right && player0x < 144 then player0x = player0x + 1
    if joy1left && player1x > 0 then player1x = player1x - 1
    if joy1right && player1x < 144 then player1x = player1x + 1

    if joy0up && player0y > player0height + 2 then player0y = player0y - 1
    if joy0down && player0y < 82 then player0y = player0y + 1
    if joy1up && player1y > player1height + 2 then player1y = player1y - 1
    if joy1down && player1y < 82 then player1y = player1y + 1
    if missile0y = offscreen then goto ____skip_move_p0missile
    missile0x = missile0x + 1
    if missile0x > 158 then missile0y = offscreen
    goto ____p0missile_done
____skip_move_p0missile
    if !joy0fire then goto ____skip_joy0fire
    if missile0y <> offscreen then goto ____skip_joy0fire
    missile0x = player0x + 16
    missile0y = player0y - 7
____skip_joy0fire
____p0missile_done
    if missile1y = offscreen then goto ____skip_move_p1missile
    missile1x = missile1x - 1
    if missile1x < 1 then missile1y = offscreen
    goto ____p1missile_done
____skip_move_p1missile
    if !joy1fire then goto ____skip_joy1fire
    if missile1y <> offscreen then goto ____skip_joy1fire
    missile1x = player1x
    missile1y = player1y - 7
____skip_joy1fire
____p1missile_done
    drawscreen
    AUDC0 = 0 : AUDV0 = 0
    if collision(missile0,playfield) then temp1 = missile0x : temp2 = missile0y : missile0y = offscreen : temp5 = 79 : gosub SubBreakWall
    if collision(missile0,player1) then pfscore2 = pfscore2 / 4 : missile0y = offscreen : Temp = 1 : gosub SubPlayerHit
    if collision(missile1,playfield) then temp1 = missile1x : temp2 = missile1y : missile1y = offscreen : temp5 = 81 : gosub SubBreakWall
    if collision(missile1,player0) then pfscore1 = pfscore1 / 4 : missile1y = offscreen : Temp = 0 : gosub SubPlayerHit
    if collision(player0,playfield) then player0x = player0x - 8
    if collision(player1,playfield) then player1x = player1x + 8
    if collision(player0,player1) then player0x = Prev0x : player0y = Prev0y : player1x = Prev1x : player1y = Prev1y
    if pfscore1 = 0 || pfscore2 = 0 then goto ResetGame
    if !TextCounter then goto ____end_text_counter
    TextCounter = TextCounter - 1
    if !TextCounter then TextIndex = blank_text
____end_text_counter
    
    
    goto MainLoop
/* End MainLoop */

SubBreakWall
    AUDC0 = 12 : AUDV0 = 8 : AUDF0 = 31
    if temp1 > temp5 then temp3 = 16 else temp3 = 15
    temp4 = temp4 - playfieldpos
    temp4 = temp2 / 8
    if !pfread(temp3,temp4) then temp4 = temp4 + 1
    if !pfread(temp3,temp4) then temp4 = temp4 - 2
    pfpixel temp3 temp4 off
    return
/* End SubBreakWall */


SubPlayerHit
    Temp2 = player0height
    temp1 = player0height * 2
    AUDC0 = 8 : AUDV0 = 8 : AUDF0 = 31
    for Loop=temp1 to 0 step -1
        COLUBK = bkcolor
        NUSIZ0 = $15 : NUSIZ1 = $15 ; Double-width tanks and missiles
        COLUPF = $08
        if Temp=1 then goto ____skip_p0
        player0height = Loop / 2
        COLUP0 = explode_color
        COLUP1 = p1color
        if pfscore1 then TextIndex = red_hits else TextIndex = red_wins
        TextCounter = 120
        TextColor = $4F
        goto ____skip_p1
____skip_p0
        player1height = Loop / 2
        COLUP0 = p0color
        COLUP1 = explode_color
        if pfscore2 then TextIndex = blue_hits else TextIndex = blue_wins
        TextCounter = 120
        TextColor = $9F
____skip_p1
        drawscreen
    next
    if Temp = 0 then player0height = Temp2 else player1height = Temp2
    return
/* End PlayerHit */


   data text_strings
   _hy, __P, __R, __E, __S, __S, _sp, __F, __I, __R, __E, _hy
   __R, __E, __D, _sp, __H, __I, __T, __S, _ex, _sp, _sp, _sp
   __B, __L, __U, __E, _sp, __H, __I, __T, __S, _ex, _sp, _sp
   __R, __E, __D, _sp, __W, __I, __N, __S, _ex, _sp, _sp, _sp
   __B, __L, __U, __E, _sp, __W, __I, __N, __S, _ex, _sp, _sp
   _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp
end

    inline text12a.asm
    inline text12b.asm