# Lightfoot math in the Wolfram Language

Donte Lightfoot. These scripts are the Wolfram Language form of the equation layer from the local axiom, protein, and diffusion projects, plus the public DBITS and symbolic-recursion repositories, plus the Quantro base models.

Wolfram Engine is not required to read the sources. On this machine it was not installed, so `verify_linked_math.py` checks the same identities with SymPy and NumPy and writes `certificate.json`.

## Run

```powershell
python verify_linked_math.py
wolframscript -file run_all_validations.wls
wolframscript -file publish_cloud.wls -cloud
```

`publish_cloud.wls` calls `CloudDeploy` only after the kernel is signed into Wolfram Cloud. Install the free engine at https://www.wolfram.com/engine/ and sign in with a Wolfram ID first.

## Linked checks

| Script | Claim |
| --- | --- |
| `lightfoot_derivation.wls` | mu = Log[150] / (3 Pi^2) is within 0.001 of 0.16905 |
| `primal_logic_kernel.wls` | Kernel equilibrium residual is 0 |
| `primal_control.wls` | Closed form of x' = alpha theta - lambda x, sample Lyapunov bound |
| `lyapunov_bound.wls` | The Lyapunov gap is the square (lambda x - alpha theta)^2 / (2 lambda) |
| `protein_cymatics.wls` | Resonance mode frequencies |
| `gate_angle.wls` | Gate angle is linear in layer time |
| `memory_kernel.wls` | Laplace transform of the exponential memory kernel |
| `diffusion_kernel.wls` | Heat-equation fundamental solution has residual 0 |
| `diffusion_recovery.wls` | Slab decay rate recovers mu |
| `dbit_stability.wls` | Spectral radius stays below 1 inside the stability box |
| `cpl_heisenberg.wls` | C_PL derivative at 0 and infinite-time limit |
| `symbolic_recursion.wls` | Memory fixed point tends to a q / mu |
| `coherence_score.wls` | Identical signals score 1 |
| `quantro_base.wls` | Michaelis-Menten half-maximum, FitzHugh-Nagumo nullclines, Nernst rest, Poiseuille steady flow, SIR conservation, time-warp floor |

`project_links.json` maps each script to its source project.

## Left out

Home-defense MATLAB scripts, the Lambda command and stealth layer, the closed primal-quantum kernel, and the private monorepos are not in this folder. Multi-Heart APL files are placeholders. The heart, enzyme, Nernst, flow, and SIR equations are the Quantro base models with overlays off.
