
 ;*** The height of the displayed data...
bmp_48x1_2_window = 12

 ;*** The height of the bitmap data. This can be larger than 
 ;*** the displayed data height, if you're scrolling or animating 
 ;*** the data...
bmp_48x1_2_height = 12

 ifnconst bmp_48x1_2_PF1
bmp_48x1_2_PF1
 endif
        BYTE %00000000
 ifnconst bmp_48x1_2_PF2
bmp_48x1_2_PF2
 endif
        BYTE %00000000
 ifnconst bmp_48x1_2_background
bmp_48x1_2_background
 endif
        BYTE $c2

 ifnconst bmp_48x1_2_color
bmp_48x1_2_color
 endif
 ; *** this is the bitmap color. If you want to change it in a 
 ; *** variable instead, dim one in bB called "bmp_48x1_2_color"
	.byte $0E


   if >. != >[.+bmp_48x1_2_height]
	align 256
   endif

bmp_48x1_2_00
 ; *** replace this block with your bimap_00 data block...
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000001
	BYTE %00000001
	BYTE %00000001
	BYTE %00000001
	BYTE %00000000
	BYTE %00000000



   if >. != >[.+bmp_48x1_2_height]
	align 256
   endif


bmp_48x1_2_01
 ; *** replace this block with your bimap_01 data block...
	BYTE %00010001
	BYTE %00010010
	BYTE %00111001
	BYTE %00010000
	BYTE %00000000
	BYTE %00000000
	BYTE %00010011
	BYTE %10010011
	BYTE %01011011
	BYTE %10000000
	BYTE %00000000
	BYTE %00000000



   if >. != >[.+bmp_48x1_2_height]
	align 256
   endif


bmp_48x1_2_02
 ; *** replace this block with your bimap_02 data block...
 	BYTE %00001100
	BYTE %10000010
	BYTE %00001100
	BYTE %00000110
	BYTE %00000000
	BYTE %00000000
	BYTE %10110011
	BYTE %00010001
	BYTE %10011001
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000



   if >. != >[.+bmp_48x1_2_height]
	align 256
   endif


bmp_48x1_2_03
 ; *** replace this block with your bimap_03 data block...
 	BYTE %01000110
	BYTE %01001010
	BYTE %11100110
	BYTE %01000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00001000
	BYTE %00001000
	BYTE %10001100
	BYTE %00001110
	BYTE %00000000
	BYTE %00000000



   if >. != >[.+bmp_48x1_2_height]
	align 256
   endif


bmp_48x1_2_04
 ; *** replace this block with your bimap_04 data block...
 	BYTE %10001000
	BYTE %10001000
	BYTE %11011100
	BYTE %00001000
	BYTE %00000000
	BYTE %00000000
	BYTE %10101011
	BYTE %10110010
	BYTE %10101011
	BYTE %10110011
	BYTE %00000000
	BYTE %00000000



   if >. != >[.+bmp_48x1_2_height]
	align 256
   endif


bmp_48x1_2_05
 ; *** replace this block with your bimap_05 data block...
 	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10000000
	BYTE %00000000
	BYTE %00000000

   