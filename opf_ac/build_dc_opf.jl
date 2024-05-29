function build_dc_opf!(m::Model)
    # This function builds the polar form of a nonlinear AC power flow formulation

    # Create m.ext entries "variables", "expressions" and "constraints"
    m.ext[:variables] = Dict()
    m.ext[:expressions] = Dict()
    m.ext[:constraints] = Dict()

    # Extract sets
    N = m.ext[:sets][:N]
    N_sl = m.ext[:sets][:N_sl]
    B = m.ext[:sets][:B]
    B_ac_fr = m.ext[:sets][:B_ac_fr]
    B_ac_to = m.ext[:sets][:B_ac_to]
    G = m.ext[:sets][:G]
    G_ac = m.ext[:sets][:G_ac]
    L = m.ext[:sets][:L]
    L_ac = m.ext[:sets][:L_ac]
    B_ac = m.ext[:sets][:B_ac]
    B_arcs = m.ext[:sets][:B_arcs]
    S = m.ext[:sets][:S]
    S_ac = m.ext[:sets][:S_ac]

    # Extract parameters
    vamin = m.ext[:parameters][:vamin]
    vamax = m.ext[:parameters][:vamax]
    bb =  m.ext[:parameters][:bb] 
    gs =  m.ext[:parameters][:gs]
    smax = m.ext[:parameters][:smax]
    angmin = m.ext[:parameters][:angmin]
    angmax = m.ext[:parameters][:angmax]
    b_shift = m.ext[:parameters][:b_shift]
    b_tap = m.ext[:parameters][:b_tap]
    pd = m.ext[:parameters][:pd]
    pmax = m.ext[:parameters][:pmax]
    pmin = m.ext[:parameters][:pmin]
    gen_cost = m.ext[:parameters][:gen_cost]

    ##### Create variables 
    # Bus variables
    va = m.ext[:variables][:va] = @variable(m, [i=N], lower_bound = vamin[i], upper_bound = vamax[i], base_name = "va") # voltage angle

    # Generator variables
    pg = m.ext[:variables][:pg] = @variable(m, [g=G], lower_bound = pmin[g], upper_bound = pmax[g], base_name = "pg") # active and reactive

    # Branch variables
    pb = m.ext[:variables][:pb] = @variable(m, [(b,i,j) in B_ac], lower_bound = -smax[b], upper_bound = smax[b], base_name = "pb") # from side active power flow (i->j)

     
    ##### Objective

    m.ext[:objective] = @objective(m, Min,
                sum(gen_cost[g][1]*pg[g] + gen_cost[g][2]
                        for g in G))


    # Power flow constraints in from and to direction
    m.ext[:constraints][:pbij] = @constraint(m, [(b,i,j) = B_ac_fr], pb[(b, i, j)] ==  - bb[b] * (va[i] - va[j] - b_shift[b])/b_tap[b]) # active power i to j
    m.ext[:constraints][:pbji] = @constraint(m, [(b,j,i) = B_ac_to], pb[(b, j, i)] ==  - bb[b] * (va[j] - va[i] + b_shift[b])/b_tap[b]) # active power j to i


    # Thermal limits for the branches
    # m.ext[:constraints][:sij] = @constraint(m, [(b,i,j) = B_ac_fr], pb[(b, i, j)] <=  smax[b])
    # m.ext[:constraints][:sij] = @constraint(m, [(b,i,j) = B_ac_fr], pb[(b, i, j)] >= -smax[b])


    # Branch angle limits
    m.ext[:constraints][:thetaij] = @constraint(m, [(b,i,j) = B_ac_fr], va[i] - va[j] <= angmax[b])
    m.ext[:constraints][:thetaji] = @constraint(m, [(b,i,j) = B_ac_fr], va[i] - va[j] >= angmin[b])
    m.ext[:constraints][:thetaij] = @constraint(m, [(b,j,i) = B_ac_to], va[j] - va[i] <= angmax[b])
    m.ext[:constraints][:thetaji] = @constraint(m, [(b,j,i) = B_ac_to], va[j] - va[i] >= angmin[b])

    # Kirchhoff's current law, i.e., nodal power balance
    if isempty(S)
        m.ext[:constraints][:p_balance] = @constraint(m, [i in N], sum(pg[g] for g in G_ac[i]) - sum(pd[l] for l in L_ac[i]) == sum(pb[(b,i,j)] for (b,i,j) in B_arcs[i]) )
    else
        m.ext[:constraints][:p_balance] = @constraint(m, [i in N], sum(pg[g] for g in G_ac[i]) - sum(pd[l] for l in L_ac[i]) - sum(gs[s] for s in S_ac[i]) == sum(pb[(b,i,j)] for (b,i,j) in B_arcs[i]) )
    end
    # Voltage angle on reference bus = 0, reference bus is bus 4 in this case
    m.ext[:constraints][:varef] = @constraint(m, [n_sl in N_sl], va[n_sl] == 0)
    
    return m 
end
