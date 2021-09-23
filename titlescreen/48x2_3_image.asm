

 ;*** The height of the displayed data...
bmp_48x2_3_window = 12

 ;*** The height of the bitmap data. This can be larger than 
 ;*** the displayed data height, if you're scrolling or animating 
 ;*** the data...
bmp_48x2_3_height = 12

   if >. != >[.+(bmp_48x2_3_height)]
      align 256
   endif
 BYTE 0 ; leave this here!


 ;*** The color of each line in the bitmap, in reverse order...
bmp_48x2_3_colors 
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E
   .byte $0E


   if >. != >[.+bmp_48x2_3_height]
      align 256
   endif


bmp_48x2_3_00
 ; *** replace this block with your bimap_00 data block...
	BYTE %00000000
	BYTE %00000000
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


   if >. != >[.+bmp_48x2_3_height]
      align 256
   endif


bmp_48x2_3_01
 ; *** replace this block with your bimap_01 data block...
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00001000
	BYTE %00001001
	BYTE %00011100
	BYTE %00001000
	BYTE %00000000
	BYTE %00010011
	BYTE %10010011
	BYTE %01011011
	BYTE %10000000



   if >. != >[.+bmp_48x2_3_height]
      align 256
   endif


bmp_48x2_3_02
 ; *** replace this block with your bimap_02 data block...
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10000110
	BYTE %01000101
	BYTE %10000110
	BYTE %00000100
	BYTE %00000000
	BYTE %10110011
	BYTE %00010001
	BYTE %10011001
	BYTE %00000000



   if >. != >[.+bmp_48x2_3_height]
      align 256
   endif


bmp_48x2_3_03
 ; *** replace this block with your bimap_03 data block...
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %01110110
	BYTE %01100010
	BYTE %01110110
	BYTE %00000110
	BYTE %00000000
	BYTE %00001000
	BYTE %00001000
	BYTE %10001100
	BYTE %00001110



   if >. != >[.+bmp_48x2_3_height]
      align 256
   endif


bmp_48x2_3_04
 ; *** replace this block with your bimap_04 data block...
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10101000
	BYTE %10101000
	BYTE %00110000
	BYTE %10000000
	BYTE %00000000
	BYTE %10101011
	BYTE %10110010
	BYTE %10101011
	BYTE %10110011



   if >. != >[.+bmp_48x2_3_height]
      align 256
   endif


bmp_48x2_3_05
 ; *** replace this block with your bimap_05 data block...
	BYTE %00000000
	BYTE %00000000
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



