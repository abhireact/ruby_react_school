let set3Data = []; // Initialize as an empty array

const fetchSetThreeData = async () => {
  try {
    const response = await fetch('/upload_excel_set_three/template3_exists');
    const data = await response.json();

    set3Data = [
      { 
        id: 1, 
        name: 'Caste', 
        done: data.caste_exists,  
        requiredHeaders: [
          {
            "Caste *": "name",
          },
          {
            name: "string"
          },
        ],
        optionalHeaders: [{}, {}],
        title: "Caste Data Upload",
        uploadEndpoint: "/upload_excel_set_three/upload_castes",
      },
      { 
        id: 2, 
        name: 'Caste Categories', 
        done: data.caste_category_exist,
        requiredHeaders: [
          {
            "Caste Category Name *": "name", 
          },
          { name: "string" },
        ],
        optionalHeaders: [{}, {}],
        title: "Caste Categories Data Upload",
        uploadEndpoint: "/upload_excel_set_three/upload_caste_categories",
      },
      { 
        id: 3, 
        name: 'Student Category', 
        done: data.student_category_exist,
        requiredHeaders: [
          {
            "Student Category *": "name"
          },
          {
            name: "string",

          },
        ],
        optionalHeaders: [{}, {}],
        title: "Student Categories Data Upload",
        uploadEndpoint: "/upload_excel_set_three/upload_student_categories",
      },
      { 
        id: 4, 
        name: 'House Details', 
        done: data.house_details_exist,
        requiredHeaders: [
          {
            "House *": "name",

          },
          {
            name: "string"
          },
        ],
        optionalHeaders: [{}, {}],
        title: "House Details Data Upload",
        uploadEndpoint: "/upload_excel_set_three/upload_house_details",
      },
      { 
        id: 5, 
        name: 'Subject',
        done: data.subject_exist,
        requiredHeaders: [
            {
                "Time Table *": "mg_time_table_name",
                "Class Code *": "mg_course_code",
                "Subject Name *": "subject_name",
                "Subject Code *": "subject_code",
                "Max Weekly Class *": "max_weekly_class",
                "No of Classes *": "no_of_classes",
                "Scoring Type*": "scoring_type"
            },
          {
            mg_time_table_name: "string",
            mg_course_code: "string",
            subject_name: "string",
            subject_code: "string",
            max_weekly_class: "number",
            no_of_classes: "number",
            scoring_type: "string"
          }
        ],
        optionalHeaders:  [{}, {}],
        title: "Subject Data Upload",
        uploadEndpoint: "/upload_excel_set_three/upload_subject_details",
        headerline:1, 
        dataline:2  
      },
      { 
        id: 6, 
        name: 'Section Subject',
        done: data.section_exist,
        requiredHeaders: [
            {
                "Academic Year *": "academic_year",
                "Class Code *": "class_name",
                "Section Name *":"batch_name",
                "Subject Name *": "subject_name",
                "Subject Code *": "subject_code"
            },
          {
            academic_year: "string",
            class_name: "string",
            subject_name: "string",
            subject_code: "string",
            batch_name: "string"
         
          }
        ],
        optionalHeaders:  [{}, {}],
        title: "Section Subject Data Upload",
        uploadEndpoint: "/upload_excel_set_three/upload_subject_details",
      },
      { 
        id: 7, 
        name: 'Student',
        done: data.student_exist,
        requiredHeaders: [
            {   
              "Academic Year *": "academic_year",
              "First Name *": "first_name",
              "Class Code *": "class_name",
              "Section Name *":"section_name",
              "Mobile Number *": "mobile_number"
                
            },
          {
            academic_year: "string",
            first_name: "string",
            class_name: "string",
            section_name: "string",
            mobile_number: "string"
           
         
          }
        ],
        optionalHeaders:  [{
          "Admission Date":"admission_date",
          "Admission Number":"admission_number",
          "Middle Name":"middle_name",
          "Last Name":"last_name",
          'Blood Group' :"blood_group",
          "Aadhar Number":"adharnumber",
          "Caste":"caste_name",
         " Caste Category":"caste_category_name",
          "Student Category":"student_category_name",
          "Mother Tongue":"mother_tongue",
          "Religion":"religion",
          "Is Sibling":"is_sibling",
          "Sibling Name" :"sibling_name",
          "Relationship": "sibling_relationship",
          "Class Code (Sibling)":"sibling_class",
          "Section (Sibling)":"sibling_section",
          "Roll Number":"class_roll_number",
          "Date of Admission (Sibling)":"sibling_date_of_admission",
          "Admission Number (Sibling)":"sibling_admision_number",
        //   "C-Address Line1":"address_line1",
        //   "C-Address Line2":"address_line2",
        //  " C-Street":"city",
        //   "C-Landmark":"landmark",
        //   "C-City" :"city",
        //   "C-State":"state",
        //   "C-Pincode":"pin_code",
        //   "C-Country":"country",
        //   "P-Address Line1":"pr_address_line1",
        //   "P-Address Line2":"pr_address_line2",
        //   "P-Street":"pr_state",
        //   "P-Landmark":"pr_landmark",
        //   "P-City":"pr_city",
        //   "P-State":"pr_state",
        //   "P-Pincode":"pr_pin_code",
        //  " P-Country":"pr_country",
          "Phone Number":"mobile_number",
          "Notification":"student_notification",
          "Subscription":"student_subscription",
          "Email id":"email_id",
          "School Name":"prev_school_name",
          "Class (Marks)": "course",
          "Year" :"year",
          "Marks Obtained":"marks_obtained",
          "Total Marks":"total_marks",
          "Grade/Percentage":"grade",
         " Is Transfer Certificate Produced":"transfer_certificate"
        },  {
          admission_date: "date",
          admission_number: "string",
          middle_name: "string",
          last_name: "string",
          blood_group: "string",
          adharnumber: "string",
          caste_name: "string",
          caste_category_name: "string",
          student_category_name: "string",
          mother_tongue: "string",
          religion: "string",
          is_sibling: "boolean",
          sibling_name: "string",
          sibling_relationship: "string",
          sibling_class: "string",
          sibling_section: "string",
          class_roll_number: "number",
          sibling_date_of_admission: "date",
          sibling_admision_number: "string",
          // address_line1: "string",
          // address_line2: "string",
          // city: "string",
          // landmark: "string",
          // state: "string",
          // pin_code: "string",
          // country: "string",
          // pr_address_line1: "string",
          // pr_address_line2: "string",
          // pr_state: "string",
          // pr_landmark: "string",
          // pr_city: "string",
          // pr_pin_code: "string",
          // pr_country: "string",
          mobile_number: "string",
          student_notification: "boolean",
          student_subscription: "boolean",
          email_id: "string",
          prev_school_name: "string",
          course: "string",
          year: "number",
          marks_obtained: "number",
          total_marks: "number",
          grade: "string",
          transfer_certificate: "boolean",
        }],
        title: "Student Data Upload",
        uploadEndpoint: "/upload_excel_set_three/upload_students",
        headerline:1, 
        dataline:2 
      }
    ];

    return set3Data; // Return the populated array
  } catch (error) {
    console.error("Error fetching data:", error);
    throw error;
  }
};

// Export the populated data after fetching
const exportedset3Data = (async () => {
  await fetchSetThreeData(); // Wait for the data to be fetched
  return set3Data;         // Export the populated array
})();

export default exportedset3Data;
