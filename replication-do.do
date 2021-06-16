/// 1. TRADE_HS8.DTA
use trade_hs8.dta, clear

*** Figure 1
gen tempyear=year-1900
loc tariff duty_mex_yr
sort year phaseout_cat
graph box schedulehs8_mex `tariff' if phaseout_cat=="A", over(tempyear) noout ///
title("Class A") ytitle("") graphregion(fcolor(white)) ylabel(,nogrid) note("") legend(ring(0) pos(3) col(1) order(1 "Scheduled" 2 "Applied")) ///
saving(classA, replace)
graph box schedulehs8_mex `tariff' if phaseout_cat=="B", over(tempyear) noout ///
title("Class B") ytitle("") graphregion(fcolor(white)) ylabel(,nogrid) note("") legend(off) ///
saving(classB, replace)
graph box schedulehs8_mex `tariff' if (phaseout_cat=="C" | phaseout_cat=="C+" ), over(tempyear) noout ///
title("Class C & C+") ytitle("") graphregion(fcolor(white)) ylabel(,nogrid) note("") legend(off) ///
saving(classC, replace)
graph box schedulehs8_mex `tariff' if phaseout_cat=="D", over(tempyear) noout ///
title("Class D") ytitle("") graphregion(fcolor(white)) ylabel(,nogrid) note("") legend(off) ///
saving(classD, replace)
gr combine classA.gph classB.gph classC.gph classD.gph, graphregion(color(white)) ycommon
drop temp*
erase classA.gph
erase classB.gph
erase classC.gph
erase classD.gph 

*** Table 1: Phaseout Categories of HS-8 Goods Imported to US from Mexico
tab phaseout_cat if year==1993, sum(schedulehs8_mex)
tab phaseout_cat if year==1999, sum(schedulehs8_mex)

bysort phaseout_cat year: egen tempclass = sum(val_FOB)
bysort year: egen temptot = sum(val_FOB)
g tempshare = tempclass/temptot

tab phaseout_cat if year==1993, sum(tempshare)
tab phaseout_cat if year==1999, sum(tempshare)




/// 2. TRADE_HS6.DTA
use trade_hs6.dta, clear

*** Table 2: Sample Characteristics at HS6 Level
bysort cclass2 year: egen tempclass = sum(us_mex_v_mo)
bysort year: egen temptot = sum(us_mex_v_mo)
gen tempshare = tempclass/temptot

egen temptag=tag(hs6 year) if tempshare>0 & tempshare!=.
tab cclass2 if temptag==1 & year==1993, sum(schedulehs6_mex)
tab cclass2 if temptag==1 & year==1993, sum(tempshare)
tab cclass2 if temptag==1 & year==1999, sum(schedulehs6_mex)
tab cclass2 if temptag==1 & year==1999, sum(tempshare)
drop temp*

