(* Run every linked Wolfram derivation and write a JSON certificate. *)
base = DirectoryName[$InputFileName];

results = <|
  "lightfoot" -> Get[FileNameJoin[{base, "lightfoot_derivation.wls"}]],
  "primal_logic_kernel" -> Get[FileNameJoin[{base, "primal_logic_kernel.wls"}]],
  "primal_control" -> Get[FileNameJoin[{base, "primal_control.wls"}]],
  "lyapunov_bound" -> Get[FileNameJoin[{base, "lyapunov_bound.wls"}]],
  "protein_cymatics" -> Get[FileNameJoin[{base, "protein_cymatics.wls"}]],
  "gate_angle" -> Get[FileNameJoin[{base, "gate_angle.wls"}]],
  "memory_kernel" -> Get[FileNameJoin[{base, "memory_kernel.wls"}]],
  "diffusion_kernel" -> Get[FileNameJoin[{base, "diffusion_kernel.wls"}]],
  "diffusion_recovery" -> Get[FileNameJoin[{base, "diffusion_recovery.wls"}]],
  "dbit_stability" -> Get[FileNameJoin[{base, "dbit_stability.wls"}]],
  "cpl_heisenberg" -> Get[FileNameJoin[{base, "cpl_heisenberg.wls"}]],
  "symbolic_recursion" -> Get[FileNameJoin[{base, "symbolic_recursion.wls"}]],
  "coherence_score" -> Get[FileNameJoin[{base, "coherence_score.wls"}]],
  "quantro_base" -> Get[FileNameJoin[{base, "quantro_base.wls"}]]
|>;

passes = {
  results["lightfoot"]["pass"],
  results["primal_logic_kernel"]["pass"],
  results["primal_control"]["lyapunovPass"],
  results["lyapunov_bound"]["pass"],
  results["protein_cymatics"]["pass"],
  results["gate_angle"]["pass"],
  results["memory_kernel"]["pass"],
  results["diffusion_kernel"]["pass"],
  results["diffusion_recovery"]["pass"],
  results["dbit_stability"]["pass"],
  results["cpl_heisenberg"]["pass"],
  results["symbolic_recursion"]["pass"],
  results["coherence_score"]["pass"],
  results["quantro_base"]["pass"]
};

results["allPass"] = And @@ passes;
results["passCount"] = Count[passes, True];
results["checkCount"] = Length[passes];

names = {
  "lightfoot", "primal_logic_kernel", "primal_control", "lyapunov_bound",
  "protein_cymatics", "gate_angle", "memory_kernel", "diffusion_kernel",
  "diffusion_recovery", "dbit_stability", "cpl_heisenberg",
  "symbolic_recursion", "coherence_score", "quantro_base"
};
summary = <|
  "allPass" -> results["allPass"],
  "passCount" -> results["passCount"],
  "checkCount" -> results["checkCount"],
  "passes" -> AssociationThread[names, passes]
|>;

Export[FileNameJoin[{base, "..", "validation_results_wolfram.json"}], summary, "JSON"];
Print["=== WOLFRAM OVERALL: ", If[results["allPass"], "ALL PASS", "SOME FAIL"],
  " (", results["passCount"], "/", results["checkCount"], ") ==="];
results
