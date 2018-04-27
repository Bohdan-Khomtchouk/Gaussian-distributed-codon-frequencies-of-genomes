|========================== figs for p1 (paper1_v3) ===========================

|***************************** set in userdict ********************************
|    /prpath (/mnt/Cheetah/mother/pr/) def
| OR
|    /prpath (/home/wn/pr/) def
|
|******************************************************************************

userdict /FCU known not {
    [ prpath (cu/p1/dcode/) concat (fit.d) fromfiles
  } if

userdict /COMPOSE known not {
    [ prpath (dcode/) concat (compose_wn_3.d) fromfiles
  } if

|=============================================================================

/MKFIG module
200 dict dup begin

/Pi 3.141592653589793 def

|----------------------------- string concatenation
| [ (s1) (s2) ... | (s1+s2+...)

/concat {
  ] 
  0 1 index { length add } forall /b array 0 3 -1 roll
  ~fax forall pop
} bind def

/pick { /speciesid name
  false exch { /entry name
      entry /speciesid get speciesid eq { pop true exit } if
    } forall
  { entry } { null } ifelse
} bind def

|----------------------------- whereabouts ----------------------------------

/DBdir [ prpath (cu/p1/db/) concat def
/PDFdir [ bkpath (cu/p1/figs/) concat def


|----------------------------- select model to use --------------------------

/do_exp {
   /allbox (all.box) def                
   /avgbox (avg.box) def
   /fig3f  (fig3.pdf) def
   /fig4f  (fig4.pdf) def
   /fig5f  (fig5.pdf) def
} bind def
        
/do_emp {
   /allbox (allemp.box) def                
   /avgbox (avgemp.box) def
   /fig3f  (fig3emp.pdf) def
   /fig4f  (fig4emp.pdf) def
   /fig5f  (fig5emp.pdf) def
} bind def
        
|--------------------- PostScript graph mode setters ------------------------
  /dgray {
    0.6 0.6 0.6 ~setrgbcolor
  } def
  
  /lgray {
    0.8 0.8 0.8 ~setrgbcolor
  } def

  /black {
    0 0 0 ~setrgbcolor
  } def

  /yellow {
    0.9 0.9 0.2 ~setrgbcolor
  } def

  /green {
    0.2 0.9 0.2 ~setrgbcolor
  } def

  /red {
    0.9 0.2 0.2 ~setrgbcolor
  } def
  
  /blue {
    0.4 0.4 0.9 ~setrgbcolor
  } def

  /purple {
     0.34828     0.023   1.74706 ~setrgbcolor
  } def

  /orange {
     0.06327      0.71 0.07824999 ~setrgbcolor
  } def

  /dashed {
    figslinedash ~setlinewidth
    [3 3] 0 ~setdash
  } def

  /dotted {
    figslinedot ~setlinewidth
    [1 1] 0 ~setdash
  } def

  /longdashed {
    figslinedash ~setlinewidth
    [5 1] 0 ~setdash
  } def

  /shortdashed {
    figslinedash ~setlinewidth
    [2 2] 0 ~setdash
  } def

  /figslinedash 1.0 def
        /figslinedot 1.0 def

|============================ make pdf of fig1 ===============================
|
/species1_fig1 9606 def    | Homo sapiens
/species2_fig1 3702 def    | Arabidopsis thaliana
/species3_fig1 1911 def    | Streptomyces griseus
/species4_fig1 212717 def  | Clostridium tetani E88


/fig1 {
  /fig_layer layer
  { L1tools begin load end
    PDFdir (fig1.pdf) 
    ~[ [ [ mkpan1A_fig1
           (\large \textbf{A}) { alignLB -43 100 translate } ~latex ]
           mkpan1B_fig1
           (\large \textbf{B}) { alignLB -43 100 translate } ~latex ]
         ]
         [ mkpan2A_fig1
           (\large \textbf{C}) { alignLB -43 100 translate } ~latex ]
           mkpan2B_fig1
           (\large \textbf{D}) { alignLB -43 100 translate } ~latex ]
         ]
       ] 9 { alignLT } ~panelarray
     ] dup /PLOT name COMPOSE begin  /oldsymbolsize symbolsize def
                      /symbolsize 4 def /verboxe false def
                      PDFfigure
                      /symbolsize oldsymbolsize def
               end
  } stopped /fig_layer _layer
    not { (Fig1 done\n) toconsole } if
 } bind def 

