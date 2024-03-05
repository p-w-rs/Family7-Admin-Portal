using Oxygen, HTTP, JSON, Random, Nettle, SQLite, DataFrames, StructTypes, Dates

const db = SQLite.DB("../private/family7f.db")

include("../src/server/DBTypes.jl")
include("../src/server/DBQueries.jl")

regions = ["Saratoga Springs", "Riverton", "Bluffdale", "Lehi", "Herriman"]
for i in 1:5
    insert_region(rand(1:25), string(now()), "Utah", "Utah County", regions[i])
    insert_contact(i, "WHO", "$i@$i.com", "1234567890", "Whatever you want")
    insert_contract(i, string(now()), "49.99", "db/contracts/contract$i.pdf")
    insert_caseworker(i, "frist$i, last$i", "1234567890", "$i@$i.com", "Whatever you want")
    insert_employee(i, "teacher", string(now()), "49.99", "private/employee_pictures/employee$i.jpg", "first$i, last$i", "01/01/2000", "123 Fake Street", "1234567890", "first$i@family7f.com", "other$i@gmail.com", hexdigest("sha256", "$i first$i last$i"), "", "")
    insert_family(i, i, i, i, string(now()), string(now()), "123 Fake Street", "1234567890", "family$i@gamil.com", string(now()), "True", "db/media_releases/media_release$i.pdf")
    insert_member(i, "frist$i, last$i", "03/21/1992", "123 Fake Street", "1234567890", "member$i@gamil.com", "home")
    insert_applicant(i, string(now()), "first last", "1234567890", "app$i@gamil.coom", "Some other stuff", "db/resumes/resume$i.pdf")
    insert_partnerreport(i, i, i, i, i, string(now()), string(now()), rand(1:100), string(now()), string(now()), rand(1:10), "Some topic", "$i", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11")
end
insert_employee(1, "admin,teacher", string(now()), "499.99", "db/employee_pictures/employee1.jpg", "Sherie, Allen", "01/01/2000", "123 Fake Street", "1234567890", "sherie@family7f.com", "", hexdigest("sha256", "sherie"), "", "")
insert_employee(2, "teacher", string(now()), "49.99", "db/employee_pictures/employee2.jpg", "a, z", "01/01/2000", "123 Fake Street", "1234567890", "a", "a@gmail.com", hexdigest("sha256", "a"), "", "")
insert_employee(3, "", string(now()), "49.99", "db/employee_pictures/employee3.jpg", "b, z", "01/01/2000", "123 Fake Street", "1234567890", "b", "b@gmail.com", hexdigest("sha256", "b"), "", "")
