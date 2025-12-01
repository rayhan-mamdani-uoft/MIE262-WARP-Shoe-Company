
#Sets from dat
set S; #shoes
set M; #machines
set R; #raw materials

#Constants from problem
param BUDGET = 10000000;
param DEMAND_PENALTY = 10; #each pair is -$10
param WORKER_WAGE = 25; #hourly wage of machine workers per hour in $
param WAREHOUSE_CAP = 140000; #total capacity of all warehouses from data in num pairs
param MACHINE_TIME = 60 * 12 * 28; #total minutes a machine can operate for
#Params from set
param shoe_price{S};
param shoe_demand{S};
param shoe_materials{S, R} default 0;
param machine_op_time{S, M} default 0;
param machine_op_cost{M};
param raw_max{R};
param raw_cost{R};

#Decision Variables
var x{S} integer >= 0; #num of each shoe produced

#Objective Function
maximize profit: sum{s in S} shoe_price[s]*x[s]
- sum{s in S, r in R} raw_cost[r]*x[s]*shoe_materials[s, r]
- sum{s in S, m in M}((25/60) + machine_op_cost[m])*x[s]*((machine_op_time[s, m])/60)
- sum{s in S} 10 * max(0, shoe_demand[s]-x[s]);

#Constraints
subject to Op_Time_C{m in M}: sum{s in S} x[s]*(machine_op_time[s, m]/60) <= MACHINE_TIME; #operating time of each machine cannot exceed the operation minutes in february
subject to Raw_Max_C{r in R}: sum{s in S} x[s]*shoe_materials[s, r] <= raw_max[r]; #each material cannot exceed the respective max quantity
subject to Warehouse_C: sum{s in S} x[s] <= WAREHOUSE_CAP; #total number of shoes does not exceed the warehouse capacity
subject to Shoe_Demand_C{s in S}: x[s] <= shoe_demand[s]; #production of a shoe should not exceed the demand of the shoe
subject to Budget_C: (sum{s in S, r in R} raw_cost[r]*x[s]*shoe_materials[s, r]) + (sum{s in S, m in M}(machine_op_cost[m]+WORKER_WAGE/60)*x[s]*(machine_op_time[s, m]/60)) <= BUDGET;