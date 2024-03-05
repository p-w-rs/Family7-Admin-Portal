using Oxygen, HTTP, JSON, Random, Nettle, SQLite, DataFrames, StructTypes, Dates

const db = SQLite.DB("../private/family7f.db")

include("../src/server/DBQueries.jl")
include("../src/server/DBTypes.jl")
include("../src/server/StaticStuff.jl")
include("../src/server/Authentication.jl")

for i in 1:8
    res = get_employee(i)
    employee = makeTypes(
        res, Employee, Region
    )
    println(employee[1].employee_name)
end

res = getn_employee() |> DataFrame
n = res[1, 1]

for i in 1:div(n, 2)
    res = get_employees(2, i, 2)
    employees = makeTypes(
        res, Employee, Region
    )
    println(i)
    println(employees[1][1].id)
    println(employees[1][1].employee_name)
    println(employees[2][1].id)
    println(employees[2][1].employee_name)
    println()
end



