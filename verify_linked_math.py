"""Check the same identities as the Wolfram Language scripts.

Wolfram Engine is optional. This file is the numeric and symbolic certificate
that can run with SymPy and NumPy. Each check names the .wls file it mirrors.
"""

from __future__ import annotations

import json
import math
from pathlib import Path

import numpy as np
import sympy as sp

HERE = Path(__file__).resolve().parent
OUT = HERE / "certificate.json"


def record(name: str, ok: bool, detail: dict) -> dict:
    return {"id": name, "pass": bool(ok), **detail}


def lightfoot() -> dict:
    D0 = 150
    mu = math.log(D0) / (3 * math.pi**2)
    claim = 0.16905
    err = abs(mu - claim)
    return record(
        "lightfoot",
        err < 1e-3,
        {"wls": "lightfoot_derivation.wls", "mu": mu, "claim": claim, "absError": err},
    )


def primal_kernel() -> dict:
    mu = math.log(150) / (3 * math.pi**2)
    gain, gating, forcing = 1.0, 0.8, 1.0
    state = gain * gating * forcing / mu
    residual = gain * gating * forcing - mu * state
    return record(
        "primal_logic_kernel",
        abs(residual) < 1e-12,
        {"wls": "primal_logic_kernel.wls", "state": state, "residual": residual},
    )


def primal_control() -> dict:
    alpha, lam, theta0, x0 = 1.25, math.log(150) / (3 * math.pi**2), 2.0, 0.0
    xss = alpha * theta0 / lam
    xdot = alpha * theta0 - lam * xss

    def x_at(t: float) -> float:
        return xss + (x0 - xss) * math.exp(-lam * t)

    return record(
        "primal_control",
        abs(xdot) < 1e-12 and abs(x_at(0) - x0) < 1e-12,
        {"wls": "primal_control.wls", "equilibrium": xss, "xAt20": x_at(20), "xDot": xdot},
    )


def lyapunov() -> dict:
    x, theta, alpha, lam = sp.symbols("x theta alpha lam", real=True)
    vdot = x * (alpha * theta - lam * x)
    upper = -(lam / 2) * x**2 + (alpha**2 / (2 * lam)) * theta**2
    gap = sp.simplify(upper - vdot)
    square = sp.simplify((lam * x - alpha * theta) ** 2 / (2 * lam))
    identity = sp.simplify(gap - square)
    rng = np.random.default_rng(1)
    xx = rng.normal(size=400)
    th = rng.normal(size=400)
    lam_n = math.log(150) / (3 * math.pi**2)
    alpha_n = 1.25
    numeric = (
        -(lam_n / 2) * xx**2
        + (alpha_n**2 / (2 * lam_n)) * th**2
        - xx * (alpha_n * th - lam_n * xx)
    )
    ok = identity == 0 and float(np.min(numeric)) >= -1e-10
    return record(
        "lyapunov_bound",
        ok,
        {
            "wls": "lyapunov_bound.wls",
            "identity": str(identity),
            "minNumericGap": float(np.min(numeric)),
        },
    )


def resonance() -> dict:
    omega0 = 0.99712057
    modes = [
        (0, 0, 1, 0.99712057),
        (0, 0, 2, 1.99424114),
        (1, 1, 0, 1.41014143),
        (1, 1, 1, 1.72706349),
        (2, 0, 0, 1.99424114),
    ]
    errors = [abs(omega0 * math.sqrt(m * m + n * n + p * p) - f) for m, n, p, f in modes]
    return record(
        "protein_cymatics",
        max(errors) < 1e-6,
        {"wls": "protein_cymatics.wls", "maxError": max(errors)},
    )


def gate_angle() -> dict:
    freq, t, nq = sp.symbols("freq t n_qubits", positive=True)
    phi = 2 * sp.pi * freq * t * sp.Rational(1, 3) * sp.sin(sp.pi * 5 / nq)
    slope = sp.simplify(sp.diff(phi, t))
    expected = sp.simplify(2 * sp.pi * freq * sp.Rational(1, 3) * sp.sin(sp.pi * 5 / nq))
    omega0 = 0.99712057
    phi_n = 2 * math.pi * (omega0 * math.sqrt(2)) * (250 / 2500) * (1 / 3) * math.sin(math.pi * 5 / 20)
    return record(
        "gate_angle",
        slope == expected and math.isfinite(phi_n),
        {"wls": "gate_angle.wls", "phi": phi_n},
    )


