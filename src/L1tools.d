|================================ L1tools  ====================================
|              Tools for making and analyzing L1 data bases
|
| A L1 data base is a cooked transcript of (typically all) CUTG databases
|
| - there is only one L1 data base in the DB1 dictionary at a given time
| - the root of the L1 data base is a list of species entries described
|   below

/L1tools module
200 dict dup begin

|----------------------------- string concatenation
| [ (s1) (s2) ... | (s1+s2+...)

/concat {
  ] 
  0 1 index { length add } forall /b array 0 3 -1 roll
  ~fax forall pop
} bind def

|------------------------ organizational tables -------------------------------
/aas 21 dict dup begin
| nonpolar (9)
  /F [ /UUU /UUC ] def
  /L [ /UUA /UUG /CUU /CUC /CUA /CUG ] def
  /I [ /AUU /AUC /AUA ] def
  /M [ /AUG ] def
  /V [ /GUU /GUC /GUA /GUG ] def
  /A [ /GCU /GCC /GCA /GCG ] def
  /P [ /CCU /CCC /CCA /CCG ] def
  /W [ /UGG ] def
  /G [ /GGU /GGC /GGA /GGG ] def
| polar (6)
  /S [ /UCU /UCC /UCA /UCG /AGU /AGC ] def
  /T [ /ACU /ACC /ACA /ACG ] def
  /Y [ /UAU /UAC ] def
  /Q [ /CAA /CAG ] def
  /N [ /AAU /AAC ] def
  /C [ /UGU /UGC ] def
| basic (3)
  /H [ /CAU /CAC ] def
  /K [ /AAA /AAG ] def
  /R [ /CGU /CGC /CGA /CGG /AGA /AGG ] def
| acidic (2)
  /D [ /GAU /GAC ] def
  /E [ /GAA /GAG ] def
| stop
  /STOP [ /UAA /UAG /UGA ] def
end def
/chemNcd <l 29 18 10 4 3 > def  | run lengths (in cd) of chemical flavors
/chemNaa <l 9 6 3 2 1 > def     | run lengths (in aa) of chemical flavors

