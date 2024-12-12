let set2Data = []; // Initialize as an empty array

const fetchSetTwoData = async () => {
  try {
    const response = await fetch('/upload_excel/employee_data_exists');
    const data = await response.json();
     set2Data = [

        { 
            id: 1, 
            name: 'Employee Department', 
            done: data.department_exists,  
            requiredHeaders: [
                { "Department name *": "department_name",
                    "Department code *": "department_code",} ,{
            department_name:"string",
            department_code:"string"
            },],
            optionalHeaders: [{},{}],
            title: "Employee Department Data Upload",
            uploadEndpoint: "/upload_excel/upload_departments",
            
          },
          { 
            id: 2, 
            name: 'Employee Profile', 
            done:  data.employee_profile_exists,  
            requiredHeaders: [
              {
                "category *": "category_name",
                "profile name *": "position_name", 
              } ,{
                category_name:"string",
                position_name:"string"
            },],
            optionalHeaders: [{},{}],
            title: "Employee Profile Data Upload",
            uploadEndpoint: "/upload_excel/upload_positions",
            
          },
          { 
            id: 3, 
            name: 'Employee Type', 
            done:  data.employee_type_exists,  
            requiredHeaders: [
              {
                "employee type *": "employee_type",
              } ,{
                employee_type:"string",
             },],
            optionalHeaders: [{},{}],
            title: "Employee Type Data Upload",
            uploadEndpoint: "/upload_excel/upload_employee_types",
            
          },
          { 
            id: 4, 
            name: 'Employee Salary Component', 
            done:  data.salary_component_exists ,  
            requiredHeaders: [
              {
                "name *": "name",
                "is deduction *": "is_deduction",
                "account name *": "account_name",
              } ,{
                name:"string",
                is_deduction:"string",
                account_name:"string"
             },],
            optionalHeaders: [{},{}],
            title: "Employee Salary  Upload",
            uploadEndpoint: "/upload_excel/upload_salary",
            
          },
          { 
            id: 5, 
            name: 'Employee Grades', 
            done:  data.grade_exists,  
            requiredHeaders: [
              {
                "grade name *": "grade_name",
              },{},],
            optionalHeaders: [{},{}],
            title: "Employee Grade Data  Upload",
            uploadEndpoint: "/upload_excel/upload_grades",
      
          },
          { 
            id: 6, 
            name: 'Employee Leave', 
            done:  data.leave_type_exists  ,  
            requiredHeaders: [
              {
                "leave type *": "leave_name",
                "leave code *": "leave_code",
                "employee type *": "employee_type",
                "min leave count *": "min_leave_count",
                "max no of leaves *": "max_leave_count",
                "monthly limit *": "monthly_limit",
                "minimum year experience *": "minimum_year_experience",
                "minimum month experience *": "minimum_month_experience",
                "gender *": "gender",
                "marital status *": "marital_status",
            
                "accumulation period *": "accumilation_period",
                "accumulation count *": "accumilation_count",
                "is auto reset": "is_auto_reset",
                "reset period *": "reset_period",
                "reset start date *": "reset_date",
                "is carry forward": "is_carry_forward",
                "carry forward limit *": "carry_forward_limit",
                "is showable": "is_showable"
              },{
                accumilation_period:"number"
             },],
            optionalHeaders: [{
              "should leave not be deducted": "is_leave_should_not_be_deducted",
              "accumulation": "is_accumilation",
              "is auto reset": "is_auto_reset",
              "is carry forward": "is_carry_forward",
              "is showable": "is_showable"
            },{}],
            title: "Employee Leaves Data  Upload",
            uploadEndpoint: "/upload_excel/upload_employee_leave_types",
            headerline:1,//headers from second row 
            dataline:2 // data from third row 
          },
          { 
            id: 7, 
            name: 'Employee ', 
            done:  data.employee_exists  ,  
            requiredHeaders: [
              {
                "first name *": "first_name",
                "employee category *": "emp_category",
                "employee department *": "emp_department",
                "mobile number *": "mobile_number",
                "date of birth":"date_of_birth",
                "joining date":"employee_joining_date",
              },{
               "employee_joining_date":"date",
               "date_of_birth":"date",
             },],
            optionalHeaders: [{
              "last name *": "last_name",
              "middle name": "middle_name",
              "employee profile": "emp_profile",
              "job title": "job_title",
              "qualification": "qualification",
              "total year experience": "t_year_exp",
              "total month experience": "t_mon_exp",
              "employee type": "emp_type",
              "mother tongue": "mother_tongue",
              "ltc applicable": "ltc_applicable",
              "max class per day": "max_class_per_day",
              "employee grade": "emp_grade",
              "last working day": "last_work_day",
              "status": "status",
              "aadhar number": "aadhar_number",
              "bank name": "bank_name",
              "account number": "account_number",
              "branch name": "branch_name",
              "ifs code": "ifs_code",
              "phone number": "phone_number",
              "email id": "email_id",
            },{}],
            title: "Employee  Data  Upload",
            uploadEndpoint: "/upload_excel/upload_employees",
            headerline:1,//headers from second row 
            dataline:2 // data from third row 
          },
          // { 
          //   id: 8, 
          //   name: 'Assign Class Teacher', 
          //   done:  data.employee_exists  ,  
          //   requiredHeaders: [
          //     {
          //       "Employee First Name *": "employee_f_name",
          //       "Employee Last Name *": "employee_l_name",
          //       "Date of Birth *": "dob",
          //       "Class Code *": "class_code",
          //       "Section Name *": "section_name"
          //     }
          //     ,{
          //      "employee_joining_date":"date"
          //    },],
          //   optionalHeaders: [{
             
          //   },{}],
          //   title: "Employee  Data  Upload",
          //   uploadEndpoint: "/upload_excel/upload_employees",
          //   headerline:1,//headers from second row 
          //   dataline:2 // data from third row 
          // },
   
    
    ];

    return set2Data; // Return the populated array
  } catch (error) {
    console.error("Error fetching data:", error);
    throw error;
  }
};

// Export the populated data after fetching
const exportedSet2Data = (async () => {
  await fetchSetTwoData(); // Wait for the data to be fetched
  return set2Data;         // Export the populated array
})();

export default exportedSet2Data;

// const fetchEmployeeData = async () => {
//     try {
//       const response = await fetch('/upload_excel/employee_data_exists');
//       const data = await response.json();

//      set2Data = [

//         { 
//             id: 1, 
//             name: 'Employee Department', 
//             done: data.timetable_exists,  
//             requiredHeaders: [
//                 { "Department name *": "department_name",
//                     "Department code *": "department_code",} ,{
//             department_name:"string",
//             department_code:"string"
//             },],
//             optionalHeaders: [{},{}],
//             title: "Employee Department Data Upload",
//             uploadEndpoint: "/upload_excel/upload_departments",
            
//           },
//         { id: 2, name: 'Employee Profile', done: data.employee_profile_exists },
//         { id: 3, name: 'Employee Type', done: data.employee_type_exists },
//         { id: 4, name: 'Employee Salary Component', done: data.salary_component_exists },
//         { id: 5, name: 'Employee Grade', done: data.grade_exists },
//         { id: 6, name: 'Employee Leaves', done: data.leave_type_exists },
//         { id: 7, name: 'Employee', done: data.employee_exists },
//       ];

    
//     } catch (error) {
//       console.error('Error fetching school data:', error);

//     }
//   };