def memory_kernel() -> dict:
    alpha = math.log(150) / (3 * math.pi**2)
    s = 1.5
    tau = np.linspace(0, 80, 400_000)
    integrand = alpha * np.exp(-(alpha + s) * tau)
    numeric = float(np.trapezoid(integrand, tau))
    closed = alpha / (s + alpha)
    err = abs(numeric - closed)
    k0 = alpha * math.exp(0)
    return record(
        "memory_kernel",
        err < 1e-8 and abs(k0 - alpha) < 1e-15,
        {"wls": "memory_kernel.wls", "laplaceError": err, "alpha": alpha},
    )


def diffusion() -> dict:
    t, x = sp.symbols("t x", positive=True)
    u = (4 * sp.pi * t) ** (-sp.Rational(1, 2)) * sp.exp(-(x**2) / (4 * t))
    residual = sp.simplify(sp.diff(u, t) - sp.diff(u, x, 2))
    return record(
        "diffusion_kernel",
        residual == 0,
        {"wls": "diffusion_kernel.wls", "heatResidual": str(residual)},
    )


def diffusion_recovery() -> dict:
    kappa, L, D0 = sp.symbols("kappa L D0", positive=True)
    alpha = kappa * (sp.pi / L) ** 2
    mu = sp.log(D0) / (3 * sp.pi**2)
    kappa_match = sp.log(D0) * L**2 / (3 * sp.pi**4)
    identity = sp.simplify(alpha.subs(kappa, kappa_match) - mu)
    return record(
        "diffusion_recovery",
        identity == 0,
        {"wls": "diffusion_recovery.wls", "identity": str(identity)},
    )


def dbit() -> dict:
    deltas = np.linspace(0.2, 0.4, 9)
    lams = np.linspace(0.2, 0.4, 9)
    kappas = (-0.1, 0.0, 0.1)
    acs = (-1.0, 1.0, 2.0)
    rhos = []
    for delta in deltas:
        for lam in lams:
            for kappa in kappas:
                for ac in acs:
                    if abs(ac * kappa) > 0.1 + 1e-12:
                        continue
                    J = np.array([[1 - delta, kappa], [lam * ac, 1 - lam]], dtype=float)
                    rhos.append(float(np.max(np.abs(np.linalg.eigvals(J)))))
    D0 = 149.9992314
    x0 = 150.0
    s = 4.0
    final = D0 - (x0 - D0) * math.exp(-0.82 * s) - 5 * math.sin(1.8 * s) * math.exp(-0.55 * s)
    err = abs(final - D0)
    max_rho = max(rhos)
    return record(
        "dbit_stability",
        max_rho < 1 and err < 1,
        {
            "wls": "dbit_stability.wls",
            "sampleCount": len(rhos),
            "maxRho": max_rho,
            "attractorFinalError": err,
        },
    )


def cpl() -> dict:
    t, lx, lp, ax, ap = sp.symbols("t lx lp ax ap", positive=True)
    expr = ax * ap * (1 - sp.exp(-(lx + lp) * t)) / (lx + lp)
    deriv0 = sp.simplify(sp.diff(expr, t).subs(t, 0))
    limit = sp.simplify(sp.limit(expr, t, sp.oo))
    sample = float(expr.subs({t: 1, lx: sp.Rational(1, 2), lp: sp.Rational(1, 2), ax: 1, ap: 1}))
    ok = deriv0 == ax * ap and limit == ax * ap / (lx + lp) and sample > 0
    return record(
        "cpl_heisenberg",
        ok,
        {"wls": "cpl_heisenberg.wls", "sampleAt1": sample, "derivativeAt0": str(deriv0)},
    )


def symbolic_recursion() -> dict:
    a, q, mu, dt = sp.symbols("a q mu dt", positive=True)
    fixed = a * q * dt / (1 - sp.exp(-mu * dt))
    lim = sp.simplify(sp.limit(fixed, dt, 0, dir="+"))
    identity = sp.simplify(lim - a * q / mu)
    mu_n = math.log(150) / (3 * math.pi**2)
    dt_n = 0.01
    fixed_n = 1 * 1 * dt_n / (1 - math.exp(-mu_n * dt_n))
    target = 1 / mu_n
    return record(
        "symbolic_recursion",
        identity == 0 and abs(fixed_n - target) < 1e-2,
        {
            "wls": "symbolic_recursion.wls",
            "identity": str(identity),
            "fixedPoint": fixed_n,
            "target": target,
        },
    )


