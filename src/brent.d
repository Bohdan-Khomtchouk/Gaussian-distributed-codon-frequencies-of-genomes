
/BRENT module  | toolbox

|-------------------------------------------------------------------------
| /eqn_solver_1D: dictionary containing brent, bracket, and guessbracbrent
| to solve 1D algebraic equation "brenteval"

10 dict dup begin

|============================== interna ==================================

|-------------------------------------------- brent
| solve "function" by Brent's Method adapted from Press, et al.
| input: x1, x2, tol; x1 and x2 must bracket the root

/brent {
   /tol name
   /b name
   /a name

   /BRENTMAX 100 def
   /BRENTEPS 1.0e-15 def

|   /fa a eval def
|   /fb b eval def

|   fa fb mul 0.0 gt
|      { (\nroot must be bracketed in brent\n) toconsole
|        brentfct toconsole halt } if

   /fc fb def

   /bisk  0 def
   /quadk 0 def
   1 1 BRENTMAX
      {
         /iterk name
         fb 0.0 ge fc 0.0 ge and  fb 0.0 lt fc 0.0 lt and  or
            { /c a def /fc fa def /d b a sub def /e d def } if
         fc abs fb abs lt
            { /a b def /b c def /c a def /fa fb def /fb fc def /fc fa def } if


         /tol1 2.0 BRENTEPS mul b abs mul  0.5 tol mul add def
         /xm 0.5 c b sub mul def
         xm abs tol1 le  fb 0.0 eq  or { /iterk iterk 1 sub def b exit } if

         e abs tol1 ge  fa abs fb abs gt  and
            {
               /quadk quadk 1 add def
               /s fb fa div def
               a c eq
                  { /p 2.0 xm mul s mul def  /q 1.0 s sub def }
                  {
                     /q fa fc div def
                     /r fb fc div def

                     2.0 xm mul q mul q r sub mul
                     b a sub r 1.0 sub mul
                     sub s mul /p name

                     q 1.0 sub r 1.0 sub mul s 1.0 sub mul /q name
                  }
               ifelse

               p 0.0 gt { /q q neg def } if
               /p p abs def

               /min1 3.0 xm mul q mul  tol1 q mul abs sub def
               /min2 e q mul abs def

               min1 min2 lt { /min min1 def }{ /min min2 def } ifelse
               2.0 p mul min lt
                  { /e d def /d p q div def }
                  { /d xm def /e d def }
               ifelse
            }
            {
               /bisk bisk 1 add def
               /d xm def
               /e d def
            } ifelse
         
         /a b def
         /fa fb def
         d abs tol1 gt
            { /b b d add def }
            {
               xm 0.0 ge { /sign tol1 abs def }{ /sign tol1 abs neg def } ifelse
               /b b sign add def
            }
         ifelse

         /fb b brenteval def
      }  for

   iterk BRENTMAX lt
} bind def


| find bracket for root inside interval (x1,x2) by cutting it
| into Nint intervals (adapted from Press, et al.)

/bracket {
   /Nint name
   /bx2 name
   /bx1 name

   /bnbb 0 def
   /bdx bx2 bx1 sub Nint div def
   /bx bx1 def

   /bfp bx brenteval def

   Nint {
     /bx bx bdx add def
     /bfc bx brenteval def
     
     bfc bfp mul 0.0 le {
       /bnbb bnbb 1 add def
       bx bdx sub /fa bfp def
       bx /fb bfc def
     } if

     /bfp bfc def
   } repeat
      
   bnbb 1 eq
} bind def

|============================== front ends ===============================
| Needs following definitions in your working directory:
|
| brenteval       -- procedure taking argument and returning value of function
| brenttolerance  -- of root value to be found 
| guessrange      -- relative interval for guess to be used

|------------------------------------ guessbracbrent
|   guess xl xr n | root true  | found it
|                   false      | not found
|
|   tests guess to see if it close to a solution. If not
|   the provided interval (xl,xr) is divided in n segments to see if
|   there is a root in the interval.  The equation is then solved by
|   brent.

/guessbracbrent {
  /n  name
  /xr name
  /xl name
  /guess name
  
  /factorl 1.0 guessfactor sub def
  /factorr 1.0 guessfactor add def
  
  factorl guess mul brenteval dup /fa name
  factorr guess mul brenteval dup /fb name
  mul 0.0 gt {xl xr n bracket} {
    factorl guess mul factorr guess mul
    true
  } ifelse
  {brenttolerance brent} ~false ifelse
} bind def

end _module 

