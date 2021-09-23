
 ;*** The height of the displayed data...
bmp_48x1_1_window = 12

 ;*** The height of the bitmap data. This can be larger than 
 ;*** the displayed data height, if you're scrolling or animating 
 ;*** the data...
bmp_48x1_1_height = 12

 ifnconst bmp_48x1_1_PF1
bmp_48x1_1_PF1
 endif
        BYTE %00000000
 ifnconst bmp_48x1_1_PF2
bmp_48x1_1_PF2
 endif
        BYTE %00000000
 ifnconst bmp_48x1_1_background
bmp_48x1_1_background
 endif
        BYTE $c2

 ifnconst bmp_48x1_1_color
bmp_48x1_1_color
 endif
 ; *** this is the bitmap color. If you want to change it in a 
 ; *** variable instead, dim one in bB called "bmp_48x1_1_color"
	.byte $58


   if >. != >[.+bmp_48x1_1_height]
	align 256
   endif

bmp_48x1_1_00
 ; *** replace this block with your bimap_00 data block...
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000



   if >. != >[.+bmp_48x1_1_height]
	align 256
   endif


bmp_48x1_1_01
 ; *** replace this block with your bimap_01 data block...
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00101001
	BYTE %00111010
	BYTE %00111001
	BYTE %00000000
	BYTE %00000000
	BYTE %00011001
	BYTE %00010100
	BYTE %00011001
	BYTE %00010000



   if >. != >[.+bmp_48x1_1_height]
	align 256
   endif


bmp_48x1_1_02
 ; *** replace this block with your bimap_02 data block...
 	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10100101
	BYTE %10100101
	BYTE %10110001
	BYTE %00000100
	BYTE %00000000
	BYTE %00000110
	BYTE %10000010
	BYTE %01000011
	BYTE %00000000



   if >. != >[.+bmp_48x1_1_height]
	align 256
   endif


bmp_48x1_1_03
 ; *** replace this block with your bimap_03 data block...
 	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %01011101
	BYTE %01011001
	BYTE %10011101
	BYTE %00000001
	BYTE %00000000
	BYTE %01110010
	BYTE %01100010
	BYTE %01110111
	BYTE %00000010



   if >. != >[.+bmp_48x1_1_height]
	align 256
   endif


bmp_48x1_1_04
 ; *** replace this block with your bimap_04 data block...
 	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %01001000
	BYTE %01010100
	BYTE %01001000
	BYTE %01000000
	BYTE %00000000
	BYTE %01010000
	BYTE %01010000
	BYTE %01100000
	BYTE %01000000



   if >. != >[.+bmp_48x1_1_height]
	align 256
   endif


bmp_48x1_1_05
 ; *** replace this block with your bimap_05 data block...
 	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

   