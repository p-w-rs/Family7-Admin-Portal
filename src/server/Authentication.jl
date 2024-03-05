function auth_middleware(req::HTTP.Request)
    cookies = HTTP.cookies(req)
    if length(cookies) == 0
        return false, ("", "")
    else
        idx = findfirst(getproperty.(cookies, :name) .== "f7f_id")
        isnothing(idx) && return false, ("", "")
        session_id = cookies[idx].value

        idx = findfirst(getproperty.(cookies, :name) .== "f7f_token")
        isnothing(idx) && return false, ("", "")
        session_token = cookies[idx].value
        session_token == "" && return false, ("", "")

        employee = makeTypes(
            token_auth(session_id, session_token), Employee
        )
        isnothing(employee) && return false, ("", "")
        println("\n\n\n", employee, "\n\n\n")

        id, roles, token_exp = employee.id, employee.roles, employee.token_exp
        if DateTime(token_exp) <= now()
            set_token("", "", id)
            return false, ("", "")
        end

        return true, (id, roles)
    end
end

function authenticate_user(email, password)
    hash = hexdigest("sha256", password)
    employee = makeTypes(
        auth(email, hash), Employee
    )
    if isnothing(employee)
        return false, ("", "")
    end

    token = length(employee.token) == 0 ? hexdigest("sha256", password, randstring(64)) : employee.token
    set_token(token, string(now() + Day(7)), employee.id)
    return true, (employee.id, token)
end

@post "/api/login" function (req::HTTP.Request)
    data = JSON.parse(String(req.body))
    email = data["email"]
    password = data["password"]
    authenticated, (id, token) = authenticate_user(email, password)
    if authenticated
        session_id = HTTP.Cookie("f7f_id", string(id), path="/", maxage=3600 * 24 * 7, secure=true, httponly=true, samesite=HTTP.Cookies.SameSite(4))
        session_token = HTTP.Cookie("f7f_token", token, path="/", maxage=3600 * 24 * 7, secure=true, httponly=true, samesite=HTTP.Cookies.SameSite(4))
        cookies = HTTP.stringify.([session_id, session_token], false)
        headers = ["Set-Cookie" => cookies[1], "Set-Cookie" => cookies[2]]
        return html("Authentication success"; status=200, headers=headers)
    else
        return html("Authentication failed"; status=401)
    end
end

@post "/api/logout" function (req::HTTP.Request)
    authenticated, (id, roles) = auth_middleware(req)
    authenticated && set_token("", "", id)
    session_id = HTTP.Cookie("f7f_id", "", path="/", maxage=-1, secure=true, httponly=true, samesite=HTTP.Cookies.SameSite(4))
    session_token = HTTP.Cookie("f7f_token", "", path="/", maxage=-1, secure=true, httponly=true, samesite=HTTP.Cookies.SameSite(4))
    cookies = HTTP.stringify.([session_id, session_token], false)
    headers = ["Set-Cookie" => cookies[1], "Set-Cookie" => cookies[2]]
    return html("Logged out"; status=200, headers=headers)
end
