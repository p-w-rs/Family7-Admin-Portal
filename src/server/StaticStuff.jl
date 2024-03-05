# Public assets
const login() = file("./public/static/Login.html")
const home() = file("./public/static/Home.html")
const notfound() = file("./public/static/NotFound.html")

dynamicfiles("./public/static", "/static")
dynamicfiles("./public/assets", "/assets")
