(* Lightfoot constant derivation: mu = Log[D0]/(3 Pi^2) *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

c = axiomConstants[];
mu = axiomConstants["lightfootMu"];
muClaim = 0.16905;

derivation = {
  "formula" -> HoldForm[Log[D0]/(3 Pi^2)],
  "D0" -> c["D0"],
  "muDerived" -> N[mu, 16],
  "muClaim" -> muClaim,
  "absError" -> N[Abs[mu - muClaim], 6],
  "pass" -> Abs[mu - muClaim] < 10^-3
};

Print["[Wolfram Lightfoot] mu = ", N[mu, 10], "  error = ", derivation["absError"]];
derivation