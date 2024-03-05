using Oxygen, HTTP, JSON, Random, Nettle, SQLite, DataFrames, StructTypes, Dates

include("../src/server/DBTypes.jl")

function JLType_to_ELMType(type::DataType)::String
    if type == Int64
        return "Int"
    elseif type == String
        return "String"
    end
end

function elmType(name::String, fields::Vector{String}, types::Vector{String})::String
    members = String[]
    for (field, type) in zip(fields, types)
        push!(members, "$field : $type")
    end
    return "type alias $name = {$(join(members, ", "))}"
end

elmTypes = String[]
for type in myTypes
    name = string(type)
    fields = [string.(fieldnames(type))...]
    types = [JLType_to_ELMType.(fieldtypes(type))...]
    push!(elmTypes, elmType(name, fields, types))
end

open("../src/client/DBTypes.elm", "w") do io
    println(io, "module DBTypes exposing (..)\n")
    for elmType in elmTypes
        println(io, elmType)
        println(io, "\n")
    end
end

run(`elm-format ../src/client/DBTypes.elm --yes`)