|-- create references globally used
| All codon frequencies will be stored in the order in which codon
| values appear in `aas'. 

/cvs [ aas { exch pop { } forall } forall ] def  | flat list of codon values
/idxs 64 dict dup begin                          | dictionary of codon indices
  0 cvs { exch dup 1 add 3 1 roll def } forall pop
end def
/gc3s [ cvs { mkact (   ) 0 * 4 -1 roll text pop 2 get
              dup (G) 0 get eq exch (C) 0 get eq or 
            } forall
      ] def                                      | list of GC3 booleans

/gcs 64 /d array def                             | array of GC counts
0 1 63 { dup cvs exch get (   ) 0 * 4 -1 roll text pop dup dup
         0.0
         exch 0 get dup (G) 0 get eq exch (C) 0 get eq or { 1 add } if
         exch 1 get dup (G) 0 get eq exch (C) 0 get eq or { 1 add } if
         exch 2 get dup (G) 0 get eq exch (C) 0 get eq or { 1 add } if
         exch gcs exch put
       } for

|----------------------------- whereabouts -----------------------------------
/CUTGdir { [ prpath (cu/txt/CUTG/) concat } def
/txtdir { [ prpath (cu/txt/) concat } def
                
/dbdir { [ prpath (cu/db/) concat } def
/dcodedir { [ prpath (cu/dcode/) concat } def        

|----------------------------- L1 kingdoms -----------------------------------
/kingdoms [  (vrl) (phg) (bct) (pln) (inv) (vrt) (mam) (rod) (pri) ] def
/dbname (L1.box) def

| We will compile genomic, mitochondrial, and chloroplast entries together
| into one database.

|------------------------------ buffers -------------------------------------
  /y 64 /d array def
  /ty 64 /d array def
  /ycd 64 /d array def
  /yaa 21 /d array def
  /ysc 5 /d array def
  /mes 80 /b array def
  /RN  1e4 /s array def     | random number buffer
  /nRN 0 def                | # of random values left in buffer
  /fwbuf 100 /b array def

|-- get a random value between 0-1 exclusively

/getRN {
 nRN 0 eq { RN false ran1 pop /nRN RN length def } if
 /nRN nRN 1 sub def
 RN nRN get
} bind def

|-------------------------- make L1 database ---------------------------------
/MINCODONS 1e4 def

| NOTE: -- EDy now defined as Euclidean distance, not mean distance
|       -- eliminates one duplicate bct entry of CUTG

/make {
  save /mksave name
  { /txtbuf 50e6 /b array def
    |-- index the codon values of the CUTG dbs to our codon order
    CUTGdir (SPSUM_LABEL.txt) txtbuf readfile
    (\n) search not ~stop if pop pop
    [ exch
      { token not ~exit if mkpass /cv name
        idxs cv get exch
      } loop pop
    ] /CUTGidxs name
    CUTGidxs length 64 ne ~stop if
    |-- define some buffers
    /entry 10 dict def
    |---- kingdoms loop
    [ |-- list of CUTG entry dictionaries
    kingdoms { dup /kingdom name toconsole ( ) toconsole |--> console
        CUTGdir [ (gb) kingdom (.spsum.txt) concat txtbuf readfile /txt name
        kingdom token not { pop stop } if mkpass /kdname name pop
        |---- species loop
        { txt
          |-- parse data base for next entry
          dup length 0 eq ~exit if
          (:) search not ~stop if exch pop
          |-- categorize entry (genomic or etc: mitochondrial, chloroplast..)
            (.) search
              { 3 1 roll pop } { (genomic) } ifelse /etc name
              token not ~stop if mkpass /speciesid name pop
          (:) search not ~stop if exch pop
          /speciesname name
          |-- read the codon counts of the entry
          (\n) search not ~stop if pop pop
          0 1 63 { /kcc name
                   token not ~stop if
                   y CUTGidxs kcc get put
                 } for
          dup length 0 gt { (\n) search { pop pop } if } if
          /txt name
          |-- process the entry if it warrants it
          speciesid class /numclass eq  | that means no `error' flag in CUTG
          dup { speciesid 239242 eq     | duplicate virus entries?
                speciesid 258965 eq or
                speciesid 258969 eq or { pop false } if
              } if
          0.0 y add dup /Ncodons name MINCODONS ge
          and { |-- we are good
                etc mkact etcdict begin exec end /etcidx name 
                y Ncodons div pop  |-> frequency
                0.0 y ty copy 1.0 64.0 div sub 2 pwr add sqrt
                  /EDy name  | mean ED with respect to < 1/64 ..>
                0.0 0 1 63 { /kcd name
                             gc3s kcd get { y kcd get add } if
                           } for /gc3 name
                [ /kingdom /kdname /etc /etcidx /speciesid /speciesname
                  /Ncodons /EDy /y /gc3 ]
                { dup find entry 3 -1 roll put } forall
                entry transcribe |-> entry list
              } if
        } loop pop
      } forall
    ] /entries name
    |-- write data base
    entries dbdir dbname writeboxfile
  } stopped
  entries length
  mksave restore
  exch not { (\nEntries saved in db: ) toconsole _ } if pop
} bind def

/etcdict 20 dict dup begin
  /genomic { 0 } def
  /mitochondrion { 1 } def
  /chloroplast { 2 } def
  /cyanelle { 3 } def
  /plastid { 4 } def
  /nucleomorph { 5 } def
  /secondary { 6 } def    | secondary endosymbiont
  /chromoplast { 7 } def
  /leucoplast { 8 } def
  /x          { 9 } def   | I dunno
  /proplastid { 10 } def
  /apicoplast { 11 } def
  /kinetoplast { 12 } def
end def

