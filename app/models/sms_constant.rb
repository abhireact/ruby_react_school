class SmsConstant < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_TIME_REGEX = /\b((1[0-2]|0?[1-9]):([0-5][0-9])([AaPp][Mm]))/
  SCHOOL_CLOUD_ADMIN_UPLOAD = ["School Name *", "School Code *", "Start Time *", "End Time *", "Affiliated To *", "Affiliation No/Reg No *", "Leave Calendar Start Date", "Address Line1 *", "Address Line2", "Street", "Landmark", "City *", "State *", "Pincode *", "Country *", "Phone Number *", "Fax Number *", "Email Id *", "Time Zone", "Currency Type *", "Grading System *"]
  SCHOOL_CLOUD_ADMIN_UPLOAD_MANDATORY = ["School Name *", "School Code *", "Start Time *", "End Time *", "Affiliated To *", "Affiliation No/Reg No *", "Address Line1 *", "State *", "Pincode *", "Country *", "Phone Number *", "Fax Number *", "Email Id *", "Currency Type *", "Grading System *"]
  SCHOOL_CLOUD_ADMIN_UPLOAD_DATA_TYPE_LENGTH = ["School Name *", "School Code *", "Affiliated To *", "Affiliation No/Reg No *", "Address Line1 *", "Address Line2", "Street", "Landmark", "City *", "State *", "Country *", "Fax Number *", "Currency Type *", "Grading System *"]
  SCHOOL_CLOUD_ADMIN_UPLOAD_DATE_FIELDS = ["Leave Calendar Start Date"]
  SCHOOL_CLOUD_ADMIN_UPLOAD_PHONE_FIELDS = ["Phone Number *"]
  SCHOOL_CLOUD_ADMIN_UPLOAD_PINCODE_FIELDS = ["Pincode *"]
  SCHOOL_CLOUD_ADMIN_UPLOAD_EMAIL_FIELDS = ["Email Id *"]
  SCHOOL_CLOUD_ADMIN_UPLOAD_TIME_FIELDS = ["Start Time *", "End Time *"]
  WING_CLOUD_ADMIN_UPLOAD = ["Wing name *"]
  WING_CLOUD_ADMIN_UPLOAD_MANDATORY = ["Wing name *"]
  WING_CLOUD_ADMIN_UPLOAD_DATA_TYPE = ["Wing name *"]
  ACADEMIC_YEAR_FOR_SCHOOL_UPLOAD = ["Name *", "Start Date *", "End Date *"]
  ACADEMIC_YEAR_FOR_SCHOOL_UPLOAD_MANDATORY = ["Name *", "Start Date *", "End Date *"]
  ACADEMIC_YEAR_FOR_SCHOOL_UPLOAD_DATE_FIELDS = ["Start Date *", "End Date *"]
  ACCOUNT_FOR_SCHOOL_UPLOAD = ["Account Name *", "Description", "User Name *", "Password *"]
  ACCOUNT_FOR_SCHOOL_UPLOAD_MANDATORY = ["Account Name *", "User Name *", "Password *"]
  HOUSE_SCHOOL_UPLOAD = ["House *", "Description"]
  HOUSE_SCHOOL_UPLOAD_DATA_TYPE = ["House *", "Description"]
  HOUSE_SCHOOL_UPLOAD_MANDATORY = ["House *"]
  CLOUD_ACCOUNT_ADMIN_UPLOAD = ["Account Name *", "Description", "User Name *", "Password *"]
  CLOUD_ACCOUNT_ADMIN_UPLOAD_MANDATORY = ["Account Name *", "User Name *", "Password *"]
  CLASS_CLOUD_ADMIN_UPLOAD = ["Time Table *", "Wing  Name *", "Class name *", "Code *"]
  CLASS_CLOUD_ADMIN_UPLOAD_MANDATORY = ["Time Table *", "Wing  Name *", "Class name *", "Code *"]
  CLASS_CLOUD_ADMIN_UPLOAD_DATA_TYPE = ["Class name *", "Code *"]
  CLASS_CLOUD_ADMIN_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Time Table *", column_name: "name", table: MgTimeTable, invalid: [], dependency: "Academic year" }, { column: "Wing  Name *", column_name: "wing_name", table: MgWing, invalid: [], dependency: "wings" }]
  SECTION_CLOUD_ADMIN_UPLOAD = ["Class Name *", "Section Name *", "Start Date *", "End Date *"]
  SECTION_CLOUD_ADMIN_UPLOAD_DATA_TYPE = ["Section Name *"]
  SECTION_CLOUD_ADMIN_UPLOAD_MANDATORY = ["Class Name *", "Section Name *", "Start Date *", "End Date *"]
  SECTION_CLOUD_ADMIN_UPLOAD_DATE_FIELDS = ["Start Date *", "End Date *"]
  SECTION_CLOUD_ADMIN_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Class Name *", column_name: "course_name", table: MgCourse, invalid: [], dependency: "classes" }]
  EMPLOYEES_LEAVE_TYPE_UPLOAD = ["Leave Type *", "Leave Code *", "Employee Type *", "Min Leave Count *", "Max No of Leaves *", "Minimum Year Experience *", "Minimum Month Experience *", "Gender *", "Should Leave Not Be Deducted *", "Accumulation *", "Accumulation Period", "Accumulation Count", "Is Auto Reset *", "Reset Period", "Reset Start Date", "Is Carry Forward *", "Carry Forward Limit", "Is Showable", "Monthly limit *", "Delay deduction *", "Delay time", "Delay days count", "Leave deduction count"]
  EMPLOYEES_LEAVE_TYPE_UPLOAD_MANDATORY = ["Leave Type *", "Leave Code *", "Employee Type *", "Min Leave Count *", "Max No of Leaves *", "Minimum Year Experience *", "Minimum Month Experience *", "Gender *", "Should Leave Not Be Deducted *", "Accumulation *", "Is Auto Reset *", "Is Carry Forward *", "Is Showable", "Monthly limit *", "Delay deduction *"]
  EMPLOYEES_LEAVE_TYPE_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Employee Type *", column_name: "employee_type", table: MgEmployeeType, invalid: [], dependency: "employee types" }]
  EMPLOYEES_LEAVE_TYPE_UPLOAD_COLUMN_DEPENDANCY_FIELDS = [["Accumulation *", "Accumulation Period", "Accumulation Count"], ["Is Auto Reset *", "Reset Period", "Reset Start Date"], ["Is Carry Forward *", "Carry Forward Limit"], ["Delay deduction *", "Delay time", "Delay days count", "Leave deduction count"]]
  EMPLOYEE_DEPARTMENT_SCHOOL_UPLOAD = ["Department name *", "Department code *"]
  EMPLOYEE_DEPARTMENT_SCHOOL_UPLOAD_DATA_TYPE = ["Department name *", "Department code *"]
  EMPLOYEE_PROFILE_SCHOOL_UPLOAD = ["Category *", "Profile Name *"]
  EMPLOYEE_PROFILE_SCHOOL_UPLOAD_DATA_TYPE = ["Profile Name *"]
  EMPLOYEE_PROFILE_SCHOOL_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Category *", column_name: "category_name", table: MgEmployeeCategory, invalid: [], dependency: "employee categories" }]
  EMPLOYEE_TYPE_SCHOOL_UPLOAD = ["Employee type *"]
  EMPLOYEE_TYPE_SCHOOL_UPLOAD_DATA_TYPE = ["Employee type *"]
  EMPLOYEE_TYPE_SCHOOL_UPLOAD_MANDATORY = ["Employee type *"]
  EMPLOYEE_SCHOOL_UPLOAD = ["User name", "Sl No", "Joining Date", "First Name *", "Middle Name", "Last Name *", "Gender", "Date of Birth", "Employee Category *", "Employee Profile", "Employee Department *", "Job Title", "Qualification", "Total Year Experience", "Total Month Experience", "Employee Type", "Mother Tongue", "LTC Applicable", "Max Class Per Day", "Employee Grade", "Last Working Day", "Status", "Aadhar Number", "Bank Name", "Account Number", "Branch Name", "IFS Code", "Marital Status", "Mother's Name", "Father's Name", "Blood Group", "Country", "Referred", "Referred By", "Designation", "C-Address Line1", "C-Address Line2", "C-City", "C-State", "C-Pincode", "C-Country", "C-Landmark", "P-Address Line1", "P-Address Line2", "P-City", "P-State", "P-Pincode", "P-Country", "P-Landmark", "Phone Number", "Mobile Number *", "M-Notification", "M-Subscription", "Email Id", "E-Notification", "E-Subscription", "Contact Name", "Contact Number"]
  EMPLOYEE_SCHOOL_UPLOAD_DATA_TYPE = ["User name", "Sl No", "Joining Date", "First Name *", "Middle Name", "Last Name *", "Gender", "Job Title", "Qualification", "Total Year Experience", "Total Month Experience", "Mother Tongue", "Max Class Per Day", "Status", "Aadhar Number", "Bank Name", "Account Number", "Branch Name", "IFS Code", "Marital Status", "Mother's Name", "Father's Name", "Blood Group", "Country", "Referred", "Referred By", "Designation", "C-Address Line1", "C-Address Line2", "C-City", "C-State", "C-Country", "C-Landmark", "P-Address Line1", "P-Address Line2", "P-City", "P-State", "P-Country", "P-Landmark", "Contact Name"]
  EMPLOYEE_SCHOOL_UPLOAD_MANDATORY = ["First Name *", "Last Name *", "Employee Category *", "Employee Department *"]
  EMPLOYEE_SCHOOL_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Employee Department *", column_name: "department_name", table: MgEmployeeDepartment, invalid: [], dependency: "employee dapartments" }, { column: "Employee Profile", column_name: "position_name", table: MgEmployeePosition, invalid: [], dependency: "employee positions" }, { column: "Employee Type", column_name: "employee_type", table: MgEmployeeType, invalid: [], dependency: "employee types" }, { column: "Employee Grade", column_name: "grade_name", table: MgEmployeeGrade, invalid: [], dependency: "employee grades" }]
  EMPLOYEE_SCHOOL_UPLOAD_PHONE_FIELDS = ["Mobile Number *"]
  EMPLOYEE_SCHOOL_UPLOAD_DATE_FIELDS = ["Date of Birth", "Joining Date"]
  EMPLOYEE_CATEGORY_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Employee Category *", column_name: "category_name", table: MgEmployeeCategory, invalid: [], dependency: "employee categories" }]
  SALARY_COMPONENT_SCHOOL_UPLOAD = ["Name *", "Is deduction *", "Account Name *"]
  SALARY_COMPONENT_SCHOOL_UPLOAD_DATA_TYPE = ["Name *", "Account Name *"]
  SALARY_COMPONENT_SCHOOL_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Account Name *", column_name: "mg_account_name", table: MgAccount, invalid: [], dependency: "Accounts" }]
  GRADE_SCHOOL_UPLOAD = ["Grade name *", "Components *", "Applicable *", "Amount *"]
  GRADE_SCHOOL_UPLOAD_DATA_TYPE = ["Grade name *", "Components *"]
  GRADE_SCHOOL_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Components *", column_name: "name", table: MgSalaryComponent, invalid: [], dependency: "Salary Components" }]
  ASSIGN_ClASS_TEACHER_CLOUD_ADMIN_UPLOAD = ["Class Code *", "Section Name *", "Employee First Name *", "Employee Last Name *", "Date of Birth *"]
  ASSIGN_ClASS_TEACHER_CLOUD_ADMIN_UPLOAD_DATE_FIELDS = ["Date of Birth *"]
  ASSIGN_ClASS_TEACHER_CLOUD_ADMIN_UPLOAD_EMPLOYEE_FIELDS = [{ column: ["Employee First Name *", "Employee Last Name *", "Date of Birth *"], column_name: ["first_name", "last_name", "date_of_birth"], table: MgEmployee, invalid: [], dependency: "Employees" }]
  ASSIGN_ClASS_TEACHER_CLOUD_ADMIN_UPLOAD_CLASS_FIELDS = [{ column: ["Class Code *", "Section Name *"], column_name: ["code", "name"], table: [MgCourse, MgBatch], invalid: [], dependency: "Class and Section" }]
  CASTE_FOR_SCHOOL_UPLOAD = ["Caste *", "Description"]
  CASTE_FOR_SCHOOL_UPLOAD_DATA_TYPE = ["Caste *", "Description"]
  CASTE_FOR_SCHOOL_UPLOAD_MANDATORY = ["Caste *"]
  CASTE_CATEGORY_FOR_SCHOOL_UPLOAD = ["Caste Category Name *", "Description"]
  CASTE_CATEGORY_FOR_SCHOOL_UPLOAD_DATA_TYPE = ["Caste Category Name *", "Description"]
  CASTE_CATEGORY_FOR_SCHOOL_UPLOAD_MANDATORY = ["Caste Category Name *"]
  STUDENT_CATEGORY_FOR_SCHOOL_UPLOAD = ["Student Category *"]
  STUDENT_CATEGORY_FOR_SCHOOL_UPLOAD_DATA_TYPE = ["Student Category *"]
  STUDENT_FOR_SCHOOL_UPLOAD = ["User name", "SL.NO", "Admission Date", "Admission Number*", "House", "First Name *", "Middle Name", "Last Name *", "Class Code *", "Section Name *", "Date of Birth", "Gender", "Blood Group", "Birth Place", "Country", "Aadhar Number", "Caste", "Caste Category", "Mother Tongue", "Religion", "Quota", "Name of Scholarship", "Annual Scholarship Amount", "Frequency of Disbursement", "Start Date", "End Date", "Name", "Position", "Employee Id", "Joining Date", "Employee First Name", "Employee Last Name", "Employe date of birth", "Employee Type", "Employee Id", "Joining Date", "Is Sibling", "Sibling Name", "Relationship", "Class Code", "Section", "Roll Number", "Date of Admission", "Admission Number", "C-Address Line1", "C-Address Line2", "C-Street", "C-Landmark", "C-City", "C-State", "C-Pincode", "C-Country", "P-Address Line1", "P-Address Line2", "P-Street", "P-Landmark", "P-City", "P-State", "P-Pincode", "P-Country", "Phone Number", "Mobile Number", "Notification", "Subscription", "Email id", "Notification", "Subscription", "School Name", "Class", "Year", "Marks Obtained", "Total Marks", "Grade/Percentage", "Is Transfer Certificate Produced", "Guardian First Name *", "Guardian Middle Name", "Guardian Last Name *", "Relation", "Guardian Date of Birth", "Occupation", "Education", "Guardian Aadhar Number", "Address Line1", "Address Line2", "Street", "Landmark", "City", "State", "Pincode", "Country", "Guardian Phone Number", "Mobile Number *", "Notification", "Subscription", "Email Id", "Notification", "Subscription", "Primary Contact", "Guardian2 First Name *", "Guardian2 Last Name", "Guardian2 Mobile Number", "Guardian2 Email Id", "Guardian2 Relation", "Guardian2 Primary Contact", "Guardian First Name *", "Guardian3 Last Name", "Guardian3 Mobile Number", "Guardian3 Email Id", "Guardian3 Relation", "Guardian3 Primary Contact"]
  STUDENT_SCHOOL_UPLOAD_MANDATORY = ["Admission Number*", "First Name *", "Last Name *", "Class Code *", "Section Name *", "Guardian First Name *", "Guardian Last Name *", "Mobile Number *", "Guardian2 First Name *"]
  STUDENT_SCHOOL_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Class Code *", column_name: "code", table: MgCourse, invalid: [], dependency: "class" }, { column: "Section Name *", column_name: "name", table: MgBatch, invalid: [], dependency: "Section" }, { column: "Caste", column_name: "name", table: MgCaste, invalid: [], dependency: "Caste" }, { column: "Caste Category", column_name: "name", table: MgCasteCategory, invalid: [], dependency: "Caste Category" }]
  STUDENT_SCHOOL_UPLOAD_PHONE_FIELDS = ["Mobile Number *"]
  STUDENT_SCHOOL_UPLOAD_DATE_FIELDS = ["Date of Birth", "Joining Date"]
  SUBJECT_SCHOOL_UPLOAD = ["Class Code *", "Subject Name *", "Subject Code *", "Max Weekly Class *", "Is Extra Curricular *", "Is Core Subject *", "Is Lab *", "No of Classes *", "Index"]
  SUBJECT_SCHOOL_UPLOAD_MANDATORY = ["Class Code *", "Subject Name *", "Subject Code *", "Max Weekly Class *", "Is Extra Curricular *", "Is Core Subject *", "Is Lab *", "No of Classes *"]
  SUBJECT_SCHOOL_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Class Code *", column_name: "code", table: MgCourse, invalid: [], dependency: "classes" }]
  SECTION_SUBJECT_SCHOOL_UPLOAD = ["Class Code *", "Section Name *", "Subject Name *", "Subject Code *"]
  SECTION_SUBJECT_SCHOOL_UPLOAD_CLASS_FIELDS = [{ column: ["Class Code *", "Section Name *"], column_name: ["code", "name"], table: [MgCourse, MgBatch], invalid: [], dependency: "Classes" }]
  SECTION_SUBJECT_SCHOOL_UPLOAD_SUBJECT_FIELDS = [{ column: ["Class Code *", "Subject Name *"], column_name: ["code", "subject_name"], table: [MgCourse, MgSubject], invalid: [], dependency: "Subjects" }]
  FEE_CATEGORY_SCHOOL_UPLOAD = ["Name *", "Description", "Particulars *"]
  FEE_CATEGORY_SCHOOL_UPLOAD_MANDATORY = ["Name *", "Particulars *"]
  FEE_PARTICULAR_SCHOOL_UPLOAD = ["Fee Category *", "Fee Particular *", "Account *", "Amount *", "Class Code *", "Section *", "Student First Name", "Student Last Name", "Date of Birth", "Student Category"]
  FEE_PARTICULAR_SCHOOL_UPLOAD_DATE_FIELDS = ["Date of Birth"]
  FEE_PARTICULAR_SCHOOL_UPLOAD_MANDATORY = ["Fee Category *", "Fee Particular *", "Account *", "Amount *", "Class Code *", "Section *"]
  FEE_PARTICULAR_SCHOOL_UPLOAD_CLASS_FIELDS = [{ column: ["Class Code *", "Section *"], column_name: ["code", "name"], table: [MgCourse, MgBatch], invalid: [], dependency: "Classes" }]
  FEE_PARTICULAR_SCHOOL_UPLOAD_CATEGORY_FIELDS = [{ column: ["Fee Category *", "Fee Particular *"], column_name: ["name", "particular_name"], table: [MgFeeCategory, MgParticularType], invalid: [], dependency: "Particulars" }]
  FEE_PARTICULAR_SCHOOL_UPLOAD_STUDENT_FIELDS = [{ column: ["Student First Name", "Student Last Name", "Date of Birth"], column_name: ["first_name", "last_name", "date_of_birth"], table: MgStudent, invalid: [], dependency: "Students" }]
  FEE_PARTICULAR_SCHOOL_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Fee Category *", column_name: "name", table: MgFeeCategory, invalid: [], dependency: "Fee Category" }, { column: "Account *", column_name: "mg_account_name", table: MgAccount, invalid: [], dependency: "Accounts" }]
  LATE_FEE_FINE_SCHOOL_UPLOAD = ["Fine Name *", "Description", "Days After Due Date *", "Amount *", "Account *"]
  LATE_FEE_FINE_SCHOOL_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Account *", column_name: "mg_account_name", table: MgAccount, invalid: [], dependency: "Accounts" }]
  QUESTION_BANK_UPLOAD = ["Syllabus *", "Chapter *", "Topic *", "Question type *", "Question *", "Mark *", "Difficulty level *", "Blooms level *", "Question key *", "Answer *"]
  QUESTION_BANK_PM_UPLOAD = ["Syllabus *", "Chapter *", "Topic *", "Question type *", "Paragraph *", "Total Mark *", "Difficulty level *", "Blooms level *", "Question *", "Mark *", "Question key *", "Answer *"]
  QUESTION_BANK_ARQ_UPLOAD = ["Syllabus *", "Chapter *", "Topic *", "Question type *", "Assertion *", "Reason *", "Mark *", "Difficulty level *", "Blooms level *", "Question key *", "Answer *"]
  QUESTION_BANK_DTQ_UPLOAD = ["Syllabus *", "Chapter *", "Topic *", "Question type *", "Question *", "Mark *", "Difficulty level *", "Blooms level *", "Question key *"]
  QUESTION_BANK_UPLOAD_MANDATORY = ["Syllabus *", "Chapter *", "Topic *", "Question type *", "Question *", "Mark *", "Difficulty level *", "Blooms level *", "Question key *", "Answer *"]
  QUESTION_BANK_DTQ_UPLOAD_MANDATORY = ["Syllabus *", "Chapter *", "Topic *", "Question type *", "Question *", "Mark *", "Difficulty level *", "Blooms level *", "Question key *"]
  QUESTION_BANK_ARQ_UPLOAD_MANDATORY = ["Syllabus *", "Chapter *", "Topic *", "Question type *", "Assertion *", "Reason *", "Mark *", "Difficulty level *", "Blooms level *", "Question key *", "Answer *"]
  QUESTION_BANK_PMQ_UPLOAD_MANDATORY = ["Syllabus *", "Chapter *", "Topic *", "Question type *", "Paragraph *", "Total Mark *", "Difficulty level *", "Blooms level *", "Question *", "Mark *", "Question key *", "Answer *"]
  QUESTION_BANK_UPLOAD_DEPENDANCY_FIELDS = [{ column: "Syllabus *", column_name: "name", table: MgSyllabus, invalid: [], dependency: "Syllabus" }, { column: "Chapter *", column_name: "unit_name", table: MgUnit, invalid: [], dependency: "Chapter" }, { column: "Topic *", column_name: "topic_name", table: MgTopic, invalid: [], dependency: "Topic" }]
end
