(* DBITS discrete kernel. Stability box Eq.107: delta, lambda in [0.2, 0.4], |a_c kappa| <= 0.1. *)
(* J = {{1-delta, kappa}, {lambda a_c, 1-lambda}}, stable when spectral radius < 1. *)

samples = {};
Do[
  If[Abs[ac * kappa] <= 0.1,
    J = {{1 - delta, kappa}, {lam * ac, 1 - lam}};
    AppendTo[samples, Max[Abs[Eigenvalues[N[J, 20]]]]]
  ],
  {delta, Subdivide[0.2, 0.4, 8]},
  {lam, Subdivide[0.2, 0.4, 8]},
  {kappa, {-0.1, 0, 0.1}},
  {ac, {-1, 1, 2}}
];

(* Continuous offset toward the D0 attractor, from the public dbit core. *)
D0 = 149.9992314;
x0 = 150;
attractorValue[s_] := D0 - (x0 - D0) Exp[-0.82 s] - 5 Sin[1.8 s] Exp[-0.55 s];
finalErr = Abs[attractorValue[4] - D0];

report = <|
  "sampleCount" -> Length[samples],
  "maxRho" -> Max[samples],
  "rhoPass" -> Max[samples] < 1,
  "attractorFinalError" -> N[finalErr, 8],
  "attractorPass" -> finalErr < 1,
  "pass" -> Max[samples] < 1 && finalErr < 1
|>;

Print["[Wolfram DBITS] max rho = ", report["maxRho"], "  attractor error = ", report["attractorFinalError"]];
report
