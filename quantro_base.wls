(* Quantro-Heart base models, overlay off. *)
(* Michaelis-Menten mass, FitzHugh-Nagumo nullclines, Nernst rest, *)
(* Poiseuille steady flow, SIR population, overlay time-warp floor. *)

ClearAll[S, P, Vmax, Km, v, w, a, b, c, E, T, z, Co, Ci, Q, dP, mu, L, r];
ClearAll[beta, II, RR, gamma, NN, alpha, lambda, t];

mmV = Vmax S / (Km + S);
mmPass = Simplify[(mmV /. S -> Km) - Vmax/2] === 0;

fhnDv = v - v^3 / 3 - w;
fhnDw = (v + a - b w) / c;
fhnPass = Simplify[fhnDv /. w -> v - v^3 / 3] === 0 &&
  Simplify[fhnDw /. w -> (v + a) / b] === 0;

Rgas = 8314462618 / 1000000000;
Faraday = 9648533212 / 100000;
EN = (Rgas T) / (z Faraday) Log[Co / Ci];
nernstPass = Simplify[(10 (EN - E) /. E -> EN)] === 0;

Qss = Pi r^4 dP / (8 mu L);
poisPass = Simplify[(5 (Qss - Q) /. Q -> Qss)] === 0;

inf = beta S II / NN;
rec = gamma II;
sirPass = Simplify[-inf + (inf - rec) + rec] === 0;

warp[tt_, aa_, ll_] := Max[1, 1 + aa Sin[ll tt]];
warpSamples = Table[warp[tt, 1/5, 3/2], {tt, 0, 2 Pi, Pi/12}];
warpPass = And @@ Map[# >= 1 &, warpSamples];

report = <|
  "michaelisMenten" -> mmPass,
  "fitzhughNagumo" -> fhnPass,
  "nernst" -> nernstPass,
  "poiseuille" -> poisPass,
  "sir" -> sirPass,
  "timeWarpFloor" -> warpPass,
  "pass" -> mmPass && fhnPass && nernstPass && poisPass && sirPass && warpPass
|>;

Print["[Wolfram Quantro] pass = ", report["pass"]];
report
