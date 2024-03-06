##### Get results
baseMVA = m.ext[:parameters][:baseMVA] # for conversion
# Get sets
N = m.ext[:sets][:N]
B = m.ext[:sets][:B]
G = m.ext[:sets][:G]
L = m.ext[:sets][:L]
S = m.ext[:sets][:S]
B_ac_fr = m.ext[:sets][:B_ac_fr]
B_ac_to = m.ext[:sets][:B_ac_to]
B_ac = m.ext[:sets][:B_ac]
B_arcs = m.ext[:sets][:B_arcs]
S_ac = m.ext[:sets][:S_ac]
G_ac = m.ext[:sets][:G_ac]
L_ac = m.ext[:sets][:L_ac]

##### Get parameters
# Bus parameters
vmmin = m.ext[:parameters][:vmmin]
vmmax = m.ext[:parameters][:vmmax]
vamin = m.ext[:parameters][:vamin]
vamax = m.ext[:parameters][:vamax]
# Branch parameters
rb = m.ext[:parameters][:rb]
xb = m.ext[:parameters][:xb]
gb =  m.ext[:parameters][:gb]
bb =  m.ext[:parameters][:bb]
gfr = m.ext[:parameters][:gb_sh_fr]
bfr = m.ext[:parameters][:bb_sh_fr]
gto = m.ext[:parameters][:gb_sh_to]
bto = m.ext[:parameters][:bb_sh_to]
smax = m.ext[:parameters][:smax]
imax = m.ext[:parameters][:imax]
angmin = m.ext[:parameters][:angmin]
angmax = m.ext[:parameters][:angmax]
b_shift = m.ext[:parameters][:b_shift]
b_tap = m.ext[:parameters][:b_tap]
# Load parameters
pd = m.ext[:parameters][:pd]
qd = m.ext[:parameters][:qd]
il_rated = m.ext[:parameters][:il_rated]
# Shunt elements
gs =  m.ext[:parameters][:gs]
bs =  m.ext[:parameters][:bs]
# Generator parameters
pmax = m.ext[:parameters][:pmax]
pmin = m.ext[:parameters][:pmin]
qmax = m.ext[:parameters][:qmax]
qmin = m.ext[:parameters][:qmin]
ig_rated = m.ext[:parameters][:ig_rated]
max_gen_ncost = m.ext[:parameters][:gen_max_ncost]
gen_ncost = m.ext[:parameters][:gen_ncost]
gen_cost = m.ext[:parameters][:gen_cost]

# Get the values of selected variables
pg = value.(m.ext[:variables][:pg])
vm = value.(m.ext[:variables][:vm])

# Plot generator active power
plot_markersize = 7
plot_fontfamily = "Computer Modern"
plot_titlefontsize = 20
plot_guidefontsize = 16
plot_tickfontsize = 12
plot_legendfontsize = 12
plot_size = (960,480)
plot_legend = false #:topright # :bottomright
plot_legend_column = 2
gen_p_all_mw = [pg[g] for g in G].*baseMVA
plot_gen_p = bar(gen_p_all_mw,
                    framestyle = :box,
                    legend= plot_legend,
                    # palette=cgrad(:default, length(gen_ids), categorical = true),
                    fontfamily=plot_fontfamily,
                    # background_color=:transparent,
                    foreground_color=:black,
                    titlefontsize = plot_titlefontsize,
                    guidefontsize = plot_guidefontsize,
                    tickfontsize = plot_tickfontsize,
                    legendfontsize = plot_legendfontsize,
                    size = plot_size,left_margin = (5,:mm),bottom_margin = (6,:mm))
xlabel!("Generator")
ylabel!("Active power [MW]")
xticks!([1:1:length(G);], G)
y_u_lim = maximum(gen_p_all_mw) + 50
ylims!(0,y_u_lim)
title!("Generator Dispatch")
Plots.svg(joinpath(@__DIR__,"results","plot_pg.svg"))

# Plot voltage
plot_markersize = 7
plot_fontfamily = "Computer Modern"
plot_titlefontsize = 20
plot_guidefontsize = 16
plot_tickfontsize = 12
plot_legendfontsize = 12
plot_size = (720,480)
plot_legend = false #:topright # :bottomright
plot_legend_column = 2
vm_all_pu = [vm[i] for i in N]
plot_vm_all_pu = bar(vm_all_pu,
                    framestyle = :box,
                    legend= plot_legend,
                    # palette=cgrad(:default, length(gen_ids), categorical = true),
                    fontfamily=plot_fontfamily,
                    # background_color=:transparent,
                    foreground_color=:black,
                    titlefontsize = plot_titlefontsize,
                    guidefontsize = plot_guidefontsize,
                    tickfontsize = plot_tickfontsize,
                    legendfontsize = plot_legendfontsize,
                    size = plot_size,left_margin = (2,:mm),bottom_margin = (4,:mm))
xlabel!("Bus")
ylabel!("Voltage [pu]")
xticks!([1:1:length(N);], N)
ylims!(0.9,1.1)
title!("Voltage magnitude")
Plots.svg(joinpath(@__DIR__,"results","plot_vm.svg"))




