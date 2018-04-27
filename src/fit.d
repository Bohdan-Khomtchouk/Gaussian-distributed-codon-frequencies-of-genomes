|================================ paper1 FCU ==================================
| Fits of codon usage/rank: simulated gau*exp or gau*emp models


|***************************** set in userdict ********************************
|    /prpath (/mnt/Cheetah/mother/pr/) def
| OR
|    /prpath (/home/wn/pr/) def
*******************************************************************************

userdict /AMOEBA known not {
    [ prpath (dcode/) concat (amoeba.d) fromfiles
  } if

userdict /BRENT known not {
    [ prpath (dcode/) concat (brent.d) fromfiles
  } if

userdict /L1tools known not {
    [ prpath (cu/dcode/) concat (L1tools.d) fromfiles
  } if
        
|==============================================================================
|
| - trimmed down descendent of fitcondonuse_v5

| Prior to fitting a model to data by 'dofits':
| - use 'setsigma' or 'setmu' to define the parameters of the Gaussian,
|   then create and save the new model by 'mksim'
| - alternatively load a previously created model by 'loadsim'
| - use L1tools for loading and selecting genomes for fit

/FCU module
200 dict dup begin

/Pi 3.141592653589793 def
/Ncodons 64d def

|----------------------------- string concatenation
| [ (s1) (s2) ... | (s1+s2+...)

/concat {
  ] 
  0 1 index { length add } forall /b array 0 3 -1 roll
  ~fax forall pop
} bind def

|----------------- BIG buffer for text files

/txtbuf 50e6 /b array def

|------------------------------ flip array or list
| array/list | --      (flipped in place)

/flip { dup /flipv name
  { } forall
  0 1 flipv length 1 sub { flipv exch put } for
} bind def

|----------------------------- whereabouts ----------------------------------

/DBdir [ prpath (cu/db/) concat def

|---------------------------------- model setups ---------------------------

/model1_exp {
  /lambda 64.0 def 0.009 setsigma mksim_exp
} bind def

/model1_emp {
  /lambda 64.0 def 0.009 setsigma mksim_emp
} bind def

|----------------------------- genome selection setups ---------------------
|  -- | selected_entries

| We use genomic DNA of bct (no plasmids), arc, pln, inv, vrt, mam, rod,
| pri, total codon count >= 1e4 codons

/sel1 {
  L1tools begin
    /MINCODONS 1e4 def
    load
    entries 0 S_one_etc thin /genentries name
    (kdfix_bct.d) load_kds
    genentries /bct S_one_kd thin apply_kds
    genentries [ /bct /arc /pln /inv /vrt /mam /rod /pri ] S_list_kd thin
  end
} bind def

|------------------------- global model parameters -------------------------
|
| These MUST be defined/set ONLY in FCU!!!
|

/lambda Ncodons def
/alpha 0.5 def

/setsigma { /sigma name
  MUdict begin { compMU } stopped end
  { (Failed\n) toconsole } { mu _ pop } ifelse
  vartgau sqrt _ pop
} bind def

/setmu { /mu name
  SIGdict begin { compSIG } stopped end
  { (Failed\n) toconsole } { sigma _ pop } ifelse
  vartgau sqrt _ pop
} bind def

|----------- computation of mu for the truncated Gaussian -----------------
|            given (FCU) sigma and the number of codons
|

/MUdict 100 dict dup begin  | note t

  /brenttolerance 1e-7 def
  /guessfactor 0.1 def

| use: -- | mu 

/compMU {
    0.01 -20.0 1.0 64 div 60 
    BRENT mkread begin guessbracbrent end
    not { (MU) toconsole stop } if 
    FCU /mu put
  } bind def

  |----------- compute function whose zero is found by brent:
  |  function = mean of truncated normal distribution minus 1/Ncodons
  |  parameter: sigma   (of normal distribution), Ncodons
  |  use: mu_of_normal | residue  (= mean_of_truncated - 1/Ncodons)

  /brenteval { FCU /mu put
    /tmin mu sigma div neg def       | integrate over 0<= y <= 1
    /tmax 1.0 mu sub sigma div def
    tmax 5 gt tmin 5 gt and 
      { tmax dup mul tmin dup mul sub -0.5 mul exp r2Pi div /rphi name
        1.0  rphi sub
        tmin pol rphi tmax pol mul sub div sigma mul }
      { tmin phi tmax phi sub tmax Phi tmin Phi sub div sigma mul }
      ifelse
      mu add 1.0 Ncodons div sub
  } bind def

  /r2Pi 2.0 Pi mul sqrt def
  /phi { dup mul -0.5 mul exp r2Pi div } bind def
  /Phi { 2.0 sqrt div Erf 1.0 add 2.0 div } bind def
  /Erf { /xerf name
     xerf abs 0.5 mul 1.0 add -1 pwr /terf name
     0.170872277  
     terf mul -0.82215223 add
     terf mul 1.48851587 add 
     terf mul -1.13520398 add
     terf mul 0.27886807 add
     terf mul -0.18628806 add
     terf mul 0.09678418 add
     terf mul 0.37409196 add
     terf mul 1.00002368 add
     terf mul -1.26551223 add
     xerf 2 pwr sub exp terf mul neg 1.0 add
     xerf 0.0 lt ~neg if
    } bind def
  /pol { -1 pwr dup /t_1 name 2 pwr /t_2 name
         7.0 t_2 mul 5.0 sub t_2 mul 3.0 add t_2 mul
         1.0 sub t_2 mul 1.0 add t_1 mul
       } bind def

end def

|----------- computation of sigma for the truncated Gaussian given
|            (FCU) mu
|

/SIGdict 100 dict dup begin  | note the private space

  /brenttolerance 1e-6 def
  /guessfactor 0.1 def

| use: mu | sigma 

  /compSIG {
    0.012 1e-4 1.0 30 
    BRENT mkread begin guessbracbrent end
    not { (SIG) toconsole stop } if 
    FCU /sigma put
  } bind def

  |----------- compute function whose zero is found by brent:
  |  function = mean of truncated normal distribution minus 1/Ncodons
  |  parameter: sigma   (of normal distribution), Ncodons
  |  use: mu_of_normal | residue  (= mean_of_truncated - 1/Ncodons)

  /brenteval { FCU /sigma put
    /tmin mu sigma div neg def       | integrate over 0<= y <= 1
    /tmax 1.0 mu sub sigma div def
    tmax 5 gt tmin 5 gt and 
      { tmax dup mul tmin dup mul sub -0.5 mul exp r2Pi div /rphi name
        1.0  rphi sub
        tmin pol rphi tmax pol mul sub div sigma mul }
      { tmin phi tmax phi sub tmax Phi tmin Phi sub div sigma mul }
      ifelse
      mu add 1.0 Ncodons div sub
  } bind def

  /r2Pi 2.0 Pi mul sqrt def
  /phi { dup mul -0.5 mul exp r2Pi div } bind def
  /Phi { 2.0 sqrt div Erf 1.0 add 2.0 div } bind def
  /Erf { /xerf name
     xerf abs 0.5 mul 1.0 add -1 pwr /terf name
     0.170872277  
     terf mul -0.82215223 add
     terf mul 1.48851587 add 
     terf mul -1.13520398 add
     terf mul 0.27886807 add
     terf mul -0.18628806 add
     terf mul 0.09678418 add
     terf mul 0.37409196 add
     terf mul 1.00002368 add
     terf mul -1.26551223 add
     xerf 2 pwr sub exp terf mul neg 1.0 add
     xerf 0.0 lt ~neg if
    } bind def
  /pol { -1 pwr dup /t_1 name 2 pwr /t_2 name
         7.0 t_2 mul 5.0 sub t_2 mul 3.0 add t_2 mul
         1.0 sub t_2 mul 1.0 add t_1 mul
       } bind def

end def

|------------------ compute variance of truncated Gaussian given current 
|                   mu and sigma

/vartgau { 
  MUdict begin
  mu neg sigma div dup /al name dup phi /phial name Phi neg
  1.0 mu sub sigma div dup /bt name dup phi /phibt name Phi add
  -1 pwr /Z_1 name
  1.0 al phial mul bt phibt mul sub Z_1 mul add
  phial phibt sub Z_1 mul 2 pwr sub
  sigma 2 pwr mul
  end
} bind def

|-------------------- compute variance of exponential/empirical primitive
|  requires that model be established

/varexp {
  SIMdict /expy get
  L1tools begin y copy 1.0 64 div sub 2 pwr 0.0 exch add end 63 div
} bind def
        
|----------------------- manage simulation models ----------------------- 

|----------------------------- set up a simulation model from scratch
| -- | --
|
| uses: Nblocks, expects lambda, sigma, and mu in FCU;
| saves: `sim.box' in db directory

/mksim_exp {
   /sim_layer layer
   { SIMdict begin
       mk_ws
       mk_exp
       mk_gauss
       mk_ref
       50 dict dup begin
           [ /Nblocks /lambda /mu /sigma /expy /gauy /codref ]
             { dup find def } forall
           /emptype false def
         end
           
       DBdir (sim.box) writeboxfile
   } stopped end
   /sim_layer _layer
   not { ( sim saved\n) toconsole } if
} bind def

|----------------------------- set up a simulation model from scratch
| -- | --
|
| uses: Nblocks, expects lambda, sigma, and mu in FCU;
| saves: `simemp.box' in db directory

/mksim_emp {
   /sim_layer layer
   { SIMdict begin
       mk_ws
       mk_emp
       mk_gauss
       mk_ref
       50 dict dup begin
         [ /Nblocks /lambda /mu /sigma /expy /gauy /codref ]
           { dup find def } forall
         /emptype true def
         end
       DBdir (simemp.box) writeboxfile
   } stopped end
   /sim_layer _layer
   not { ( sim saved\n) toconsole } if
 } bind def

        

|-- load a simulation model (retrieves model params for Gaussian as well) 
|
| (simbox) | -- 
|
| - loads `sim.box' from DBdir

/loadsim { /simbox name
  /sim_layer layer
  { DBdir simbox readboxfile /boxdict name
    SIMdict begin mk_ws
      boxdict begin lambda mu sigma emptype end
      FCU begin /emptype name /sigma name /mu name /lambda name end
      boxdict /Nblocks get /Nblocks name
      boxdict /expy get expy copy pop
      boxdict /gauy get gauy copy pop
      boxdict /codref get codref copy pop
  } stopped end
  /sim_layer _layer
  not { ( sim loaded\n) toconsole } if
} bind def
        

|------------------------------ do_fits --------------------------------
|
| - use L1tools to load and select genomes to be included in fit
| - expects the fixed sigma and mu of the Gaussian to be defined as above
| - fit alpha for each genome entry
| - create a report db including for each fitted genome a dictionary
|   containing a copy of the genome's entry dictionary plus the results
|   of the fit:
|     pmodel - list: alpha, sigma, mu
|     ey     - array: ranged experimental codon frequencies
|     fity   - array: ranged fitted frequencies
|     fitres - array: residuals of the fit
|     fitrms - scalar: rms of the fit
|     fitEDy - scalar: bias predicted from fit
| - the report is saved in a boxfile named by string `boxname'.

/runthrough true def  | true: marks `failed fit', moves on; else: halts

| use: sel_entries (boxname) | -- 

/do_fits { /boxname name /fitentries name
  /fit_layer layer
  { [ /ey /fitres /fity ]
      { Ncodons /d array def } forall
    /pmodel 3 /d array def

    [ |-- start report db
 |-- species loop
    fitentries { /entry name
        20 dict /repentry name
        entry { repentry 3 -1 roll put } forall
        entry /y get L1tools begin y copy pop rank_y y end ey copy pop
        count /ostack name countdictstack /dstack name
        { fitEG } stopped
           { countdictstack dstack sub ~end repeat | drop dictstack 
             count ostack sub ~pop repeat          | drop opd stack 
             false repentry /fitconv put
             (B) runthrough not ~halt if  | for inspection of the misfit
           }
           { repentry begin
             ey transcribe /ey name         | ranked experimental frequencies
             fity transcribe /fity name     | ranked fitted frequencies
             fitres transcribe /fitres name | residuals of fit
             fitrms /fitrms name            | rms of residual
             fitEDy /fitEDy name            | fitted bias     
             end
             (y)
           }
           ifelse
        toconsole | ticker
        repentry 
      } forall
|-- close report list and write
    ] /report name
    report DBdir boxname writeboxfile
  } stopped
  /fit_layer _layer
  not { [ (\n) boxname ( done\n) concat toconsole } if
} bind def


|---------------------------------fit exponential/empirical * Gaussian model
|
| The transformed parameter used by the amoeba, u, restricts alpha:
| alpha = 1/(1+exp(-2u))      range: 0 <= alpha <= 1 

/fitEG {
  SIMdict /functions get 0 get /function name | for extensions..
  SIMdict begin
    AMOEBA begin 
      | u(alpha)
      1 setup
      0.0 p 0 get 0 put 0.1 p 1 get 0 put  
      0 1 1 { /i name
          p i get /function find enddict y i put
        } for      
      /TOL 3e-6 def
      /Maxfunctions 500 def

      amoeba
      dup repentry /fitconv put not { p 0 get } if
      function pop 
    end
    alpha pmodel 0 put
    sigma pmodel 1 put 
    mu pmodel 2 put
  end
  AMOEBA /y get 0 get Ncodons div sqrt /fitrms name
  0.0 fity fitres copy 1.0 64 div sub 2 pwr add sqrt /fitEDy name     
  pmodel transcribe repentry /pmodel put
  fity fitres copy ey sub pop
} bind def


|================================= Model ==================================

/SIMdict 200 dict dup begin 

/Nblocks 100 def   | of Nblock events for building distributions
/Nblock 1e4 def    | batch of random numbers generated by ran1
/Nconvol 100 def   | number of convolutions averaged into mean convolution

|----------------------- make simulation workspace

/mk_ws {
  /y Nblock /d array def
  /P  Nblock /s array def
        [ /expy /gauy /ny /codref /cvy /hy /scvy ] { 64 /d array def } forall
  P true ran1 pop | reset random number generator for pseudo-random operation
} bind def

|----------------------- make simple distributions ----------------------------
| divide cumulative 0 <= P <= 1 space into 64 bins
| make random number in range 0,1 and map to P bin
| compute y for P and add to y running average of P bin
| compute average y in all 64 P-indexed bins

|--------------------------- make exponentially** distributed frequencies
| ** the truncation effect of the exponential is beyond machine accuracy, so
|    we ignore truncation
| needs lambda in FCU

/mk_exp {
  0.0 expy copy pop  | running freq sum in freq bins
  0 ny copy pop      | running counts in freq bins
  Nblocks {
    P false ran1 y copy neg 1.0 add ln lambda neg div pop | P->y  **
    P 64 mul pop
    0 1 Nblock 1 sub { /kr name
        P kr get /ky name
        y kr get  expy ky get add expy ky put
        ny ky get 1 add ny ky put
      } for
  } repeat
  0 1 63 { /ky name
      expy ky get ny ky get div expy ky put   | beware of nulls
    } for
} bind def

|--------------------------- make empirical version of second component
| -- uses 'sel1' to gather CUTG entries
| -- uses 'binreport' to compute bin-average frequency/rank plots
| -- adopts the average of the last bin as second primitive

/mk_emp {
  sel1
  FCU begin /report name binreport binned /ys get 11 get end
  expy copy FCU begin flip end
} bind def
        
|--------------------------- make truncated-Gaussian distributed frequencies
| needs both mu and sigma defined in FCU by 'setsigma' or 'setmu'

/mk_gauss {
  0.0 gauy copy pop  | running freq sum in freq bins
  0 ny copy pop      | running counts in freq bins
  Nblocks {
    P false ran1 pop | make inverse, y(P) of Gaussian
    0 1 Nblock 1 sub { /ky name
        P ky get Ydict begin compY end y ky put
      } for
    P 64 mul pop
    0 1 Nblock 1 sub { /kr name
        P kr get /ky name
        y kr get  gauy ky get add gauy ky put
        ny ky get 1 add ny ky put
      } for
  } repeat
  0 1 63 { /ky name
      gauy ky get ny ky get div gauy ky put   | beware of nulls
    } for
} bind def

|---------------------------- make random codon references between the sets

/mk_ref {
codref 0 64 0 1 ramp pop pop
P false ran1 64 mul pop
0 2 P length 2 sub { /kr name
    codref P kr get get codref P kr 1 add get get
    codref P kr get put codref P kr 1 add get put
  } for
} bind def

|----------------------------- `convolute' by mixing distributions and
|                               rank the resulting frequencies
| -- | --

/convol { 
  /beta 1.0 alpha sub def
  gauy cvy copy alpha mul pop
  expy hy copy beta mul pop
  0 1 63 { /ky name | convolve it
      cvy ky get hy codref ky get get add cvy ky put
    } for
  0 1 62 { /ky name  | rank it
      ky 1 63 { /kky name
        cvy kky get cvy ky get 2 copy gt
        { cvy kky put cvy ky put } { pop pop } ifelse
      } for
    } for
} bind def

|---------------------------- make n scrambles/convolutions/rankings and
|                             average ranked frequencies (in scvy)
| -- | y

/nconvol {
        mk_ref convol cvy scvy copy
        Nconvol 1 sub { mk_ref convol cvy add  } repeat
        Nconvol div
} bind def

|---------------------------- `functions' for amoeba fit
| Note: the simulation approach computes y(rank) directly, so that
|       we minimize the vertical (y) residual

/functions [
|-- fitmode 2 (because of history)
 { SIMdict begin
        /pF name  | < u(alpha) >
        pF 0 get -2 mul exp 1 add -1 pwr FCU /alpha put
        nconvol dup fity copy pop
        0.0 exch ey sub 2 pwr add 
   end
 } bind
] def

end def

|----------- computation of y(P) for the truncated Gaussian given
|            mu and sigma (that is, the inverse of the truncated Gaussian
|            cumulative distribution function (cumbersome)
|

/Ydict 100 dict dup begin  | note the private space

  /brenttolerance 1e-6 def
  /guessfactor 0.1 def

| use: P | y 

  /compY { /myP name
    1.0 mu sub sigma div Phi
    mu sigma div neg Phi dup /base name sub -1 pwr /norm name
    1.0 64 div 0.0 0.2 30 
    BRENT mkread begin guessbracbrent end
    not { (1) toconsole stop } if  | brent non-convergence
  } bind def

  |----------- compute function whose zero is found by brent:
  |  function = mean of truncated normal distribution minus 1/Ncodons
  |  parameter: sigma   (of normal distribution), Ncodons
  |  use: mu_of_normal | residue  (= mean_of_truncated - 1/Ncodons)

  /brenteval {
      mu sub sigma div Phi base sub norm mul myP sub
  } bind def

  /Phi { 2.0 sqrt div Erf 1.0 add 2.0 div } bind def
  /Erf { /xerf name
     xerf abs 0.5 mul 1.0 add -1 pwr /terf name
     0.170872277  
     terf mul -0.82215223 add
     terf mul 1.48851587 add 
     terf mul -1.13520398 add
     terf mul 0.27886807 add
     terf mul -0.18628806 add
     terf mul 0.09678418 add
     terf mul 0.37409196 add
     terf mul 1.00002368 add
     terf mul -1.26551223 add
     xerf 2 pwr sub exp terf mul neg 1.0 add
     xerf 0.0 lt ~neg if
    } bind def
end def


|================================= curve makers ==============================

|------------------------------- write text file of simulation results
| - computes average convolutions of Nconvol scrambles
| - for a list of alpha settings
|
| use: (filename) | --
|
/alphas <d 0 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 1 > def
/Nconvol 100 def

/wF_sim { /filename name
  /wF_layer layer 
  {
  txtbuf 0
  10 (Nblocks) text 12 SIMdict /Nblocks get * number (\n) fax
  10 (Lambda) text 12 lambda -2 number (\n) fax
  10 (Mu) text 12 mu -8 number (\n) fax
  10 (Sigma) text 12 sigma -8 number (\n\n) fax
  10 (Alpha\n) text
  0 1 alphas length 1 sub { /ky name
      10 alphas ky get -6 number (\n) fax
    } for
  (\nRank, Y...\n) fax
  [ 0 1 alphas length 1 sub { /kal name
        alphas kal get /alpha name
        Nconvol SIMdict begin nconvol end transcribe 
      } for
  ] /cvlist name
  0 1 63 { /ky name
      10 ky 1 add -1 number 
      cvlist { ky get 12 exch -8 number } forall
      (\n) fax
    } for
  0 exch getinterval wFdir [ filename (.txt) concat 
    dup 4 1 roll writefile
  } stopped
  /wF_layer _layer
  not { [ filename ( written\n) concat toconsole } if
} bind def

|------------------------------ make text file of analytical model p's 
| -- | --         (text file `ps_gauexp' in wFdir
|
| Tabulates probability densities `normal*exponential' model for varied alpha
| and a ramp of y values. The `y' ramp is controlled by:

/fy 0.0 def
/ly 0.065 def
/Ny 101 def

/wF_ps {
   /wF_layer layer 
   {
     [ /y ] { Ny /d array def } forall
     /ps [ alphas length { Ny /d array } repeat ] def
     y 0 Ny fy ly fy sub Ny 1 sub div ramp pop pop
     modeldict begin Ny mk_ws end
     0 1 alphas length 1 sub { /kal name
         /alpha alphas kal get def
         y modeldict begin ws_y copy ev_p end ps kal get copy pop
       } for
     |-- write text file
     txtbuf 0
     modeldict begin
     10 (Mu) text 10 (Sigma) text 10 (Lambda) text (\n) fax
     10 mu -5 number 10 sigma -5 number 10 lambda -5 number (\n) fax
     end
     10 (Alpha) text
     0 1 alphas length 1 sub { /kal name
         10 alphas kal get -5 number
       } for
     (\n\nY, p,...\n) fax
     0 1 Ny 1 sub { /ky name
         10 y ky get -5 number
         0 1 alphas length 1 sub { /kal name
             10 ps kal get ky get -5 number
           } for
         (\n) fax
       } for
     0 exch getinterval wFdir [ (ps_gauexp.txt) concat writefile
   } stopped
   /wF_ps_layer _layer
     not { (\nps_gauexp done\n) toconsole } if 
} bind def 

|----------------------------- make text file of analytical P's
/wF_Ps {
   /wF_Ps_layer layer 
   {
     [ /y ] { Ny /d array def } forall
     /ps [ alphas length { Ny /d array } repeat ] def
     y 0 Ny fy ly fy sub Ny 1 sub div ramp pop pop
     modeldict begin Ny mk_ws end
     0 1 alphas length 1 sub { /kal name
         /alpha alphas kal get def
         y modeldict begin ws_y copy ev_P end ps kal get copy pop
       } for
     |-- write text file
     txtbuf 0
     10 (Mu) text 10 (Sigma) text 10 (Lambda) text (\n) fax
     modeldict begin
     10 mu -5 number 10 sigma -5 number 10 lambda -5 number (\n) fax
     end
     10 (Alpha) text
     0 1 alphas length 1 sub { /kal name
         10 alphas kal get -5 number
       } for
     (\n\nY, P,...\n) fax
     0 1 Ny 1 sub { /ky name
         10 y ky get -5 number
         0 1 alphas length 1 sub { /kal name
             10 ps kal get ky get -5 number
           } for
         (\n) fax
       } for
     0 exch getinterval wFdir [ (Ps_gauexp.txt) concat writefile
   } stopped
   /wF_layer _layer
     not { (\nPs_gauexp done\n) toconsole } if 
} bind def 

|=========================== report evaluation ==============================

|------------------- load report
|  (report.box) | --  (report)
|
/loadrep { /boxname name
  /rep_layer layer
  { DBdir boxname readboxfile /report name
  } stopped
  /rep_layer _layer
  not { [ boxname ( loaded\n) concat toconsole } if
} bind def

|------------------- dig up species by name        
| (search_for) | --   (->console)
        
/dig { /speciesname name
  /idx 0 def       
  report { /entry name
      entry /speciesname get speciesname search
        { pop pop pop idx _ pop } 
        { pop }
        ifelse
      /idx idx 1 add def
    } forall
} bind def
          
|------------------- list fits

/fits_ {
  txtbuf 0 (\n) fax
  -30 (Species) text
  10 (EDy) text
  10 (fitEDy) text
  10 (fitconv) text
  10 (fitrms) text
  10 (alpha) text
  (\n\n) fax
  report { begin
      -30 speciesname text
      10 EDy 2 number
      10 fitEDy 2 number
      10 fitconv {(yes)} {(no)} ifelse text
      10 fitrms 2 number
      10 pmodel 0 get 3 number
      (\n) fax
      end
    } forall
  0 exch getinterval toconsole
} bind def

|------------------- binning of report for paper1_v3 figures
| (report) -- | --   (binned, binentries)
|
| binned      - dictionary reporting binwise analysis results
| binentries  - fake entries to submit bin-averaged frequencies to do_fits
|
| This can also be applied to data entries (before do_fits).
      

/binreport {
  /binned 20 dict def    
  L1tools begin
    /biny1 5e-2 def
    /biny2 17e-2 def
    /nbins 12 def
    report sortaEDy dup binEDy binned /hy put binned /hx put
      group binned /grouped put pop
    report /bct S_one_kd thin sortaEDy binEDy binned /hybct put pop pop
    report /arc S_one_kd thin sortaEDy binEDy binned /hyarc put pop pop
    report [ /pln /inv /vrt /mam /rod /pri ] S_list_kd thin
      sortaEDy binEDy binned /hyeuk put pop pop
    64 /d array 0 64 0.5 1.0 ramp pop binned /x put  | for gpg
    65 /d array 0 65 0.0 1.0 ramp pop binned /xx put | for hgm    
    1.0 64 div 64 /d array copy binned /ybar put
    [ binned /grouped get { avgys } forall ] binned /ys put
    [ binned /grouped get { { } forall } forall ] binned /flatgrouped put
  end
  [ 
  /kbin 0 def
  binned /ys get {
        3 dict dup begin
          /speciesid kbin def
          exch /y name
          dup /y get transcribe 0.0 exch 1.0 64.0 div sub 2 pwr add sqrt
            /EDy name  | mean ED with respect to < 1/64 ..>
        end
      /kbin kbin 1 add def   
    } forall
  ] /binentries name
} bind def


end _module
