(* Lean DiffusionKernel: slab rate alpha = kappa (Pi/L)^2 equals mu *)
(* when Log[D0] = 3 kappa Pi^4 / L^2. *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

ClearAll[kappa, L, D0];
alphaExpr = kappa (Pi / L)^2;
muExpr = Log[D0] / (3 Pi^2);
kappaMatch = Log[D0] L^2 / (3 Pi^4);
recovered = Simplify[alphaExpr /. kappa -> kappaMatch];
identity = Simplify[recovered - muExpr];

muN = axiomConstants["lightfootMu"];
report = <|
  "recovered" -> recovered,
  "mu" -> muExpr,
  "identity" -> identity,
  "muNumeric" -> N[muN, 16],
  "pass" -> identity === 0
|>;

Print["[Wolfram DiffusionRecovery] identity = ", identity];
report
