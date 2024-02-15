# Create a function to define sets and pass it to the function
function define_sets!(m::Model, data::Dict)
    # Create a dictionary for the sets
    m.ext[:sets] = Dict()
    # Sets of elements
    # Set of AC nodes
    N = m.ext[:sets][:N] = [bus_id for (bus_id,bus) in data["bus"]]
    # Set of slack nodes
    N_sl = m.ext[:sets][:N_sl] = [bus_id for (bus_id,bus) in data["bus"] if bus["bus_type"]==3]
    # Set of AC branches
    B = m.ext[:sets][:B] = [br_id for (br_id,branch) in data["branch"]]
    # Set of shunt elements
    S = m.ext[:sets][:S] = [s_id for (s_id,shunt) in data["shunt"]]
    # Set of generators
    G = m.ext[:sets][:G] = [gen_id for (gen_id,gen) in data["gen"]]
    # Set of loads
    L = m.ext[:sets][:L] = [load_id for (load_id,load) in data["load"]]

    # Set of AC topology from side (i->j) and to side (j->i)
    B_ac_fr = m.ext[:sets][:B_ac_fr] = [(br_id, string(br["f_bus"]), string(br["t_bus"])) for (br_id,br) in data["branch"]] 
    B_ac_to = m.ext[:sets][:B_ac_to] = [(br_id, string(br["t_bus"]), string(br["f_bus"])) for (br_id,br) in data["branch"]]
    # Build a union set of both sets above
    B_ac = m.ext[:sets][:B_ac] = [B_ac_fr; B_ac_to]
    # Branch connectivity to buses, i.e. which branches are connected to a certain node, used in nodal power balance equations
    B_arcs = m.ext[:sets][:B_arcs] = Dict((i, []) for i in N) # create a
    for (l,i,j) in B_ac
        push!(B_arcs[i], (l,i,j))
    end
    # Shunt connectivity to buses, i.e. which shunts are connected to a certain node, used in nodal power balance equations
    S_ac = m.ext[:sets][:S_ac] = Dict((i, []) for i in N)
    for (s, shunt) in data["shunt"]
        push!(S_ac[string(shunt["shunt_bus"])], s)
    end
    # Generator connectivity, i.e. which generators are connected to a certain node, used in nodal power balance equations
    G_ac = m.ext[:sets][:G_ac] = Dict((i, []) for i in N)
    for (g, gen) in data["gen"]
        push!(G_ac[string(gen["gen_bus"])], g)
    end
    # Load connectivity, i.e. which loads are connected to a certain node, used in nodal power balance equations
    L_ac = m.ext[:sets][:L_ac] = Dict((i, []) for i in N)
    for (l, load) in data["load"]
        push!(L_ac[string(load["load_bus"])], l)
    end

    ####################################################################################################
    ####################    DC NETWORK ELEMENTS
    ####################################################################################################
    if !isempty(data["busdc"])
        ND = m.ext[:sets][:ND] = [bus_id for (bus_id,bus) in data["busdc"]] # set of DC buses
        BD = m.ext[:sets][:BD] = [br_id for (br_id,br) in data["branchdc"]] # set of DCbranches
        CV = m.ext[:sets][:CV] = [conv_id for (conv_id,conv) in data["convdc"]] # set of converters  
        CV_arcs = m.ext[:sets][:CV_arcs] = [(conv_id,conv["busac_i"],conv["busdc_i"]) for (conv_id,conv) in data["convdc"]] # set of (converter,ac bus,dc bus)    
        BD_dc_fr = m.ext[:sets][:BD_dc_fr] = [(br_id,string(br["fbusdc"]),string(br["tbusdc"])) for (br_id,br) in data["branchdc"]]
        BD_dc_to = m.ext[:sets][:BD_dc_to] = [(br_id,string(br["tbusdc"]),string(br["fbusdc"])) for (br_id,br) in data["branchdc"]]

        # Create bus pairs
        m.ext[:sets][:busdc_ij] = []
        m.ext[:sets][:busdc_ji] = []
        contain_busdc_ij = []
        for a in m.ext[:sets][:BD_dc_fr]
            if !((a[2],a[3]) in contain_busdc_ij)
                push!(m.ext[:sets][:busdc_ij], (a[2],a[3]))
                push!(m.ext[:sets][:busdc_ji], (a[3],a[2]))     
                push!(contain_busdc_ij, (a[2],a[3]))
            end
        end
        # Topology
        BD_dc = m.ext[:sets][:BD_dc] = [m.ext[:sets][:BD_dc_fr];m.ext[:sets][:BD_dc_to]]
        ND_arcs = Dict((bdc_id, Tuple{String,String,String}[]) for bdc_id in m.ext[:sets][:ND])
        for (l,i,j) in BD_dc
            push!(ND_arcs[i], (l,i,j))
        end
        m.ext[:sets][:ND_arcs] = ND_arcs
    end

    # Create bus pairs
    m.ext[:sets][:bus_ij] = []
    m.ext[:sets][:bus_ji] = []
    contain_bus_ij = []
    for a in m.ext[:sets][:B_ac_fr]
        if !((a[2],a[3]) in contain_bus_ij)
            push!(m.ext[:sets][:bus_ij], (a[2],a[3]))
            push!(m.ext[:sets][:bus_ji], (a[3],a[2]))     
            push!(contain_bus_ij, (a[2],a[3]))
        end
    end
    m.ext[:sets][:bus_ij_ji] = [m.ext[:sets][:bus_ij];m.ext[:sets][:bus_ji]]

    return 
