using Pkg
tempdir = mktempdir()
Pkg.activate(tempdir)
Pkg.develop(PackageSpec(path=joinpath(@__DIR__, "..")))
Pkg.add(["BenchmarkTools", "SCS", "ECOS", "PkgBenchmark"])
Pkg.resolve()

using Convex: Convex, ProblemDepot
using SCS: SCSSolver
using ECOS: ECOSSolver
using BenchmarkTools


const SUITE = BenchmarkGroup()

problems =  Regex[r"constant_fix!_with_complex_numbers", r"affine_dot_multiply_atom", r"affine_hcat_atom",  r"affine_trace_atom", r"exp_entropy_atom", r"exp_log_perspective_atom", r"socp_norm_2_atom", r"socp_quad_form_atom", r"socp_sum_squares_atom", r"lp_norm_inf_atom", r"lp_maximum_atom", r"sdp_and_exp_log_det_atom", r"sdp_norm2_atom", r"sdp_lambda_min_atom", r"sdp_sum_largest_eigs", r"mip_integer_variables"]

SUITE["formulation"] = ProblemDepot.benchmark_suite(Convex.conic_problem; include=problems)