/mkpan1A_fig1 {
    L1tools begin
      entries 0 species1_fig1 pick /entry1 name
      entries 0 species2_fig1 pick /entry2 name
      entry1 /y get y copy pop entry2 /y get ty copy pop rank_y_ty
      ty transcribe /tty name | back row
    0 1 63 { /k name
        y k get ty k get gt { 0 tty k put } { 0 ty k put } ifelse
      } for
    tty ty y
    end
    /pan 5 dict def
      transcribe pan /hy put
      transcribe pan /byf put
      transcribe pan /byb put
      65 /d array 0 65 0.0 1.0 ramp pop pan /hx put 
    L1tools begin
      entry2 /y get y copy rank_y transcribe 
    end pan /by put
    ~[ pan
       [ /hx [ /byb { [ 0.1 0.1 1 ~setrgbcolor ] ps hFill } ]
             [ /hy { [ 1 0.1 0.1 ~setrgbcolor ] ps hFill } ] 
             [ /byf { [ 0.1 0.1 1 ~setrgbcolor ] ps hFill } ]
             [ /by { [ 1 ~setlinewidth 0 ~setgray ] ps hLine } ]
       ]
       [ true * * /lin () (Rank) ] | abs
       [ false 0.0 0.08 /lin1 0.02 1.0 () (Frequency, $y$) 2 ] | ord
       144 100 { }
       ~hgm
} def

/mkpan1B_fig1 {
    L1tools begin
      entries 0 species3_fig1 pick /entry1 name
      entries 0 species4_fig1 pick /entry2 name
      entry1 /y get y copy pop entry2 /y get ty copy pop rank_y_ty
      ty transcribe /tty name | back row
    0 1 63 { /k name
        y k get ty k get gt { 0 tty k put } { 0 ty k put } ifelse
      } for
    tty ty y
    end
    /pan 5 dict def
      transcribe pan /hy put
      transcribe pan /byf put
      transcribe pan /byb put
      65 /d array 0 65 0.0 1.0 ramp pop pan /hx put
    L1tools begin
      entry2 /y get y copy rank_y transcribe 
    end pan /by put
    ~[ pan
       [ /hx [ /byb { [ 0.1 0.1 1 ~setrgbcolor ] ps hFill } ]
             [ /hy { [ 1 0.1 0.1 ~setrgbcolor ] ps hFill } ] 
             [ /byf { [ 0.1 0.1 1 ~setrgbcolor ] ps hFill } ]
             [ /by { [ 1 ~setlinewidth 0 ~setgray ] ps hLine } ]
       ]
       [ true * * /lin () (Rank) ] | abs
       [ false 0.0 0.08 /lin1 0.02 1.0 () (Frequency, $y$) 2 ] | ord
       144 100 { }
       ~hgm
} def

/mkpan2A_fig1 {
    /pan 5 dict def
    DBdir FCU begin /DBdir name allbox loadrep binreport binned end /binned name
    binned /hx get pan /hx put
    binned /hy get pan /hy put
    binned /hybct get pan /hybct put
    binned /hyarc get 5 mul pan /hyarc put
    binned /hyeuk get pan /hyeuk put
    ~[ pan
       [ /hx [ /hy { [ lgray ] ps hFill } ]
             [ /hybct { [ 0.5 ~setlinewidth ] ps hLine } ]
             [ /hyarc { [ 0.5 ~setlinewidth 1 0 0 ~setrgbcolor ] ps hLine } ]
             [ /hyeuk { [ 0.5 ~setlinewidth 0 0 1 ~setrgbcolor ] ps hLine } ]
       ]
       [ true * * /lin1 0.02 1.0 ()
         (Bias, $B$) 2 ] | abs
       [ true * * /lin () (Genomes/bin)  ] | ord
       144 100 { }
       ~hgm
       ~[ drawasterisks ] <d 0 0 144 100 > { } ~PS
} def

/mkpan2B_fig1 {
    /pan 3 dict def
    64 /d array 0 64 0.5 1.0 ramp pop /x name
    x pan /x put
    1.0 64 div 64 /d array copy pan /ybar put
    binned /ys get pan /ys put
    ~[ pan
       [ [ /x /ybar
           { [ 0.5 ~setlinewidth [ 2 2 ] 0 ~setdash ] ps Line }
         ]
         [ /x /ys
           { [ 0.5 ~setlinewidth stepcolor ] ps Line } 
         ]
       ]
       [ true * * /lin () (Rank) ]
       [ false 0.0 0.1 /lin1 0.02 1.0 () (Frequency, $y$) 2 ]
       144 100 { }
       ~gpgraf
} def

|-- draw asterisks marking fig1 species positions

/drawasterisks {
  ~gsave ~newpath 0 ~setgray
  0.065 0.04 ~sub 0.14 ~div 144 ~mul 
    320 400 ~div 100 ~mul ~moveto (K) ~show
  0.145 0.04 ~sub 0.14 ~div 144 ~mul 
    160 400 ~div 100 ~mul ~moveto (K) ~show
  ~grestore
} bind def


|============================== make pdf of fig2 =============================
| - expects a model and defined alpha to exist in FCU
| - items to be plotted in panels include:
|   gauy    - flipped Gaussian primitive (decreasing order)
|   expy    - flipped exponential/empirical primitive
|   sgauy   - gauy scaled by alpha
|   sexpy   - expy scaled by (1-alpha) 
|   codref  - flipped cross reference array
|   cvy_us  - unranked summed scaled ys
|   cvy     - reranked summed scaled ys
|   codref2 - reference for colors in cvy        
|   y2      - list of individual Nconvol ranked 'convolutions'
|   rms     - rms of ranked convolutions, array
|   ymean   - mean of Nconvol ranked convolutions
|   x       - abscissa array, histogram format
|   RMS     - rms of ranked convolutions, scalar

        
/fig2 {
  /fig_layer layer
  { /pan 100 dict def
  FCU begin /alpha 0.5 def SIMdict begin
    gauy 64 /d array copy dup flip pan /gauy put
    expy 64 /d array copy dup flip pan /expy put
    gauy 64 /d array copy alpha mul dup flip pan /sgauy put
    expy 64 /d array copy 1.0 alpha sub mul dup flip pan /sexpy put
    mk_ref codref 64 /d array copy dup flip pan /codref put
    0 1 63 { /k name  | yeah
        pan /codref get dup k get 63 exch sub exch k put
      } for
    gauy cvy copy alpha mul pop  expy hy copy 1.0 alpha sub mul pop
    0 1 63 { /ky name
        cvy ky get hy codref ky get get add cvy ky put
      } for
    cvy 64 /d array copy dup flip pan /cvy_us put
    |-- make reference for color in sorted convolution
    64 /d array 0 64 0 1 ramp pop /codref2 name
    0 1 62 { /ky name 
        ky 1 63 { /kky name
            cvy kky get cvy ky get 2 copy gt
              { cvy kky put cvy ky put
                codref2 kky get codref2 ky get
                codref2 kky put codref2 ky put
              } { pop pop } ifelse
          } for
      } for
    codref2 pan /codref2 put
    0 1 63 { /k name  | yeah
        pan /codref2 get dup k get 63 exch sub exch k put
      } for
    cvy 64 /d array copy pan /cvy_s put
          
    [ /ymean /y2 /rms ] { 64 /d array def } forall
    /ys [ Nconvol { 64 /d array } repeat ] def
    65 /d array 0 65 0.0 1.0 ramp pop pan /x put | for histo!
    0 rms copy ymean copy
    0 1 Nconvol 1 sub { /kys name
        SIMdict begin mk_ref convol cvy end ys kys get copy add
      } for
    Nconvol div pop | ymean
    rms ys { y2 copy ymean sub 2 pwr add } forall
      Nconvol 1 sub div sqrt pop | rms
    0.0 rms add 63 div /RMS name
    [ /ymean /rms /ys /RMS ] { dup find pan 3 -1 roll put } forall
  end end

  pan begin 
    [ 3 34 63 88 50 ] { ys exch get } forall
      [ /y1 /y2 /y3 /y4 /y5 ] ~name forall
    [ 3 34 63 88 50 ] { ys exch get 64 /d array copy ymean sub } forall
      [ /r1 /r2 /r3 /r4 /r5 ] ~name forall
    /bl 0.0 64 /d array copy def
  [ /rainbow /scrambled /scrambled2 ] { 64 /d array def } forall
  rainbow 0 64 0.0 1.0 63 div ramp pop pop
  0 1 63 { /k name
      rainbow k get scrambled codref k get put
      rainbow codref2 k get get scrambled2 k put
    } for
  end

  PDFdir FCU /emptype get {(fig2emp.pdf)}{(fig2.pdf)} ifelse
    { [ [         
          | panel A -- gaussian distr, full and scaled
          { pan
            [ /x [ /sgauy { hFillx } /rainbow ]
                 [ /gauy { hLine } ]
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false 0.0 0.04 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            (\large \textbf{A}) { alignLB -43 100 translate } latex 
          }
          | panel B -- exponential distr, full and scaled
          { pan
            [ /x [ /sexpy  { hFillx } /scrambled ]
                 [ /expy { hLine } ] 
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false 0.0 0.1 /lin1 0.02 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            (\large \textbf{B}) { alignLB -43 100 translate } latex 
          }
        ]
        [
          | panel C -- convoluted, unsorted and sorted
          { pan
            [ /x [ /cvy_us  { hFillx } /rainbow ]
                 [ /sgauy { [ dgray ] ps hLine } ]
|                 [ /cvy_s { hLine } ] 
                 
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false 0.0 0.06 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            (\large \textbf{C}) { alignLB -43 100 translate } latex 
          }
          | panel D -- convoluted, sorted & colored
          { pan
            [ /x [ /cvy_s  { hFillx } /scrambled2 ]
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false 0.0 0.06 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            (\large \textbf{D}) { alignLB -43 100 translate } latex 
          }
        ]
        [
          | panel E -- single and mean convolutions
          { pan
            [ /x [ /ymean { hLine } ]
                 [ /y1 { [ green 0.35 ~setlinewidth ] ps hLine } ]
                 [ /y2 { [ red 0.35 ~setlinewidth ] ps hLine } ]
                 [ /y3 { [ blue 0.35 ~setlinewidth ] ps hLine } ]
 |                [ /y4 { [ purple ] ps hLine } ]
 |                [ /y5 { [ orange ] ps hLine } ]
                 [ /bl { [ 0.5 ~setgray 0.35 ~setlinewidth ] ps hLine } ] 
                 [ /r1 { [ green 0.35 ~setlinewidth ] ps hLine } ]
                 [ /r2 { [ red 0.35 ~setlinewidth ] ps hLine } ]
                 [ /r3 { [ blue 0.35 ~setlinewidth ] ps hLine } ]
 |                [ /r4 { [ purple ] ps hLine } ]
 |                [ /r5 { [ orange ] ps hLine } ]
             ]
            [ true * * /lin () (Rank) ] | abs
            [ true * * /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            (\large \textbf{E}) { alignLB -43 100 translate } latex 
          }
        ]
      ] 9 ~alignLT panelarray
    } COMPOSE begin  /oldsymbolsize symbolsize def
                     /symbolsize 4 def /verboxe false def
                     PDFfigure
                     /symbolsize oldsymbolsize def
              end
  } stopped
  /fig_layer _layer
  not { (fig2) toconsole ( done\n) toconsole } if
} bind def 


|------------------------ make PDF for fig 3 --------------------------------

/fig3 {
  /fig_layer layer
  { FCU begin avgbox loadrep report end transcribe /avg name
    FCU begin allbox loadrep report end /all name
    65 /d array 0 65 0.0 1.0 ramp pop /xx name   
    all { xx exch /xx put } forall
    avg { xx exch /xx put } forall
          
    all 9606 pick dup begin
        100 /b array 0 (\textit{\small ) fax
        speciesname fax (}) fax 
        0 exch getinterval /species name
        100 /b array 0 ($\(\alpha=) fax
        * pmodel 0 get -2 number
        (\)$) fax 0 exch getinterval /alpha name
      end /panA name 
    all 3702 pick dup begin
        100 /b array 0 (\textit{\small ) fax
        speciesname fax (}) fax 
        0 exch getinterval /species name
        100 /b array 0 ($\(\alpha=) fax
        * pmodel 0 get -2 number
        (\)$) fax 0 exch getinterval /alpha name
      end /panB name
    all 1911 pick dup begin
        100 /b array 0 (\textit{\small ) fax
        speciesname fax (}) fax 
        0 exch getinterval /species name
        100 /b array 0 ($\(\alpha=) fax
        * pmodel 0 get -2 number
        (\)$) fax 0 exch getinterval /alpha name
      end /panD name
    all 212717 pick dup begin
        100 /b array 0 (\textit{\small ) fax
        speciesname fax (}) fax 
        0 exch getinterval /species name
        100 /b array 0 ($\(\alpha=) fax
        * pmodel 0 get -2 number
        (\)$) fax 0 exch getinterval /alpha name
      end /panE name
    avg 1 pick dup begin
        (\textit{\small Mean of bin 2}) /species name
        100 /b array 0 ($\(\alpha=) fax
        * pmodel 0 get -2 number
        (\)$) fax 0 exch getinterval /alpha name
      end /panC name      
    avg 9 pick dup begin
        (\textit{\small Mean of bin 10}) /species name
        100 /b array 0 ($\(\alpha=) fax
        * pmodel 0 get -2 number
        (\)$) fax 0 exch getinterval /alpha name
      end /panF name

    PDFdir fig3f
    { [ [
          | panel A -- Homo sapiens
          { panA
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
                  [ /fitres { [ blue 0.35 ~setlinewidth ] ps hLine } ]
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false -0.01 0.05 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            panA /species get { alignLB 30 82 translate } latex
            panA /alpha get { alignLB 30 70 translate } latex
            
|            (Homo sapiens) { alignLB 30 82 translate } latex
|            ($\alpha=0.6$) { alignLB 30 70 translate } latex 
            (\large \textbf{A}) { alignLB -46 100 translate } latex 
          }
          | panel D -- Streptomyces griseus
          { panD
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
                  [ /fitres { [ blue 0.35 ~setlinewidth ] ps hLine } ]
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false -0.01 0.08 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            panD /species get { alignLB 30 82 translate } latex
            panD /alpha get { alignLB 30 70 translate } latex
|            (Streptomyces griseus) { alignLB 30 82 translate } latex
|            ($\alpha=0.6$) { alignLB 30 70 translate } latex 
            (\large \textbf{D}) { alignLB -46 100 translate } latex 
          }
        ]
        [    
          | panel B -- Arabidopsis thaliana
          { panB
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
                  [ /fitres { [ blue 0.35 ~setlinewidth ] ps hLine } ]
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false -0.01 0.05 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            panB /species get { alignLB 30 82 translate } latex
            panB /alpha get { alignLB 30 70 translate } latex
|            (Arabidopsis thaliana) { alignLB 30 82 translate } latex
|           ($\alpha=0.1$) { alignLB 30 70 translate } latex
            (\large \textbf{B}) { alignLB -46 100 translate } latex 
          }
          | panel E -- Clostridium tetani
          { panE
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
                  [ /fitres { [ blue 0.35 ~setlinewidth ] ps hLine } ]
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false -0.01 0.08 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            panE /species get { alignLB 30 82 translate } latex
            panE /alpha get { alignLB 30 70 translate } latex
|            (Clostridium tetani) { alignLB 30 82 translate } latex
|            ($\alpha=0.6$) { alignLB 30 70 translate } latex 
            (\large \textbf{E}) { alignLB -46 100 translate } latex 
          }
        ]
        [
          | panel C -- Bin 2
          { panC
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
                  [ /fitres { [ blue 0.35 ~setlinewidth ] ps hLine } ]
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false -0.01 0.05 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            panC /species get { alignLB 30 82 translate } latex
            panC /alpha get { alignLB 30 70 translate } latex
|            (Average, bin 2) { alignLB 30 82 translate } latex
|           ($\alpha=0.1$) { alignLB 30 70 translate } latex
            (\large \textbf{C}) { alignLB -46 100 translate } latex 
          }
          | panel F -- Bin 10
          { panF
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
                  [ /fitres { [ blue 0.35 ~setlinewidth ] ps hLine } ]
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false -0.01 0.08 /lin1 0.01 * () (Frequency) 2 ] | ord
            144 100 { }
            hgm
            panF /species get { alignLB 30 82 translate } latex
            panF /alpha get { alignLB 30 70 translate } latex
|            (Average, bin 10) { alignLB 30 82 translate } latex
|            ($\alpha=0.6$) { alignLB 30 70 translate } latex 
            (\large \textbf{F}) { alignLB -46 100 translate } latex 
          }
        ]
      ] 9 ~alignLT panelarray
    } COMPOSE begin  /oldsymbolsize symbolsize def
                     /symbolsize 4 def /verboxe false def
                     PDFfigure
                     /symbolsize oldsymbolsize def
              end
  } stopped
  /fig_layer _layer
  not { (fig3) toconsole ( done\n) toconsole } if
} bind def

|----------------------- make PDF for fig4 ---------------------------------
/specieslab_figs4 [
  (Escherichia coli O157)
  (Oryza ativa)
  (Drosophila melanogaster)
  (Saccharomyces cerevisiae)
  (Caenorhabditis elegans)
  (Danio rerio)
  (Pan troglodytes)
  (Mus musculus)
  (Rattus norvegicus)
  (Enterobacter sp. 638)
  (Shigella dysenteriae Sd197)
  (Yersinia pestis antiqua)
] def

/speciesid_figs4 <l
  386585     | 0.08000
  311553     | 0.059
  7227       | 0.07412
  4932       | 0.07898
  6239       | 0.07219
  7955       | 0.06706
  9598       | 0.07093
  10090      | 0.06656
  10116      | 0.07012
  399742     | 0.08785
  300267     | 0.08077 
  360102     | 0.07091
> def        

/pannames [ /p0 /p1 /p2 /p3 /p4 /p5 /p6 /p7 /p8 /p9 /p10 /p11 ] def


/fig4 {
  /fig_layer layer
  { FCU begin allbox loadrep report end /all name
    65 /d array 0 65 0.0 1.0 ramp pop /xx name   
    all { xx exch /xx put } forall
    0 1 11 { /kpan name
        all speciesid_figs4 kpan get pick /pan name
        pan pannames kpan get name
        pan begin
            100 /b array 0 (\textit{\small ) fax
              speciesname fax (}) fax 
              0 exch getinterval /species name
            100 /b array 0 ($\(\alpha=) fax
              * pmodel 0 get -2 number
              (\)$) fax 0 exch getinterval /alpha name
          end 
      } for 

    PDFdir fig4f
    { [ [
          { p0
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin1 0.02 * () (Frequency) 2 ] | ord
            100 72 { }
            hgm
            p0 /species get { alignLB 10 62 translate } latex
            p0 /alpha get { alignLB 10 50 translate } latex 
          }
          { p1
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin ] | ord
            100 72 { }
            hgm
            p1 /species get { alignLB 10 62 translate } latex 
            p1 /alpha get { alignLB 10 50 translate } latex 
          }
          { p2
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin ] | ord
            100 72 { }
            hgm
            p2 /species get { alignLB 10 62 translate } latex
            p2 /alpha get { alignLB 10 50 translate } latex  
          }
        ]
        [
          { p3
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin1 0.02 * () (Frequency) 2 ] | ord
            100 72 { }
            hgm
            p3 /species get { alignLB 10 62 translate } latex 
            p3 /alpha get { alignLB 10 50 translate } latex 
          }
          { p4
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin ] | ord
            100 72 { }
            hgm
            p4 /species get { alignLB 10 62 translate } latex
            p4 /alpha get { alignLB 10 50 translate } latex  
          }
          { p5
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin ] | ord
            100 72 { }
            hgm
            p5 /species get { alignLB 10 62 translate } latex
            p5 /alpha get { alignLB 10 50 translate } latex  
          }
        ]
        [
          { p6
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin1 0.02 * () (Frequency) 2 ] | ord
            100 72 { }
            hgm
            p6 /species get { alignLB 10 62 translate } latex
            p6 /alpha get { alignLB 10 50 translate } latex  
          }
          { p7
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin ] | ord
            100 72 { }
            hgm
            p7 /species get { alignLB 10 62 translate } latex
            p7 /alpha get { alignLB 10 50 translate } latex  
          }
          { p8
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin ] | abs
            [ false 0.0 0.06 /lin ] | ord
            100 72 { }
            hgm
            p8 /species get { alignLB 10 62 translate } latex
            p8 /alpha get { alignLB 10 50 translate } latex  
          }
        ]
        [
          { p9
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false 0.0 0.06 /lin1 0.02 * () (Frequency) 2 ] | ord
            100 72 { }
            hgm
            p9 /species get { alignLB 10 62 translate } latex
            p9 /alpha get { alignLB 10 50 translate } latex  
          }
          { p10
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false 0.0 0.06 /lin ] | ord
            100 72 { }
            hgm
            p10 /species get { alignLB 10 62 translate } latex
            p10 /alpha get { alignLB 10 50 translate } latex  
          }
          { p11
            [ /xx [ /ey  { [ lgray ] ps hFill } ]
                  [ /fity { hLine } ] 
            ]
            [ true * * /lin () (Rank) ] | abs
            [ false 0.0 0.06 /lin ] | ord
            100 72 { }
            hgm
            p11 /species get { alignLB 10 62 translate } latex 
            p11 /alpha get { alignLB 10 50 translate } latex 
          }
        ]

      ] 6 ~alignLT panelarray
    } COMPOSE begin  /oldsymbolsize symbolsize def
                     /symbolsize 4 def /verboxe false def
                     PDFfigure
                     /symbolsize oldsymbolsize def
              end
  } stopped
  /fig_layer _layer
  not { (fig4) toconsole ( done\n) toconsole } if
} bind def

