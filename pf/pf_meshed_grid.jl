# Declare packages to be used
using PowerModels
using Plots

###### OVERHEAD LINE

# Load test case data
data = PowerModels.parse_file("case14.m")

# Solve power flow
result = PowerModels.compute_ac_pf(data)

# Inspect results
for (b, bus) in result["solution"]["bus"]
    println("Bus ", b, ": Vm = ", bus["vm"], " p.u.")
end