|-------------------------- load L1 database ---------------------------------
| loads database `dbname' from directory 'dbdir'. The list of genome
| dictionaries is referenced as `entries'. Usually executed from within
| 'L1tools'; if you execute it from a different current dictionary, you need
| to provide `dbdir' and 'dbname' inside that context.
|

/load {
  { dbdir dbname readboxfile /entries name
  } stopped
  not { (\nNumber of entries loaded: ) toconsole entries length _ pop } 
      { pop pop }
      ifelse
} bind def

|-------------------------- thin L1 database ---------------------------------
| Thins the L1 or a secondary data base retaining only entries that match a
| selection criterion. The selection criterion is set up by one of the
| selectors described below.
|
| entrylist selector | entrylist
|
| For instance, to select entries of the /pri kingdom from the primary data
| base, use:  entries /pri S_one_kd thin /pri_entries name
|  

/thin { /sel name /src name
  [ src { dup sel not ~pop if } forall ]
} bind def

|-------------------------------- (de)selectors -------------------------------
| A selector is generated by using one of the following:

|-- select one kingdom: /kingdom | selector

/S_one_kd { /p1 name
  ~[ /kdname ~get p1 ~eq ] bind
} def

|-- select one etc index: etcidx | selector

/S_one_etc { /p1 name
  ~[ /etcidx ~get p1 ~eq ] bind
} def

|-- deselect one kingdom: /kingdom | selector

/D_one_kd { /p1 name
  ~[ /kdname ~get p1 ~ne ] bind
} def

|-- deselect one etc index: etcidx | selector

/D_one_etc { /p1 name
  ~[ /etcidx ~get p1 ~ne ] bind
} def

|-- select list of kingdoms

/S_list_kd { /p1 name
  ~[ /kdname ~get /p2 ~name
     ~false p1 { p2 eq { pop true } if } ~forall
   ] bind
} def

|-- deselect a list of kingdoms

/D_list_kd { /p1 name
  ~[ /kdname ~get /p2 ~name
     ~true p1 { p2 eq { pop false } if } ~forall
   ] bind
} def

|-- select list of etc's

/S_list_etc { /p1 name
  ~[ /etcidx ~get /p2 ~name
     ~false p1 { p2 eq { pop true } if } ~forall
   ] bind
} def

|-- deselect a list of etc's

/D_list_etc { /p1 name
  ~[ /etcidx ~get /p2 ~name
     ~true p1 { p2 eq { pop false } if } ~forall
   ] bind
} def

|--------------------------------- picker -----------------------------------
|
| picks one specified entry from the L1 data base
| 
| use: entries etcidx speciesid | entry

/pick { /speciesid name /etcidx name
  false exch { /entry name
      entry /etcidx get etcidx eq 
        { entry /speciesid get speciesid eq { pop true exit } if } if
    } forall
  { entry } { null } ifelse
} bind def

|----------------------------- find a species by name -------------------------
|
|  [entries] (string) | [matchedentries]
|
| The string is used as 'search' string in scanning species name through the
| entries.

/matchbyname { /pat name
  [ exch             
  { dup /speciesname get pat search { pop pop pop } { pop pop } ifelse
  } forall
  ]
} bind def

|------------------- tools for editing kingdom associations -------------------


|--------------------- distill species name from CUTG db into a search keyword
|
| CUTG_speciesname | /keyword

/mk_keyword_bct {        
      fwbuf 0 (/) fax
      3 -1 roll
      (lasmid) search
         { pop pop pop (Plasmid) fax }
         { (hytoplasma) search
           { pop pop pop (phytoplasma) fax }
           { (symbiont) search
               { pop pop pop (symbiont) fax }
               { |-- purge generalities
                (Candidatus ) anchorsearch ~pop if
                (St. ) anchorsearch ~pop if
                (:) search { pop pop } if
                ( ) search { 3 1 roll pop pop } if
                /fw name
                |-- purge expletives
                fw { (-) search { pop (_) exch copy pop }
                                { pop exit}
                                ifelse
                   } loop
                fw ([) search { pop (_) exch copy pop } if pop | [ to _
                fw (]) search { pop (_) exch copy pop } if pop | ] to _
                fw (') search { pop (_) exch copy pop } if pop | ' to _
                fw (,) search { pop (_) exch copy pop } if pop | , to _
                fw (') search { pop (_) exch copy pop } if pop | ' to _
                fw ( ) search { pop (_) exch copy pop } if pop | space to _
                fw (.) search { pop (_) exch copy pop } if pop | . to _
                fw (\() search { pop (_) exch copy pop } if pop | ( to _
                fw (\)) search { pop (_) exch copy pop } if pop | ) to _
                fw fax      
               }
              ifelse
           } ifelse
         } ifelse
      0 exch getinterval mkact exec | /keyword
} bind def

/kdfixes 10 dict dup begin
    /bct (kdfix_bct.d) def
 end def
       
/kdkeymakers 10 dict dup begin
    /bct ~mk_keyword_bct def
end def
        

|------------------------ list on console (first name word) /kd for editing
| kingdom associations of species sharing a keyword derived from their species
| names; run only on the set of entries belonging to CUTG_kd
|
| use: entries /CUTG_kd | --  (console output)

/list_kds { /CUTG_db name /myentries name
  save /mysave name
  { 1000 dict /firsts name
    100 /b array /cbuf name
    myentries { /entry name
        entry /speciesname get kdkeymakers /CUTG_db get exec /fn name
        firsts fn known not
          { entry /kdname get firsts fn put
            cbuf 0 (\n\() fax fw fax (\)   /) fax entry /kingdom get fax
            0 exch getinterval toconsole
          } if
      } forall
    (\n) toconsole
  } stopped
  not { (\nEntries ready for editing\n) toconsole
      } if
  clear
  mysave restore
} bind def

| The list presents in each line as string the key word of the species
| name and its original /kingdom specifier. There is one line for each
| different first word in species names. The kingdom names of the edited
| list will be assigned to all species matching that first word. Save
| the edited list (with added [ ... ] brackets in a kdfix_xxx.d file of
| directory 'p1/dcode'. 

|----------------------- load fixes for kingdom associations
|
| use: (patchfile.d) | --  (patches)

/load_kds {
  /patch_layer layer
  { dcodedir exch fromfiles /patchlist name
    patchlist length 2 div dict /patches name
    0 2 patchlist length 1 sub { /k name
        patchlist k 1 add get
        patches
        fwbuf 0 (/) fax patchlist k get fax 0 exch getinterval
        mkact exec put
      } for
  } stopped
  /patch_layer _layer
  not { (\nAssociations loaded: ) toconsole patches used _ pop
      } if
} bind def

|----------------------- apply patches for kingdom associations
|
| use:  entries | -- (patched_entries)
|

/apply_kds { /myentries name
  myentries { /entry name
      entry /speciesname get mk_keyword_bct /fn name
      patches fn known
        { patches fn get entry /kdname put
          fwbuf 0 * patches fn get text 0 exch getinterval
          entry /kingdom get copy pop
        } if
    } forall
} bind def

|--------------------- print speciesnames missed by kd fixes --------------
|     mincodons /CUTG_kd | --   (console output)

/findmissedfixes { /CUTG_kd name
   /oldMINCODONS MINCODONS def /MINCODONS name
   make     
   load entries CUTG_kd S_one_kd thin /kdentries name
   kdfixes CUTG_kd get load_kds     
   kdentries { 
      /speciesname get kdkeymakers CUTG_kd get exec /fn name
      |-- we list all unknown entries (rather than only new ones)
      patches fn known not
        { fwbuf 0 (\() fax * fn text (\)) fax 0 exch getinterval s_ pop } if
   } forall
   /MINCODONS oldMINCODONS def
} bind def

|--------------------------- sorting tools --------------------------------

|------------------------ sort entry list in place by ascending EDy
| entries | sorted_entries
|

/sortaEDy { /sortlist name
  0 1 sortlist length 2 sub { /k1 name
      k1 1 sortlist length 1 sub { /k2 name
          sortlist k1 get sortlist k2 get 2 copy
          /EDy get exch /EDy get lt
            { sortlist k1 put sortlist k2 put }
            { pop pop }
            ifelse
        } for
    } for
  sortlist
} bind def

|----------------------------- binning tools ------------------------------
| To-bin entries need not be sorted. (But if entries are sorted you can use
| the `group' tool to partition entries by bin.)

