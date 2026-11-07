(* Primal-Heisenberg C_PL(t) = a_x a_p (1 - Exp[-(lambda_x + lambda_p) t]) / (lambda_x + lambda_p) *)
ClearAll[t, lx, lp, ax, ap];
cpl[t_, lx_, lp_, ax_, ap_] := ax ap (1 - Exp[-(lx + lp) t]) / (lx + lp);
deriv0 = Simplify[D[cpl[t, lx, lp, ax, ap], t] /. t -> 0];
limitInf = Assuming[lx + lp > 0, Limit[cpl[t, lx, lp, ax, ap], t -> Infinity]];
sample = cpl[1, 1/2, 1/2, 1, 1];

report = <|
  "derivativeAt0" -> deriv0,
  "limit" -> limitInf,
  "sampleAt1" -> N[sample, 12],
  "pass" -> deriv0 === ax * ap && limitInf === ax ap / (lx + lp) && sample > 0
|>;

Print["[Wolfram Cpl] C_PL(1) = ", report["sampleAt1"]];
report
