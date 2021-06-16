# 2021_NAFTA

This document describes the STATA programs, datasets and variables used to create the results reported in "How Does Trade Respond to Anticipated Tariff Changes? Evidence from NAFTA" by Shafaat Yar Khan and Armen Khederlarian.

All results are replicated using "replication-do.do". This file generates all Tables and Figures in the order in which they appear described in the paper. There are 4 datasets used to generate the results:

1. "trade hs6.dta": Used to deliver the main results of section 2 and 3. Unit of observation is HS6 product - month.
  - Tables 2, 3, 4, 5, 6, B.1, B.2, B.3, B.4, B.5, B.6, C.2, C.3, C.4
  - Figures 2, 3, B.1, C.1, C.3, C.4
  
2. "trade hs8.dta": Used to show the tariff schedule per phaseout category (Table 1 and Figure 1). Unit of observation is HS8 product - year.

3. "simulation baseline.dta": Generates Figure 4 of section 4 (Model Simulations) and Table C.6 of
the Online Appendix. Unit of observation is firm - model - month. Model refers to one of the three
calibrations used (Benchmark, low I/S, unanticipated).

4. "all simulations.xls": Generates Figure 5 of section 4 (Model Simulations). Unit of observation is
model | all the used calibrations are specified in Table C.5.