|----------------------------- bin entries using EDy
|  entries | counts hx hy
|
| NOTA BENE:
| - The returned array of counts holds
|   #entries<y1, #entries/bin(k).., #entries>y2   (0 <= k <= #bins-1)
| - The arrays hx and hy hold the (in-range) bins of a histogram

/biny1 5e-2 def
/biny2 17e-2 def
/nbins 12 def

/binEDy { /set name
  biny2 biny1 sub nbins div /binwidth name
  0 nbins 2 add /d array copy /counts name
  set { /EDy get biny1 sub binwidth div 
        dup 0 lt
          { pop 0 }
          { dup nbins le { 1 add } { pop nbins 1 add } ifelse }
          ifelse
        counts exch 2 copy get 1 add 3 1 roll put
      } forall
  counts 
  nbins 1 add /d array 0 nbins 1 add biny1 binwidth ramp pop
  counts 1 nbins getinterval
} bind def

|------------------------------- group binned entries
| Note: Entries must be sorted using the binning criterion.
| 
| entries counts | [ pre bin ... post ] [ bin ...] 
|
| Each entry of the returned lists is a sublist of 'entries' (thus
| do NOT discard 'entries').

/group { /counts name /set name
  /k 0 def
  [ counts { /n name
        set k n getinterval
        /k k n add def
      } forall
  ]
  dup 1 counts length 2 sub getinterval
} bind def

