/////// PRACTICAL 1: Meta-analysis 

/// please change the path to open diabetes1.dta
use "C:\Users\efthimiou\Google Drive\presentations\---TEACHING---\Oxford 2019\practical Stata\diuretics.dta", clear

describe 

notes 

metan r1 f1 r2 f2

metan r1 f1 r2 f2, or fixedi

metan r1 f1 r2 f2, or randomi

metan r1 f1 r2 f2, rr fixed

metan r1 f1 r2 f2, or randomi label(namevar=study) xlabel(0.1, 0.2, 0.5, 1, 2, 4) effect(Odds ratio) favours(favours diuretic # favours control) texts(180)


/////  (optional exercise)
use "C:\Users\efthimiou\Google Drive\presentations\---TEACHING---\Oxford 2019\practical Stata\diabetes1.dta",clear

generate f1=n1-r1
generate f2=n2-r2
list r1 f1 n1 r2 f2 n2

gen or=(r2/f2)/(r1/f1)
gen logor=log(or)
gen selogor=sqrt(1/r2+1/f2+1/r1+1/f1)
list study study_id or logor selogor

metan logor selogor

metan logor selogor, eform lcols(study_id)



metan logor selogor, eform lcols(study_id) random
metan r2 f2 r1 f1, lcols(study_id) or randomi

metan r2 f2 r1 f1, lcols(study_id) or randomi nograph
list study or _ES selogor _selogES

g mu = log(r(ES))
display mu
display r(selogES)
display r(ES) 
display r(ci_low)
display r(ci_upp)
display r(tau2)



/////////// PRACTICAL 2: Fitting the network meta-analysis model
use "C:\Users\efthimiou\Google Drive\presentations\---TEACHING---\Oxford 2019\practical Stata\diabetes2.dta" ,clear

list study t r n

network setup r n, stud(study) trt(t) ref(1) or numcodes

edit

network convert standard
network map
network convert pairs
networkplot _t1 _t2, lab(PL BB CCB CCB ACE ARB)
network convert augmented

network meta c
lincom [_y_5]_cons -[ _y_2]_cons, eform

foreach trt1 in 2 3 4 5 6{
 foreach trt2 in 2 3 4 5 6{

if "`trt1'"=="`trt2'" continue
if "`trt2'">"`trt1'" lincom [_y_`trt2']_cons-[_y_`trt1']_cons,eform
  }
 }

 netleague
 network rank min,mean
 
 intervalplot, mvmeta lab(Placebo BB Diuretics CCB ACE ARB) eform null(1) sep  range(0.4 2) xlab(0.4 0.7 1.5 2) marg(5 40 5 5)


/////////////////////////
use "C:\Users\efthimiou\Google Drive\presentations\---TEACHING---\Oxford 2019\practical Stata\glaucoma.dta" ,clear
list study t mean sd n
network setup mean sd n,stud(study) trt(t) smd ref(1) numcodes
edit
network convert pairs

network map
network convert augmented

network meta c
foreach trt1 in 2 3 4 5 6 7 8 9 {
 foreach trt2 in 2 3 4 5 6 7 8 9 {

if "`trt1'"=="`trt2'" continue
if "`trt2'">"`trt1'" lincom [_y_`trt2']_cons-[_y_`trt1']_cons,eform
  }
 }

 
 /////////Practical 3: Assessing inconsistency in network meta-analysis
use "C:\Users\efthimiou\Google Drive\presentations\---TEACHING---\Oxford 2019\practical Stata\diabetes2.dta", clear

network setup r n, stud(study) trt(t) ref(1) or

network convert pairs

ifplot _y _stderr _t1 _t2 study, eform lab(P BB D CCB ACE ARB) plotopt(texts(120))
ifplot _y _stderr _t1 _t2 study, eform lab(P BB D CCB ACE ARB) tau2(comparison)
di  .1168^2

ifplot _y _stderr _t1 _t2 study, eform lab(P BB D CCB ACE ARB) tau2(0.014)



network convert standard 

network sidesplit A B
network sidesplit all

