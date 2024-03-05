dblock = ReentrantLock()
function (q::SQLite.Stmt)(args...)
	global dblock
	Threads.lock(dblock) do
		DBInterface.execute(q, [args...])
	end
end

const auth = SQLite.Stmt(db,"SELECT * FROM Employee WHERE (employee_email=? AND password=?);")

const token_auth = SQLite.Stmt(db,"SELECT * FROM Employee WHERE (id=? AND token=?);")

const set_token = SQLite.Stmt(db,"UPDATE Employee SET token=?, token_exp=? WHERE id=?;")

const insert_region = SQLite.Stmt(db,"INSERT INTO Region (space, join_date, state, county, city) VALUES (?,?,?,?,?);")

const set_region = SQLite.Stmt(db,"UPDATE Region SET space=?, join_date=?, state=?, county=?, city=? WHERE id=?;")

const delete_region = SQLite.Stmt(db,"DELETE FROM Region WHERE id=?;")

const get_region = SQLite.Stmt(db,"SELECT * FROM Region WHERE id=?;")

const get_regions = SQLite.Stmt(db,"SELECT * FROM Region LIMIT ? OFFSET (? - 1) * ?;")

const getn_region = SQLite.Stmt(db,"SELECT COUNT(*) FROM Region;")

const insert_contact = SQLite.Stmt(db,"INSERT INTO Contact (region_id, contact_name, contact_phone, contact_email, contact_info) VALUES (?,?,?,?,?);")

const set_contact = SQLite.Stmt(db,"UPDATE Contact SET region_id=?, contact_name=?, contact_phone=?, contact_email=?, contact_info=? WHERE id=?;")

const delete_contact = SQLite.Stmt(db,"DELETE FROM Contact WHERE id=?;")

const get_contact = SQLite.Stmt(db,"SELECT a.*,b.* FROM Contact a INNER JOIN Region b ON a.region_id = b.id WHERE a.id=?;")

