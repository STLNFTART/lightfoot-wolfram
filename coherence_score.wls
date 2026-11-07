(* Coherence retention on an identical signal is 1, and the score stays in [0, 1]. *)
phaseAlign[x_, y_] := Module[{xc, yc, denom, corr},
  xc = x - Mean[x];
  yc = y - Mean[y];
  denom = Norm[xc] Norm[yc];
  If[denom < 10^-12, 1, Clip[(xc . yc / denom + 1) / 2, {0, 1}]]
];
energyKeep[x_, y_] := Module[{ratio},
  ratio = Total[y^2] / (Total[x^2] + 10^-12);
  Clip[1 - Abs[1 - ratio], {0, 1}]
];
stabilityKeep[x_, y_] := Module[{sx, sy},
  sx = StandardDeviation[x];
  sy = StandardDeviation[y];
  1 - Min[1, Abs[sy - sx] / (sx + 10^-9)]
];
score[x_, y_] := 1/2 phaseAlign[x, y] + 3/10 energyKeep[x, y] + 1/5 stabilityKeep[x, y];

x = N[{1, 2, 3, 4, 5}];
same = score[x, x];
flipped = score[x, -x];

report = <|
  "identical" -> same,
  "flipped" -> flipped,
  "pass" -> same == 1 && 0 <= flipped <= 1
|>;

Print["[Wolfram Coherence] identical = ", same, "  flipped = ", flipped];
report
