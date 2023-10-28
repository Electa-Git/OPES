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
    # Shunt connectivity to buses, i.e. which branches are connected to a certain node, used in nodal power balance equations
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

    # Create parameter dictionary
    m.ext[:parameters] = Dict()

    baseMVA = m.ext[:parameters][:baseMVA] = data["baseMVA"] # get the base MVA

    # Bus parameters
    vmmin = m.ext[:parameters][:vmmin] = Dict(i => data["bus"][i]["vmin"] for i in N) # minimum voltage magnitude
    vmmax = m.ext[:parameters][:vmmax] = Dict(i => data["bus"][i]["vmax"] for i in N) # maximum voltage magnitude
    vamin = m.ext[:parameters][:vamin] = Dict(i => -pi for i in N) # Arbitrary limit of -pi for minimum bus voltage angle
    vamax = m.ext[:parameters][:vamax] = Dict(i =>  pi for i in N) # Arbitrary limit of  pi for maximum bus voltage angle

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
    b_shift = m.ext[:parameters][:b_shift] = Dict(b => data["branch"][b]["shift"] for b in B) # maximum voltage angle difference over branch
    b_tap = m.ext[:parameters][:b_tap] = Dict(b => data["branch"][b]["tap"] for b in B)
    
    # Load parameters: Assuming a fixed demand!
    pd = m.ext[:parameters][:pd] = Dict(l => data["load"][l]["pd"] for l in L)  # active power demand in pu
    qd = m.ext[:parameters][:qd] = Dict(l => data["load"][l]["qd"] for l in L)  # reactive power demand in pu
    il_rated = m.ext[:parameters][:il_rated] = Dict(l => (data["load"][l]["pd"]^2 + data["load"][l]["qd"]^2) / 0.9 for l in L)  # active power demand in pu
    
    # Shunt elements
    gs =  m.ext[:parameters][:gs] = Dict(s => data["shunt"][s]["gs"] for s in S) # branch series conductance
    bs =  m.ext[:parameters][:bs] = Dict(s => data["shunt"][s]["bs"] for s in S) # branch series admittance

    # Generator parameters
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
    
    return m
end