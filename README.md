# BEM
Basic codes in Matlab for BEM
1. Find the boundary elements through the uniform method (BE_u.m) and the adaptive method (BE_a.m, adaptive.m) and then in case of a circular boundary through the uniform method (BE_u_c.m). The script that does the plot is BoundaryElements_test.m
2. Find the approximated density, that is the unknown of the BIE: it can be used the collocation method (BEM_col.m) or the Galerkin method (BEM_gal.m); in both cases there are singular integrals in the matrix A, which can be solved through the singularity extraction technique or not. 
3. Calculate the scattered wave in the domain (ScatteredWave.m).
4. Plot the solution with different domains but taking always a plane wave as the incident one (solution.m). The method to define the boundary elements and the one to find the density is to be selected using BEM.m.
5. Calculate the error between the approximated scattered wave of the BEM and the exact one (Error.m). Plot the convergence comparing uniform and adaptive discretizations, singularity extraction and non-singularity extraction methods (Error_test.m).

Report: Report_Daldossi.pdf
