myTypes = DataType[]

struct Region
    id::Int64
    space::Int64
    join_date::String
    state::String
    county::String
    city::String
end
push!(myTypes, Region)
StructTypes.StructType(::Type{Region}) = StructTypes.Struct()

struct Contact
    id::Int64
    region_id::Int64
    contact_name::String
    contact_phone::String
    contact_email::String
    contact_info::String
end
push!(myTypes, Contact)
StructTypes.StructType(::Type{Contact}) = StructTypes.Struct()

struct Contract
    id::Int64
    region_id::Int64
    contract_date::String
    contract_rate::String
    contract_path::String
end
push!(myTypes, Contract)
StructTypes.StructType(::Type{Contract}) = StructTypes.Struct()

struct CaseWorker
    id::Int64
    region_id::Int64
    caseworker_name::String
    caseworker_phone::String
    caseworker_email::String
    caseworker_info::String
end
push!(myTypes, CaseWorker)
StructTypes.StructType(::Type{CaseWorker}) = StructTypes.Struct()

struct Employee
    id::Int64
    region_id::Int64
    roles::String
    employ_date::String
    employee_rate::String
    employee_picture::String
    employee_name::String
    employee_bday::String
    employee_address::String
    employee_phone_number::String
    employee_email::String
    alt_email::String
    password::String
    token::String
    token_exp::String
end
push!(myTypes, Employee)
StructTypes.StructType(::Type{Employee}) = StructTypes.Struct()

struct Family
    id::Int64
    region_id::Int64
    employee_id::Int64
    caseworker_id::Int64
    contract_id::Int64
    first_lesson_date::String
    last_lesson_date::String
    family_address::String
    family_phone::String
    family_email::String
    media_release_consent::String
    media_release_date::String
    media_release_path::String
end
push!(myTypes, Family)
StructTypes.StructType(::Type{Family}) = StructTypes.Struct()

struct Member
    id::Int64
    family_id::Int64
    name::String
    member_bday::String
    member_address::String
    member_phone::String
    member_email::String
    living_status::String
end
push!(myTypes, Member)
StructTypes.StructType(::Type{Member}) = StructTypes.Struct()

struct Applicant
    id::Int64
    region_id::Int64
    submission_date::String
    applicant_name::String
    applicant_phone::String
    applicant_email::String
    other::String
    resume_path::String
end
push!(myTypes, Applicant)
StructTypes.StructType(::Type{Applicant}) = StructTypes.Struct()

struct PartnerReport
    id::Int64
    region_id::Int64
    employee_id::Int64
    caseworker_id::Int64
    contract_id::Int64
    family_id::Int64
    report_date::String
    service_date::String
    miles_traveled::Int64
    arrive_time::String
    depart_time::String
    session_number::Int64
    session_topic::String
    members_present::String
    q1::String
    q2::String
    q3::String
    q4::String
    q5::String
    q6::String
    q7::String
    q8::String
    q9::String
    q10::String
    q11::String
end
push!(myTypes, PartnerReport)
StructTypes.StructType(::Type{PartnerReport}) = StructTypes.Struct()

struct PreCourseSurvey
    id::Int64
    region_id::Int64
    family_id::Int64
    survey_date::String
end
push!(myTypes, PreCourseSurvey)
StructTypes.StructType(::Type{PreCourseSurvey}) = StructTypes.Struct()

struct PostCourseSurvey
    id::Int64
    region_id::Int64
    family_id::Int64
    survey_date::String
end
push!(myTypes, PostCourseSurvey)
StructTypes.StructType(::Type{PostCourseSurvey}) = StructTypes.Struct()

function create_struct(T, dict)
    field_names = fieldnames(T)
    values = [dict[name] for name in field_names]
    return T(values...)
end
function create_struct(T, dict, alt_id)
    field_names = fieldnames(T)
    values = [dict[name] for name in field_names]
    values[1] = dict[alt_id]
    return T(values...)
end
typename(T) = T.name.name
typeid(T) = Symbol(lowercase(string(typename(T))) * "_id")
function makeTypes(q_result, Ts...)
    MyTuple = NamedTuple{tuple(typename.(Ts)...),Tuple{Ts...}}
    result = MyTuple[]
    for dict in q_result
        structs = Union{Ts...}[create_struct(Ts[1], dict)]
        for T in Ts[2:end]
            push!(structs,
                create_struct(T, dict, typeid(T))
            )
        end
        push!(result, MyTuple(structs))
    end
    if isempty(result)
        return nothing
    end
    return length(result) > 1 ? result : first(result)
end
function makeTypes(q_result, T)
    result = T[]
    for dict in q_result
        push!(result, create_struct(T, dict))
    end
    if isempty(result)
        return nothing
    end
    return length(result) > 1 ? result : first(result)
end