end

# Create a function to pass the grid data to the JuMP model
function process_parameters!(m::Model, data::Dict)
    # Extract sets
    N = m.ext[:sets][:N]
    B = m.ext[:sets][:B]
    G = m.ext[:sets][:G]
    L = m.ext[:sets][:L]
    S = m.ext[:sets][:S]

    ND = m.ext[:sets][:ND]
    BD = m.ext[:sets][:BD]
    CV = m.ext[:sets][:CV] 
    CV_arcs = m.ext[:sets][:CV_arcs] 
    BD_dc_fr = m.ext[:sets][:BD_dc_fr]
    BD_dc_to = m.ext[:sets][:BD_dc_to]

    # Create parameter dictionary
    m.ext[:parameters] = Dict()

    baseMVA = m.ext[:parameters][:baseMVA] = data["baseMVA"] # get the base MVA

    ####################################################################################################
    ####################    AC NETWORK ELEMENTS
    ####################################################################################################

    # Bus parameters
    vmmin = m.ext[:parameters][:vmmin] = Dict(i => data["bus"][i]["vmin"] for i in N) # minimum voltage magnitude
    vmmax = m.ext[:parameters][:vmmax] = Dict(i => data["bus"][i]["vmax"] for i in N) # maximum voltage magnitude
    vamin = m.ext[:parameters][:vamin] = Dict(i => -Float64(pi) for i in N) # Arbitrary limit of -pi for minimum bus voltage angle
    vamax = m.ext[:parameters][:vamax] = Dict(i =>  Float64(pi) for i in N) # Arbitrary limit of  pi for maximum bus voltage angle

    # Branch parameters
    rb = m.ext[:parameters][:rb] = Dict(b => data["branch"][b]["br_r"] for b in B) # branch resistance
    xb = m.ext[:parameters][:xb] = Dict(b => data["branch"][b]["br_x"] for b in B) # branch reactance
    gb =  m.ext[:parameters][:gb] = Dict(b => real(1 / (data["branch"][b]["br_r"] + data["branch"][b]["br_x"]im)) for b in B) # branch series conductance
    bb =  m.ext[:parameters][:bb] = Dict(b => imag(1 / (data["branch"][b]["br_r"] + data["branch"][b]["br_x"]im)) for b in B) # branch series admittance
    gfr = m.ext[:parameters][:gb_sh_fr] = Dict(b => data["branch"][b]["g_fr"] for b in B) # branch shunt conductance from side i -> j
    bfr = m.ext[:parameters][:bb_sh_fr] = Dict(b => data["branch"][b]["b_fr"] for b in B) # branch shunt susceptance from side i -> j
    gto = m.ext[:parameters][:gb_sh_to] = Dict(b => data["branch"][b]["g_to"] for b in B) # branch shunt conductance to side j -> i
    bto = m.ext[:parameters][:bb_sh_to] = Dict(b => data["branch"][b]["b_to"] for b in B) # branch shunt susceptance to side  j -> j
    smax = m.ext[:parameters][:smax] = Dict(b => data["branch"][b]["rate_a"] for b in B) # branch rated power in pu
    imax = m.ext[:parameters][:imax] = Dict(b => data["branch"][b]["c_rating_a"] for b in B if haskey(data["branch"][b],"c_rating_a")) # branch rated power in pu
    angmin = m.ext[:parameters][:angmin] = Dict(b => data["branch"][b]["angmin"] for b in B) # minimum voltage angle difference over branch
    angmax = m.ext[:parameters][:angmax] = Dict(b => data["branch"][b]["angmax"] for b in B) # maximum voltage angle difference over branch
    b_shift = m.ext[:parameters][:b_shift] = Dict(b => data["branch"][b]["shift"] for b in B)
    b_tap = m.ext[:parameters][:b_tap] = Dict(b => data["branch"][b]["tap"] for b in B)
    
    # Load parameters: Assuming a fixed demand!
    load_bus = m.ext[:parameters][:load_bus] =  Dict(l => string(data["load"][l]["load_bus"]) for l in L)
    pd = m.ext[:parameters][:pd] = Dict(l => data["load"][l]["pd"] for l in L)  # active power demand in pu
    qd = m.ext[:parameters][:qd] = Dict(l => data["load"][l]["qd"] for l in L)  # reactive power demand in pu
    il_rated = m.ext[:parameters][:il_rated] = Dict(l => (data["load"][l]["pd"]^2 + data["load"][l]["qd"]^2) / 0.9 for l in L)  # active power demand in pu
    
    # Shunt elements
    shunt_bus = m.ext[:parameters][:shunt_bus] =  Dict(g => string(data["shunt"][l]["shunt_bus"]) for s in S)
    gs =  m.ext[:parameters][:gs] = Dict(s => data["shunt"][s]["gs"] for s in S) # branch series conductance
    bs =  m.ext[:parameters][:bs] = Dict(s => data["shunt"][s]["bs"] for s in S) # branch series admittance

    # Generator parameters
    gen_bus = m.ext[:parameters][:gen_bus] =  Dict(g => string(data["gen"][g]["gen_bus"]) for g in G)
    pmax = m.ext[:parameters][:pmax] = Dict(g => data["gen"][g]["pmax"] for g in G)  # maximum active power in pu
    pmin = m.ext[:parameters][:pmin] = Dict(g => data["gen"][g]["pmin"] for g in G)  # minimum active power in pu
    qmax = m.ext[:parameters][:qmax] = Dict(g => data["gen"][g]["qmax"] for g in G)  # maximum reactive power in pu
    qmin = m.ext[:parameters][:qmin] = Dict(g => data["gen"][g]["qmin"] for g in G)  # minimum reactive power in pu
    ig_rated = m.ext[:parameters][:ig_rated] = Dict(g => sqrt(data["gen"][g]["pmax"]^2 + data["gen"][g]["qmax"]^2) / 0.9 for g in G)  # maximum active power in pu
    
    max_gen_ncost = m.ext[:parameters][:gen_max_ncost] = maximum([data["gen"][g]["ncost"] for g in G])
    m.ext[:parameters][:gen_ncost] = Dict(g => data["gen"][g]["ncost"] for g in G)
    m.ext[:parameters][:gen_cost] = Dict(g => data["gen"][g]["cost"] for g in G)
    # Uniform the length of the cost vector for all generators
    for (gen_id,gen_cost) in m.ext[:parameters][:gen_cost]
        while (length(m.ext[:parameters][:gen_cost][gen_id]) < max_gen_ncost)
            prepend!(m.ext[:parameters][:gen_cost][gen_id],0)
        end
    end
     
    m.ext[:parameters][:ij_ang_max] = Dict()
    m.ext[:parameters][:ij_ang_min] = Dict()
    m.ext[:parameters][:ji_ang_max] = Dict()
    m.ext[:parameters][:ji_ang_min] = Dict()
    contain_bus_ij = []
    for a in m.ext[:sets][:B_ac_fr]
        if !((a[2],a[3]) in contain_bus_ij)
            m.ext[:parameters][:ij_ang_max][(a[2],a[3])] = data["branch"][a[1]]["angmax"]
            m.ext[:parameters][:ij_ang_min][(a[2],a[3])] = data["branch"][a[1]]["angmin"]
            m.ext[:parameters][:ji_ang_max][(a[3],a[2])] = data["branch"][a[1]]["angmax"]
            m.ext[:parameters][:ji_ang_min][(a[3],a[2])] = data["branch"][a[1]]["angmin"]
            push!(contain_bus_ij, (a[2],a[3]))
        end
    end
    m.ext[:parameters][:ij_ji_ang_max] = merge!(m.ext[:parameters][:ij_ang_max],m.ext[:parameters][:ji_ang_max])
    m.ext[:parameters][:ij_ji_ang_min] = merge!(m.ext[:parameters][:ij_ang_min],m.ext[:parameters][:ji_ang_min])


    ####################################################################################################
    ####################    DC NETWORK ELEMENTS
    ####################################################################################################
    if !isempty(data["busdc"])

        m.ext[:parameters][:busdc] = Dict()
        m.ext[:parameters][:busdc][:vm_max] = Dict(busdc_id => busdc["Vdcmax"] for (busdc_id,busdc) in data["busdc"])
        m.ext[:parameters][:busdc][:vm_min] = Dict(busdc_id => busdc["Vdcmin"] for (busdc_id,busdc) in data["busdc"])
        m.ext[:parameters][:busdc][:vm_set] = Dict(busdc_id => busdc["Vdc"] for (busdc_id,busdc) in data["busdc"])
        m.ext[:parameters][:busdc][:c] = Dict(busdc_id => busdc["Cdc"] for (busdc_id,busdc) in data["busdc"])
        m.ext[:parameters][:busdc][:p] = Dict(busdc_id => busdc["Pdc"] for (busdc_id,busdc) in data["busdc"])

        m.ext[:parameters][:convdc] = Dict()
        m.ext[:parameters][:convdc][:busdc] = Dict(conv_id => string(conv["busdc_i"]) for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:status] = Dict(conv_id => conv["status"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:bus] = Dict(conv_id => string(conv["busac_i"]) for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:bases] = bases = Dict(conv_id => get_pu_buses(baseMVA,conv["basekVac"]) for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:loss_a] = Dict(conv_id => conv["LossA"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"]) # pu
        m.ext[:parameters][:convdc][:loss_b] = Dict(conv_id => conv["LossB"]/bases[conv_id]["basekV3p"] for (conv_id,conv) in data["convdc"]) # pu
        m.ext[:parameters][:convdc][:loss_c_inv] = Dict(conv_id => conv["LossCinv"]/bases[conv_id]["baseZ"] for (conv_id,conv) in data["convdc"]) # pu
        m.ext[:parameters][:convdc][:loss_c_rec] = Dict(conv_id => conv["LossCrec"]/bases[conv_id]["baseZ"] for (conv_id,conv) in data["convdc"]) # pu
        m.ext[:parameters][:convdc][:p_ac_max] = Dict(conv_id => conv["Pacmax"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:p_ac_min] = Dict(conv_id => conv["Pacmin"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:q_ac_max] = Dict(conv_id => conv["Qacmax"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:q_ac_min] = Dict(conv_id => conv["Qacmin"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:p_dc_max] = Dict(conv_id => 1.2*conv["Pacmax"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:p_dc_min] = Dict(conv_id => 1.2*conv["Pacmin"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:droop] = Dict(conv_id => conv["droop"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:i_max] = Dict()
        for (conv_id,conv) in data["convdc"]   
            pacrated = max(abs(conv["Pacmax"]/bases[conv_id]["baseMVA"]),abs(conv["Pacmin"]/bases[conv_id]["baseMVA"]))
            qacrated = max(abs(conv["Qacmax"]/bases[conv_id]["baseMVA"]),abs(conv["Qacmin"]/bases[conv_id]["baseMVA"]))
            if conv["Imax"] < sqrt(pacrated^2 + qacrated^2)
                m.ext[:parameters][:convdc][:i_max][conv_id] = sqrt(pacrated^2+qacrated^2)
            else
                m.ext[:parameters][:convdc][:i_max][conv_id] = conv["Imax"]
            end
        end
        m.ext[:parameters][:convdc][:vm_min] = Dict(conv_id => conv["Vmmin"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:vm_max] = Dict(conv_id => conv["Vmmax"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:vm_dc_set] = Dict(conv_id => conv["Vdcset"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:p_g] = Dict(conv_id => conv["P_g"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:q_g] = Dict(conv_id => conv["Q_g"]/bases[conv_id]["baseMVA"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:b_f] = Dict(conv_id => conv["bf"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:r_tf] = Dict(conv_id => conv["rtf"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:g_tf] = Dict(conv_id => real(1/(conv["rtf"]+conv["xtf"]*im)) for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:x_tf] = Dict(conv_id => conv["xtf"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:b_tf] = Dict(conv_id => imag(1/(conv["rtf"]+conv["xtf"]*im)) for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:r_pr] = Dict(conv_id => conv["rc"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:g_pr] = Dict(conv_id => real(1/(conv["rc"]+conv["xc"]*im)) for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:x_pr] = Dict(conv_id => conv["xc"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:b_pr] = Dict(conv_id => imag(1/(conv["rc"]+conv["xc"]*im)) for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:is_tf] = Dict(conv_id => conv["transformer"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:is_pr] = Dict(conv_id => conv["reactor"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:is_filter] = Dict(conv_id => conv["filter"] for (conv_id,conv) in data["convdc"])
        m.ext[:parameters][:convdc][:tap_tf] = Dict(conv_id => conv["tm"] for (conv_id,conv) in data["convdc"])
        # DC branches
        m.ext[:parameters][:branchdc] = Dict()
        m.ext[:parameters][:branchdc][:rate_a] = Dict(br_id => br["rateA"]/baseMVA for (br_id,br) in data["branchdc"])
        m.ext[:parameters][:branchdc][:rate_b] = Dict(br_id => br["rateB"]/baseMVA for (br_id,br) in data["branchdc"])
        m.ext[:parameters][:branchdc][:rate_c] = Dict(br_id => br["rateC"]/baseMVA for (br_id,br) in data["branchdc"])
        m.ext[:parameters][:branchdc][:status] = Dict(br_id => br["status"] for (br_id,br) in data["branchdc"])
        m.ext[:parameters][:branchdc][:r] = Dict(br_id => br["r"] for (br_id,br) in data["branchdc"])
        m.ext[:parameters][:branchdc][:g] = Dict(br_id => 1/br["r"] for (br_id,br) in data["branchdc"])
        m.ext[:parameters][:branchdc][:l] = Dict(br_id => br["l"] for (br_id,br) in data["branchdc"])
        m.ext[:parameters][:branchdc][:dcpoles] = Dict(br_id => data["dcpol"] for (br_id,br) in data["branchdc"])
    end
    
    return m
end

function get_pu_buses(baseMVA,basekV)
    bases = Dict()
    bases["baseMVA"] = baseMVA
    bases["basekV"] = basekV
    bases["basekV3p"] = basekV * sqrt(3)
    bases["baseS"] = baseS = baseMVA*1e6
    bases["basekA"] = basekA = baseMVA/(sqrt(3)*basekV)
    bases["baseZ"] = 1/(basekA^2/baseMVA)
    bases["baseI"] = baseS/basekV
    return bases
end