*** Table 3: Anticipatory Slumps & Bumps
** Panel A
xtset hs6n date
eststo clear
eststo: qui reghdfe ymex_b6_b34 i.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb( hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_b6_b35 i.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb( hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_q4_q23 i.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb( hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lb6 i.phasedout#c.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_q1_lb6 i.phasedout#c.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lq4 i.phasedout#c.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) nocons
** Panel B
xtset hs6n date
eststo clear
eststo: qui reghdfe ymex_b6_b34 F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb( hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_b6_b35 F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb( hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_q4_q23 F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb( hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lb6 S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_q1_lb6 S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lq4 S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) nocons

*** Table 4: Trade-Flow vs. Trade-Consumption Elasticities over Time
** Panel A: All Goods
loc FE "noabsorb"
loc indicator ""
xtset hs6n date
eststo clear
loc n=1*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp1=_est_est1
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=3*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp3=_est_est3
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp3==1 & year>1990, `FE' vce(cluster hs6n)
loc n=5*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp5=_est_est5
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp5==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp7=_est_est7
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp7==1 & year>1990, `FE' vce(cluster hs6n)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label
** Panel B: Phaseout Categories
loc FE "noabsorb"
loc indicator "ibn.phasedout#c."
xtset hs6n date
eststo clear
loc n=1*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp1=_est_est1
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=3*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp3=_est_est3
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp3==1 & year>1990, `FE' vce(cluster hs6n)
loc n=5*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp5=_est_est5
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp5==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp7=_est_est7
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp7==1 & year>1990, `FE' vce(cluster hs6n)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label

*** Table 5: Average Trade-Flow vs. Trade-Consumption Elasticities
eststo clear
eststo: qui xtreg ymex_yr lx1mex_yr i.year if tag_hs6_yr==1 & year>1990, fe vce(cluster hs6n)
gen temp=_est_est1
eststo: qui xtreg qmex_base_yr lx1mex_yr i.year if tag_hs6_yr==1 & temp==1 & year>1990, fe vce(cluster hs6n)
gen temp2=_est_est2
eststo clear
eststo: qui xtreg ymex_yr lx1mex_yr i.year if tag_hs6_yr==1 & temp2==1, fe vce(cluster hs6n)
eststo: qui xtreg qmex_base_yr lx1mex_yr i.year if tag_hs6_yr==1 & temp==1, fe vce(cluster hs6n)
eststo: qui xtreg ymex_yr ibn.phasedout#c.lx1mex_yr i.year if tag_hs6_yr==1 & temp2==1, fe vce(cluster hs6n)
eststo: qui xtreg qmex_base_yr ibn.phasedout#c.lx1mex_yr i.year if tag_hs6_yr==1 & temp==1, fe vce(cluster hs6n)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*lx1mex_yr*)

*** Table 6: Robustness: Alternative Measures of Consumed Imports
** Panel A: All Goods
loc FE "noabsorb"
loc indicator ""
xtset hs6n date
eststo clear
eststo: qui reghdfe S12.ymex_yr `indicator'S12.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp1=_est_est1
eststo: qui reghdfe S84.ymex_yr `indicator'S84.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp2=_est_est2
loc q qmex_lag_yr
loc n=1*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp2==1 & year>1990, `FE' vce(cluster hs6n)
loc q qmex_commonk_yr
loc n=1*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp2==1 & year>1990, `FE' vce(cluster hs6n)
loc q qmex_shock120_yr
loc n=1*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp2==1 & year>1990, `FE' vce(cluster hs6n)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*lx1mex_yr*)
** Panel B: Phaseout Categories
loc FE "noabsorb"
loc indicator "ibn.phasedout#c."
xtset hs6n date
eststo clear
eststo: qui reghdfe S12.ymex_yr `indicator'S12.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp1=_est_est1
eststo: qui reghdfe S84.ymex_yr `indicator'S84.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp2=_est_est2
loc q qmex_lag_yr
loc n=1*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp2==1 & year>1990, `FE' vce(cluster hs6n)
loc q qmex_commonk_yr
loc n=1*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp2==1 & year>1990, `FE' vce(cluster hs6n)
loc q qmex_shock120_yr
loc n=1*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.`q' `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp2==1 & year>1990, `FE' vce(cluster hs6n)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*lx1mex_yr*)

*** Table B.1 (Appendix): Anticipatory Slumps & Bumps - Fixed Effects Robustness
xtset hs6n date
eststo clear
eststo: qui reghdfe ymex_b6_b34 i.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_b6_b34 i.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs4n) vce(cluster hs2n)
eststo: qui reghdfe ymex_b6_b34 i.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb(sitc_r3) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lb6 i.phasedout#c.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n year) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lb6 i.phasedout#c.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs4n year) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lb6 i.phasedout#c.S12.lx1mex_yr if tag_hs6_yr==1, absorb(sitc_r3 year) vce(cluster hs2n)
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) nocons

*** Table B.2 (Appendix): Anticipatory Slumps & Bumps - Storability
xtile temphh_xtile = HH, n(2)

xtset hs6n date
gen temp = temphh_xtile==2 & phasedout==1
eststo clear
eststo: qui reghdfe ymex_b6_b34 	i.temp#c.F12.S12.lx1mex_yr if tag_hs6_yr ==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_b6_b35 	i.temp#c.F12.S12.lx1mex_yr if tag_hs6_yr ==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_q4_q23 	i.temp#c.F12.S12.lx1mex_yr if tag_hs6_yr ==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lb6 	i.temp#c.S12.lx1mex_yr if tag_hs6_yr ==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_q1_lb6 	i.temp#c.S12.lx1mex_yr if tag_hs6_yr ==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe ymex_t1_lq4 	i.temp#c.S12.lx1mex_yr if tag_hs6_yr ==1, absorb(hs6n) vce(cluster hs2n)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) nocons

*** Table B.3 (Appendix): Empirical Validation of the Imputed Consumption of Imports
loc FE "absorb(hs6n)"
xtset hs6n date
eststo clear
eststo: qui reghdfe ymex_b6_b34 F12.S12.lx1mex_yr if tag_hs6_yr==1, `FE' vce(cluster hs2n)
gen temp1=_est_est1
eststo: qui reghdfe ymex_b6_b35 F12.S12.lx1mex_yr if tag_hs6_yr==1, `FE' vce(cluster hs2n)
gen temp2=_est_est2
eststo: qui reghdfe ymex_q4_q23 F12.S12.lx1mex_yr if tag_hs6_yr==1, `FE' vce(cluster hs2n)
gen temp3=_est_est3
eststo clear
eststo: qui reghdfe qmex_b6_b34 F12.S12.lx1mex_yr if tag_hs6_yr==1 & temp1==1, `FE' vce(cluster hs2n)
eststo: qui reghdfe qmex_b6_b35 F12.S12.lx1mex_yr if tag_hs6_yr==1 & temp2==1, `FE' vce(cluster hs2n)
eststo: qui reghdfe qmex_q4_q23 F12.S12.lx1mex_yr if tag_hs6_yr==1 & temp3==1, `FE' vce(cluster hs2n)
eststo: qui reghdfe qmex_b6_b34 ibn.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1 & temp1==1, `FE' vce(cluster hs2n)
eststo: qui reghdfe qmex_b6_b35 ibn.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1 & temp2==1, `FE' vce(cluster hs2n)
eststo: qui reghdfe qmex_q4_q23 ibn.phasedout#c.F12.S12.lx1mex_yr if tag_hs6_yr==1 & temp3==1, `FE' vce(cluster hs2n)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*x1mex*)

*** Table B.4 (Appendix): Durable vs. Non-Durable Goods
loc FE "noabsorb"
loc indicator "ibn.becsn#c."
xtset hs6n date
eststo clear
loc n=1*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp1=_est_est1
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp1==1 & year>1990, `FE' vce(cluster hs6n)
loc n=3*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp3=_est_est3
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp3==1 & year>1990, `FE' vce(cluster hs6n)
loc n=5*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp5=_est_est5
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp5==1 & year>1990, `FE' vce(cluster hs6n)
loc n=7*12
eststo: qui reghdfe S`n'.ymex_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp7=_est_est7
eststo: qui reghdfe S`n'.qmex_base_yr `indicator'S`n'.lx1mex_yr if tag_hs6_yr==1 & temp7==1 & year>1990, `FE' vce(cluster hs6n)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label

*** Table B.5 (Appendix): Dynamic Elasticities - Unrestricted ECM
loc FE "absorb(hs6n year)"
xtset hs6n date
eststo clear
eststo: qui reghdfe S12.ymex_yr S12.lx1mex_yr L12.ymex_yr L12.lx1mex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp=_est_est1
eststo: qui reghdfe S12.qmex_base_yr S12.lx1mex_yr L12.qmex_base_yr L12.lx1mex_yr if tag_hs6_yr==1 & temp==1 & year>1990, `FE' vce(cluster hs6n)
gen temp2=_est_est2
eststo clear
eststo: qui reghdfe S12.ymex_yr S12.lx1mex_yr L12.ymex_yr L12.lx1mex_yr if tag_hs6_yr==1 & temp2==1, `FE' vce(cluster hs6n)
nlcom (-_b[L12.lx1mex_yr]/_b[L12.ymex_yr])
eststo: qui reghdfe S12.qmex_base_yr S12.lx1mex_yr L12.qmex_base_yr L12.lx1mex_yr if tag_hs6_yr==1 & temp==1, `FE' vce(cluster hs6n)
nlcom (-_b[L12.lx1mex_yr]/_b[L12.qmex_base_yr])
eststo: qui reghdfe S12.ymex_yr ibn.phasedout#c.S12.lx1mex_yr ibn.phasedout#c.L12.ymex_yr ibn.phasedout#c.L12.lx1mex_yr if tag_hs6_yr==1 & temp2==1, `FE' vce(cluster hs6n)
nlcom (-_b[i1.phasedout#c.L12.lx1mex_yr]/_b[i1.phasedout#c.L12.ymex_yr])
nlcom (-_b[i0.phasedout#c.L12.lx1mex_yr]/_b[i0.phasedout#c.L12.ymex_yr])
eststo: qui reghdfe S12.qmex_base_yr ibn.phasedout#c.S12.lx1mex_yr ibn.phasedout#c.L12.qmex_base_yr ibn.phasedout#c.L12.lx1mex_yr if tag_hs6_yr==1 & temp==1, `FE' vce(cluster hs6n)
nlcom (-_b[i1.phasedout#c.L12.lx1mex_yr]/_b[i1.phasedout#c.L12.qmex_base_yr])
nlcom (-_b[i0.phasedout#c.L12.lx1mex_yr]/_b[i0.phasedout#c.L12.qmex_base_yr])
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label

*** Table B.6 (Appendix): Dynamic Elasticities - Restricted ECM
loc FE "absorb(hs6n year)"
xtset hs6n date
eststo clear
eststo: qui reghdfe ymex_yr lx1mex_yr L12.ymex_yr if tag_hs6_yr==1 & year>1990, `FE' vce(cluster hs6n)
gen temp=_est_est1
eststo: qui reghdfe qmex_base_yr lx1mex_yr L12.qmex_base_yr if tag_hs6_yr==1 & temp==1 & year>1990, `FE' vce(cluster hs6n)
gen temp2=_est_est2
eststo clear
eststo: qui reghdfe ymex_yr lx1mex_yr L12.ymex_yr if tag_hs6_yr==1 & temp2==1, `FE' vce(cluster hs6n)
nlcom (_b[lx1mex_yr]/(1-_b[L12.ymex_yr]))
eststo: qui reghdfe qmex_base_yr lx1mex_yr L12.qmex_base_yr if tag_hs6_yr==1 & temp==1, `FE' vce(cluster hs6n)
nlcom (_b[lx1mex_yr]/(1-_b[L12.qmex_base_yr]))
eststo: qui reghdfe ymex_yr ibn.phasedout#c.lx1mex_yr ibn.phasedout#c.L12.ymex_yr if tag_hs6_yr==1 & temp2==1, `FE' vce(cluster hs6n)
nlcom (_b[i1.phasedout#c.lx1mex_yr]/(1-_b[i1.phasedout#c.L12.ymex_yr]))
eststo: qui reghdfe qmex_base_yr ibn.phasedout#c.lx1mex_yr ibn.phasedout#c.L12.qmex_base_yr if tag_hs6_yr==1 & temp==1, `FE' vce(cluster hs6n)
nlcom (_b[i1.phasedout#c.lx1mex_yr]/(1-_b[i1.phasedout#c.L12.qmex_base_yr]))
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label

*** Table C.2 (Online Appendix): Anticipatory Slumps & Bumps - Storability Interaction
xtset hs6n date 
gen lxA1mex_HH = F12.S12.lx1mex_yr*HH
gen lxA1mex_HH2 = F12.S12.lx1mex_yr*HH2

loc fe "absorb(hs6n)"
loc indicator "phasedout"
eststo clear
eststo: qui reghdfe ymex_b6_b34 F12.S12.lx1mex_yr lxA1mex_HH lxA1mex_HH2 if tag_hs6_yr==1, `fe' vce(cluster hs2n)
eststo: qui reghdfe ymex_b6_b35 F12.S12.lx1mex_yr lxA1mex_HH lxA1mex_HH2 if tag_hs6_yr==1, `fe' vce(cluster hs2n)
eststo: qui reghdfe ymex_q4_q23 F12.S12.lx1mex_yr lxA1mex_HH lxA1mex_HH2 if tag_hs6_yr==1, `fe' vce(cluster hs2n)
eststo: qui reghdfe ymex_b6_b34 ibn.`indicator'#c.F12.S12.lx1mex_yr ibn.`indicator'#c.lxA1mex_HH ibn.`indicator'#c.lxA1mex_HH2 ibn.`indicator' if tag_hs6_yr==1, `fe' vce(cluster hs2n)
eststo: qui reghdfe ymex_b6_b35 ibn.`indicator'#c.F12.S12.lx1mex_yr ibn.`indicator'#c.lxA1mex_HH ibn.`indicator'#c.lxA1mex_HH2 ibn.`indicator' if tag_hs6_yr==1, `fe'  vce(cluster hs2n)
eststo: qui reghdfe ymex_q4_q23 ibn.`indicator'#c.F12.S12.lx1mex_yr ibn.`indicator'#c.lxA1mex_HH ibn.`indicator'#c.lxA1mex_HH2 ibn.`indicator' if tag_hs6_yr==1, `fe'  vce(cluster hs2n) 
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*x1mex* *xA1mex*)

*** Table C.3 (Online Appendix): Anticipatory Effects in Mexican Exporter Prices
gen tempx = log(1+duty_mex_yr)

local y ymex
xtset hs6n date
eststo clear
eststo: qui reghdfe `y'_b6_b34 F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
gen temp1=_est_est1
eststo: qui reghdfe `y'_b6_b35 F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
gen temp2=_est_est2
eststo: qui reghdfe `y'_q4_q23 F12.S12.lx1mex_yr if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
gen temp3=_est_est3
eststo: qui reghdfe uv_b6_b34 F12.S12.tempx if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe uv_b6_b35 F12.S12.tempx if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe uv_q4_q23 F12.S12.tempx if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe uv_b6_b34 ibn.phasedout#c.F12.S12.tempx if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe uv_b6_b35 ibn.phasedout#c.F12.S12.tempx if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
eststo: qui reghdfe uv_q4_q23 ibn.phasedout#c.F12.S12.tempx if tag_hs6_yr==1, absorb(hs6n) vce(cluster hs2n)
drop temp*
esttab est4 est5 est6 est7 est8 est9, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label

*** C.4 (Online Appendix) Cummulative elasticities
foreach c in us eu {
foreach j in mex row {
bysort hs6 year: egen temp_`c'_`j'_myr = sum(`c'_`j'_v_mo)
bysort hs6 year: egen temp_`c'_`j'_qyr = sum(`c'_sale_base_hs6avg`j'_`j')
forv t=1/4 {
bysort hs6 year: egen temp_`c'_`j'_m`t' = sum(`c'_`j'_v_mo/(qtr<=`t'))
bysort hs6 year: egen temp_`c'_`j'_q`t' = sum(`c'_sale_base_hs6avg`j'_`j'/(qtr<=`t'))
replace temp_`c'_`j'_m`t'=temp_`c'_`j'_m`t'*(4/`t')
replace temp_`c'_`j'_q`t'=temp_`c'_`j'_q`t'*(4/`t')
}
}
}
forv t=1/4 {
gen temp_y`t' = log(1+temp_us_mex_m`t')-log(1+temp_us_row_m`t')-log(1+temp_eu_mex_m`t')+log(1+temp_eu_row_m`t')
gen temp_q`t' = log(1+temp_us_mex_q`t')-log(1+temp_us_row_q`t')-log(1+temp_eu_mex_q`t')+log(1+temp_eu_row_q`t')
}
gen temp_yyr = log(1+temp_us_mex_myr)-log(1+temp_us_row_myr)-log(1+temp_eu_mex_myr)+log(1+temp_eu_row_myr)
gen temp_qyr = log(1+temp_us_mex_qyr)-log(1+temp_us_row_qyr)-log(1+temp_eu_mex_qyr)+log(1+temp_eu_row_qyr)
xtset hs6n date
gen temprefy = L12.temp_yyr
gen temprefq = L12.temp_qyr
forv n=1/4 {
replace temp_y`n' = temp_y`n'-temprefy
replace temp_q`n' = temp_q`n'-temprefq
}

xtset hs6n date
eststo clear
loc FE "noabsorb"
loc indicator "ibn.phasedout#c."
eststo: qui reghdfe temp_y1 `indicator'S12.lx1mex_yr if year>1990 & tag_hs6_yr==1, `FE' vce(cluster hs6n)
gen temp1 = _est_est1
eststo: qui reghdfe temp_q1 `indicator'S12.lx1mex_yr if temp1==1, `FE' vce(cluster hs6n)
eststo: qui reghdfe temp_y2 `indicator'S12.lx1mex_yr if year>1990 & tag_hs6_yr==1, `FE' vce(cluster hs6n)
gen temp3 = _est_est3
eststo: qui reghdfe temp_q2 `indicator'S12.lx1mex_yr if temp3==1, `FE' vce(cluster hs6n)
eststo: qui reghdfe temp_y3 `indicator'S12.lx1mex_yr if year>1990 & tag_hs6_yr==1, `FE' vce(cluster hs6n)
gen temp5 = _est_est5
eststo: qui reghdfe temp_q3 `indicator'S12.lx1mex_yr if temp5==1, `FE' vce(cluster hs6n)
eststo: qui reghdfe temp_y4 `indicator'S12.lx1mex_yr if year>1990 & tag_hs6_yr==1, `FE' vce(cluster hs6n)
gen temp7 = _est_est7
eststo: qui reghdfe temp_q4 `indicator'S12.lx1mex_yr if temp7==1, `FE' vce(cluster hs6n)
drop temp?
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*x1mex*)
esttab using "${folder}Data work/Tables/dynamics_quarterly.tex", replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*x1mex*)




*** Figures 2 and C.1
gen counter = _n
forvalues n = 10(5)90 {
_pctile HH, p(`n')
scalar temp_`n' = r(r1)
}
matrix HH_vector = (temp_10, temp_15, temp_20, temp_25, temp_30, temp_35, temp_40, temp_45, temp_50, temp_55, temp_60, temp_65, temp_70, temp_75, temp_80, temp_85, temp_90)
gen pHH = HH_vector[1,_n] in 1/17
gen is = round(pHH*12,.01)

foreach i in _b6_b25 _q4_q23 _b6_b35 _b6_b34 {

loc fe "absorb(hs6n)"
loc indicator "phasedout"
xtset hs6n date
qui reghdfe ymex`i' ibn.`indicator'#c.F12.S12.lx1mex_yr ibn.`indicator'#c.lxA1mex_HH ibn.`indicator'#c.lxA1mex_HH2 ibn.`indicator' if tag_hs6_yr==1, `fe'  vce(cluster hs2n)

scalar change_tariff = -0.01
mat b = e(b)
scalar b0 = b[1,2]
scalar b1 = b[1,4]
scalar b2 = b[1,6]
mat cov = e(V)
matrix cov_mat = (cov[2,2],cov[4,2],cov[6,2]\cov[4,2],cov[4,4],cov[6,4]\cov[6,2],cov[6,4],cov[6,6])

forvalues n=1/17 {
scalar temp = HH_vector[1,`n']
scalar temp_`n' = b0*change_tariff+b1*temp*change_tariff + b2*(temp^2)*change_tariff
scalar deriv1 = change_tariff
scalar deriv2 = change_tariff*temp
scalar deriv3 = change_tariff*temp^2
scalar drop temp
matrix temp = (deriv1,deriv2,deriv3)
matrix temp2 = (deriv1\deriv2\deriv3)
matrix var_`n' = temp*cov_mat*temp2
matrix drop temp temp2
}

matrix betasm`i' = (temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7, temp_8, temp_9, temp_10, temp_11, temp_12, temp_13, temp_14, temp_15, temp_16, temp_17)
matrix var_m`i' = (var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11, var_12, var_13, var_14, var_15, var_16, var_17)
scalar drop _all
gen betas`i' = betasm`i'[1,_n] in 1/17
gen var`i' = var_m`i'[1,_n] in 1/17
gen std_errors`i' = var`i'^0.5
gen ci_ub`i' = betas`i'+1.68*std_errors`i'
gen ci_lb`i' = betas`i'-1.68*std_errors`i'

replace counter=. if betas`i'==.
}

*** Figure 2:
local i 3
local i2 4
local y counter
loc base b6_b34
twoway line betas_`base' `y' if counter>1 & counter<15, lwidth(*1.5) lcolor(navy) || ///
line ci_ub_`base' `y' if counter>1 & counter<15, lwidth(*1) lcolor(navy) lpatt(dash) || ///
line ci_lb_`base' `y' if counter>1 & counter<15, lwidth(*1) lcolor(navy) lpatt(dash) ||, legend(off) yline(0, lcolor(grey) lwidth(*0.5) lpatt(dash)) ///
graphregion(color(white)) xtitle("Percentile HH Index", size(`i2')) ytitle("{&Delta}{sub:11:12-5:8} m{sup:DD}{sub:z,t-1} ", size(`i2')) ///
xlabel(3 "20%" 5 "30%" 7 "40%"  9 "50%" 11 "60%" 13 "70%" 15 "80%" , labsize(`i')) ylabel(,nogrid labsize(`i'))

*** Figure C.1 (Online Appendix): Anticipation and Storability at different Sub-Periods
local i 3
local i2 4
local y counter
twoway line betas_b6_b34 `y'  if counter>1 & counter<15,  lcolor(navy) lwidth(*1.25) || ///
line betas_b6_b35 `y'  if counter>1 & counter<15, lcolor(grey) lpatt(shortdash) lwidth(*1.25) || ///
line betas_q4_q23 `y'  if counter>1 & counter<15, lcolor(grey) lpatt(dash) lwidth(*1.25) ||, ///
legend (col(1) ring(0) pos(1) order(1 "Months 11:12 - 5:8" 2 "Months 11:12 - 5:10" 3 "Months 10:12 - 4:9")) ||, yline(0, lcolor(grey) lwidth(*0.5) lpatt(dash)) ///
graphregion(color(white)) xtitle("Percentile HH Index", size(`i2')) ytitle("{&Delta}{sub:n-n'} m{sup:DD}{sub:z,t-1}", size(`i2')) ///
xlabel(3 "20%" 5 "30%" 7 "40%"  9 "50%" 11 "60%" 13 "70%" 15 "80%" , labsize(`i')) ylabel(,nogrid labsize(`i'))
drop pHH is ci_* betas_* std_errors_* var_* counter

*** Figure 3: Example of our Baseline Proxy
local i hs6avg
local j mex
local p 870421
twoway bar us_`j'_v_mo date if hs6=="`p'", color(maroon) || line us_sale_base_`i'`j'_`j' date if hs6=="`p'", lcolor(navy) lwidth(*1.5) ///
graphregion(fcolor(white)) tlabel(1990m1(12)1999m12, labsize(small)) ylabel(,nogrid nolabel notick) xtitle("") ///
legend(pos(11) ring(0) col(1) label(1 "Trade Flows") label(2 "Trade Consumption"))

*** Figure B.1 (Appendix): Distribution Inventory-Sales Ratio
egen temptag =tag(hs6)
gen tempis = round(HH,.01)
gen temp = tempis
replace temp=1 if temp>1
egen temp2 = median(tempis/(tag_hs6_yr ==1))
scalar median=temp2
local med=median
hist tempis if temptag==1, fraction ///
graphregion(color(white)) ytitle("Fraction") xtitle("HH Index", size(`i')) ///
xlabel( ,labsize(`i')) ylabel( ,labsize(`i') nogrid) fcolor(none) lcolor(grey) xline(`med', lcolor(red) lpatt(dash) lwidth(*1.25))
drop temp*

*** Figure C.3 (Online Appendix): Dynamic Elasticity - All HS6 Goods
xtset hs6n date
eststo clear
eststo: qui reghdfe D.ymex_yr D.lx1mex_yr L.lx1mex_yr L.ymex_yr if tag_hs6_yr==1 & year>1990, absorb(hs6n year) vce(cluster hs2n)
gen temp2 = _est_est1
eststo clear
eststo: qui reghdfe D.ymex_yr D.lx1mex_yr L.lx1mex_yr L.ymex_yr if temp2==1, absorb(hs6n year) vce(cluster hs2n)
mat B1 = e(b)
qui{
gen y_se = .
nlcom -_b[D.lx1mex_yr]
mat v = r(V)
replace y_se = sqrt(v[1,1]) if year==1991
local pr -(_b[D.lx1mex_yr] + _b[L.lx1mex_yr] + (_b[D.lx1mex_yr]*_b[L.ymex_yr]))
forval y = 1992/1999 {
	nlcom `pr'
	mat v = r(V)
	replace y_se = sqrt(v[1,1]) if year==`y'
	local pr `pr' - (1+_b[L.ymex_yr])^(`y'-1991)*(_b[L.lx1mex_yr] + (_b[D.lx1mex_yr]*_b[L.ymex_yr]))
}
}
eststo: qui reghdfe D.qmex_base_yr D.lx1mex_yr L.lx1mex_yr L.qmex_base_yr if temp2==1, absorb(hs6n year) vce(cluster hs2n)
mat B2 = e(b)
qui {
gen q_se = .
nlcom -_b[D.lx1mex_yr]
mat v = r(V)
replace q_se = sqrt(v[1,1]) if year==1991
local pr -(_b[D.lx1mex_yr] + _b[L.lx1mex_yr] + (_b[D.lx1mex_yr]*_b[L.qmex_base_yr]))
forval y = 1992/1999 {
	nlcom `pr'
	mat v = r(V)
	replace q_se = sqrt(v[1,1]) if year==`y'
	local pr `pr' - (1+_b[L.qmex_base_yr])^(`y'-1991)*(_b[L.lx1mex_yr] + (_b[D.lx1mex_yr]*_b[L.qmex_base_yr]))
}
}
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label nocons
qui {
	gen y = year-1990
	gen y_ir = .
	gen y_ir2 = .
	gen y_ll = .
	gen y_ul = .
	gen q_ir = .
	gen q_ir2 = .
	gen q_ll = .
	gen q_ul = .
	replace y_ir = -B1[1,1] if year>=1991
	replace q_ir = -B2[1,1] if year>=1991
	replace y_ir2 = -B1[1,1] if year>=1991
	replace q_ir2 = -B2[1,1] if year>=1991
	replace y_ir = -(B1[1,1] + B1[1,2] + B1[1,1]*B1[1,3]) if year>=1992	
	replace q_ir = -(B2[1,1] + B2[1,2] + B2[1,1]*B2[1,3]) if year>=1992
	replace y_ir2 = -(B1[1,1] + B1[1,2] + B1[1,1]*B1[1,3]) if year>=1992	
	replace q_ir2= -(B2[1,1] + B2[1,2] + B2[1,1]*B2[1,3]) if year>=1992
	forval t = 1/8 {
		replace y_ir = y_ir - (1+B1[1,3])^(`t')*(B1[1,2] + B1[1,1]*B1[1,3]) if year>=1992 + `t'
		replace q_ir = q_ir - (1+B2[1,3])^(`t')*(B2[1,2] + B2[1,1]*B2[1,3]) if year>=1992 + `t'
		replace y_ir2 =  - B1[1,2] + (1+B1[1,3])*y_ir2 if year>=1992 + `t'
		replace q_ir2 =  - B2[1,2] + (1+B2[1,3])*q_ir2 if year>=1992 + `t'
	}
	forval y = 1991/1999 {
		replace y_ul = y_ir + y_se if year==`y'
		replace y_ll = y_ir - y_se if year==`y'
		replace q_ul = q_ir + q_se if year==`y'
		replace q_ll = q_ir - q_se if year==`y'
	}
	sort year
	twoway line y_ir y if year>1990 & temp2==1, lcolor(maroon) lwidth(*1.25) ///
		|| line q_ir y if year>1990 & temp2==1, lcolor(navy) lpatt(dash) lwidth(*1.25) ///
		yscale() xlabel(#10) ylabel(#10, nogrid) graphregion(fcolor(white)) xtitle("Years") ytitle("Elasticity") ///
		legend(order(1 "Trade-Flows" 2 "Trade-Consumption") ring(0) pos(3) row(2))
}
drop temp* y_ir* q_ir* y y_se q_se *_ul *ll

*** Figure C.4 (Online Appendix): Dynamic Elasticity - Phased-Out Goods
xtset hs6n date
eststo clear
eststo: qui reghdfe D.ymex_yr D.lx1mex_yr L.lx1mex_yr L.ymex_yr if tag_hs6_yr==1 & year>1990 & phasedout==1, absorb(hs6n year) vce(cluster hs2n)
gen temp2 = _est_est1
eststo clear
eststo: qui reghdfe D.ymex_yr D.lx1mex_yr L.lx1mex_yr L.ymex_yr if temp2==1, absorb(hs6n year) vce(cluster hs2n)
mat B1 = e(b)
qui{
gen y_se = .
nlcom -_b[D.lx1mex_yr]
mat v = r(V)
replace y_se = sqrt(v[1,1]) if year==1991
local pr -(_b[D.lx1mex_yr] + _b[L.lx1mex_yr] + (_b[D.lx1mex_yr]*_b[L.ymex_yr]))
forval y = 1992/1999 {
	nlcom `pr'
	mat v = r(V)
	replace y_se = sqrt(v[1,1]) if year==`y'
	local pr `pr' - (1+_b[L.ymex_yr])^(`y'-1991)*(_b[L.lx1mex_yr] + (_b[D.lx1mex_yr]*_b[L.ymex_yr]))
}
}
eststo: qui reghdfe D.qmex_base_yr D.lx1mex_yr L.lx1mex_yr L.qmex_base_yr if temp2==1, absorb(hs6n year) vce(cluster hs2n)
mat B2 = e(b)
qui {
gen q_se = .
nlcom -_b[D.lx1mex_yr]
mat v = r(V)
replace q_se = sqrt(v[1,1]) if year==1991
local pr -(_b[D.lx1mex_yr] + _b[L.lx1mex_yr] + (_b[D.lx1mex_yr]*_b[L.qmex_base_yr]))
forval y = 1992/1999 {
	nlcom `pr'
	mat v = r(V)
	replace q_se = sqrt(v[1,1]) if year==`y'
	local pr `pr' - (1+_b[L.qmex_base_yr])^(`y'-1991)*(_b[L.lx1mex_yr] + (_b[D.lx1mex_yr]*_b[L.qmex_base_yr]))
}
}
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label nocons
qui {
	gen y = year-1990
	gen y_ir = .
	gen y_ir2 = .
	gen y_ll = .
	gen y_ul = .
	gen q_ir = .
	gen q_ir2 = .
	gen q_ll = .
	gen q_ul = .
	replace y_ir = -B1[1,1] if year>=1991
	replace q_ir = -B2[1,1] if year>=1991
	replace y_ir2 = -B1[1,1] if year>=1991
	replace q_ir2 = -B2[1,1] if year>=1991
	replace y_ir = -(B1[1,1] + B1[1,2] + B1[1,1]*B1[1,3]) if year>=1992	
	replace q_ir = -(B2[1,1] + B2[1,2] + B2[1,1]*B2[1,3]) if year>=1992
	replace y_ir2 = -(B1[1,1] + B1[1,2] + B1[1,1]*B1[1,3]) if year>=1992	
	replace q_ir2= -(B2[1,1] + B2[1,2] + B2[1,1]*B2[1,3]) if year>=1992
	forval t = 1/8 {
		replace y_ir = y_ir - (1+B1[1,3])^(`t')*(B1[1,2] + B1[1,1]*B1[1,3]) if year>=1992 + `t'
		replace q_ir = q_ir - (1+B2[1,3])^(`t')*(B2[1,2] + B2[1,1]*B2[1,3]) if year>=1992 + `t'
		replace y_ir2 =  - B1[1,2] + (1+B1[1,3])*y_ir2 if year>=1992 + `t'
		replace q_ir2 =  - B2[1,2] + (1+B2[1,3])*q_ir2 if year>=1992 + `t'
	}
	forval y = 1991/1999 {
		replace y_ul = y_ir + y_se if year==`y'
		replace y_ll = y_ir - y_se if year==`y'
		replace q_ul = q_ir + q_se if year==`y'
		replace q_ll = q_ir - q_se if year==`y'
	}
	sort year
	twoway line y_ir y if year>1990 & temp2==1, lcolor(maroon) lwidth(*1.25) ///
		|| line q_ir y if year>1990 & temp2==1, lcolor(navy) lpatt(dash) lwidth(*1.25) ///
		yscale() xlabel(#10) ylabel(#10, nogrid) graphregion(fcolor(white)) xtitle("Years") ytitle("Elasticity") ///
		legend(order(1 "Trade-Flows" 2 "Trade-Consumption") ring(0) pos(3) row(2))
}
drop temp* y_ir* q_ir* y y_se q_se *_ul *ll



/// 3. MODEL SIMULATIONS
*** Figure 4: Impulse Response Function of Aggregate Variables in the 3 Simulations 
use simulation_baseline.dta, clear

egen temptag  = tag(model year mon)
bysort model year mon: egen temp1 = sum(imports)
bysort model: egen temp1ref = mean(temp1/(year==2001 & temptag ==1))
replace temp1 = log(temp1/temp1ref)
bysort model year mon: egen temp2 = sum(sales)
bysort model: egen temp2ref = mean(temp2/(year==2001 & temptag ==1))
replace temp2 = log(temp2/temp2ref)
bysort model year mon: egen temp3 = sum(stock)
bysort model: egen temp3ref = mean(temp3/(year==2001 & temptag ==1))
replace temp3 = log(temp3/temp3ref)
gen tempis = stock/sales
bysort model year mon: egen temp4 = mean(tempis)
bysort model: egen temp4ref = mean(temp4/(year==2001 & temptag ==1))
replace temp4 = log(temp4/temp4ref)
bysort model year mon: egen temp5 = mean(prices)
bysort model: egen temp5ref = mean(temp5/(year==2001 & temptag ==1))
replace temp5 = log(temp5/temp5ref)

local color1 maroon
local color2 navy
local color3 black
local color4 grey
local i 4
local thick 0.8
local libdate = ym(2003,12)
local y1 2002
local y2 2005
twoway line temp1 date if model==1 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color1') lwidth(`thick') || ///
line temp2 date if model==1 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color2') lwidth(`thick') ||, ///
graphregion(color(white)) xlabel(none) ylabel( ,labsize(`i') nogrid) xline(`libdate', lcolor(`color4') lpatt(dash) lwidth(0.05)) ///
legend(off) ///
 title("Panel A: Benchmark") ytitle("log (X/X{sub:0})") xtitle("") bgcolor(none) saving(high, replace)
twoway line temp1 date if model==2 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color1') lwidth(`thick') || ///
line temp2 date if model==2 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color2') lwidth(`thick') ||, ///
graphregion(color(white)) xlabel(none) ylabel( ,labsize(`i') nogrid) xline(`libdate', lcolor(`color4') lpatt(dash) lwidth(0.05)) ///
legend(size(`i') col(1) ring(0) pos(5) label(1 "Imports") label(2 "Consumption")) ///
 title("Panel B: Low I/S") ytitle("log (X/X{sub:0})") xtitle("") bgcolor(none) saving(low, replace)
twoway line temp1 date if model==3 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color1') lwidth(`thick') || ///
line temp2 date if model==3 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color2') lwidth(`thick') ||, ///
graphregion(color(white)) xlabel(none) ylabel( ,labsize(`i') nogrid) xline(`libdate', lcolor(`color4') lpatt(dash) lwidth(0.05)) ///
legend(size(`i') col(1) ring(0) pos(5) label(1 "Imports") label(2 "Consumption")) ///
 title("Panel C: Unanticipated") ytitle("log (X/X{sub:0})") xtitle("") bgcolor(none) saving(unanticipated, replace)
twoway line temp3 date if model==1 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color1') lwidth(`thick') || ///
line temp3 date if model==2 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color2') lwidth(`thick') || ///
line temp3 date if model==3 & temptag ==1 & year>`y1' & year<`y2', lcolor(`color3') lwidth(`thick') ||, ///
legend(size(`i') col(1) ring(0) pos(1) label(1 "Benchmark I/S") label(2 "Low I/S") label(3 "Unanticipated")) ///
graphregion(color(white)) xlabel(none) ylabel( ,labsize(`i') nogrid) xline(`libdate', lcolor(grey) lpatt(dash) lwidth(0.05)) ///
 title("Panel D: Stock") ytitle("log (S/S{sub:0})") xtitle("") bgcolor(none) saving(stock, replace)
drop temp*
gr combine high.gph low.gph unanticipated.gph stock.gph, ycommon graphregion(color(white))
erase high.gph 
erase low.gph
erase unanticipated.gph
erase stock.gph

*** Table C.6 (Online Appendix): Simulation Results for Three Calibrations
sort id year mon
egen temptag = tag(id year)

xtset idn date
local proxy base
eststo clear
eststo: qui reg limports_yr ibn.model#c.ltariffs ibn.model if temptag==1 & (year==2002 | year==2005), vce(cluster id)
eststo: qui reg limports_yr ibn.model#c.ltariffs ibn.model if temptag==1 & (year==2003 | year==2004), vce(cluster id)
eststo: qui reg lsales_yr ibn.model#c.ltariffs ibn.model if temptag==1 & (year==2002 | year==2005), vce(cluster id)
eststo: qui reg lsales_yr ibn.model#c.ltariffs ibn.model if temptag==1 & (year==2003 | year==2004), vce(cluster id)
eststo: qui reg lsales_`proxy'_yr ibn.model#c.ltariffs ibn.model if temptag==1 & (year==2002 | year==2005), vce(cluster id)
eststo: qui reg lsales_`proxy'_yr ibn.model#c.ltariffs ibn.model if temptag==1 & (year==2003 | year==2004), vce(cluster id)
drop temp*
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*tariff*)

*** Figure 5: Monte Carlo Simulations: Trade vs. Trade-Consumption Elasticities
import excel all_simulations.xlsx, sheet("Sheet1") firstrow clear

gen bias_imports = imports_in/imports_out
gen bias_sales = sales_in/sales_out
gen bias_sales_base = sales_base_in/sales_base_out

gen temp = fr==0 & depreciate_transit==0
eststo clear
eststo: qui reg bias_imports imports_slump if temp==1 
eststo: qui reg bias_sales imports_slump if temp==1 
esttab, replace b(1) se(1) ar2 star(* 0.10 ** 0.05 *** 0.01) label keep(*imports_slump*)

local eq `"`e(depvar)' ="'
local eq "`eq' `: di  %7.2f _b[_cons]'"
local eq `"`eq' `=cond(_b[imports_slump]>0, "+", "-")'"'
local eq `"`eq' `:di %6.2f abs(_b[imports_slump])' imports_slump"'
local eq `"`eq' + {&epsilon}"'
local color1 maroon
local color2 navy
local i 4
local i2 .25
local i3 1
local x imports_slump
twoway scatter bias_imports `x' if temp==1, color(`color1') msize(`i3') || lfit bias_imports `x' if temp==1, color(`color1') lwidth(`i2') || ///
scatter bias_sales `x' if temp==1, color(`color2') msize(`i3') || lfit bias_sales `x' if temp==1, color(`color2') lwidth(`i2') || ///
scatter bias_sales_base `x' if temp==1, color(`color2') msymbol(+) msize(`i3') || lfit bias_sales_base `x' if temp==1, lpattern(dash) color(`color2') lwidth(`i2') ||, ///
graphregion(color(white)) xtitle("Anticipatory Slump", size(`i')) ytitle("{&epsilon} relative to True Trade-Consumption Elasticity", size(`i')) ///
xlabel( , labsize(`i')) ylabel( ,labsize(`i') nogrid) legend(symysize(`i') size(`i') col(1) ring(0) pos(10) order(1 "Trade-Flow" 3 "Actual Trade-Consumption"  5 "Imputed Trade-Consumption"))

