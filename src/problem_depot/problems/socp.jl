
@add_problem socp function socp_norm_2_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable(2, 1)
    A = [1 2; 2 1; 3 4]
    b = [2; 3; 4]
    p = minimize(norm2(A * x + b))
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 0.64888 atol=atol rtol=rtol
        @test evaluate(norm2(A * x + b)) ≈ 0.64888 atol=atol rtol=rtol
    end

    x = Variable(2, 1)
    A = [1 2; 2 1; 3 4]
    b = [2; 3; 4]
    lambda = 1
    p = minimize(norm2(A * x + b) + lambda * norm2(x), x >= 1)
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 14.9049 atol=atol rtol=rtol
        @test evaluate(norm2(A * x + b) + lambda * norm2(x)) ≈ 14.9049 atol=atol rtol=rtol
    end

    x = Variable(2)

    p = minimize(norm2([x[1] + 2x[2] + 2; 2x[1] + x[2] + 3; 3x[1]+4x[2] + 4]) + lambda * norm2(x), x >= 1)
    if test
        @test vexity(p) == ConvexVexity()
    end

    handle_problem!(p)
    if test
        @test p.optval ≈ 14.9049 atol=atol rtol=rtol
        @test evaluate(norm2(A * x + b) + lambda * norm2(x)) ≈ 14.9049 atol=atol rtol=rtol
    end

    x = Variable(2, 1)
    A = [1 2; 2 1; 3 4]
    b = [2; 3; 4]
    lambda = 1
    p = minimize(norm2(A * x + b) + lambda * norm_1(x), x >= 1)
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 15.4907 atol=atol rtol=rtol
        @test evaluate(norm2(A * x + b) + lambda * norm_1(x)) ≈ 15.4907 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_frobenius_norm_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    m = Variable(4, 5)
    c = [m[3, 3] == 4, m >= 1]
    p = minimize(norm(vec(m), 2), c)
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ sqrt(35) atol=atol rtol=rtol
        @test evaluate(norm(vec(m), 2)) ≈ sqrt(35) atol=atol rtol=rtol
    end
end

@add_problem socp function socp_quad_over_lin_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable(3, 1)
    A = [2 -3 5; -2 9 -3; 5 -8 3]
    b = [-3; 9; 5]
    c = [3 2 4]
    d = -3
    p = minimize(quadoverlin(A*x + b, c*x + d))
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 17.7831 atol=atol rtol=rtol
        @test (evaluate(quadoverlin(A * x + b, c * x + d)))[1] ≈ 17.7831 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_sum_squares_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable(2, 1)
    A = [1 2; 2 1; 3 4]
    b = [2; 3; 4]
    p = minimize(sumsquares(A*x + b))
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 0.42105 atol=atol rtol=rtol
        @test (evaluate(sumsquares(A * x + b)))[1] ≈ 0.42105 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_square_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable(2, 1)
    A = [1 2; 2 1; 3 4]
    b = [2; 3; 4]
    p = minimize(sum(square(A*x + b)))
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 0.42105 atol=atol rtol=rtol
        @test evaluate(sum(square(A * x + b))) ≈ 0.42105 atol=atol rtol=rtol
    end

    x = Variable(2, 1)
    A = [1 2; 2 1; 3 4]
    b = [2; 3; 4]
    expr = A * x + b
    p = minimize(sum(dot(^)(expr,2))) # elementwise ^
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 0.42105 atol=atol rtol=rtol
        @test evaluate(sum(broadcast(^, expr, 2))) ≈ 0.42105 atol=atol rtol=rtol
    end

    p = minimize(sum(dot(*)(expr, expr))) # elementwise *
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 0.42105 atol=atol rtol=rtol
        @test evaluate(sum((dot(*))(expr, expr))) ≈ 0.42105 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_inv_pos_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable(4)
    p = minimize(sum(invpos(x)), invpos(x) < 2, x > 1, x == 2, 2 == x)
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 2 atol=atol rtol=rtol
        @test evaluate(sum(invpos(x))) ≈ 2 atol=atol rtol=rtol
    end

    x = Variable(3)
    p = minimize(sum(dot(/)([3,6,9], x)), x<=3)
    handle_problem!(p)
    if test
        @test x.value ≈ fill(3.0, (3, 1)) atol=atol rtol=rtol
        @test p.optval ≈ 6 atol=atol rtol=rtol
        @test evaluate(sum((dot(/))([3, 6, 9], x))) ≈ 6 atol=atol rtol=rtol
    end

    x = Variable()
    p = minimize(sum([3,6,9]/x), x<=3)
    handle_problem!(p)
    if test
        @test x.value ≈ 3 atol=atol rtol=rtol
        @test p.optval ≈ 6 atol=atol rtol=rtol
        @test evaluate(sum([3, 6, 9] / x)) ≈ 6 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_geo_mean_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable(2)
    y = Variable(2)
    p = minimize(geomean(x, y), x >= 1, y >= 2)
    # not DCP compliant
    if test
        @test vexity(p) == ConcaveVexity()
    end
    p = maximize(geomean(x, y), 1 < x, x < 2, y < 2)
    # Just gave it a vector as an objective, not okay
    if test
        @test_throws Exception handle_problem!(p)
    end

    p = maximize(sum(geomean(x, y)), 1 < x, x < 2, y < 2)
    handle_problem!(p)
    if test
        @test p.optval ≈ 4 atol=atol rtol=rtol
        @test evaluate(sum(geomean(x, y))) ≈ 4 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_sqrt_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable()
    p = maximize(sqrt(x), 1 >= x)
