using Oxygen, HTTP, JSON, Random, Nettle, SQLite, DataFrames, StructTypes, Dates

include("../src/server/DBTypes.jl")

const db = SQLite.DB("../private/family7f.db")
database_queries = String[
    "const auth = SQLite.Stmt(db,\"SELECT * FROM Employee WHERE (employee_email=? AND password=?);\")",
    "const token_auth = SQLite.Stmt(db,\"SELECT * FROM Employee WHERE (id=? AND token=?);\")",
    "const set_token = SQLite.Stmt(db,\"UPDATE Employee SET token=?, token_exp=? WHERE id=?;\")"
]
names = lowercase.(string.(myTypes))

function createTable(name, fields, types)
    query = "CREATE TABLE $name ("

    references = ""
    for (field, type) in zip(fields, types)
        if field == :id
            query *= "$field INTEGER PRIMARY KEY AUTOINCREMENT, "
        elseif "id" in split(string(field), "_")
            query *= "$field INTEGER, "
            name = split(string(field), "_")[1]
            idx = findfirst(x -> x == name, names)
            references *= "FOREIGN KEY ($field) REFERENCES $(myTypes[idx])(id), "
        else
            if type <: String
                query *= "$field TEXT, "
            elseif type <: Integer
                query *= "$field INTEGER, "
            else
                println("Type $type not supported")
                exit(1)
            end
        end
    end
    query *= references
    query = query[1:end-2] * ");"
    DBInterface.execute(db, query)
end

function createQueries(name, fields)
    c = 'b'
    refs = []
    joins = []
    for field in fields[2:end]
        if "id" in split(string(field), "_")
            _name = split(string(field), "_")[1]
            idx = findfirst(x -> x == _name, names)
            push!(refs, "$c.*")
            push!(joins, "INNER JOIN $(myTypes[idx]) $c ON a.$field = $c.id")
            c += 1
        end
    end

    insert = "const insert_$(lowercase(name)) = SQLite.Stmt(db,\"INSERT INTO $name ("
    for field in fields[2:end]
        insert *= "$field, "
    end
    insert = insert[1:end-2] * ") VALUES ($(join(["?" for _ in fields[2:end]], ",")));\")"

    set = "const set_$(lowercase(name)) = SQLite.Stmt(db,\"UPDATE $name SET "
    for field in fields[2:end]
        set *= "$field=?, "
    end
    set = set[1:end-2] * " WHERE id=?;\")"

    delete = "const delete_$(lowercase(name)) = SQLite.Stmt(db,\"DELETE FROM $name WHERE id=?;\")"
    get = "const get_$(lowercase(name)) = SQLite.Stmt(db,\"SELECT a.*,$(join(refs, ",")) FROM $name a $(join(joins, " ")) WHERE a.id=?;\")"
    gets = "const get_$(lowercase(name))s = SQLite.Stmt(db,\"SELECT a.*,$(join(refs, ",")) FROM $name a $(join(joins, " ")) LIMIT ? OFFSET (? - 1) * ?;\")"
    getn = "const getn_$(lowercase(name)) = SQLite.Stmt(db,\"SELECT COUNT(*) FROM $name;\")"

    if name == "Region"
        get = "const get_$(lowercase(name)) = SQLite.Stmt(db,\"SELECT * FROM $name WHERE id=?;\")"
        gets = "const get_$(lowercase(name))s = SQLite.Stmt(db,\"SELECT * FROM $name LIMIT ? OFFSET (? - 1) * ?;\")"
    end
    push!(database_queries, [insert, set, delete, get, gets, getn]...)
end

for type in myTypes
    name = string(type)
    fields = [fieldnames(type)...]
    types = [fieldtypes(type)...]

    DBInterface.execute(db, "DROP TABLE IF EXISTS $name;")
    createTable(name, fields, types)
    createQueries(name, fields)
end

open("../src/server/DBQueries.jl", "w") do io
    println(
        io,
        "dblock = ReentrantLock()\nfunction (q::SQLite.Stmt)(args...)\n\tglobal dblock\n\tThreads.lock(dblock) do\n\t\tDBInterface.execute(q, [args...])\n\tend\nend\n"
    )
    for query in database_queries
        println(io, query)
        println(io)
    end
end