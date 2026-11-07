(* Protein cymatics gate angle: phi = 2 Pi omega t (1/3) Sin[Pi k / N] *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

c = axiomConstants[];
omega = c["omega0"] Sqrt[2];
tLayer = 250 / c["nLayers"];
k = 5;
nQ = c["nQubits"];
phi = 2 Pi omega tLayer (1/3) Sin[Pi k / nQ];

ClearAll[tt, freq];
phiOfT = 2 Pi freq tt (1/3) Sin[Pi k / nQ];
slope = Simplify[D[phiOfT, tt]];

report = <|
  "omega110" -> N[omega, 12],
  "t" -> N[tLayer, 12],
  "phi" -> N[phi, 12],
  "dphiDt" -> slope,
  "pass" -> slope === 2 Pi freq (1/3) Sin[Pi * 5 / nQ] && NumericQ[N[phi]]
|>;

Print["[Wolfram GateAngle] phi = ", report["phi"]];
report
