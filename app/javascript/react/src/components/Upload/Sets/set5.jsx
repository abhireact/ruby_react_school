let set5Data = []; // Initialize as an empty array

const fetchSetFiveData = async () => {
  try {
    const response = await fetch('/upload_excel_set_one/template1_exists');
    const data = await response.json();

    set5Data = [
      { 
        id: 1, 
        name: 'Library Resource Categories', 
        done: data.timetable_exists,  
        requiredHeaders: [
          {
            "name *": "name",
            "Wing Name *":"wing_name"

          },
          {
            "name": "string",
            "wing_name":"string"
          },
        ],
        optionalHeaders: [{
            "description" : "description"
        }, 
        {
            "description":"string"

        }],
        title: "Library Resource Type Data Upload",
        uploadEndpoint: "/upload_excel_set_five/upload_library_resource_category",
      },
      {
        "id": 2,
        "name": "Library Resource Type",
        "done": data.timetable_exists,
        requiredHeaders: [
            {
                "Resource Category *": "resource_category",
                "Type of Resource *": "type_of_resource",
                "Max Issuable Count *": "max_issuable_count",
                "Max Borrow Days *": "max_borrow_days",
                "Renewal Period *": "renewal_period",
                "Max no.of Renewals Allowed *": "max_renewals_allowed",
                "Fine(per day) *": "fine_per_day",
                "Prefix *": "prefix",
                "Wing Name *": "wing_name",
                "User Type *": "user_type"
            },
            {
                "resource_category": "string",
                "type_of_resource": "string",
                "max_issuable_count": "number",
                "max_borrow_days": "number",
                "renewal_period": "number",
                "max_no_of_renewals_allowed": "number",
                "fine_per_day": "number",
                "prefix": "string",
                "wing_name": "string",
                "user_type": "string"
            }
        ],
        optionalHeaders: [
            {
                "Description": "description",
                "Is Non Issuable": "is_non_issuable"
            },
            {
                "description": "string",
                "is_non_issuable": "boolean"
            }
        ],
        "title": "Library Resource Type Data Upload",
        uploadEndpoint: "/upload_excel_set_five/upload_resource_type"
    },
    {
      "id": 3,
      "name": "Library Manage Subject",
      "done": data.timetable_exists,
      requiredHeaders: [
          {
              "Subject *": "name",
             
          },
          {
              "name": "string",
              
          }
      ],
      optionalHeaders: [
          {
              "Description": "description"
              
          },
          {
              "description": "string"
              
          }
      ],
      "title": "Library Manage Subject Data Upload",
      uploadEndpoint: "/upload_excel_set_five/upload_library_subjects"
    },
    {
      "id": 4,
      "name": "Library Stack Management",
      "done": data.timetable_exists,
      requiredHeaders: [
          {
              "Room No *": "room_no",
              "Rack No *":"rack_no",
              "First Letter of Title *":"first_letter_of_title"
             
          },
          {
              "room_no": "number",
              "rack_no": "number",
              "first_letter_of_title": "string"
              
          }
      ],
      optionalHeaders: [{},{}],
      "title": "Library Stack Management Data Upload",
      uploadEndpoint: "/upload_excel_set_five/upload_library_stack"
    },
    {
      "id": 5,
      "name": "Library Resource Inventory",
      "done": data.timetable_exists,
      requiredHeaders: [
        {
          "Resource Category *": "resource_category",
          "Resource Type *": "resource_type",
          "Name/Title *": "name_title",
          "Author *": "author",
          "Subject *": "subject",
          "Class *": "class",
          "Stack Title*": "stack_title",
          "Wing Name *": "wing_name",
          "Stack Room *": "stack_room",
          "Stack rack *": "stack_rack",
          "Cost *" :"cost"
        },
        {
          "resource_category": "string",
          "resource_type": "string",
          "name_title": "string",
          "author": "string",
          "subject": "string",
          "class": "string",
          "stack_title": "string",
          "wing_name": "string",
          "stack_room": "number",
          "stack_rack": "number",
          "cost":"number"
        }
      ],
      optionalHeaders: [
        {
          "Volume/Edition": "volume_edition",
          "Year": "year",
          "Publication/Company": "publication_company",
          "Accession No": "accession_no",
          "ISBN/ISSN": "isbn_issn",
          "Non-Issuable": "non_issuable",
          "Is Lost": "is_lost",
          "Is Damaged": "is_damaged"
        },
        {
          "volume_edition": "string",
          "year": "string",
          "publication_company": "string",
          "accession_no": "string",
          "isbn_issn": "string",
          "non_issuable": "boolean",
          "is_lost": "boolean",
          "is_damaged": "boolean"
        }
      ],
      title: "Library Resource Inventory Data Upload",
      uploadEndpoint: "/upload_excel_set_five/upload_library_resources_inventory"
    },
    {
      "id": 6,
      "name": "Library Incharge",
      "done": data.timetable_exists,
      requiredHeaders: [
          {
              "User Name *": "user_name",
              "Password *":"password"
             
          },
          {
              "user_name": "string",
              "password": "string"

              
          }
      ],
      optionalHeaders: [{},{}],
      "title": "Library Incharge Data Upload",
      uploadEndpoint: "/upload_excel_set_five/upload_library_incharge"
    },
    {
      "id": 7,
      "name": "Library Assistant Incharge",
      "done": data.timetable_exists,
      requiredHeaders: [
          {
              "User Name *": "user_name",
              "Password *":"password" 
          },
          {
              "user_name": "string",
              "password": "string"
 
          }
      ],
      optionalHeaders: [{},{}],
      "title": "Library Assistant Incharge Data Upload",
      uploadEndpoint: "/upload_excel_set_five/upload_library_assistant_incharge"
    },
    {
      "id": 8,
      "name": "Kisok",
      "done": data.timetable_exists,
      requiredHeaders: [
          {
              "User Name *": "user_name",
              "Password *":"password" 
          },
          {
              "user_name": "string",
              "password": "string"
 
          }
      ],
      optionalHeaders: [{},{}],
      "title": "Kisok Data Upload",
      uploadEndpoint: "/upload_excel_set_five/kiosk_cloudadmin_upload"
    }
    ];

    return set5Data; // Return the populated array
  } catch (error) {
    console.error("Error fetching data:", error);
    throw error;
  }
  
};

// Export the populated data after fetching
const exportedSet1Data = (async () => {
  await fetchSetFiveData(); // Wait for the data to be fetched
  return set5Data;         // Export the populated array
})();

export default exportedSet1Data;