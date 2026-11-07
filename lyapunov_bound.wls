(* Lyapunov gap is a square: upper - Vdot = (lambda x - alpha theta)^2 / (2 lambda) *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

ClearAll[x, theta, alpha, lambda];
vdot = x (alpha * theta - lambda * x);
upper = -(lambda/2) x^2 + (alpha^2 / (2 lambda)) theta^2;
gap = Simplify[upper - vdot];
square = Simplify[(lambda x - alpha theta)^2 / (2 lambda)];
identity = Simplify[gap - square];

c = axiomConstants[];
alphaN = c["alpha"];
lambdaN = axiomConstants["lambda"];
samples = RandomVariate[NormalDistribution[], {400, 2}];
numericGap = Map[
  Function[{pair},
    Module[{xx = pair[[1]], th = pair[[2]]},
      (-(lambdaN/2) xx^2 + (alphaN^2 / (2 lambdaN)) th^2) -
        xx (alphaN th - lambdaN xx)
    ]
  ],
  samples
];

report = <|
  "gap" -> gap,
  "completedSquare" -> square,
  "identity" -> identity,
  "minNumericGap" -> Min[numericGap],
  "pass" -> identity === 0 && Min[numericGap] >= -10^-10
|>;

Print["[Wolfram Lyapunov] identity = ", identity, "  min gap = ", report["minNumericGap"]];
report
