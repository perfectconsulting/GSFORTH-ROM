( forth screen editor v.1.08 screen 1 of 12 )
vocabulary screen immediate
screen definitions

here

139 constant key/up ( move cursor up )
138 constant key/dw ( move cursor down )
137 constant key/rt ( move cursor right )
136 constant key/lt ( move cursor left )
13 constant key/nl( new line )
127 constant key/bs ( back space )
19 constant key/sv ( save screen )
14 constant key/nt ( next screen )
12 constant key/lr ( last screen )
1 constant key/ad ( add a line )
18 constant key/rm ( remove a line )

( forth screen editor v.1.08 screen 2 of 12 )
3 constant key/ct ( cut line & store in pad )
16 constant key/pt ( paste pad into line )
4 constant key/dl ( delete )
9 constant key/in ( insert )
2 constant key/bl ( blank out line )
24 constant key/ex ( exit )
7 constant key/go ( goto )

0 variable keypress ( the key pressed )
0 variable scr/add ( the start address of the edit screen )
0 variable sc ( the current screen number )
0 variable y ( the y position of the cursor )
0 variable x ( the x position of the cursor )

( forth screen editor v.1.08 screen 3 of 12 )
: (version) ." 1.08" ;
: (standard) ." fig forth" ;
.( forth screen editor version ) (version) cr
.( copyright 1987 Steve James.) cr
(standard) space ." standard version." cr
.( n screen ed : to edit screen n )

pad 64 32 fill
cr
cr

( forth screen editor v.1.08 screen 4 of 12 )
( editor primitives )
( this routine disables normal bbc cursor editing )
( and enables editor keys with *fx 4,1 )

: cursor/on 0 1 4 osbyte ;

( this rounine enables normal bbc cursor editing )
( and disables editor keys with *fx 4,0          )

: cursor/off 0 0 4 osbyte ;

( forth screen editor v.1.08 screen 5 of 12 )
: locate 31 emit emit emit ; ( y x -- )
: $line line 64 type ; ( -- )
: return [compile] forth definitions ; ( -- )
: title 1 14 locate ." forth screen editor " (version) space
." (c) Steven James 1987." cr ;
: == 71 0 do ." =" loop ; ( -- )
: || 19 3 do i 5 locate ." | " i 3 - dup 10 < if 32 emit endif
 . i 75 locate ." |" loop ; ( -- )
: set-up 3 mode title 2 5 locate == || 19 5 locate == 20 5 locate
." |pad|" 20 75 locate ." |" 21 5 locate == ; ( -- )

( forth screen editor v.1.08 screen 6 of 12 )
: #list dup dup block scr/add ! 1 5 locate ." scr #" . scr ! 16 0
do i dup 3 + 11 locate $line loop ; ( n -- )
: $pad 20 11 locate pad 63 type ; ( n -- )
: cpoke 3 - 64 * swap 11 - + scr/add @ + c! ; ( n x y -- )
: cpeek 3 - 64 * swap 11 - + scr/add @ + c@ ; ( x y -- n )
: %list 16 y @ 3 - do i dup 3 + 11 locate $line loop ; ( y -- )
: clear line 64 1 do dup 32 swap c! 1+ loop drop ; ( n -- )

( forth screen editor v.1.08 screen 7 of 12 )
: cur/u dup key/up = if -1 y +! then y @ 3 < if 18 y ! endif ; ( n -- )
: cur/d dup key/dw = if 1 y +! then y @ 18 > if 3 y ! endif ; ( n -- )
: cur/r dup key/rt = if 1 x +! then x @ 74 > if 11 x ! endif ; ( n -- )
: cur/l dup key/lt = if -1 x +! then x @ 11 < if 74 x ! endif ; ( n -- )
: ret dup key/nl = if 1 y +! 11 x ! then y @ 18 > if 18 y ! endif ; ( n -- )
: del dup key/bs = if -1 x +! 8 emit 32 dup emit x @ y @ cpoke then
 x @ 11 < if 74 x ! endif ; ( n -- )

( forth screen editor v.1.08 screen 8 of 12 )
: sav/pg dup key/sv = if update flush sc @ block drop endif ; ( n -- )
: nxt/pg dup key/nt = if sc @ 120 < if 1 sc +! sc @ #list endif endif ; ( n -- )
: lar/pg dup key/lr = if sc @ 0 > if -1 sc +! sc @ #list endif endif ; ( n -- )
: add/ln dup key/ad = if y @ 3 - dup 15 < if dup 14
do i line i 1+ line 64 cmove -1 +loop endif clear %list endif ; ( n -- )
: rem/ln dup key/rm = if y @ 3 - dup 15 < if 15 swap
do i 1+ line i line 64 cmove loop endif 15 clear %list endif ; ( n -- )

( GOOD )


( forth screen editor v.1.08 screen 9 of 12 )
: cut dup key/ct = if y @ 3 - line pad 64 cmove $pad endif ; ( n -- )
: paste dup key/pt = if pad y @ 3 - line 64 cmove y @ 11 locate
pad 64 type endif ; ( n -- )


( HERE MAYBE )

: del/rt dup key/dl = if x @ 74 < if 74 x @ do i 1+ y @ cpeek i y @
cpoke loop endif 32 74 y @ cpoke y @ 3 - line x @ 11 - + 64 x @ 11
- - type endif ; ( n -- )
: insert dup key/in = if x @ 74 do i 1- y @ cpeek i y @ cpoke -1
+loop 32 x @ y @ cpoke y @ 3 - line x @ 11 - + 64 x @ 11 - - type
endif ; ( n -- )
: rubout dup key/bl = if y @ dup 11 locate 3 - dup clear line 64 type
 endif ; ( n -- )



( ERROR )

( forth screen editor v.1.08 screen 10 of 12 )
: gotonum key dup emit 48 - key dup 13 = not if dup emit  48 - swap
base @ * + else drop endif ;
: goto dup key/go = if 7 emit 1 10 locate space space 1 10 locate gotonum
dup sc ! #list endif ;

( forth screen editor v.1.08 screen 11 of 12 )
: keys cur/u cur/d cur/r cur/l ret del sav/pg nxt/pg lar/pg del/rt insert
add/ln rem/ln cut paste rubout goto y @ x @ locate ; ( n -- )

( forth screen editor v.1.08 screen 12 of 12 )
: ed flush dup sc ! set-up #list $pad cursor/on 3 y ! 11 x ! 3 11 locate
begin key dup keypress ! dup 31 > over 127 < and
if x @ y @ cpoke keypress @ dup emit 1 x +! endif keys key/ex = until
cursor/off 22 1 locate return ; ( n -- )

here swap - . .( bytes used by the editor.) cr cr
forth definitions