const get_contacts = SQLite.Stmt(db,"SELECT a.*,b.* FROM Contact a INNER JOIN Region b ON a.region_id = b.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_contact = SQLite.Stmt(db,"SELECT COUNT(*) FROM Contact;")

const insert_contract = SQLite.Stmt(db,"INSERT INTO Contract (region_id, contract_date, contract_rate, contract_path) VALUES (?,?,?,?);")

const set_contract = SQLite.Stmt(db,"UPDATE Contract SET region_id=?, contract_date=?, contract_rate=?, contract_path=? WHERE id=?;")

const delete_contract = SQLite.Stmt(db,"DELETE FROM Contract WHERE id=?;")

const get_contract = SQLite.Stmt(db,"SELECT a.*,b.* FROM Contract a INNER JOIN Region b ON a.region_id = b.id WHERE a.id=?;")

const get_contracts = SQLite.Stmt(db,"SELECT a.*,b.* FROM Contract a INNER JOIN Region b ON a.region_id = b.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_contract = SQLite.Stmt(db,"SELECT COUNT(*) FROM Contract;")

const insert_caseworker = SQLite.Stmt(db,"INSERT INTO CaseWorker (region_id, caseworker_name, caseworker_phone, caseworker_email, caseworker_info) VALUES (?,?,?,?,?);")

const set_caseworker = SQLite.Stmt(db,"UPDATE CaseWorker SET region_id=?, caseworker_name=?, caseworker_phone=?, caseworker_email=?, caseworker_info=? WHERE id=?;")

const delete_caseworker = SQLite.Stmt(db,"DELETE FROM CaseWorker WHERE id=?;")

const get_caseworker = SQLite.Stmt(db,"SELECT a.*,b.* FROM CaseWorker a INNER JOIN Region b ON a.region_id = b.id WHERE a.id=?;")

const get_caseworkers = SQLite.Stmt(db,"SELECT a.*,b.* FROM CaseWorker a INNER JOIN Region b ON a.region_id = b.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_caseworker = SQLite.Stmt(db,"SELECT COUNT(*) FROM CaseWorker;")

const insert_employee = SQLite.Stmt(db,"INSERT INTO Employee (region_id, roles, employ_date, employee_rate, employee_picture, employee_name, employee_bday, employee_address, employee_phone_number, employee_email, alt_email, password, token, token_exp) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);")

const set_employee = SQLite.Stmt(db,"UPDATE Employee SET region_id=?, roles=?, employ_date=?, employee_rate=?, employee_picture=?, employee_name=?, employee_bday=?, employee_address=?, employee_phone_number=?, employee_email=?, alt_email=?, password=?, token=?, token_exp=? WHERE id=?;")

const delete_employee = SQLite.Stmt(db,"DELETE FROM Employee WHERE id=?;")

const get_employee = SQLite.Stmt(db,"SELECT a.*,b.* FROM Employee a INNER JOIN Region b ON a.region_id = b.id WHERE a.id=?;")

const get_employees = SQLite.Stmt(db,"SELECT a.*,b.* FROM Employee a INNER JOIN Region b ON a.region_id = b.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_employee = SQLite.Stmt(db,"SELECT COUNT(*) FROM Employee;")

const insert_family = SQLite.Stmt(db,"INSERT INTO Family (region_id, employee_id, caseworker_id, contract_id, first_lesson_date, last_lesson_date, family_address, family_phone, family_email, media_release_consent, media_release_date, media_release_path) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);")

const set_family = SQLite.Stmt(db,"UPDATE Family SET region_id=?, employee_id=?, caseworker_id=?, contract_id=?, first_lesson_date=?, last_lesson_date=?, family_address=?, family_phone=?, family_email=?, media_release_consent=?, media_release_date=?, media_release_path=? WHERE id=?;")

const delete_family = SQLite.Stmt(db,"DELETE FROM Family WHERE id=?;")

const get_family = SQLite.Stmt(db,"SELECT a.*,b.*,c.*,d.*,e.* FROM Family a INNER JOIN Region b ON a.region_id = b.id INNER JOIN Employee c ON a.employee_id = c.id INNER JOIN CaseWorker d ON a.caseworker_id = d.id INNER JOIN Contract e ON a.contract_id = e.id WHERE a.id=?;")

const get_familys = SQLite.Stmt(db,"SELECT a.*,b.*,c.*,d.*,e.* FROM Family a INNER JOIN Region b ON a.region_id = b.id INNER JOIN Employee c ON a.employee_id = c.id INNER JOIN CaseWorker d ON a.caseworker_id = d.id INNER JOIN Contract e ON a.contract_id = e.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_family = SQLite.Stmt(db,"SELECT COUNT(*) FROM Family;")

const insert_member = SQLite.Stmt(db,"INSERT INTO Member (family_id, name, member_bday, member_address, member_phone, member_email, living_status) VALUES (?,?,?,?,?,?,?);")

const set_member = SQLite.Stmt(db,"UPDATE Member SET family_id=?, name=?, member_bday=?, member_address=?, member_phone=?, member_email=?, living_status=? WHERE id=?;")

const delete_member = SQLite.Stmt(db,"DELETE FROM Member WHERE id=?;")

const get_member = SQLite.Stmt(db,"SELECT a.*,b.* FROM Member a INNER JOIN Family b ON a.family_id = b.id WHERE a.id=?;")

const get_members = SQLite.Stmt(db,"SELECT a.*,b.* FROM Member a INNER JOIN Family b ON a.family_id = b.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_member = SQLite.Stmt(db,"SELECT COUNT(*) FROM Member;")

const insert_applicant = SQLite.Stmt(db,"INSERT INTO Applicant (region_id, submission_date, applicant_name, applicant_phone, applicant_email, other, resume_path) VALUES (?,?,?,?,?,?,?);")

const set_applicant = SQLite.Stmt(db,"UPDATE Applicant SET region_id=?, submission_date=?, applicant_name=?, applicant_phone=?, applicant_email=?, other=?, resume_path=? WHERE id=?;")

const delete_applicant = SQLite.Stmt(db,"DELETE FROM Applicant WHERE id=?;")

const get_applicant = SQLite.Stmt(db,"SELECT a.*,b.* FROM Applicant a INNER JOIN Region b ON a.region_id = b.id WHERE a.id=?;")

const get_applicants = SQLite.Stmt(db,"SELECT a.*,b.* FROM Applicant a INNER JOIN Region b ON a.region_id = b.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_applicant = SQLite.Stmt(db,"SELECT COUNT(*) FROM Applicant;")

const insert_partnerreport = SQLite.Stmt(db,"INSERT INTO PartnerReport (region_id, employee_id, caseworker_id, contract_id, family_id, report_date, service_date, miles_traveled, arrive_time, depart_time, session_number, session_topic, members_present, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);")

const set_partnerreport = SQLite.Stmt(db,"UPDATE PartnerReport SET region_id=?, employee_id=?, caseworker_id=?, contract_id=?, family_id=?, report_date=?, service_date=?, miles_traveled=?, arrive_time=?, depart_time=?, session_number=?, session_topic=?, members_present=?, q1=?, q2=?, q3=?, q4=?, q5=?, q6=?, q7=?, q8=?, q9=?, q10=?, q11=? WHERE id=?;")

const delete_partnerreport = SQLite.Stmt(db,"DELETE FROM PartnerReport WHERE id=?;")

const get_partnerreport = SQLite.Stmt(db,"SELECT a.*,b.*,c.*,d.*,e.*,f.* FROM PartnerReport a INNER JOIN Region b ON a.region_id = b.id INNER JOIN Employee c ON a.employee_id = c.id INNER JOIN CaseWorker d ON a.caseworker_id = d.id INNER JOIN Contract e ON a.contract_id = e.id INNER JOIN Family f ON a.family_id = f.id WHERE a.id=?;")

const get_partnerreports = SQLite.Stmt(db,"SELECT a.*,b.*,c.*,d.*,e.*,f.* FROM PartnerReport a INNER JOIN Region b ON a.region_id = b.id INNER JOIN Employee c ON a.employee_id = c.id INNER JOIN CaseWorker d ON a.caseworker_id = d.id INNER JOIN Contract e ON a.contract_id = e.id INNER JOIN Family f ON a.family_id = f.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_partnerreport = SQLite.Stmt(db,"SELECT COUNT(*) FROM PartnerReport;")

const insert_precoursesurvey = SQLite.Stmt(db,"INSERT INTO PreCourseSurvey (region_id, family_id, survey_date) VALUES (?,?,?);")

const set_precoursesurvey = SQLite.Stmt(db,"UPDATE PreCourseSurvey SET region_id=?, family_id=?, survey_date=? WHERE id=?;")

const delete_precoursesurvey = SQLite.Stmt(db,"DELETE FROM PreCourseSurvey WHERE id=?;")

const get_precoursesurvey = SQLite.Stmt(db,"SELECT a.*,b.*,c.* FROM PreCourseSurvey a INNER JOIN Region b ON a.region_id = b.id INNER JOIN Family c ON a.family_id = c.id WHERE a.id=?;")

const get_precoursesurveys = SQLite.Stmt(db,"SELECT a.*,b.*,c.* FROM PreCourseSurvey a INNER JOIN Region b ON a.region_id = b.id INNER JOIN Family c ON a.family_id = c.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_precoursesurvey = SQLite.Stmt(db,"SELECT COUNT(*) FROM PreCourseSurvey;")

const insert_postcoursesurvey = SQLite.Stmt(db,"INSERT INTO PostCourseSurvey (region_id, family_id, survey_date) VALUES (?,?,?);")

const set_postcoursesurvey = SQLite.Stmt(db,"UPDATE PostCourseSurvey SET region_id=?, family_id=?, survey_date=? WHERE id=?;")

const delete_postcoursesurvey = SQLite.Stmt(db,"DELETE FROM PostCourseSurvey WHERE id=?;")

const get_postcoursesurvey = SQLite.Stmt(db,"SELECT a.*,b.*,c.* FROM PostCourseSurvey a INNER JOIN Region b ON a.region_id = b.id INNER JOIN Family c ON a.family_id = c.id WHERE a.id=?;")

const get_postcoursesurveys = SQLite.Stmt(db,"SELECT a.*,b.*,c.* FROM PostCourseSurvey a INNER JOIN Region b ON a.region_id = b.id INNER JOIN Family c ON a.family_id = c.id LIMIT ? OFFSET (? - 1) * ?;")

const getn_postcoursesurvey = SQLite.Stmt(db,"SELECT COUNT(*) FROM PostCourseSurvey;")

