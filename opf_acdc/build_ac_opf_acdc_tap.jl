function build_ac_opf_acdc_tap!(m::Model)
    # This function builds the polar form of a nonlinear AC power flow formulation

    # Create m.ext entries "variables", "expressions" and "constraints"
    m.ext[:variables] = Dict()
    m.ext[:expressions] = Dict()
    m.ext[:constraints] = Dict()

    # Extract sets
    # AC network
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
    bus_ij = m.ext[:sets][:bus_ij]
    bus_ji = m.ext[:sets][:bus_ji]
    bus_ij_ji = m.ext[:sets][:bus_ij_ji]

    # DC network
    CV = m.ext[:sets][:CV]
    ND = m.ext[:sets][:ND]
    BD = m.ext[:sets][:BD]
    ND_arcs = m.ext[:sets][:ND_arcs]
    CV_arcs = m.ext[:sets][:CV_arcs]   
    BD_dc_fr = m.ext[:sets][:BD_dc_fr]
    BD_dc_to = m.ext[:sets][:BD_dc_to]
    BD_dc = m.ext[:sets][:BD_dc]

    busdc_ij = m.ext[:sets][:busdc_ij]
    busdc_ji = m.ext[:sets][:busdc_ji]

    # Extract parameters
    # AC network
    gen_bus = m.ext[:parameters][:gen_bus]
    load_bus = m.ext[:parameters][:load_bus]
    shunt_bus = m.ext[:parameters][:shunt_bus]
    vmmin = m.ext[:parameters][:vmmin]
    vmmax = m.ext[:parameters][:vmmax]
    vamin = m.ext[:parameters][:vamin]
    vamax = m.ext[:parameters][:vamax]
    rb =  m.ext[:parameters][:rb]
    xb =  m.ext[:parameters][:xb] 
    gb =  m.ext[:parameters][:gb]
    bb =  m.ext[:parameters][:bb] 
    gs =  m.ext[:parameters][:gs]
    bs =  m.ext[:parameters][:bs] 
    gfr = m.ext[:parameters][:gb_sh_fr]
    bfr = m.ext[:parameters][:bb_sh_fr]
    gto = m.ext[:parameters][:gb_sh_to]
    bto = m.ext[:parameters][:bb_sh_to]
    smax = m.ext[:parameters][:smax]
    angmin = m.ext[:parameters][:angmin]
    angmax = m.ext[:parameters][:angmax]
    b_shift = m.ext[:parameters][:b_shift]
    b_tap = m.ext[:parameters][:b_tap]
    pd = m.ext[:parameters][:pd]
    qd = m.ext[:parameters][:qd]
    pmax = m.ext[:parameters][:pmax]
    pmin = m.ext[:parameters][:pmin]
    qmax = m.ext[:parameters][:qmax]
    qmin = m.ext[:parameters][:qmin]
    gen_cost = m.ext[:parameters][:gen_cost]
    ij_ji_ang_max = m.ext[:parameters][:ij_ji_ang_max]
    ij_ji_ang_min = m.ext[:parameters][:ij_ji_ang_min]

    # DC network
    # DC bus
    busdc_vm_max = m.ext[:parameters][:busdc][:vm_max]
    busdc_vm_min = m.ext[:parameters][:busdc][:vm_min]
    busdc_vm_set = m.ext[:parameters][:busdc][:vm_set]
    busdc_c = m.ext[:parameters][:busdc][:c]
    busdc_p = m.ext[:parameters][:busdc][:p]

    # Converters
    conv_busdc = m.ext[:parameters][:convdc][:busdc]
    conv_bus = m.ext[:parameters][:convdc][:bus]
    conv_status = m.ext[:parameters][:convdc][:status]
    conv_loss_a = m.ext[:parameters][:convdc][:loss_a]
    conv_loss_b = m.ext[:parameters][:convdc][:loss_b]
    conv_loss_c_inv = m.ext[:parameters][:convdc][:loss_c_inv]
    conv_loss_c_rec = m.ext[:parameters][:convdc][:loss_c_rec]
    conv_p_ac_max = m.ext[:parameters][:convdc][:p_ac_max]
    conv_p_ac_min = m.ext[:parameters][:convdc][:p_ac_min]
    conv_q_ac_max = m.ext[:parameters][:convdc][:q_ac_max]
    conv_q_ac_min = m.ext[:parameters][:convdc][:q_ac_min]
    conv_p_dc_max = m.ext[:parameters][:convdc][:p_dc_max]
    conv_p_dc_min = m.ext[:parameters][:convdc][:p_dc_min]
    conv_droop = m.ext[:parameters][:convdc][:droop]
    conv_i_max = m.ext[:parameters][:convdc][:i_max]
    conv_vm_min = m.ext[:parameters][:convdc][:vm_min]
    conv_vm_max = m.ext[:parameters][:convdc][:vm_max]
    conv_vm_dc_set = m.ext[:parameters][:convdc][:vm_dc_set]
    conv_p_g = m.ext[:parameters][:convdc][:p_g]
    conv_q_g = m.ext[:parameters][:convdc][:q_g]
    conv_b_f = m.ext[:parameters][:convdc][:b_f]
    conv_tf_r = m.ext[:parameters][:convdc][:r_tf]
    conv_tf_g = m.ext[:parameters][:convdc][:g_tf]
    conv_tf_x = m.ext[:parameters][:convdc][:x_tf]
    conv_tf_b = m.ext[:parameters][:convdc][:b_tf]
    conv_pr_r = m.ext[:parameters][:convdc][:r_pr]
    conv_pr_g = m.ext[:parameters][:convdc][:g_pr]
    conv_pr_x = m.ext[:parameters][:convdc][:x_pr]
    conv_pr_b = m.ext[:parameters][:convdc][:b_pr]
    conv_tf_tap = m.ext[:parameters][:convdc][:tap_tf]
    conv_is_tf = m.ext[:parameters][:convdc][:is_tf]
    conv_is_pr = m.ext[:parameters][:convdc][:is_pr]
    conv_is_filter = m.ext[:parameters][:convdc][:is_filter]

    # DC branches
    brdc_rate_a = m.ext[:parameters][:branchdc][:rate_a]
    brdc_rate_b = m.ext[:parameters][:branchdc][:rate_b]
    brdc_rate_c = m.ext[:parameters][:branchdc][:rate_c]
    brdc_status = m.ext[:parameters][:branchdc][:status]
    brdc_r = m.ext[:parameters][:branchdc][:r]
    brdc_g = m.ext[:parameters][:branchdc][:g]
    brdc_l = m.ext[:parameters][:branchdc][:l]
    brdc_dcpoles = m.ext[:parameters][:branchdc][:dcpoles]

    ##### Create variables 
    # AC components
    # Bus variables
    vm = m.ext[:variables][:vm] = @variable(m, [i=N], lower_bound = vmmin[i], upper_bound = vmmax[i], base_name = "vm") # voltage magnitude
    va = m.ext[:variables][:va] = @variable(m, [i=N], lower_bound = vamin[i], upper_bound = vamax[i], base_name = "va") # voltage angle

    # Generator variables
    pg = m.ext[:variables][:pg] = @variable(m, [g=G], lower_bound = pmin[g], upper_bound = pmax[g], base_name = "pg") # active and reactive
    qg = m.ext[:variables][:qg] = @variable(m, [g=G], lower_bound = qmin[g], upper_bound = qmax[g], base_name = "qg") # voltage angle

    # Branch variables
    pb = m.ext[:variables][:pb] = @variable(m, [(b,i,j) in B_ac], base_name = "pb") # from side active power flow (i->j)
    qb = m.ext[:variables][:qb] = @variable(m, [(b,i,j) in B_ac], base_name = "qb") # from side reactive power flow (i->j)
     
    # DC components
    # Buses
    busdc_vm = m.ext[:variables][:busdc_vm] = @variable(m, [nd=ND], lower_bound=busdc_vm_min[nd], upper_bound=busdc_vm_max[nd], base_name="busdc_vm")
    
    # Branches
    brdc_p = m.ext[:variables][:brdc_p] = @variable(m, [(d,e,f)=BD_dc], lower_bound=-brdc_rate_a[d], upper_bound=brdc_rate_a[d], base_name="brdc_p")
    brdc_p_loss = m.ext[:variables][:brdc_p_loss] = @variable(m, [(d,e,f)=BD_dc], base_name="brdc_p_loss")

    # Converters
    conv_p_ac = m.ext[:variables][:conv_p_ac] = @variable(m, [cv=CV], lower_bound=conv_p_ac_min[cv], upper_bound=conv_p_ac_max[cv], base_name="conv_p_ac") # converter active power
    conv_q_ac = m.ext[:variables][:conv_q_ac] = @variable(m, [cv=CV], lower_bound=conv_q_ac_min[cv], upper_bound=conv_q_ac_max[cv], base_name="conv_q_ac") # converter reactive power
    conv_p_dc = m.ext[:variables][:conv_p_dc] = @variable(m, [cv=CV], lower_bound=conv_p_dc_min[cv], upper_bound=conv_p_dc_max[cv], base_name="conv_p_dc") # converter active power
    
    conv_im = m.ext[:variables][:conv_im] = @variable(m, [cv=CV], lower_bound = 0,
                            upper_bound = conv_i_max[cv], base_name="conv_im") # converter ac-side current
    
    conv_tap = m.ext[:variables][:conv_tap] = @variable(m, [cv=CV], lower_bound = 0.9, upper_bound = 1.1, base_name = "conv_tap") # converter active power
    
    
    # conv_im = m.ext[:variables][:conv_im] = @variable(m, [cv=CV], lower_bound = 0, base_name="conv_im") # converter ac-side current
    conv_im_dc = m.ext[:variables][:conv_im_dc] = @variable(m, [cv=CV], base_name="conv_im_dc") # converter dc-side current
    power_scale = 2
    conv_p_ac_grid = m.ext[:variables][:conv_p_ac_grid] = @variable(m, [cv=CV], lower_bound=power_scale*conv_p_ac_min[cv], upper_bound=power_scale*conv_p_ac_max[cv], base_name="conv_p_ac_grid") # converter active power to the grid
    conv_q_ac_grid = m.ext[:variables][:conv_q_ac_grid] = @variable(m, [cv=CV], lower_bound=power_scale*conv_q_ac_min[cv], upper_bound=power_scale*conv_q_ac_max[cv], base_name="conv_q_ac_grid") # converter reactive power to the grid
    conv_tf_p_cie = m.ext[:variables][:conv_tf_p_cie] = @variable(m, [cv=CV], lower_bound=power_scale*conv_p_ac_min[cv], upper_bound=power_scale*conv_p_ac_max[cv],base_name="conv_tf_p_cie")
    conv_tf_q_cie = m.ext[:variables][:conv_tf_q_cie] = @variable(m, [cv=CV], lower_bound=power_scale*conv_q_ac_min[cv], upper_bound=power_scale*conv_q_ac_max[cv],base_name="conv_tf_q_cie")
    conv_tf_p_cei = m.ext[:variables][:conv_tf_p_cei] = @variable(m, [cv=CV], lower_bound=power_scale*conv_p_ac_min[cv], upper_bound=power_scale*conv_p_ac_max[cv],base_name="conv_tf_p_cei")
    conv_tf_q_cei = m.ext[:variables][:conv_tf_q_cei] = @variable(m, [cv=CV], lower_bound=power_scale*conv_q_ac_min[cv], upper_bound=power_scale*conv_q_ac_max[cv],base_name="conv_tf_q_cei")
    conv_pr_p_cie = m.ext[:variables][:conv_pr_p_cie] = @variable(m, [cv=CV], lower_bound=power_scale*conv_p_ac_min[cv], upper_bound=power_scale*conv_p_ac_max[cv],base_name="conv_pr_p_cie")
    conv_pr_q_cie = m.ext[:variables][:conv_pr_q_cie] = @variable(m, [cv=CV], lower_bound=power_scale*conv_q_ac_min[cv], upper_bound=power_scale*conv_q_ac_max[cv],base_name="conv_pr_q_cie")
    conv_pr_p_cei = m.ext[:variables][:conv_pr_p_cei] = @variable(m, [cv=CV], lower_bound=power_scale*conv_p_ac_min[cv], upper_bound=power_scale*conv_p_ac_max[cv],base_name="conv_pr_p_cei")
    conv_pr_q_cei = m.ext[:variables][:conv_pr_q_cei] = @variable(m, [cv=CV], lower_bound=power_scale*conv_q_ac_min[cv], upper_bound=power_scale*conv_q_ac_max[cv],base_name="conv_pr_q_cei")
    conv_vm_f = m.ext[:variables][:conv_vm_f] = @variable(m, lower_bound=0.9/1.2, upper_bound=1.1*1.2, [cv=CV], base_name="conv_vm_f")
    conv_va_f = m.ext[:variables][:conv_va_f] = @variable(m, lower_bound=-2*pi, upper_bound=2*pi, [cv=CV], base_name="conv_va_f")
    conv_vm = m.ext[:variables][:conv_vm] = @variable(m, [cv=CV], lower_bound=conv_vm_min[cv], upper_bound=conv_vm_max[cv], base_name="conv_vm")
    conv_va = m.ext[:variables][:conv_va] = @variable(m, [cv=CV], lower_bound=-2*pi, upper_bound=2*pi, base_name="conv_va")

    ##### Objective
    max_gen_ncost = m.ext[:parameters][:gen_max_ncost]
    if max_gen_ncost == 1
        m.ext[:objective] = @objective(m, Min,
                sum(gen_cost[g][1]
                        for g in G)
        )
    elseif max_gen_ncost == 2
        m.ext[:objective] = @objective(m, Min,
                sum(gen_cost[g][1]*pg[g] + gen_cost[g][2]
                        for g in G)
        )
    elseif max_gen_ncost == 3
        m.ext[:objective] = @NLobjective(m, Min,
                sum(gen_cost[g][1]*pg[g]^2 + gen_cost[g][2]*pg[g] + gen_cost[g][3]
                        for g in G)
        )
    elseif max_gen_ncost == 4
        m.ext[:objective] = @NLobjective(m, Min,
                sum(gen_cost[g][1]*pg[g]^3 + gen_cost[g][2]*pg[g]^2 + gen_cost[g][3]*pg[g] + gen_cost[g][4]
                        for g in G)
        )
    end

    ####################################################################################################
    ####################    AC NETWORK AND AC/DC CONSTRAINTS
    ####################################################################################################
    
    # Power flow constraints in from and to direction
    m.ext[:constraints][:pbij] = @NLconstraint(m, [(b,i,j) = B_ac_fr],
        pb[(b, i, j)] == 
        (gb[b] + gfr[b])*vm[i]^2/b_tap[b]^2
        - (gb[b] * vm[i] * vm[j] * cos(va[i] - va[j] - b_shift[b]))/b_tap[b]
        - (bb[b] * vm[i] * vm[j] * sin(va[i] - va[j] - b_shift[b]))/b_tap[b]
    ) # active power i to j
    m.ext[:constraints][:qbij] = @NLconstraint(m, [(b,i,j) = B_ac_fr],
        qb[(b, i, j)] ==
        -(bb[b] + bfr[b])*vm[i]^2/b_tap[b]^2
        + (bb[b] * vm[i] * vm[j] * cos(va[i] - va[j] - b_shift[b]))/b_tap[b]
        - (gb[b] * vm[i] * vm[j] * sin(va[i] - va[j] - b_shift[b]))/b_tap[b]
    ) # reactive power i to j
    m.ext[:constraints][:pbji] = @NLconstraint(m, [(b,j,i) = B_ac_to],
        pb[(b, j, i)] ==
        (gb[b] + gto[b])*(vm[j])^2
        - (gb[b] * vm[j] * vm[i] * cos(va[j] - va[i] + b_shift[b]))/b_tap[b]
        - (bb[b] * vm[j] * vm[i] * sin(va[j] - va[i] + b_shift[b]))/b_tap[b]
    ) # active power j to i
    m.ext[:constraints][:qbji] = @NLconstraint(m, [(b,j,i) = B_ac_to],
        qb[(b, j, i)] ==
        -(bb[b] + bto[b])*(vm[j])^2
        + (bb[b] * vm[j] * vm[i] * cos(va[j] - va[i] + b_shift[b]))/b_tap[b]
        - (gb[b] * vm[j] * vm[i] * sin(va[j] - va[i] + b_shift[b]))/b_tap[b]
    ) # reactive power j to i

    # Thermal limits for the branches
    m.ext[:constraints][:sij] = @NLconstraint(m, [(b,i,j) = B_ac], pb[(b, i, j)]^2 + qb[(b, i, j)]^2 <= smax[b]^2)
    
    # Bus angle difference limits
    m.ext[:constraints][:ang_ij_lb] = @constraint(m, [(i,j) = bus_ij_ji],
        ij_ji_ang_min[(i,j)] <= va[i] - va[j])
    m.ext[:constraints][:ang_ij_ub] = @constraint(m, [(i,j) = bus_ij_ji],
        va[i] - va[j] <= ij_ji_ang_max[(i,j)])

    # Voltage angle on reference bus = 0
    m.ext[:constraints][:varef] = @constraint(m, [n_sl in N_sl], va[n_sl] == 0)
    
    # Converter station power flow constraints
    # Transformer
    m.ext[:constraints][:p_grid_tf] = Dict()
    m.ext[:constraints][:q_grid_tf] = Dict()
    m.ext[:constraints][:p_tf_cie] = Dict()
    m.ext[:constraints][:q_tf_cie] = Dict()
    m.ext[:constraints][:p_tf_cei] = Dict()
    m.ext[:constraints][:q_tf_cei] = Dict()

    for cv in CV
        if conv_is_tf[cv] == 0
            m.ext[:constraints][:p_grid_tf][cv] = @constraint(m, 
                conv_p_ac_grid[cv] - conv_tf_p_cie[cv] == 0
            ) # OK
            m.ext[:constraints][:q_grid_tf][cv] = @constraint(m, 
                conv_q_ac_grid[cv] - conv_tf_q_cie[cv] == 0 
            ) # OK
            m.ext[:constraints][:p_tf_cie][cv] = @constraint(m, 
                conv_tf_p_cie[cv] + conv_tf_p_cei[cv] == 0
            ) # OK
            m.ext[:constraints][:q_tf_cie][cv] = @constraint(m, 
                conv_tf_q_cie[cv] + conv_tf_q_cei[cv] == 0 
            ) # OK
            @constraint(m, 
                vm[conv_bus[cv]] == conv_vm_f[cv])
            @constraint(m, 
                va[conv_bus[cv]] == conv_va_f[cv])
        else
            m.ext[:constraints][:p_grid_tf][cv] = @constraint(m, 
                conv_p_ac_grid[cv] - conv_tf_p_cie[cv] == 0
            ) # OK
            m.ext[:constraints][:q_grid_tf][cv] = @constraint(m, 
                conv_q_ac_grid[cv] - conv_tf_q_cie[cv] == 0 
            ) # OK
            m.ext[:constraints][:p_tf_cie][cv] = @NLconstraint(m, 
                conv_tf_p_cie[cv] == 
                (conv_tf_g[cv])*(vm[conv_bus[cv]]/conv_tap[cv])^2
                -(conv_tf_g[cv] * (vm[conv_bus[cv]]/conv_tap[cv]) * conv_vm_f[cv] * cos(va[conv_bus[cv]] - conv_va_f[cv]))
                -(conv_tf_b[cv] * (vm[conv_bus[cv]]/conv_tap[cv]) * conv_vm_f[cv] * sin(va[conv_bus[cv]] - conv_va_f[cv]))
            ) # OK
            m.ext[:constraints][:q_tf_cie][cv] = @NLconstraint(m, 
                conv_tf_q_cie[cv] == 
                -(conv_tf_b[cv])*(vm[conv_bus[cv]]/conv_tap[cv])^2
                +(conv_tf_b[cv] * (vm[conv_bus[cv]]/conv_tap[cv]) * conv_vm_f[cv] * cos(va[conv_bus[cv]] - conv_va_f[cv]))
                -(conv_tf_g[cv] * (vm[conv_bus[cv]]/conv_tap[cv]) * conv_vm_f[cv] * sin(va[conv_bus[cv]] - conv_va_f[cv]))
            ) # OK
            m.ext[:constraints][:p_tf_cei][cv] = @NLconstraint(m, 
                conv_tf_p_cei[cv] == 
                (conv_tf_g[cv])*(conv_vm_f[cv])^2
                -(conv_tf_g[cv] * (vm[conv_bus[cv]]/conv_tap[cv]) * conv_vm_f[cv] * cos(conv_va_f[cv] - va[conv_bus[cv]]))
                -(conv_tf_b[cv] * (vm[conv_bus[cv]]/conv_tap[cv]) * conv_vm_f[cv] * sin(conv_va_f[cv] - va[conv_bus[cv]]))
            ) # OK
            m.ext[:constraints][:q_tf_cei][cv] = @NLconstraint(m, 
                conv_tf_q_cei[cv] == 
                -(conv_tf_b[cv])*(conv_vm_f[cv])^2
                +(conv_tf_b[cv] * (vm[conv_bus[cv]]/conv_tap[cv]) * conv_vm_f[cv] * cos(conv_va_f[cv] - va[conv_bus[cv]]))
                -(conv_tf_g[cv] * (vm[conv_bus[cv]]/conv_tap[cv]) * conv_vm_f[cv] * sin(conv_va_f[cv] - va[conv_bus[cv]]))
            ) # OK
        end
    end
    # Filter
    # Phase reactor
    m.ext[:constraints][:p_tf_pr] = Dict()
    m.ext[:constraints][:q_tf_pr] = Dict()
    m.ext[:constraints][:p_pr_cie] = Dict()
    m.ext[:constraints][:q_pr_cie] = Dict()
    m.ext[:constraints][:p_pr_cei] = Dict()
    m.ext[:constraints][:q_pr_cei] = Dict()
    m.ext[:constraints][:p_pr_conv] = Dict()
    m.ext[:constraints][:q_pr_conv] = Dict()

    for cv in CV
        if conv_is_filter[cv] == 0
            m.ext[:constraints][:q_tf_pr][cv] = @constraint(m, 
                conv_tf_q_cei[cv] + conv_pr_q_cie[cv] == 0
            ) # OK
        elseif conv_is_filter[cv] == 1
            m.ext[:constraints][:q_tf_pr][cv] = @NLconstraint(m, 
                conv_tf_q_cei[cv] + conv_pr_q_cie[cv] - conv_b_f[cv]*(conv_vm_f[cv])^2  == 0
            ) # OK
        end
        if conv_is_pr[cv] == 0
            m.ext[:constraints][:p_tf_pr][cv] = @constraint(m, 
                conv_tf_p_cei[cv] + conv_pr_p_cie[cv] == 0
            ) # OK
            m.ext[:constraints][:p_pr_cie][cv] = @constraint(m, 
                conv_pr_p_cei[cv] + conv_pr_p_cie[cv] == 0
            ) # OK
            m.ext[:constraints][:q_pr_cie][cv] = @constraint(m, 
                conv_pr_q_cei[cv] + conv_pr_q_cie[cv] == 0
            ) # OK
            m.ext[:constraints][:p_pr_cei][cv] = @constraint(m, 
                conv_p_ac[cv] + conv_pr_p_cei[cv] == 0
            ) # OK
            m.ext[:constraints][:q_pr_cei][cv] = @constraint(m, 
                conv_q_ac[cv] + conv_pr_q_cei[cv] == 0
            ) # OK
            @constraint(m, 
                conv_vm[cv] == conv_vm_f[cv])
            @constraint(m, 
                conv_va[cv] == conv_va_f[cv])
        else
            m.ext[:constraints][:p_tf_pr][cv] = @constraint(m, 
                conv_tf_p_cei[cv] + conv_pr_p_cie[cv] == 0
            ) # OK
            m.ext[:constraints][:p_pr_cie][cv] = @NLconstraint(m, 
                conv_pr_p_cie[cv] == 
                (conv_pr_g[cv])*(conv_vm_f[cv])^2
                -(conv_pr_g[cv] * (conv_vm[cv]) * conv_vm_f[cv] * cos(conv_va_f[cv] - conv_va[cv]))
                -(conv_pr_b[cv] * (conv_vm[cv]) * conv_vm_f[cv] * sin(conv_va_f[cv] - conv_va[cv]))
            ) # OK
            m.ext[:constraints][:q_pr_cie][cv] = @NLconstraint(m, 
                conv_pr_q_cie[cv] == 
                -(conv_pr_b[cv])*(conv_vm_f[cv])^2
                +(conv_pr_b[cv] * (conv_vm[cv]) * conv_vm_f[cv] * cos(conv_va_f[cv] - conv_va[cv]))
                -(conv_pr_g[cv] * (conv_vm[cv]) * conv_vm_f[cv] * sin(conv_va_f[cv] - conv_va[cv]))
            ) # OK
            m.ext[:constraints][:p_pr_cei][cv] = @NLconstraint(m, 
                conv_pr_p_cei[cv] == 
                (conv_pr_g[cv])*(conv_vm[cv])^2
                -(conv_pr_g[cv] * (conv_vm[cv]) * conv_vm_f[cv] * cos(conv_va[cv] - conv_va_f[cv]))
                -(conv_pr_b[cv] * (conv_vm[cv]) * conv_vm_f[cv] * sin(conv_va[cv] - conv_va_f[cv]))
            ) # OK
            m.ext[:constraints][:q_pr_cei][cv] = @NLconstraint(m, 
                conv_pr_q_cei[cv] == 
                -(conv_pr_b[cv])*(conv_vm[cv])^2
                +(conv_pr_b[cv] * (conv_vm[cv]) * conv_vm_f[cv] * cos(conv_va[cv] - conv_va_f[cv]))
                -(conv_pr_g[cv] * (conv_vm[cv]) * conv_vm_f[cv] * sin(conv_va[cv] - conv_va_f[cv]))
            ) # OK
            m.ext[:constraints][:p_pr_conv][cv] = @constraint(m, 
                conv_p_ac[cv] + conv_pr_p_cei[cv] == 0
            ) # OK
            m.ext[:constraints][:q_pr_conv][cv] = @constraint(m, 
                conv_q_ac[cv] + conv_pr_q_cei[cv] == 0
            ) # OK
        end
    end

    # Converter AC-side converter power - Constraint converter current - OK
    m.ext[:constraints][:conv_p_ac] = @NLconstraint(m, [cv=CV],
        conv_p_ac[cv]^2 + conv_q_ac[cv]^2 == conv_vm[cv]^2 * conv_im[cv]^2
    )

    # DC grid
    # DC grid power flow model - OK
    m.ext[:constraints][:p_dc_def] = @NLconstraint(m, [(d,e,f)=BD_dc_fr],
        brdc_p[(d,e,f)] == brdc_dcpoles[d]*brdc_g[d]*busdc_vm[e]*(busdc_vm[e]-busdc_vm[f])*brdc_status[d]
    )
    m.ext[:constraints][:p_dc_dfe] = @NLconstraint(m, [(d,f,e)=BD_dc_to],
        brdc_p[(d,f,e)] == brdc_dcpoles[d]*brdc_g[d]*busdc_vm[f]*(busdc_vm[f]-busdc_vm[e])*brdc_status[d]
    )
    m.ext[:expressions][:p_dc_def] = @NLexpression(m, [(d,e,f)=BD_dc_fr],
        brdc_dcpoles[d]*brdc_g[d]*busdc_vm[e]*(busdc_vm[e]-busdc_vm[f])*brdc_status[d]
    )
    m.ext[:expressions][:p_dc_dfe] = @NLexpression(m, [(d,f,e)=BD_dc_to],
        brdc_dcpoles[d]*brdc_g[d]*busdc_vm[f]*(busdc_vm[f]-busdc_vm[e])*brdc_status[d]
    )

    # Converter constraints - OK
    # AC and DC side link via converter losses
    m.ext[:constraints][:conv_p_ac_dc] = @NLconstraint(m, [cv=CV],
        conv_p_ac[cv] + conv_p_dc[cv] == conv_loss_a[cv] + conv_loss_b[cv]*conv_im[cv] + conv_loss_c_inv[cv]*conv_im[cv]^2
    )
    m.ext[:expressions][:conv_p_loss] = @expression(m, [cv=CV],
        conv_p_ac[cv] + conv_p_dc[cv]
    )

    # Nodal power balance AC - Active power - OK
    m.ext[:constraints][:nodal_p_ac_balance] = @NLconstraint(m, [n=N],
        sum(pg[g] for g in G if gen_bus[g] == n)
        - sum(conv_p_ac_grid[cv] for cv in CV if conv_bus[cv] == n)
        - sum(pb[(br,i,j)] for (br,i,j) in B_arcs[n])
        - sum(pd[l] for l in L if load_bus[l] == n)
        - sum(gs[shunt_bus[s]]*vm[n]^2 for s in S if shunt_bus[s] == ma)
        == 0)

    # Nodal power balance AC - Reactive power - OK
    m.ext[:constraints][:nodal_q_ac_balance] = @NLconstraint(m, [n=N],
        sum(qg[g] for g in G if gen_bus[g] == n)
        - sum(conv_q_ac_grid[cv] for cv in CV if conv_bus[cv] == n)
        - sum(qb[(br,i,j)] for (br,i,j) in B_arcs[n])
        - sum(qd[l] for l in L if load_bus[l] == n)
        + sum(bs[shunt_bus[s]]*vm[n]^2 for s in S if shunt_bus[sh] == n)
        == 0)
    
    # Nodal power balance DC
    m.ext[:constraints][:nodal_p_dc_balance] = @constraint(m, [nd=ND],
        - sum(conv_p_dc[cv] for cv in CV if conv_busdc[cv] == nd)
        - sum(brdc_p[(d,f,e)] for (d,f,e) in ND_arcs[nd])
        == 0)

    return m 
end


