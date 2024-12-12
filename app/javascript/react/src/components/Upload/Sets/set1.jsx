let set1Data = []; // Initialize as an empty array

const fetchSchoolData = async () => {
  try {
    const response = await fetch('/upload_excel_set_one/template1_exists');
    const data = await response.json();

    set1Data = [
      { 
        id: 1, 
        name: 'Academic Year', 
        done: data.timetable_exists,  
        requiredHeaders: [
          {
            "name *": "name",
            "start date *": "start_date",
            "end date *": "end_date",
          },
          {
            name: "string",
            start_date: "date",
            end_date: "date",
          },
        ],
        optionalHeaders: [{}, {}],
        title: "Academic Year Data Upload",
        uploadEndpoint: "/upload_excel_set_one/upload_academics",
      },
      { 
        id: 2, 
        name: 'Wings', 
        done: data.wings_exists,
        requiredHeaders: [
          {
            "wing name *": "wing_name", 
          },
          { wing_name: "string" },
        ],
        optionalHeaders: [{}, {}],
        title: "Wings Data Upload",
        uploadEndpoint: "/upload_excel_set_one/upload_wings",
      },
      { 
        id: 3, 
        name: 'Class', 
        done: data.class_exists,
        requiredHeaders: [
          {
            "wing name *": "wing_name",
            "time table *": "time_table",
            "class name *": "course_name",
            "code *": "code",
          },
          {
            wing_name: "string",
            time_table: "string",
            course_name: "string",
          },
        ],
        optionalHeaders: [{}, {}],
        title: "Class Data Upload",
        uploadEndpoint: "/upload_excel_set_one/upload_class",
      },
      { 
        id: 4, 
        name: 'Section', 
        done: data.section_exists,
        requiredHeaders: [
          {
            "class name *": "course_name",
            "section name *": "name",
            "start date *": "start_date",
            "end date *": "end_date",
          },
          {
            course_name: "string",
            name: "string",
            start_date: "string",
            end_date: "string",
          },
        ],
        optionalHeaders: [{}, {}],
        title: "Section Data Upload",
        uploadEndpoint: "/upload_excel_set_one/upload_section",
      },
      { 
        id: 5, 
        name: 'Account', 
        done: data.accounts_exists,
        requiredHeaders: [
          {
            "account name *": "mg_account_name",
            "user name *": "user_name",
            "password *": "password",
          },
          {
            mg_account_name: "string",
            user_name: "string",
            password: "string",
          },
        ],
        optionalHeaders: [{}, {}],
        title: "Account Data Upload",
        uploadEndpoint: "/upload_excel_set_one/upload_accounts",
      },
    ];

    return set1Data; // Return the populated array
  } catch (error) {
    console.error("Error fetching data:", error);
    throw error;
  }
};

// Export the populated data after fetching
const exportedSet1Data = (async () => {
  await fetchSchoolData(); // Wait for the data to be fetched
  return set1Data;         // Export the populated array
})();

export default exportedSet1Data;
