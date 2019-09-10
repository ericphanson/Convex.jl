using Convex
using Convex.ProblemDepot: run_tests
using Test
using SCS, ECOS, GLPKMathProgInterface


# Seed random number stream to improve test reliability
using Random
Random.seed!(2)

@testset "ProblemDepot" begin
    @testset "Problems can run without `solve!`ing if `test==false`" begin
        Convex.ProblemDepot.foreach_problem() do name, func
            @testset "$name" begin
                # We want to check to make sure this does not throw
                func(Convex.conic_problem, Val(false), 0.0, 0.0, Float64)
                @test true
            end
        end
    end
end

@testset "Convex with MOI" begin
    include("test_moi.jl")
end

@testset "Convex" begin
    include("test_utilities.jl")

    @testset "MPB" begin
        @testset "SCS via MPB" begin
            run_tests(; exclude=[r"mip"]) do p
                solve!(p, SCSSolver(verbose=0, eps=1e-6))
            end
        end

        @testset "ECOS via MPB" begin
            run_tests(; exclude=[r"mip", r"sdp"]) do p
                solve!(p, ECOSSolver(verbose=0))
            end
        end

        @testset "GLPK MIP via MPB" begin
            run_tests(; exclude=[r"socp", r"sdp", r"exp"]) do p
                solve!(p, GLPKSolverMIP())
            end
        end
    end

    @testset "MOI" begin
        @testset "SCS via MOI" begin
            run_tests(; exclude=[r"mip"]) do p
                solve!(p, SCS.Optimizer(verbose=0, eps=1e-6))
            end
        end

        @testset "ECOS via MOI" begin
            run_tests(; exclude=[r"mip", r"sdp"]) do p
                solve!(p, ECOS.Optimizer(verbose=0))
            end
        end
    end
end
