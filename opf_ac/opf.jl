## Step 0: Activate environment
using Pkg
# Pkg.activate(@__DIR__)
# Pkg.instantiate()
# Pkg.update()
# Pkg.add("Ipopt")
# Pkg.add("PowerModels")
# Pkg.add("JuMP")
using PowerModels, Ipopt, JuMP
# Pkg.add("Plots") # if Plots package not added yet, for plotting results
using Plots

# Define solver
ipopt = optimizer_with_attributes(Ipopt.Optimizer)

##### Step 1: Import the grid data and initialize the JuMP model
# Select the MATPOWER case file
path = pwd()
case_file = joinpath(path, "opf_ac", "pg", "pglib_opf_case5_pjm.m")
# case_file = joinpath(path, "opf_ac", "pg", pglib_opf_case14_ieee.m")
# case_file = joinpath(path, "opf_ac", "pg", pglib_opf_case24_ieee_rts.m")
# case_file = joinpath(path, "opf_ac", "pg", pglib_opf_case300_ieee.m")
# case_file = joinpath(path, "opf_ac", "pg", pglib_opf_case1354_pegase.m")

# For convenience, use the parser of Powermodels to convert the MATPOWER format file to a Julia dictionary
data = PowerModels.parse_file(case_file)

# Initialize the JuMP model (an empty JuMP model) with defined solver
m = Model(ipopt)

##### Step 2: create the JuMP model & pass data to model
include(joinpath(path, "opf_ac", "init_model.jl")) # Define functions define_sets! and process_parameters!
define_sets!(m, data) # Pass the sets to the JuMP model
process_parameters!(m, data) # Pass the parameters to the JuMP model

##### Step 3: Build the model
include(joinpath(path, "opf_ac", "build_ac_opf.jl")) # Define build_ac_opf! function
build_ac_opf!(m) # Pass the model to the build_ac_opf! function

##### Step 4: Solve the model
optimize!(m) # Solve the model
println(objective_value(m)) # Print the objective value of the model

##### Compare the two objective functions
result_pm = PowerModels.solve_opf(case_file, ACPPowerModel, ipopt) # Solve using PowerModels and retrieve the solutions
print(Dict("objective"=>objective_value(m),"objective_pm"=>result_pm["objective"])) # Compare the objective values

#####