let set4Data = []; // Initialize as an empty array

const fetchSetFourData = async () => {
  try {
    const response = await fetch('/upload_excel_set_four/fee_data_exists');
    const data = await response.json();
     set4Data = [
 { 
            id: 1, 
            name: 'Fee Category', 
            done: data.fee_category_exists,  
            requiredHeaders: [
                { 
                  "Name *": "name",
                  "Particulars *":"particulars"
                } ,
                  { 
                    name:"string",
                    particulars:"string"
                  },],
            optionalHeaders: [{ "Description": "description",},{}],
            title: "Fee Category Upload",
            uploadEndpoint: "/upload_excel_set_four/upload_fee_category",
            headerline:1,//headers from second row 
            dataline:2 // data from third row 
            
          },
          { 
            id: 2, 
            name: 'Fee Particular', 
            done: data.fee_particular_exists,  
            requiredHeaders: [
              {
                "Fee Category *": "fee_category",
                "Fee Particular *": "fee_particular",
                "Account *": "account",
                "Amount *": "amount",
                "TimeTable *": "academic_year_name",
                "Class Code *": "class_data",
                "Section *": "section_data",
                "Student First Name *": "student_f_name",
                "Student Last Name *": "student_l_name",
                "Date of Birth *": "date_of_birth",
                "Student Category *": "student_category",
               
              }
               ,{
   
                date_of_birth: "date",
              
               
              }
              ,],
            optionalHeaders: [{"Description": "description"},{ description: "string"}],
            title: "Fee Particular Upload",
            uploadEndpoint: "/upload_excel_set_four/upload_fee_particular",
            headerline:1,//headers from second row 
            dataline:2 // data from third row 
            
          }, { 
            id: 3, 
            name: 'Fee Discount', 
            done: data.fee_discount_exists,  
            requiredHeaders: [
              {
                "Discount Type *": "discount_type",
                "Discount Name *": "discount_name",
                "Class Code*": "class_data",
                "Section *": "section",
                "Student First Name *": "student_f_name",
                "Student Last Name *": "student_last_name",
                "Date of Birth *": "dob",
                "Student category *": "student_category",
                "Fee Category *": "category",
                "Discount *": "discount_amount"
            }
             ,{dob:"date"},],
            optionalHeaders: [{},{}],
            title: "Fee Discount Upload",
            uploadEndpoint: "/upload_excel_set_four/upload_fee_discount",
            headerline:1,//headers from second row 
            dataline:2 // data from third row 
            
          }, { 
            id: 4, 
            name: 'Late Fee Fine', 
            done: data.late_fine_exists,  
            requiredHeaders: [
              {
                "Fine Name *": "fine_name",
                "Description": "description",
                "Days After Due Date *": "days_after_due_date",
                "Amount *": "amount"
            }
             ,{},],
            optionalHeaders: [{},{}],
            title: "Late Fee Fine Upload",
            uploadEndpoint: "/upload_excel_set_four/upload_late_fee_fine",
            headerline:1,//headers from second row 
            dataline:2 // data from third row 
            
          },];
          

    return set4Data; // Return the populated array
  } catch (error) {
    console.error("Error fetching data:", error);
    throw error;
  }
};

// Export the populated data after fetching
const exportedSet4Data = (async () => {
  await fetchSetFourData(); // Wait for the data to be fetched
  return set4Data;         // Export the populated array
})();

export default exportedSet4Data;

// {
//   fee_category_exists: fee_category_exists,
//   fee_particular_exists: fee_particular_exists,
//   fee_discount_exists: fee_discount_exists,
//   late_fine_exists: late_fine_exists,

// }