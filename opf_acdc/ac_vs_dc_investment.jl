## Step 0: Activate environment
using Pkg
# Pkg.activate(@__DIR__)
# Pkg.instantiate()
# Pkg.update()
# Pkg.add("Ipopt")
# Pkg.add("PowerModels")
# Pkg.add("PowerModelsACDC")
# Pkg.add("JuMP")
using PowerModels, PowerModelsACDC, Ipopt, JuMP
# Pkg.add("Plots") # if Plots package not added yet, for plotting results
using Plots

# Define solver
ipopt = optimizer_with_attributes(Ipopt.Optimizer)

##### Step 1: Import the grid data and initialize the JuMP model
# Select the MATPOWER case file
path = pwd()
case_file_ac = joinpath(path, "opf_ac", "pg", "pglib_opf_hvdc_case67_all_ac_different_costs.m")
case_file_acdc = joinpath(path, "opf_acdc", "pg", "pglib_opf_hvdc_case67_different_costs.m")

# For convenience, use the parser of Powermodels to convert the MATPOWER format file to a Julia dictionary
data_ac = PowerModels.parse_file(case_file_ac)
data_acdc = PowerModels.parse_file(case_file_acdc)

# Initialize the JuMP model (an empty JuMP model) with defined solver
m_ac = Model(ipopt)
m_acdc = Model(ipopt)

##### Step 2: create the JuMP model & pass data to model
include(joinpath(path, "opf_ac", "init_model.jl")) # Define functions define_sets! and process_parameters!
define_sets!(m_ac, data_ac) # Pass the sets to the JuMP model
process_parameters!(m_ac, data_ac) # Pass the parameters to the JuMP model

include(joinpath(path, "opf_acdc", "init_model.jl"))# Define functions define_sets! and process_parameters!
define_sets!(m_acdc, data_acdc) # Pass the sets to the JuMP model
process_parameters!(m_acdc, data_acdc) # Pass the parameters to the JuMP model


##### Step 3: Build the model
include(joinpath(path, "opf_ac", "build_ac_opf.jl")) # Define build_ac_opf_acdc! function
build_ac_opf!(m_ac) # Pass the model to the build_ac_opf_acdc! function
include(joinpath(path, "opf_acdc","build_ac_opf_acdc.jl")) # Define build_ac_opf_acdc! function
build_ac_opf_acdc!(m_acdc) # Pass the model to the build_ac_opf_acdc! function

##### Step 4: Solve the model
optimize!(m_ac) # Solve the model
optimize!(m_acdc) # Solve the model

##### Compare the two objective functions
print(Dict("objective ac grid" => objective_value(m_ac),"objective acdc grid" => objective_value(m_acdc), "ΔCost" => (objective_value(m_ac) - objective_value(m_acdc)))) # Compare the objective values
#####