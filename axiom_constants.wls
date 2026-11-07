(* Shared Axiom constants for Wolfram derivations *)
ClearAll[axiomConstants];
axiomConstants[] := <|
  "nQubits" -> 20,
  "nLayers" -> 2500,
  "D0" -> 150,
  "omega0" -> 0.99712057,
  "alpha" -> 1.25,
  "theta0" -> 2.0,
  "x0" -> 0.0
|>;

axiomConstants["lightfootMu"] := Log[axiomConstants[]["D0"]]/(3 Pi^2);
axiomConstants["lambda"] := axiomConstants["lightfootMu"];