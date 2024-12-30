import React,{ useState,useEffect} from 'react';
import { Button } from "react-bootstrap";
import { Formik, Form, Field, ErrorMessage } from 'formik';
import { Card, DatePicker,message } from 'antd';
import { User, Phone, Building2, Home } from 'lucide-react';
import * as Yup from 'yup';
import moment from 'moment';
import axios from 'axios';
import SideNavigation from './sidebar';

const EmployeeForm = ({userData, handleClose,employeeInfo,fetchData }) => {
  console.log(userData,"user data")


  const [initialValues, setInitialValues] = useState({
    first_name: null,
    middle_name: null,
    last_name: null,
    date_of_birth: null,
    employee_joining_date: null,
    last_work_day: null,
    gender: null,
    job_title: null,
    qualification: null,
    max_class_per_day: null,// Max class per day : number
    t_year_exp: null,// Total Year of Experience : number
    t_mon_exp: null,// Total Month of Experience: number
    aadhar_number:null,// Aadhar Number : accept number as string
    father_name: null,
    mother_name: null,
    marital_status: null,
    blood_group:null,
    emp_department: null,// Employee Department
    emp_category: null,//Employee Category
    emp_type: null,//Employee Type
    emp_profile: null,//Employee Profile
    emp_grade:null,//Employee Grade
    hobby:null,
    ltc_applicable:false,// LTC Applicable 
    is_referred:false , // if  it is true , refered_by  and designation inputs are shown 
    referred_by:null,
    status:null,

    bank_name: null,
    account_number: null,
    ifs_code: null,


    mobile_number: null,
    email_id:null,
    emergency_contact_number: null,
    emergency_contact_name: null,


    temporary_address_line1:null,
    temporary_address_line2:null,
    temporary_city:null,
    temporary_state:null,
    temporary_country:null,
    temporary_pin_code:null,

    permanent_address_line1:null,
    permanent_address_line2:null,
    permanent_city:null,
    permanent_state:null,
    permanent_country:null,
    permanent_pin_code:null,

    
    language: null,
    nationality: null,
    extra_curricular: null,
    sport_activity: null,
    employee_number:null
  });
  const fetchEmployeeData = () => {
    const response = axios
      .get(`/mg_employees/get_employee/${employeeInfo.id}`)
      .then(response => {
        console.log(response.data?.data,"employee info")
        setInitialValues(response.data?.data || initialValues);
      
      })
      .catch(error => {
        console.error("Error while fetching data", error);
      });

  };

  useEffect(() => {
    fetchEmployeeData();
  }, []);

  const sections = [
    { key: 'employee_info', icon: <User size={20} />, title: 'Employee Info' },
    { key: 'account_info', icon: <Building2 size={20} />, title: 'Account Info' },
    { key: 'contact_info', icon: <Phone size={20} />, title: 'Contact Info' },
    { key: 'address_info', icon: <Home size={20} />, title: 'Address' },
  ];
  const validationSchema = Yup.object({
    first_name: Yup.string().required('First name is required'),
    date_of_birth: Yup.date().required('Date of birth is required'),
    employee_joining_date: Yup.date().required('Joining date is required'),
    gender: Yup.string().required('Gender is required'),

    emp_department: Yup.string().required('Employee Department is required'),
    emp_type: Yup.string().required('Employee Type is required'),
    emp_category: Yup.string().required('Employee Category is required'),
    emp_profile: Yup.string().required('Employee Profile is required'),
    emp_grade:Yup.string().required('Employee Grade is required'),

    mobile_number: Yup.string()
        .matches(/^\d{10}$/, 'Mobile number must be 10 digit numbers')
        .required('Mobile number is required'),
        
    email_id: Yup.string()
        .email('Invalid email format'),
        
    aadhar_number: Yup.string()
            .matches(/^\d{12}$/, 'Aadhaar number must be exactly 12 digits')
          

});



  const handleSubmit = (values, { setSubmitting }) => {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
  console.log(values, "update data ")
    axios.patch(`/mg_employees/update_employee/${employeeInfo.id}`,
     values
  , {
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      }
    })
    .then(() => {
      message.success("Employee Updated Successfully");
      handleClose(); // Uncomment if you have a modal or form closure logic
      fetchData(); // Uncomment if you need to refresh or fetch updated data
    })
    .catch(error => {
      console.error("Error:", error);
      message.error("Failed to create employee");
    })
    .finally(() => {
      setSubmitting(false); // Stop the submission spinner or loader
    });
  };
  
  const [employeeCategories,setEmployeeCategories] = useState(userData.employee_category||[]);
  const [employeeDepartments,setEmployeeDepartments]=useState(userData.employee_department||[]);
  const [employeeTypes,setEmployeeTypes] = useState(userData.employee_type||[]);
  const [employeeProfiles,setEmployeeProfiles] =useState(userData.employee_position||[]);
  const [employeeGrades,setEmployeeGrades] = useState(userData.employee_grade||[]);

  return (
    <div className="d-flex" style={{ height: '100vh' }}>
      <div style={{ width: '250px', position: 'fixed', height: '100%' }}>
        <SideNavigation sections={sections} />
      </div>

      <div style={{ marginLeft: '200px', paddingLeft: '16px', width: 'calc(100% - 250px)' }}>
        <Formik
          initialValues={initialValues}
          validationSchema={validationSchema}
          onSubmit={handleSubmit}
          enableReinitialize
        >
          {({ setFieldValue, errors, touched, values,isSubmitting }) => (
            <Form>
              {/* Employee Info Section */}
              <Card id="employee_info" className="mb-4" title="EMPLOYEE DETAILS">
  <div className="row g-3">
    <div className="col-md-4">
      <label>First Name *</label>
      <div className="input-group input-group-outline my-1">
        <Field name="first_name" className="form-control" placeholder="First Name" />
      </div>
      <ErrorMessage name="first_name" component="div" className="text-danger" />
    </div>
    <div className="col-md-4">
      <label>Middle Name</label>
      <div className="input-group input-group-outline my-1">
        <Field name="middle_name" className="form-control" placeholder="Middle Name" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Last Name</label>
      <div className="input-group input-group-outline my-1">
        <Field name="last_name" className="form-control" placeholder="Last Name" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Date of Birth *</label>
      <div className="input-group input-group-outline my-1">
        <DatePicker
          style={{ width: '100%' }}
          format="DD/MM/YYYY"
          value={values.date_of_birth ? moment(values.date_of_birth) : null}
          onChange={(date) => setFieldValue('date_of_birth', date)}
          status={errors.date_of_birth && touched.date_of_birth ? 'error' : ''}
        />
      </div>
      <ErrorMessage name="date_of_birth" component="div" className="text-danger" />
    </div>
    <div className="col-md-4">
      <label>Joining Date *</label>
      <div className="input-group input-group-outline my-1">
        <DatePicker
          style={{ width: '100%' }}
          format="DD/MM/YYYY"
          value={values.employee_joining_date ? moment(values.employee_joining_date) : null}
          onChange={(date) => setFieldValue('employee_joining_date', date)}
          status={errors.employee_joining_date && touched.employee_joining_date ? 'error' : ''}
        />
      </div>
      <ErrorMessage name="employee_joining_date" component="div" className="text-danger" />
    </div>
    <div className="col-md-4">
      <label>Last Working Day</label>
      <div className="input-group input-group-outline my-1">
        <DatePicker
          style={{ width: '100%' }}
          format="DD/MM/YYYY"
          value={values.last_work_day ? moment(values.last_work_day) : null}
          onChange={(date) => setFieldValue('last_work_day', date)}
        />
      </div>
    </div>
    <div className="col-md-4">
      <label>Gender *</label>
      <div className="input-group input-group-outline my-1">
        <Field
          as="select"
          name="gender"
          className="form-control"
        >
          <option value="" label="Select Gender" />
          <option value="male" label="Male" />
          <option value="female" label="Female" />
          <option value="other" label="Other" />
        </Field>
      </div>
      <ErrorMessage name="gender" component="div" className="text-danger" />
    </div>
    <div className="col-md-4">
      <label>Job Title</label>
      <div className="input-group input-group-outline my-1">
        <Field name="job_title" className="form-control" placeholder="Job Title" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Qualification</label>
      <div className="input-group input-group-outline my-1">
        <Field name="qualification" className="form-control" placeholder="Qualification" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Max Classes Per Day</label>
      <div className="input-group input-group-outline my-1">
        <Field name="max_class_per_day" type="number" className="form-control" placeholder="Max Classes Per Day" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Total Years of Experience</label>
      <div className="input-group input-group-outline my-1">
        <Field name="t_year_exp" type="number" className="form-control" placeholder="Years of Experience" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Total Months of Experience</label>
      <div className="input-group input-group-outline my-1">
        <Field name="t_mon_exp" type="number" className="form-control" placeholder="Months of Experience" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Aadhar Number</label>
      <div className="input-group input-group-outline my-1">
        <Field name="aadhar_number" className="form-control" placeholder="Aadhar Number" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Father's Name</label>
      <div className="input-group input-group-outline my-1">
        <Field name="father_name" className="form-control" placeholder="Father's Name" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Mother's Name</label>
      <div className="input-group input-group-outline my-1">
        <Field name="mother_name" className="form-control" placeholder="Mother's Name" />
      </div>
    </div>
    <div className="col-md-4">
      <label>Marital Status</label>
      <div className="input-group input-group-outline my-1">
        <Field
          as="select"
          name="marital_status"
          className="form-control"
        >
          <option value="" label="Select Marital Status" />
          <option value="single" label="Single" />
          <option value="married" label="Married" />
          <option value="divorced" label="Divorced" />
          <option value="widowed" label="Widowed" />
        </Field>
      </div>
    </div>
    <div className="col-md-4">
      <label>Blood Group</label>
      <div className="input-group input-group-outline my-1">
      <Field
  as="select"
  name="blood_group"
  className="form-control"
>
  <option value="" label="Select Blood Group" />
  <option value="A+" label="A+" />
  <option value="A-" label="A-" />
  <option value="B+" label="B+" />
  <option value="B-" label="B-" />
  <option value="O+" label="O+" />
  <option value="O-" label="O-" />
  <option value="AB+" label="AB+" />
  <option value="AB-" label="AB-" />
</Field>

      </div>
    </div>
    <div className="col-md-4">
      <label>Employee Department *</label>
      <div className="input-group input-group-outline my-1">
      <Field as="select" name="emp_department" className="form-control">
    <option value="" label="Select Department" />
    {employeeDepartments.map(department => (
      <option key={department.id} value={department.department_name} label={department.department_name} />
    ))}
  </Field>
   
      </div>
      {errors.emp_department && touched.emp_department && <div className="text-danger">{errors.emp_department}</div>}
      
    </div>
    <div className="col-md-4">
      <label>Employee Category *</label>
      <div className="input-group input-group-outline my-1">
      <Field as="select" name="emp_category" className="form-control">
    <option value="" label="Select Category" />
    {employeeCategories.map(item => (
      <option key={item.id} value={item.category_name} label={item.category_name} />
    ))}
  </Field>
      </div>
      {errors.emp_category && touched.emp_category && <div className="text-danger">{errors.emp_category}</div>}
    </div>
    <div className="col-md-4">
      <label>Employee Type *</label>
      <div className="input-group input-group-outline my-1">
      <Field as="select" name="emp_type" className="form-control">
    <option value="" label="Select Type" />
    {employeeTypes.map(item => (
      <option key={item.id} value={item.employee_type} label={item.employee_type} />
    ))}
  </Field>
      </div>
      {errors.emp_type && touched.emp_type && <div className="text-danger">{errors.emp_type}</div>}
    </div>
    <div className="col-md-4">
      <label>Employee Profile *</label>
      <div className="input-group input-group-outline my-1">
      <Field as="select" name="emp_profile" className="form-control">
    <option value="" label="Select Profile" />
    {employeeProfiles.map(item => (
      <option key={item.id} value={item.position_name} label={item.position_name} />
    ))}
  </Field>
      </div>
      {errors.emp_profile && touched.emp_profile && <div className="text-danger">{errors.emp_profile}</div>}
    </div>
    <div className="col-md-4">
      <label>Employee Grade *</label>
      <div className="input-group input-group-outline my-1">
      <Field as="select" name="emp_grade" className="form-control">
    <option value="" label="Select Grade" />
    {employeeGrades.map(item => (
      <option key={item.id} value={item.grade_name} label={item.grade_name} />
    ))}
  </Field>
      </div>
      {errors.emp_grade && touched.emp_grade && <div className="text-danger">{errors.emp_grade}</div>}
    </div>
    <div className="col-md-4">
      <label>Hobby</label>
      <div className="input-group input-group-outline my-1">
        <Field name="hobby" className="form-control" placeholder="Hobby" />
      </div>
    </div>
    <div className="col-md-4">
      <label>LTC Applicable</label>
      <div className="input-group input-group-outline my-1">
        <Field
          as="select"
          name="ltc_applicable"
          className="form-control"
        >
          <option value="false">No</option>
          <option value="true">Yes</option>
        </Field>
      </div>
    </div>
    <div className="col-md-4">
      <label>Referred By</label>
      <div className="input-group input-group-outline my-1">
        <Field name="referred_by" className="form-control" placeholder="Referred By" />
      </div>
    </div>

    <div className="col-md-4">
      <label>Status</label>
      <div className="input-group input-group-outline my-1">
        <Field
          as="select"
          name="status"
          className="form-control"
        >  <option value="">Select Status</option>
          <option value="Working">Working</option>
          <option value="Retired">Retired</option>
          <option value="Left">Left</option>
        </Field>
      </div>
    </div>

  </div>
</Card>

              {/* Account Info Section */}
              <Card id="account_info" className="mb-4" title="ACCOUNT INFORMATION">
                <div className="row g-3">
                  <div className="col-md-4">
                    <label>Bank Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field name="bank_name" className="form-control" placeholder="Bank Name" />
                    </div>
                    <ErrorMessage name="bank_name" component="div" className="text-danger" />
                  </div>
                  <div className="col-md-4">
                    <label>Account Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field name="account_number" className="form-control" placeholder="Account Number" />
                    </div>
                    <ErrorMessage name="account_number" component="div" className="text-danger" />
                  </div>
                  <div className="col-md-4">
                    <label>IFSC Code</label>
                    <div className="input-group input-group-outline my-1">
                      <Field name="ifs_code" className="form-control" placeholder="IFSC Code" />
                    </div>
                    <ErrorMessage name="ifs_code" component="div" className="text-danger" />
                  </div>
                </div>
              </Card>

              {/* Contact Info Section */}
              <Card id="contact_info" className="mb-4" title="CONTACT INFORMATION">
                <div className="row g-3">
                  <div className="col-md-4">
                    <label>Mobile Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field name="mobile_number" className="form-control" placeholder="Phone Number" />
                    </div>
                    <ErrorMessage name="mobile_number" component="div" className="text-danger" />
                  </div>
                  <div className="col-md-4">
                    <label>Email</label>
                    <div className="input-group input-group-outline my-1">
                      <Field name="email_id" type="email" className="form-control" placeholder="Email" />
                    </div>
                    <ErrorMessage name="email_id" component="div" className="text-danger" />
                  </div>
                  <div className="col-md-4">
                    <label>Alternate Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field name="emergency_contact_number" className="form-control" placeholder="Emergency Contact" />
                    </div>
                    <ErrorMessage name="emergency_contact_number" component="div" className="text-danger" />
                  </div>
                </div>
              </Card>


          {/* Address Section */}
<Card id="address_info" className="mb-4" title="ADDRESS">
  <div className="row g-3">
    {/* Temporary Address */}
    <div className="col-12">
    <b>Current Address</b>
    </div>
    <div className="col-md-6">
      <label>Address Line 1</label>
      <div className="input-group input-group-outline my-1">
        <Field name="temporary_address_line1" className="form-control" placeholder="Address Line 1" />
      </div>
      <ErrorMessage name="temporary_address_line1" component="div" className="text-danger" />
    </div>
    <div className="col-md-6">
      <label>Address Line 2</label>
      <div className="input-group input-group-outline my-1">
        <Field name="temporary_address_line2" className="form-control" placeholder="Address Line 2" />
      </div>
    </div>
    <div className="col-md-3">
      <label>City</label>
      <div className="input-group input-group-outline my-1">
        <Field name="temporary_city" className="form-control" placeholder="City" />
      </div>
      <ErrorMessage name="temporary_city" component="div" className="text-danger" />
    </div>
    <div className="col-md-3">
      <label>State</label>
      <div className="input-group input-group-outline my-1">
        <Field name="temporary_state" className="form-control" placeholder="State" />
      </div>
      <ErrorMessage name="temporary_state" component="div" className="text-danger" />
    </div>
    <div className="col-md-3">
      <label>Country</label>
      <div className="input-group input-group-outline my-1">
        <Field name="temporary_country" className="form-control" placeholder="Country" />
      </div>
      <ErrorMessage name="temporary_country" component="div" className="text-danger" />
    </div>
    <div className="col-md-3">
      <label>Pin Code</label>
      <div className="input-group input-group-outline my-1">
        <Field name="temporary_pin_code" className="form-control" placeholder="Pin Code" />
      </div>
      <ErrorMessage name="temporary_pin_code" component="div" className="text-danger" />
    </div>

    {/* Permanent Address */}
    <div className="col-12 mt-4">
      <b>Permanent Address</b>
    </div>
    <div className="col-md-6">
      <label>Address Line 1</label>
      <div className="input-group input-group-outline my-1">
        <Field name="permanent_address_line1" className="form-control" placeholder="Address Line 1" />
      </div>
      <ErrorMessage name="permanent_address_line1" component="div" className="text-danger" />
    </div>
    <div className="col-md-6">
      <label>Address Line 2</label>
      <div className="input-group input-group-outline my-1">
        <Field name="permanent_address_line2" className="form-control" placeholder="Address Line 2" />
      </div>
    </div>
    <div className="col-md-3">
      <label>City</label>
      <div className="input-group input-group-outline my-1">
        <Field name="permanent_city" className="form-control" placeholder="City" />
      </div>
      <ErrorMessage name="permanent_city" component="div" className="text-danger" />
    </div>
    <div className="col-md-3">
      <label>State</label>
      <div className="input-group input-group-outline my-1">
        <Field name="permanent_state" className="form-control" placeholder="State" />
      </div>
      <ErrorMessage name="permanent_state" component="div" className="text-danger" />
    </div>
    <div className="col-md-3">
      <label>Country</label>
      <div className="input-group input-group-outline my-1">
        <Field name="permanent_country" className="form-control" placeholder="Country" />
      </div>
      <ErrorMessage name="permanent_country" component="div" className="text-danger" />
    </div>
    <div className="col-md-3">
      <label>Pin Code</label>
      <div className="input-group input-group-outline my-1">
        <Field name="permanent_pin_code" className="form-control" placeholder="Pin Code" />
      </div>
      <ErrorMessage name="permanent_pin_code" component="div" className="text-danger" />
    </div>
  </div>
</Card>


              <div className="d-flex justify-content-start mt-4">
                     <Button variant="info" className="me-2" type="submit" disabled={isSubmitting}>
                              {isSubmitting ? "Updating..." : "Update"}
                              </Button>
                <Button variant="dark" onClick={() => handleClose()}>
                  Cancel
                </Button>
              </div>
            </Form>
          )}
        </Formik>
      </div>
    </div>
  );
};

export default EmployeeForm;