|-------------------------------- average ranked y array of entries
| entries | yavg

/avgys { /entries name
  0.0 64 /d array copy
  entries {
      /y get y copy
      rank_y add
    } forall
  entries length dup 0 ne ~div ~pop ifelse
} bind def

|--------------------------- ranking tools -----------------------------
| These tools sort y into descending order.

/rank_y { | y only
  0 1 62 { /k1 name
      k1 1 63 { /k2 name
          y k1 get y k2 get 2 copy le 
            { y k1 put y k2 put }
            { pop pop }
            ifelse
        } for
    } for
} bind def

/rank_y_ty { | y and ty following y
  0 1 62 { /k1 name
      k1 1 63 { /k2 name
          y k1 get y k2 get 2 copy le 
            { y k1 put y k2 put
              ty k1 get ty k2 get ty k1 put ty k2 put
            }
            { pop pop }
            ifelse
        } for
    } for
} bind def

|----------------- get aa and sc levels of frequency y(cd)------------------
| use: entry | -- (ycd yaa ysc)

/getfreqs { /y get ycd copy pop
  /kaa 0 def
  ycd aas { exch pop length /d parcel 0.0 exch add
            yaa kaa put
            /kaa kaa 1 add def
          } forall pop
  ycd 0 1 4 { /ksc name
              chemNcd ksc get /d parcel 0.0 exch add 
              ysc ksc put
            } for pop
} bind def

|--------------------- variances at three levels ---------------------------
|
| Computes, over a set of L1 entries, the mean and variance of frequencies
| of use, of individual codons, of individual amino acids encoded by the
| codons, and of the groups of amino acid of similar nature of side chain.
|
| use:  entries | -- (meancd, varcd, meanaa, varaa, meansc, varsc)

/meanvar_y {
  dup length /Nentries name
  [ /meancd /varcd ] { 0.0 64 /d array copy def } forall
  [ /meanaa /varaa ] { 0.0 21 /d array copy def } forall
  [ /meansc /varsc ] { 0.0 5 /d array copy def } forall
    { getfreqs
      meancd ycd add pop
      varcd ycd ty copy 2 pwr add pop
      meanaa yaa add pop
      varaa yaa ty copy 2 pwr add pop
      meansc ysc add pop
      varsc ysc ty copy 2 pwr add pop
    } forall
  [ meancd meanaa meansc ] { Nentries div pop } forall
  varcd meancd ty copy 2 pwr Nentries mul sub Nentries 1 sub div pop
  varaa meanaa ty copy 2 pwr Nentries mul sub Nentries 1 sub div pop
  varsc meansc ty copy 2 pwr Nentries mul sub Nentries 1 sub div pop
} bind def

|------------------ align means and variances arrays of all levels
| Expands the mean and variance arrays of the aa and sc levels to match
| the cd arrays index by index

/align_cdaasc {
  /almean 64 /d array def
  /alvar 64 /d array def
  /k1 0 def /k2 0 def
  aas { exch pop length /n name
        meanaa k1 get almean k2 n getinterval copy pop
        varaa k1 get alvar k2 n getinterval copy pop
        /k1 k1 1 add def  /k2 k2 n add def
      } forall
  /meanaa almean def
  /varaa alvar def

  /almean 64 /d array def
  /alvar 64 /d array def
  /k1 0 def /k2 0 def
  chemNcd { /n name
        meansc k1 get almean k2 n getinterval copy pop
        varsc k1 get alvar k2 n getinterval copy pop
        /k1 k1 1 add def  /k2 k2 n add def
      } forall
  /meansc almean def
  /varsc alvar def
} bind def

