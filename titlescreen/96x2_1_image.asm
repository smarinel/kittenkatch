
 ; *** if you want to modify the bitmap color on the fly, just dim a
 ; *** variable in bB called "bmp_96x2_1_color", and use it to set the
 ; *** color.


 ;*** this is the height of the displayed data
bmp_96x2_1_window = 13

 ;*** this is the height of the bitmap data
bmp_96x2_1_height = 13

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif
 
 ;*** this is the color of each line in the bitmap data
bmp_96x2_1_colors 
	BYTE $3f
	BYTE $3f
	BYTE $3f
	BYTE $3f
	BYTE $2f
	BYTE $2f
	BYTE $2f
	BYTE $2f
	BYTE $2f
	BYTE $1f
	BYTE $1f
	BYTE $1f
	BYTE $1f

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_00

	BYTE %11111111
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

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_01
	BYTE %11111111
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

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_02
	BYTE %11111111
	BYTE %00001000
	BYTE %00001001
	BYTE %00001011
	BYTE %00001111
	BYTE %00001110
	BYTE %00001110
	BYTE %00001111
	BYTE %00001011
	BYTE %00001001
	BYTE %00001000
	BYTE %00000000
	BYTE %00001111


   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_03
	BYTE %11111111
	BYTE %10010011
	BYTE %10010011
	BYTE %10010011
	BYTE %00010010
	BYTE %00010010
	BYTE %00010111
	BYTE %00010111
	BYTE %10010111
	BYTE %10010010
	BYTE %10010010
	BYTE %00000000
	BYTE %00010010

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_04
	BYTE %11111111
	BYTE %10111001
	BYTE %10111011
	BYTE %10111011
	BYTE %00100011
	BYTE %00100011
	BYTE %11111011
	BYTE %11111011
	BYTE %11111001
	BYTE %00100000
	BYTE %00100000
	BYTE %00000000
	BYTE %00100011


   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_05
	BYTE %11111111
	BYTE %11101000
	BYTE %11101000
	BYTE %11101000
	BYTE %11101000
	BYTE %11101000
	BYTE %11101111
	BYTE %11101111
	BYTE %11001111
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %11101000

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif


bmp_96x2_1_06
	BYTE %11111111
	BYTE %10000100
	BYTE %10000100
	BYTE %10000101
	BYTE %10000111
	BYTE %10000111
	BYTE %10000111
	BYTE %10000111
	BYTE %00000101
	BYTE %00000100
	BYTE %00000100
	BYTE %00000000
	BYTE %10000111

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_07
	BYTE %11111111
	BYTE %01011111
	BYTE %11011111
	BYTE %11011111
	BYTE %10011111
	BYTE %00001111
	BYTE %00001111
	BYTE %10001111
	BYTE %11001110
	BYTE %11000000
	BYTE %01000000
	BYTE %00000000
	BYTE %10011111


   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif


bmp_96x2_1_08
	BYTE %11111111
	BYTE %01110011
	BYTE %01110111
	BYTE %01110111
	BYTE %01000100
	BYTE %01000100
	BYTE %11110111
	BYTE %11110111
	BYTE %11110011
	BYTE %01000000
	BYTE %01000000
	BYTE %00000000
	BYTE %01000100

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_09
	BYTE %11111111
	BYTE %10100010
	BYTE %10100010
	BYTE %10100010
	BYTE %00100010
	BYTE %00100010
	BYTE %10111110
	BYTE %10111110
	BYTE %10111100
	BYTE %00100000
	BYTE %00100000
	BYTE %00000000
	BYTE %00100010

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_10
	BYTE %11111111
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

   if >. != >[.+(bmp_96x2_1_height)]
      align 256
   endif

bmp_96x2_1_11
	BYTE %11111111
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


