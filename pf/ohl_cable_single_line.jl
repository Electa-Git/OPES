# Declare packages to be used
using PowerModels
using Plots

###### OVERHEAD LINE

# Load test case data
data = PowerModels.parse_file("case_ohl_cable.m")

# Dfine the system parameters
u_1 = 220e3# voltage on bus 1 in Volt
snom = 30.0 # Appreant power deand on bus 2 in MVA
zbase = u_1^2 / (data["baseMVA"] * 1e6) # base impedance od system in Ohm
f = 50 # Hz

# Define the overhead line parameters
l = 50 # km
r = 0.079 * l # ohm/km
x = 0.289 * l # ohm/km
c = 12.4e-9 # nF/km
bc = (2*f*pi) * c * l / 2  # 1/ohm

data["branch"]["1"]["br_r"] = r / zbase
data["branch"]["1"]["br_x"] = x / zbase
data["branch"]["1"]["b_fr"] = bc * zbase
data["branch"]["1"]["b_to"] = bc * zbase

# Define a range of load angles
ϕrange = -pi/6:0.01:pi/6
# Create array of zeros to write voltage values for each load angle
ul = zeros(1,length(ϕrange))
# Initialize index
idx = 1
# Loop over the range of load angles
for ϕ in ϕrange
    pl = snom * cos(ϕ) # active power demand
    ql = snom * sin(ϕ) # reactive power demand
    data["load"]["1"]["pd"] = pl / data["baseMVA"] # overwrite active power demand in data
    data["load"]["1"]["qd"] = ql / data["baseMVA"] # overwrite reactive power demand in data

    result = PowerModels.compute_ac_pf(data) # solve power flow

    ul[idx] = result["solution"]["bus"]["2"]["vm"] * u_1 # write voltage magnitude to array
    global idx = idx + 1
end

# Plot voltage magnitude over load angle
pu = Plots.plot(ϕrange * 180 / pi, ul'./1000, xlabel = "Load angle in °", ylabel = "|U| [kV]", fonntfamily = "Computer Modern", legend = false)

###### UNDERGROUND CABLE

# Load test case data
data = PowerModels.parse_file("case_ohl_cable.m")

# Define the underground cable parameters
r = 0.0113 # ohm/km
x = 0.111 # ohm/km
c = 231.0e-9# nF/km
bc = ( 2 * f * pi) * c  / 2  # 1/ohm

# Define a range of cable lengths
lrange = 1:50
# Create array of zeros to write voltage values for each length
ulc = zeros(1,length(lrange))
# Initialize index
idx = 1
# Loop over the range of cable lengths
for l in lrange

    data["branch"]["1"]["br_r"] = r * l / zbase # overwrite resistance in data
    data["branch"]["1"]["br_x"] = x * l / zbase # overwrite reactance in data
    data["branch"]["1"]["b_fr"] = bc * l * zbase # overwrite from shunt admittance in data
    data["branch"]["1"]["b_to"] = bc * l * zbase # overwrite to shunt admittance in data

    pl = snom * cos(0.0) # active power demand
    ql = snom * sin(0.0) # reactive power demand
    data["load"]["1"]["pd"] = pl / data["baseMVA"] # overwrite active power demand in data
    data["load"]["1"]["qd"] = ql / data["baseMVA"] # overwrite reactive power demand in data
    result = PowerModels.compute_ac_pf(data) # solve power flow

    ulc[idx] = result["solution"]["bus"]["2"]["vm"] * u_1 # write voltage magnitude to array
    global idx = idx + 1
end

# # Plot voltage magnitude over load angle
pu = Plots.plot(lrange, ulc'./1000, xlabel = "Length in km ", ylabel = "|U_2| [kV]", fonntfamily = "Computer Modern", legend = false)


##################### SECTION REACTIVE POWER FLOWS AND COMPENSATION #####################
data = PowerModels.parse_file("case_ohl_cable.m")
# Define the underground cable parameters
r = 0.0113 # ohm/km
x = 0.111 # ohm/km
c = 231.0e-9# nF/km
bc = ( 2 * f * pi) * c  / 2  # 1/ohm
l = 100 # km

data["branch"]["1"]["br_r"] = r * l / zbase # overwrite resistance in data
data["branch"]["1"]["br_x"] = x * l / zbase # overwrite reactance in data
data["branch"]["1"]["b_fr"] = bc * l * zbase # overwrite from shunt admittance in data
data["branch"]["1"]["b_to"] = bc * l * zbase # overwrite to shunt admittance in data

pl = snom * cos(0.0) # active power demand
ql = snom * sin(0.0) # reactive power demand
data["load"]["1"]["pd"] = pl / data["baseMVA"] # overwrite active power demand in data
data["load"]["1"]["qd"] = ql / data["baseMVA"] # overwrite reactive power demand in data

result = PowerModels.compute_ac_pf(data)
PowerModels.update_data!(data, result["solution"])
flows = calc_branch_flow_ac(data)
PowerModels.update_data!(data, flows)


PowerModels.print_summary(result["solution"])
println("Active power flow  1 -> 2: ", data["branch"]["1"]["pf"] * data["baseMVA"], " MW")
println("Active power flow  2 -> 1: ", data["branch"]["1"]["pt"] * data["baseMVA"], " MW")
println("Rective power flow  1 -> 2: ", data["branch"]["1"]["qf"] * data["baseMVA"], " Mvar")
println("Rective power flow  2 -> 1: ", data["branch"]["1"]["qt"] * data["baseMVA"], " Mvar")


############# Calcualte the value for the compensation reactances #############
reactive_flow = data["branch"]["1"]["qf"] * data["baseMVA"] + data["branch"]["1"]["qt"] * data["baseMVA"]
q_comp = reactive_flow * 1e6 / 2 # divide by half because of double sided compensation
x_comp = (u_1^2 / q_comp) / zbase # calculate reactance value in pu
b_comp = 1 / x_comp # convert to shunt admittance

data["shunt"]["1"] = Dict()
data["shunt"]["1"]["shunt_bus"] = 1
data["shunt"]["1"]["status"] = 1
data["shunt"]["1"]["index"] = 1
data["shunt"]["1"]["gs"] = 0.0
data["shunt"]["1"]["bs"] = b_comp

data["shunt"]["2"] = Dict()
data["shunt"]["2"]["shunt_bus"] = 2
data["shunt"]["2"]["status"] = 1
data["shunt"]["2"]["index"] = 2
data["shunt"]["2"]["gs"] = 0.0
data["shunt"]["2"]["bs"] = b_comp

result = PowerModels.compute_ac_pf(data)
PowerModels.print_summary(result["solution"])