|----------------- global variances at three levels --------------------------
|
| computes for each bin of a set of binned L1 entries the global variances
| of frequencies, over all codons, all amino acids, and all side chain types
|
| entries_by_bin | --  (gvarcd, gvaraa, gvarsc)
|
| The returned arrays have one element for each bin of entries.
|

/glob_vars { /entries_bbin name
  /nbins entries_bbin length def
  [ /gvarcd /gvaraa /gvarsc ] { nbins /d array def } forall
  /kbin 0 def
  entries_bbin { var3ways
      0.0 varcd add gvarcd kbin put
      0.0 varaa add gvaraa kbin put
      0.0 varsc add gvarsc kbin put
      /kbin kbin 1 add def
    } forall
  gvarcd gvaraa gvarsc
} bind def

|------------------------ covariances at three levels ------------------------
| use:  entries [ meancd meanaa meansc ] | [ covarcd covaraa covarsc ]
|
| The three levels describe the variation of frequency of codons (64),
| amino acids (21), and side-chain types (5). The last amino acid or
| sidechain type is derived from the group of stop codons.
|
| Each covariance matrix is given as list of row arrays. The m-th array
| of the list gives covariances of the frequencies of all items (e.g., codons)
| with respect to the frequency of item (e.g., codon) m. Note that the
| covariance matrix is symmetrical.
|

/covar { /means name /coventries name 
 [
    |-- codons
    /meancd means 0 get def
    /covarcd [ 64 { 0.0 64 /d array copy } repeat ] def
    coventries { /entry name
        0 1 63 { /k1 name
            covarcd k1 get 
            entry /y get ty copy meancd sub dup k1 get mul
            add pop
          } for
      } forall
    covarcd dup { coventries length 1 sub div pop } forall
    |-- amino acids
    /meanaa means 1 get def
    /covaraa [ 21 { 0.0 21 /d array copy } repeat ] def
    coventries { /entry name
        0 1 20 { /k1 name
            covaraa k1 get
            /kaa 0 def entry /y get
            aas { exch pop length /d parcel 0.0 exch add ty kaa put 
                  /kaa kaa 1 add def
                } forall pop
            ty 0 21 getinterval meanaa sub dup k1 get mul
            add pop
          } for
      } forall
    covaraa dup { coventries length 1 sub div pop } forall
    |-- sidechain types
    /meansc means 2 get def
    /covarsc [ 5 { 0.0 5 /d array copy } repeat ] def
    coventries { /entry name
        0 1 4 { /k1 name
            covarsc k1 get
            0.0 ty copy pop
            /ksc 0 def entry /y get
            0 1 4 { /ksc name
                    chemNcd ksc get /d parcel 0.0 exch add ty ksc put
                  } for pop
            ty 0 5 getinterval meansc sub dup k1 get mul
            add pop
          } for
      } forall
    covarsc dup { coventries length 1 sub div pop } forall
  ]
} bind def

|======================== Additional tools for mkfigs2 =======================

[ /yy1 /yy2 /yy3 /yy4 ] { 64 /d array def } forall

|--------------------------- build prototype frequencies ---------------------
| - sorts the entries into two lists of entries using GC3 content:
|   upper (GC3>0.5) and lower (GC3<0.5)
| - averages the frequencies for codons, amino acids, and side-chain type
|   of the two groups separately (true to identity rather than pre-ranked)
| - returns lists of entries for the upper and lower genomes and lists of
|   the averaged frequency arrays (cd, aa, and sc) of the upper and lower
|   entries
|
| use:  entries | | [ entries_up ] [ means_up ] [ entries_lo ]  [ means_lo ]

/bfupflo { dup
  [ exch { dup /gc3 get 0.5 gt ~pop if } forall ] 
  dup [ exch meanvar_y meancd meanaa meansc ]
  3 -1 roll
  [ exch { dup /gc3 get 0.5 lt ~pop if } forall ]
  dup [ exch meanvar_y meancd meanaa meansc ]
} bind def

|---------------------------- describe a genome by superposition of prototypes
| Fits the entry genome's codon frequencies by the superposition of the
| prototypes provided in means_up and means_lo. Returns the fraction of the
| 'lo' protoype.
|
| entry means_up means_lo | al

