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
case_file = "pg\\pglib_opf_hvdc_case67.m"

# For convenience, use the parser of Powermodels to convert the MATPOWER format file to a Julia dictionary
data = PowerModels.parse_file(case_file)

# Initialize the JuMP model (an empty JuMP model) with defined solver
m = Model(ipopt)

##### Step 2: create the JuMP model & pass data to model
include("init_model.jl") # Define functions define_sets! and process_parameters!
define_sets!(m, data) # Pass the sets to the JuMP model
process_parameters!(m, data) # Pass the parameters to the JuMP model

##### Step 3: Build the model
include("build_ac_opf_acdc.jl") # Define build_ac_opf! function
build_ac_opf_acdc!(m) # Pass the model to the build_ac_opf! function

##### Step 4: Solve the model
optimize!(m) # Solve the model
solution_summary(m)
println(objective_value(m)) # Print the objective value of the model

##### Compare the two objective functions
result_pm = PowerModelsACDC.run_acdcopf(case_file, ACPPowerModel, ipopt) # Solve using PowerModels and retrieve the solutions
print(Dict("objective"=>objective_value(m),"objective_pm"=>result_pm["objective"])) # Compare the objective values

#####