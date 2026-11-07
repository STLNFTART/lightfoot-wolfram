(* Exponential memory kernel K[tau] = alpha Exp[-alpha tau] *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

alpha = axiomConstants["lightfootMu"];
K[tau_] := alpha Exp[-alpha tau];

(* Laplace transform L{K}(s) = alpha/(s+alpha) *)
laplaceK[s_] := alpha/(s + alpha);

s = 1.5;
numericLaplace = NIntegrate[K[tau] Exp[-s tau], {tau, 0, Infinity}];

report = <|
  "alpha" -> N[alpha, 12],
  "K0" -> N[K[0], 12],
  "laplaceAt1.5" -> N[laplaceK[s], 12],
  "laplaceNumeric" -> numericLaplace,
  "laplaceError" -> Abs[numericLaplace - laplaceK[s]],
  "pass" -> Abs[numericLaplace - laplaceK[s]] < 10^-4
|>;

Print["[Wolfram MemoryKernel] Laplace error = ", report["laplaceError"]];
report