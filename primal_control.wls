(* Primal Logic Kernel v1: x'[t] = alpha*theta - lambda*x *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "axiom_constants.wls"}]];

c = axiomConstants[];
alpha = c["alpha"];
lambda = axiomConstants["lambda"];
theta0 = c["theta0"];
x0 = c["x0"];

(* Closed-form solution *)
xSS = alpha theta0/lambda;
xAnalytic[t_] := xSS + (x0 - xSS) Exp[-lambda t];

(* Lyapunov V(x) = x^2/2, Vdot = x*(alpha*theta - lambda*x) *)
Vdot[x_, theta_] := x (alpha theta - lambda x);
upperBound[x_, theta_] := -(lambda/2) x^2 + (alpha^2/(2 lambda)) theta^2;

(* Young's inequality check on random samples *)
samples = RandomVariate[NormalDistribution[], {1000, 2}];
residuals = Map[
  Function[{pair}, Module[{x = pair[[1]], theta = pair[[2]]},
    Vdot[x, theta] - upperBound[x, theta]
  ]],
  samples
];

report = <|
  "equilibrium" -> xSS,
  "xDotAtEquilibrium" -> alpha theta0 - lambda xSS,
  "maxLyapunovResidual" -> Max[residuals],
  "lyapunovPass" -> Max[residuals] <= 10^-10,
  "xAt20" -> N[xAnalytic[20], 10]
|>;

Print["[Wolfram PrimalControl] max Lyapunov residual = ", report["maxLyapunovResidual"]];
report