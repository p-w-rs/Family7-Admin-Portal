using Oxygen, HTTP, JSON, Random, Nettle, SQLite, DataFrames, StructTypes, Dates

include("Authentication.jl")
include("StaticStuff.jl")

@get "/" function (req::HTTP.Request)
    authenticated, (id, roles) = auth_middleware(req)
    if authenticated
        return home()
    else
        return login()
    end
end

@get "/test" function (req::HTTP.Request)
    return login()
end

@get "/*" function (req::HTTP.Request)
    authenticated, (id, roles) = auth_middleware(req)
    if authenticated
        path = HTTP.URI(req.target).path
        routes = Dict(
            "/home" => home,
            #"/reports" => reports,
            #"/families" => families,
            #"/employees" => employees,
            #"/contracts" => contracts,
            #"/regions" => regions,
            #"/account" => account,
            "/404" => notfound()
        )

        if haskey(routes, path)
            return routes[path]()
        else
            return notfound()
        end
    else
        return login()
    end
end

serve()