|=========================== make PDF of fig5 ===============================
|
| plots 2 panels for eubacteria and archaea (A), and eukaryotes (B) showing
| the fitted alpha of the genomes as symbols versus the empirical bias of the
| genomes. Also includes as line the theoretical curve relating bias to
| alpha. Eubacteria, archaea, plants, invertebrates, and vertebrates are
| represented by symbols in different colors.       

/fig5 {
  /fig_layer layer
  { FCU begin allbox loadrep binreport binned /flatgrouped get end /all name
    all L1tools begin /bct S_one_kd thin end /bct name
    all L1tools begin /arc S_one_kd thin end /arc name
    all L1tools begin /pln S_one_kd thin end /pln name
    all L1tools begin /inv S_one_kd thin end /inv name
    all L1tools begin [ /vrt /mam /rod /pri ] S_list_kd thin
       end /vrt name
    /pan 20 dict def
    bct mkpts5 pan begin /albct name /Bbct name end
    arc mkpts5 pan begin /alarc name /Barc name end
    pln mkpts5 pan begin /alpln name /Bpln name end
    inv mkpts5 pan begin /alinv name /Binv name end
    vrt mkpts5 pan begin /alvrt name /Bvrt name end

    |-- compute theoretical B(alpha)
    /almod 200 /d array 0 200 0.0 1.0 199.0 div ramp pop def
    /Bmod 200 /d array def      
    FCU begin emptype {(simemp.box)} {(sim.box)} ifelse loadsim end
    0 1 199 { /k name
        almod k get dup 2 pwr FCU begin vartgau end mul exch
        neg 1.0 add 2 pwr FCU begin varexp end mul add
        63 mul sqrt Bmod k put
      } for
    almod pan /almod put
    Bmod pan /Bmod put

    |-- compute model rms versus alpha

    [ /ymean /y2 /rms ] { 64 /d array def } forall
    /al 100 /d array 0 100 0.0 1.0 99 div ramp pop def
    /RMS 100 /d array def
          
    1 1 98 { /kal name
        al kal get FCU begin /alpha name
        0 rms copy ymean copy
        SIMdict /Nconvol get {
            SIMdict begin mk_ref convol cvy end dup
            ymean exch add pop
            2 pwr rms exch add pop
        } repeat
        end
        ymean FCU /SIMdict get /Nconvol get div pop
        rms ymean 2 pwr FCU /SIMdict get /Nconvol get mul sub
        0.0 exch add FCU /SIMdict get /Nconvol get 1 sub div 
        sqrt 8.0 div RMS kal put
      } for
    0.0 RMS 0 put 0.0 RMS 99 put     
    al pan /al put
    RMS pan /RMS put

    |-- extract fit rms and alpha's from report
    FCU /binned get /flatgrouped get /fitentries name
    /nfits fitentries length def 
    /fital nfits /d array def
    /fitRMS nfits /d array def
    0 1 nfits 1 sub { /kfit name
        fitentries kfit get dup
        /pmodel get 0 get fital kfit put
        /fitrms get fitRMS kfit put
      } for
    fital pan /fital put
    fitRMS pan /fitrms put

    PDFdir fig5f 
     { [ [
           { pan
             [ [ /Bbct /albct { [ 0 0 0 ~setrgbcolor ] ps dot Points } ]
               [ /Barc /alarc { [ 1 0 0 ~setrgbcolor ] ps times Points } ]
               [ /Bmod /almod { [ 0 0 0 ~setrgbcolor ] ps Line } ]
             ]
             [ false 0.04001 0.16999 /lin1 0.02 1.0 () ($B$) 2 ] | abs
             [ true 0.0 1.0 /lin1 0.2 1.0  () ($\alpha$) 2 ] | ord
             144 144 { } gpgraf
             (\large \textbf{A}) { alignLB -38 144 translate } latex
           }
           { pan
             [ [ /Bpln /alpln { [ 0 1 0 ~setrgbcolor ] ps dot Points } ]
               [ /Binv /alinv { [ 0 0 1 ~setrgbcolor ] ps times Points } ]
               [ /Bvrt /alvrt { [ 1 0 0 ~setrgbcolor ] ps cross Points } ]    
               [ /Bmod /almod { [ 0 0 0 ~setrgbcolor ] ps Line } ]
             ]
             [ false 0.04001 0.16999 /lin1 0.02 1.0 () ($B$) 2 ] | abs
             [ true 0.0 1.0 /lin1 0.2 1.0  () ($\alpha$) 2 ] | ord
             144 144 { } gpgraf
             (\large \textbf{B}) { alignLB -38 144 translate } latex         
           }
         ]  
         [
           { pan
             [ [ /fital /fitrms { [ 0 0 0 ~setrgbcolor ] ps dot Points } ]
               [ /al /RMS { [ 0 0 0 ~setrgbcolor ] ps Line } ]
             ]
             [ true 0.0 1.0 /lin1 0.2 1.0  () ($\alpha$) 2 ] | abs
             [ true 0.0 0.0 /lin1 * 1e-3 () ($rms \times 10^3$) 2 ] | ord
             144 144 { } gpgraf
             (\large \textbf{C}) { alignLB -38 144 translate } latex
           }
         ]
     ] 9 { alignLT } panelarray
     } dup /PLOT name COMPOSE begin  /oldsymbolsize symbolsize def
                      /symbolsize 4 def /verboxe false def
                      PDFfigure
                      /symbolsize oldsymbolsize def
                      end
    } stopped      
  /fig_layer _layer
  not { (fig5) toconsole ( done\n) toconsole } if
} bind def

|--- make arrays of points from report entry list
| entries | B al

/mkpts5 { /entries name
  /B entries length /d array def
  /al entries length /d array def
  0 1 entries length 1 sub { /k name
      entries k get dup /EDy get B k put
        /pmodel get 0 get al k put
    } for
  B al
} bind def
        
end _module
