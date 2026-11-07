(* Primal logic kernel: K = gain * gating * forcing - mu * state *)
(* Equilibrium state = gain * gating * forcing / mu has residual 0. *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

mu = axiomConstants["lightfootMu"];
gain = 1;
gating = 4/5;
forcing = 1;
stateEq = gain * gating * forcing / mu;
residual = Simplify[gain * gating * forcing - mu * stateEq];

report = <|
  "mu" -> N[mu, 16],
  "stateEquilibrium" -> N[stateEq, 16],
  "residual" -> N[residual, 20],
  "pass" -> residual === 0
|>;

Print["[Wolfram PrimalKernel] residual = ", report["residual"]];
report
