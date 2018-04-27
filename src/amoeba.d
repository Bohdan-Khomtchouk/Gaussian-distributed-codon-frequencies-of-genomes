/AMOEBA module
100 dict dup begin
|========================= multi-dimension amoeba ============================
|
| finds the minimum of an n-dimensional function by a simplex method
| Press et al., p.411
|

|------------------------------------------------ set up
| ndim | --
|
| ndim is the number of free parameters that determine `function' (see below)

/setup { /ndim name
  [ ndim 1 add { ndim /d array } repeat ] /p name
  /ndim1 ndim 1 add def
  /y ndim1 /d array def
  /psum ndim /d array def
  /ptry ndim /d array def
  /ptemp ndim /d array def
} bind def

|------------------------------------------------- run amoeba
| use: -- | pvec true        0n convergence (<TOL)
|      -- | false            On failure     (>Maxfunctions)
|
| - execute with AMOEBA as current dictionary
| - provide initial parameters in rowmatrix `p' of AMOEBA:
|   each row gives a full parameter set; there is one set (row) more
|   than there are parameters in the set
| - define `function' in your context
| - use of `function':  pvec | value
| - a typical `function' computes as its value the sum of squares of
|   the residues between a data set and corresponding values computed
|   from theory for a least-squares fit (NOTE: the `function' of AMOEBA
|   is the norm of the fit (with the parameters as independent variables)
|   -- it is not the theoretical relation that is fit to the data set
| - also provide the function values for the initial parameter sets `p'
|   in the AMOEBA array `y'
| - each initial parameter set should differ in one parameter by an amount
|   matching the characteristic scale of that parameter
| - convergence is assumed when the difference  between successive
|   minimization attempts of `function' is less than `TOL' (returning `true')
| - no more than `Maxfunctions' evaluations of `function' are attempted;
|   on exceeding Maxfunctions `false' is returned (the vertex matrix `p'
|   and function vector `y' can be re-used to do more iterations)
| - on convergence, the parameter vertex giving the lowest function value
|   is returned (all vertices in p are within `TOL')and `y' contains the
|   function values of thesea vertices). 
|

/TOL 1e-6 def
/Maxfunctions 1000 def

/amoeba {
  get_psum
  /nfunc 0 def
  {
    /ilo 0 def
    y 0 get y 1 get gt {1 0} {0 1} ifelse /ihi name /inhi name

    0 1 ndim {/i name
      y i get y ilo get le {/ilo i def} if
      y i get y ihi get gt {/inhi ihi def /ihi i def} { 
        y i get y inhi get gt i ihi ne and {/inhi i def} if 
      } ifelse
    } for
    
    /rtol y ihi get y ilo get sub abs def
    rtol TOL lt {
      y 0 get y ilo get y 0 put y ilo put | closest params => 0
      p 0 get p ilo get p 0 put p ilo put
      p 0 get true exit
    } if
    nfunc Maxfunctions ge { false exit } if
    /nfunc nfunc 2 add def
    -1.0 amotry /ytry name
    ytry y ilo get le {2.0 amotry /ytry name} { 
      ytry y inhi get lt {/nfunc nfunc 1 sub def} { 
        /ysave y ihi get def
        0.5 amotry /ytry name
        ytry ysave ge {
          0 1 ndim { 
            /i name
            i ilo ne { 
              p i get p ilo get add 0.5 mul psum copy pop
              currentdict psum end function exch begin y i put
            } if
          } for
          /nfunc nfunc ndim add def
          get_psum
        } if
      } ifelse
    } ifelse
  } loop
} bind def

/amotry {/fac name
   /fac1 1.0 fac sub ndim div def
   /fac2 fac1 fac sub def
   psum ptry copy fac1 mul p ihi get ptemp copy fac2 mul sub
   currentdict exch end function exch begin /mytry name
   mytry y ihi get lt {
     mytry y ihi put
     psum ptry add p ihi get sub pop
     ptry p ihi get copy pop
   } if
  mytry
} bind def

/get_psum {
   0.0 psum copy p { add } forall pop
} bind def

end _module

/testamoeba {
  AMOEBA begin 2 setup end
  /function { v_ /pfunc name
      3.0 pfunc 0 get 1 sub 2 pwr mul pfunc 1 get 3 sub 4 pwr add 1 add
    } def
  AMOEBA begin
  <d 10 10 > p 0 get copy pop
  <d 11 10 > p 1 get copy pop
  <d 10 11 > p 2 get copy pop
  0 1 2 { /i name
          p i get function y i put
        } for
  /TOL 1e-6 def
  /Maxfunctions 500 def
  amoeba _
  { p { v_ pop } forall y v_  pop } if
  end
} def
