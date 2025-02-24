# Declare packages to be used
using PowerModels
using Plots

###### OVERHEAD LINE

# Load test case data
data = PowerModels.parse_file("case30.m")

# Solve power flow
result = PowerModels.compute_ac_pf(data)

# Inspect results
PowerModels.print_summary(result["solution"])


##### SOLUTION #####

PowerModels.update_data!(data, result["solution"])
flows = calc_branch_flow_ac(data)
PowerModels.update_data!(data, flows)
reactive_flow = data["branch"]["2"]["qf"] * data["baseMVA"] + data["branch"]["2"]["qt"] * data["baseMVA"]

################### Compensation options ###################
br_id = 2
b_fr = data["branch"]["$br_id"]["b_fr"]
b_to = data["branch"]["$br_id"]["b_fr"]

# OPTION 1a - Bus 1
data = PowerModels.parse_file("case30.m")
b_comp = -(b_fr + b_to)

data["shunt"]["3"] = Dict()
data["shunt"]["3"]["shunt_bus"] = 1
data["shunt"]["3"]["status"] = 1
data["shunt"]["3"]["index"] = 3
data["shunt"]["3"]["gs"] = 0.0
data["shunt"]["3"]["bs"] = b_comp

# Solve power flow
result = PowerModels.compute_ac_pf(data)

# Inspect results
PowerModels.print_summary(result["solution"])

# OPTION 1b - Bus 3
data = PowerModels.parse_file("case30.m")
b_comp = -(b_fr + b_to)

data["shunt"]["3"] = Dict()
data["shunt"]["3"]["bs"] = b_comp
data["shunt"]["3"]["shunt_bus"] = 3
data["shunt"]["3"]["status"] = 1
data["shunt"]["3"]["index"] = 3
data["shunt"]["3"]["gs"] = 0.0
data["shunt"]["3"]["bs"] = b_comp

# Solve power flow
result = PowerModels.compute_ac_pf(data)

# Inspect results
PowerModels.print_summary(result["solution"])

# Option 2 - Bus 1 and 3
data = PowerModels.parse_file("case30.m")
b_comp = -b_fr

data["shunt"]["3"] = Dict()
data["shunt"]["3"]["shunt_bus"] = 1
data["shunt"]["3"]["status"] = 1
data["shunt"]["3"]["index"] = 3
data["shunt"]["3"]["gs"] = 0.0
data["shunt"]["3"]["bs"] = b_comp

data["shunt"]["4"] = Dict()
data["shunt"]["4"]["shunt_bus"] = 3
data["shunt"]["4"]["status"] = 1
data["shunt"]["4"]["index"] = 4
data["shunt"]["4"]["gs"] = 0.0
data["shunt"]["4"]["bs"] = b_comp

# Solve power flow
result = PowerModels.compute_ac_pf(data)

# Inspect results
PowerModels.print_summary(result["solution"])


# Option 3 - Mid point
data = PowerModels.parse_file("case30.m")
data["bus"]["31"] = deepcopy(data["bus"]["3"])
data["bus"]["31"]["index"] = 31
data["branch"]["42"] = deepcopy(data["branch"]["2"])

data["branch"]["2"]["br_r"] = data["branch"]["2"]["br_r"] / 2
data["branch"]["2"]["br_x"] = data["branch"]["2"]["br_x"] / 2
data["branch"]["2"]["b_fr"] = data["branch"]["2"]["b_fr"] / 2
data["branch"]["2"]["b_to"] = data["branch"]["2"]["b_to"] / 2
data["branch"]["2"]["t_bus"] = 31

data["branch"]["42"]["br_r"] = data["branch"]["42"]["br_r"] / 2
data["branch"]["42"]["br_x"] = data["branch"]["42"]["br_x"] / 2
data["branch"]["42"]["b_fr"] = data["branch"]["42"]["b_fr"] / 2
data["branch"]["42"]["b_to"] = data["branch"]["42"]["b_to"] / 2
data["branch"]["42"]["index"] = 42
data["branch"]["42"]["f_bus"] = 31
data["branch"]["42"]["t_bus"] = 3

b_comp = -(b_fr + b_to)

data["shunt"]["3"] = Dict()
data["shunt"]["3"]["bs"] = b_comp
data["shunt"]["3"]["shunt_bus"] = 31
data["shunt"]["3"]["status"] = 1
data["shunt"]["3"]["index"] = 3
data["shunt"]["3"]["gs"] = 0.0
data["shunt"]["3"]["bs"] = b_comp

# Solve power flow
result = PowerModels.compute_ac_pf(data)

# Inspect results
PowerModels.print_summary(result["solution"])