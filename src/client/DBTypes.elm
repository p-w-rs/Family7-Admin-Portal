module DBTypes exposing (..)


type alias Region =
    { id : Int, space : Int, join_date : String, state : String, county : String, city : String }


type alias Contact =
    { id : Int, region_id : Int, contact_name : String, contact_phone : String, contact_email : String, contact_info : String }


type alias Contract =
    { id : Int, region_id : Int, contract_date : String, contract_rate : String, contract_path : String }


type alias CaseWorker =
    { id : Int, region_id : Int, caseworker_name : String, caseworker_phone : String, caseworker_email : String, caseworker_info : String }


type alias Employee =
    { id : Int, region_id : Int, roles : String, employ_date : String, employee_rate : String, employee_picture : String, employee_name : String, employee_bday : String, employee_address : String, employee_phone_number : String, employee_email : String, alt_email : String, password : String, token : String, token_exp : String }


type alias Family =
    { id : Int, region_id : Int, employee_id : Int, caseworker_id : Int, contract_id : Int, first_lesson_date : String, last_lesson_date : String, family_address : String, family_phone : String, family_email : String, media_release_consent : String, media_release_date : String, media_release_path : String }


type alias Member =
    { id : Int, family_id : Int, name : String, member_bday : String, member_address : String, member_phone : String, member_email : String, living_status : String }


type alias Applicant =
    { id : Int, region_id : Int, submission_date : String, applicant_name : String, applicant_phone : String, applicant_email : String, other : String, resume_path : String }


type alias PartnerReport =
    { id : Int, region_id : Int, employee_id : Int, caseworker_id : Int, contract_id : Int, family_id : Int, report_date : String, service_date : String, miles_traveled : Int, arrive_time : String, depart_time : String, session_number : Int, session_topic : String, members_present : String, q1 : String, q2 : String, q3 : String, q4 : String, q5 : String, q6 : String, q7 : String, q8 : String, q9 : String, q10 : String, q11 : String }


type alias PreCourseSurvey =
    { id : Int, region_id : Int, family_id : Int, survey_date : String }


type alias PostCourseSurvey =
    { id : Int, region_id : Int, family_id : Int, survey_date : String }