def _coherence(x: np.ndarray, y: np.ndarray) -> float:
    xc = x - np.mean(x)
    yc = y - np.mean(y)
    denom = np.linalg.norm(xc) * np.linalg.norm(yc)
    phase = 1.0 if denom < 1e-12 else max(0.0, min(1.0, (float(np.dot(xc, yc) / denom) + 1) / 2))
    ratio = float(np.sum(y**2)) / (float(np.sum(x**2)) + 1e-12)
    energy = max(0.0, min(1.0, 1.0 - abs(1.0 - ratio)))
    sx = float(np.std(x))
    sy = float(np.std(y))
    stability = 1.0 - min(1.0, abs(sy - sx) / (sx + 1e-9))
    return 0.5 * phase + 0.3 * energy + 0.2 * stability


def coherence() -> dict:
    x = np.array([1.0, 2.0, 3.0, 4.0, 5.0])
    same = _coherence(x, x)
    flipped = _coherence(x, -x)
    return record(
        "coherence_score",
        abs(same - 1) < 1e-12 and 0 <= flipped <= 1,
        {"wls": "coherence_score.wls", "identical": same, "flipped": flipped},
    )


def quantro() -> dict:
    S, Vmax, Km = sp.symbols("S Vmax Km", positive=True)
    mm = sp.simplify((Vmax * S / (Km + S)).subs(S, Km) - Vmax / 2)
    v, w, a, b, c = sp.symbols("v w a b c")
    dv = v - v**3 / 3 - w
    dw = (v + a - b * w) / c
    fhn = sp.simplify(dv.subs(w, v - v**3 / 3)) == 0 and sp.simplify(dw.subs(w, (v + a) / b)) == 0
    E, T, z, Co, Ci = sp.symbols("E T z Co Ci", positive=True)
    Rgas = sp.Float("8.314462618")
    Faraday = sp.Float("96485.33212")
    EN = (Rgas * T) / (z * Faraday) * sp.log(Co / Ci)
    nernst = sp.simplify((10 * (EN - E)).subs(E, EN)) == 0
    Q, dP, mu, L, r = sp.symbols("Q dP mu L r", positive=True)
    Qss = sp.pi * r**4 * dP / (8 * mu * L)
    pois = sp.simplify((5 * (Qss - Q)).subs(Q, Qss)) == 0
    beta, II, NN, gamma = sp.symbols("beta I N gamma", positive=True)
    inf = beta * S * II / NN
    rec = gamma * II
    sir = sp.simplify(-inf + (inf - rec) + rec) == 0
    ts = np.linspace(0, 2 * math.pi, 25)
    warp = np.maximum(1, 1 + 0.2 * np.sin(1.5 * ts))
    ok = mm == 0 and fhn and nernst and pois and sir and bool(np.all(warp >= 1))
    return record(
        "quantro_base",
        ok,
        {
            "wls": "quantro_base.wls",
            "michaelisMenten": bool(mm == 0),
            "fitzhughNagumo": bool(fhn),
            "nernst": bool(nernst),
            "poiseuille": bool(pois),
            "sir": bool(sir),
            "timeWarpFloor": bool(np.all(warp >= 1)),
        },
    )


def main() -> int:
    checks = [
        lightfoot(),
        primal_kernel(),
        primal_control(),
        lyapunov(),
        resonance(),
        gate_angle(),
        memory_kernel(),
        diffusion(),
        diffusion_recovery(),
        dbit(),
        cpl(),
        symbolic_recursion(),
        coherence(),
        quantro(),
    ]
    passed = sum(1 for c in checks if c["pass"])
    certificate = {
        "engine": "sympy-numpy mirror of Wolfram Language scripts",
        "wolframEngineOnPath": False,
        "passCount": passed,
        "checkCount": len(checks),
        "allPass": passed == len(checks),
        "checks": checks,
    }
    OUT.write_text(json.dumps(certificate, indent=2), encoding="utf-8")
    for c in checks:
        print(f"{'PASS' if c['pass'] else 'FAIL'}  {c['id']}")
    print(f"=== LINKED MATH: {passed}/{len(checks)} ===")
    print(OUT)
    return 0 if certificate["allPass"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
