(* Protein cymatics resonance modes: f = omega0*Sqrt[m^2+n^2+p^2] *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

c = axiomConstants[];
omega0 = c["omega0"];

modeFreq[m_, n_, p_] := omega0 Sqrt[m^2 + n^2 + p^2];

modes = {
  {0, 0, 1, 0.99712057},
  {0, 0, 2, 1.99424114},
  {1, 1, 0, 1.41014143},
  {1, 1, 1, 1.72706349},
  {2, 0, 0, 1.99424114}
};

errors = Map[
  Function[{row}, Abs[modeFreq[row[[1]], row[[2]], row[[3]]] - row[[4]]]],
  modes
];

layer = 250;
t = layer/c["nLayers"];
gateAngle = 2 Pi * modeFreq[1, 1, 0] * t * (1/3) * Sin[Pi * 5/c["nQubits"]];

report = <|
  "modeErrors" -> N[errors, 8],
  "maxError" -> Max[errors],
  "pass" -> Max[errors] < 10^-6,
  "sampleGateAngle" -> N[gateAngle, 8]
|>;

Print["[Wolfram ProteinCymatics] max mode error = ", report["maxError"]];
report