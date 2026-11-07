(* Symbolic recursion memory step: s' = Exp[-mu dt] s + a q dt. *)
(* Fixed point tends to a q / mu as dt -> 0+. *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

ClearAll[a, q, mu, dt];
fixed[dt_] := a q dt / (1 - Exp[-mu dt]);
lim = Assuming[mu > 0, Limit[fixed[dt], dt -> 0, Direction -> "FromAbove"]];
identity = Simplify[lim - a q / mu];

muN = axiomConstants["lightfootMu"];
dtN = 1/100;
qN = 1;
aN = 1;
fixedN = aN qN dtN / (1 - Exp[-muN dtN]);
target = aN qN / muN;

report = <|
  "limit" -> lim,
  "identity" -> identity,
  "fixedPoint" -> N[fixedN, 12],
  "targetAqOverMu" -> N[target, 12],
  "pass" -> identity === 0 && Abs[fixedN - target] < 10^-2
|>;

Print["[Wolfram SymbolicRecursion] limit identity = ", identity];
report