/comp_al { 0 get /ylo name 0 get /yup name /y get /yd name
  0.0 yup yy1 copy ylo sub yy3 copy yd yy2 copy ylo sub mul add
  0.0 yy1 2 pwr add div
} bind def

|---------------------------- compute superposition of prototypes
| Using the prototype codon frequencies in means_up and means_lo construct
| the superposition codon frequencies for given alpha.
|
| means_up means_lo al | y  (Note: transcribe y for keeping)

/comp_supy { /al name 0 get /ylo name 0 get /yup name
  yup yy1 copy al mul ylo yy2 copy 1.0 al sub mul add
} bind def
 
|=============== prepare a text database from the CUTG databases ================
|
| The output database comprises all entries of the CUTG databases qbxxx.spsum.txt
| in one text file. The qbbct.spsum.txt entries are separated as 'bct' (that is,
| eubacteria) and 'arc' (archaea), a distinction not made in CUTG.
|
| The kingdom is a 3-letter code corresponding to 'xxx' in the CUTG database name
| The DNA type is an integer (0-genomic, 1-mitochondrial, 2-chloroplast,
| 3-cyanelle, 4-plastid, 5-nucleomorph, 6-secondary_endosymbiont, 7-chromoplast,
| 8-leucoplast, 9-x (sic!), 10-proplastid, 11-apicoplast, 12-kinetoplast).
| The species identifier is an integer. The number of codons is an integer,
| the count of all codons listed for the entry. Codon frequencies are normalized
| to the total codon count. Species name strings are purged of 'comma' (replaced
| by 'space')
|
| The database is formatted as a flat table with columns separated by comma.
| Each subsequent line decribes one CUTG database entry. The column headers
| (first line ) are:
|   1  kingdom
|   2  DNAtype
|   3  speciesid
|   4  Ncodons
|   5  speciesname
|   6-69 codon (header: bases; entries: frequency (5 digits)
|
| usage: (dbname.txt) min_codons | --


/make_webdb {
  /oldMINCODONS MINCODONS def /MINCODONS name
  /txtdb name
  save   /websave name
  {
    |-- get database      
    make     
    load entries /bct S_one_kd thin /bctentries name
    (kdfix_bct.d) load_kds
    bctentries apply_kds clear
    |-- start text accumulation
    /webtxtbuf 50e6 /b array def
    webtxtbuf 0
    |-- write header
    (Kingdom,DNAtype,SpeciesID,Ncodons,SpeciesName,) fax
    cvs { mkact * exch text (,) fax } forall 1 sub (\n) fax

    |-- CUTG entry loop
    entries dup length _ pop
      { /entry name
        entry /kingdom get fax (,) fax
        entry /etcidx get * exch -1 number (,) fax
        entry /speciesid get * exch -1 number (,) fax
        entry /Ncodons get * exch -1 number (,) fax
        entry /speciesname get dup
          { (,) search { pop ( ) 0 get exch 0 put } { pop exit } ifelse
          } loop fax (,) fax
        entry /y get { * exch -5 number (,) fax } forall
        1 sub (\n) fax
      } forall | entries
    0 exch getinterval dbdir txtdb writefile
  } stopped { clear } { (done\n) toconsole } ifelse
  websave restore
  /MINCODONS oldMINCODONS def
  make
} bind def

|---------------------- stupid: reformat 'missed.txt' entries: /key -> (key)

/fixmissed {        
  save /fixsave name
  { textdir (missed.txt) fromfiles /missedlist name
    0 2 missedlist length 2 sub { /k name
        missedlist k get class /nameclass eq
            { fwbuf 0 * missedlist k get text
              0 exch getinterval transcribe missedlist k put
            } if
      } for
  } stopped { clear }
            { dcodedir (fixedmissed.d) { missedlist xtexts } tofiles
            }
            ifelse
  fixsave restore
} bind def

|------------------- load L1 report (fit)
|  (report.box) | --  (report)
|
/loadL1rep { /boxname name
  /L1rep_layer layer
  { dbdir boxname readboxfile /L1rep name
  } stopped
  /L1rep_layer _layer
  not { [ boxname ( loaded\n) concat toconsole } if
} bind def

end _module
