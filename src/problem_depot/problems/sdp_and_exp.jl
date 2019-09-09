
@add_problem sdp_and_exp function sdp_and_exp_log_det_atom(handle_problem!, valtest::Val{test} = Val(false), atol=1e-3, rtol=0.0, typ::Type{T} = Float64) where {T, test}
    x = Variable(2, 2)
    p = maximize(logdet(x), [x[1, 1] == 1, x[2, 2] == 1])
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 0 atol=10atol rtol=rtol
        @test evaluate(logdet(x)) ≈ 0 atol=10atol rtol=rtol
    end
end
