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
case_file = joinpath(path, "opf_acdc", "pg", "case67_investment_dc.m")

# For convenience, use the parser of Powermodels to convert the MATPOWER format file to a Julia dictionary
data = PowerModels.parse_file(case_file)

# Initialize the JuMP model (an empty JuMP model) with defined solver
m = Model(ipopt)
m_tap = Model(ipopt)

##### Step 2: create the JuMP model & pass data to model

include(joinpath(path, "opf_acdc", "init_model.jl"))# Define functions define_sets! and process_parameters!
define_sets!(m, data) # Pass the sets to the JuMP model
define_sets!(m_tap, data) # Pass the sets to the JuMP model
process_parameters!(m, data) # Pass the parameters to the JuMP model
process_parameters!(m_tap, data) # Pass the parameters to the JuMP model


##### Step 3: Build the model
include(joinpath(path, "opf_acdc","build_ac_opf_acdc.jl")) # Define build_ac_opf_acdc! function
include(joinpath(path, "opf_acdc","build_ac_opf_acdc_tap.jl")) # Define build_ac_opf_acdc! function
build_ac_opf_acdc!(m) # Pass the model to the build_ac_opf_acdc! function
build_ac_opf_acdc_tap!(m_tap) # Pass the model to the build_ac_opf_acdc! function

##### Step 4: Solve the model
optimize!(m) # Solve the model
optimize!(m_tap) # Solve the model

##### Compare the two objective functions
print(Dict("objective" => objective_value(m), "objective optimal tap" => objective_value(m_tap), "ΔCost" => (objective_value(m) - objective_value(m_tap)))) # Compare the objective values
#####