end

@add_problem socp function socp_quad_form_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable(3, 1)
    A = [0.8608 0.3131 0.5458; 0.3131 0.8584 0.5836; 0.5458 0.5836 1.5422]
    p = minimize(quadform(x, A), [x >= 1])
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 6.1464 atol=atol rtol=rtol
        @test (evaluate(quadform(x, A)))[1] ≈ 6.1464 atol=atol rtol=rtol
    end

    x = Variable(3, 1)
    A = -1.0*[0.8608 0.3131 0.5458; 0.3131 0.8584 0.5836; 0.5458 0.5836 1.5422]
    c = [3 2 4]
    p = maximize(c*x , [quadform(x, A) >= -1])
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 3.7713 atol=atol rtol=rtol
        @test (evaluate(quadform(x, A)))[1] ≈ -1 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_huber_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    x = Variable(3)
    p = minimize(sum(huber(x, 1)), x >= 2)
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    if test
        @test p.optval ≈ 9 atol=atol rtol=rtol
        @test evaluate(sum(huber(x, 1))) ≈ 9 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_rational_norm_atom(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    A = [1 2 3; -1 2 3]
    b = A * ones(3)
    x = Variable(3)
    p = minimize(norm(x, 4.5), [A * x == b])
    if test
        @test vexity(p) == ConvexVexity()
    end
    # Solution is approximately x = [1, .93138, 1.04575]
    handle_problem!(p)
    if test
        @test p.optval ≈ 1.2717 atol=atol rtol=rtol
        @test evaluate(norm(x, 4.5)) ≈ 1.2717 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_rational_norm_dual_norm(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    v = [0.463339, 0.0216084, -2.07914, 0.99581, 0.889391]
    x = Variable(5)
    q = 1.379;  # q norm constraint that generates many inequalities
    qs = q / (q - 1);  # Conjugate to q
    p = minimize(x' * v)
    p.constraints += (norm(x, q) <= 1)
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p) # Solution is -norm(v, q / (q - 1))
    if test
        @test p.optval ≈ -2.144087 atol=atol rtol=rtol
        @test sum(evaluate(x' * v)) ≈ -2.144087 atol=atol rtol=rtol
        @test evaluate(norm(x, q)) ≈ 1 atol=atol rtol=rtol
        @test sum(evaluate(x' * v)) ≈ -(sum(abs.(v) .^ qs) ^ (1 / qs)) atol=atol rtol=rtol
    end
end

@add_problem socp function socp_rational_norm_atom_sum(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    A = [-0.719255  -0.229089
        -1.33632   -1.37121
        0.703447  -1.4482]
    b = [-1.82041, -1.67516, -0.866884]
    q = 1.5
    xvar = Variable(2)
    p = minimize(.5 * sumsquares(xvar) + norm(A * xvar - b, q))
    if test
        @test vexity(p) == ConvexVexity()
    end
    handle_problem!(p)
    # Compute gradient, check it is zero(ish)
    x_opt = xvar.value
    margins = A * x_opt - b
    qs = q / (q - 1);  # Conjugate
    denom = sum(abs.(margins).^q)^(1/qs)
    g = x_opt + A' * (abs.(margins).^(q-1) .* sign.(margins)) / denom
    if test
        @test p.optval ≈ 1.7227 atol=atol rtol=rtol
        @test norm(g, 2) ^ 2 ≈ 0 atol=atol rtol=rtol
    end
end

@add_problem socp function socp_norm_consistent_with_Base_for_matrix_variables(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    A = randn(4, 4)
    x = Variable(4, 4)
    x.value = A
    # Matrix norm
    if test
        @test evaluate(opnorm(x)) ≈ opnorm(A) atol=atol rtol=rtol
        @test evaluate(opnorm(x, 1)) ≈ opnorm(A, 1) atol=atol rtol=rtol
        @test evaluate(opnorm(x, 2)) ≈ opnorm(A, 2) atol=atol rtol=rtol
        @test evaluate(opnorm(x, Inf)) ≈ opnorm(A, Inf) atol=atol rtol=rtol
    end
    # Vector norm
    # TODO: Once the deprecation for norm on matrices is removed, remove the `vec` calls
    if test
        @test evaluate(norm(vec(x), 1)) ≈ norm(vec(A), 1) atol=atol rtol=rtol
        @test evaluate(norm(vec(x), 2)) ≈ norm(vec(A), 2) atol=atol rtol=rtol
        @test evaluate(norm(vec(x), 7)) ≈ norm(vec(A), 7) atol=atol rtol=rtol
        @test evaluate(norm(vec(x), Inf)) ≈ norm(vec(A), Inf) atol=atol rtol=rtol
    end
end

@add_problem socp function socp_Fixed_and_freed_variables(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
    @add_problem socp function socp_fix_and_free_addition(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
        x = Variable()
        y = Variable()

        p = minimize(x+y, x>=0, y>=0)
        handle_problem!(p)
        if test
            @test p.optval ≈ 0 atol=atol rtol=rtol
        end

        y.value = 4
        fix!(y)
        handle_problem!(p)
        if test
            @test p.optval ≈ 4 atol=atol rtol=rtol
        end

        free!(y)
        handle_problem!(p)
        if test
            @test p.optval ≈ 0 atol=atol rtol=rtol
        end
    end

    @add_problem socp function socp_fix_multiplication(handle_problem!, ::Val{test}, atol, rtol, ::Type{T}) where {T, test}
        a = [1,2,3,2,1]
        x = Variable(length(a))
        gamma = Variable(Positive())
        fix!(gamma, 0.7)

        p = minimize(norm(x-a) + gamma*norm(x[1:end-1] - x[2:end]))
        handle_problem!(p)
        o1 = p.optval
        # x should be very close to a
        if test
            @test o1 ≈ 0.7 * norm(a[1:end - 1] - a[2:end]) atol=atol rtol=rtol
        end
        # increase regularization
        fix!(gamma, 1.0)
        handle_problem!(p)
        o2 = p.optval
        # x should be very close to mean(a)
        if test
            @test o2 ≈ norm(a .- mean(a)) atol=atol rtol=rtol
        end

        if test
            @test o1 <= o2
        end
    end
end
