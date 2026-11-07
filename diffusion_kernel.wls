(* Fundamental solution of the 1D heat equation u_t = u_xx. *)
ClearAll[u, t, x];
u = (4 Pi t)^(-1/2) Exp[-x^2 / (4 t)];
residual = FullSimplify[D[u, t] - D[u, {x, 2}], t > 0];

report = <|
  "fundamental" -> u,
  "heatResidual" -> residual,
  "pass" -> residual === 0
|>;

Print["[Wolfram Diffusion] heat residual = ", residual];
report
