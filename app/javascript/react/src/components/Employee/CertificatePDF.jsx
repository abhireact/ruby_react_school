import React, { useRef } from 'react';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import { Card, Button, Form as BootstrapForm, Container, Row, Col } from 'react-bootstrap';
import { Input, DatePicker, message } from 'antd';
import { jsPDF } from 'jspdf';
import moment from 'moment';
import axios from "axios";

const validationSchema = Yup.object().shape({
  employee_name: Yup.string().required('Required'),
  guardian_name: Yup.string().required('Required'),
  designation: Yup.string().required('Required'),
  guardian_title: Yup.string().required('Required'),
  title: Yup.string().required('Required'),
  joining_date: Yup.date().required('Required'),
  last_working_date: Yup.date().required('Required'),
  title_sub: Yup.string().required('Required'),
  title_sub1: Yup.string().required('Required'),
  title_sub2: Yup.string().required('Required'),
});

const CertificatePDF = ({ certificateDetails,mg_employee_id}) => {
  const certificateRef = useRef(null);

  const initialValues = certificateDetails ? {
    ...certificateDetails,
    // Convert string dates to moment objects for DatePicker
  
    joining_date: certificateDetails.joining_date ? moment(certificateDetails.joining_date, 'YYYY-MM-DD') : null,
    last_working_date: certificateDetails.last_working_date ? moment(certificateDetails.last_working_date, 'YYYY-MM-DD') : null,
  } : {
    title: '',
    employee_name: '',
    guardian_title: '',
    guardian_name: '',
    subjects: '',
    designation: '',
    joining_date: null,
    last_working_date: null,
    title_sub: '',
    title_sub1: '',
    title_sub2: '',
    employee_id:mg_employee_id,
    school_id: ''
  };



  const handleSubmit = async (values, { setSubmitting }) => {
    try {
      // Convert moment objects to formatted strings
      const formattedValues = {
        ...values,
        joining_date: values.joining_date ? values.joining_date.format('DD/MM/YYYY') : '',
        last_working_date: values.last_working_date ? values.last_working_date.format('DD/MM/YYYY') : '',
      };
  
      const url = certificateDetails
        ? `experience_certificates/update_experience_certificate/${certificateDetails.id}`
        : 'experience_certificates/create_experience_certificate';
  
      const method = certificateDetails ? 'patch' : 'post';
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
  
      // Make the API request using axios
      const response = await axios({
        method, 
        url, 
        headers: {
          'Content-Type': 'application/json',
          "X-CSRF-Token": token,
        },
        data: formattedValues,
      });
      console.log(response,"certificate response")
  
      // Handle success response
      message.success(`Certificate Info has been ${certificateDetails ? 'updated' : 'saved'} successfully!`);
   
      
    } catch (error) {
      // Handle error response
      console.error('Error:', error);
      message.error(`Failed to ${certificateDetails ? 'update' : 'save'} certificate Info`);
    } finally {
      setSubmitting(false);
    }
  };

  const handleGeneratePDF = async (errors, touched, values) => {
    // Check if there are any validation errors
    const hasErrors = Object.keys(errors).length > 0 && Object.keys(touched).length > 0;
  
    if (hasErrors) {
      message.error("Please correct the validation errors before generating the PDF.");
      return;
    }
  
    try {
      // Create new PDF document
      const doc = new jsPDF({
        orientation: 'portrait',
        unit: 'mm',
        format: 'a4'
      });
  
      // Add margins
      const margin = 20;
      const pageWidth = doc.internal.pageSize.width;
      const pageHeight = doc.internal.pageSize.height;
      const contentWidth = pageWidth - (2 * margin);
  
      // Set fonts
      doc.setFont('helvetica', 'bold');
      
      // Add title with underline
      doc.setFontSize(16);
      const title = 'TO WHOMSOEVER IT MAY CONCERN';
      const titleWidth = doc.getStringUnitWidth(title) * 16 / doc.internal.scaleFactor;
      const titleX = (pageWidth - titleWidth) / 2;
      doc.text(title, titleX, 40);
      
      // Add underline to title
      const underlineY = 42;
      doc.setLineWidth(0.5);
      doc.line(titleX, underlineY, titleX + titleWidth, underlineY);
  
      // Reset font for main content
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(12);
      
      // Add main content with proper spacing
      const mainContent = `This is to certify that ${values.title} ${values.employee_name} ${values.guardian_title} of ${values.guardian_name} has worked as a ${values.designation} at our School from ${values.joining_date.format('DD/MM/YYYY')} to ${values.last_working_date.format('DD/MM/YYYY')}.`;
      
      const splitText = doc.splitTextToSize(mainContent, contentWidth);
      doc.text(splitText, margin, 60);
  
      // Add performance text with proper spacing
      const performanceText = `We found ${values.title_sub} responsible, enthusiastic and hardworking during ${values.title_sub2} work tenure. ${values.title_sub1} can prove to be an asset for any organization.`;
      const splitPerformanceText = doc.splitTextToSize(performanceText, contentWidth);
      doc.text(splitPerformanceText, margin, 80);
  
      // Add wishes with proper spacing
      const wishesText = `We wish ${values.title_sub} success in ${values.title_sub2} future endeavors.`;
      const splitWishesText = doc.splitTextToSize(wishesText, contentWidth);
      doc.text(splitWishesText, margin, 100);
  
      // Add request line in italics
      doc.setFont('helvetica', 'italic');
      const requestText = `This experience certificate is being issued at the request of ${values.title} ${values.employee_name}`;
      doc.text(requestText, margin, 120);
  
      // Add date and signature with proper spacing
      doc.setFont('helvetica', 'normal');
      doc.text(`Date : ${moment().format('DD/MM/YYYY')}`, margin, pageHeight - 40);
  
      // Add Principal text with bold
      doc.setFont('helvetica', 'bold');
      doc.text('Principal', pageWidth - margin - 20, pageHeight - 40);
  
      // Add school stamp placeholder (optional)
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(10);
      doc.text('(School Stamp)', pageWidth - margin - 25, pageHeight - 50);
  
      // Save the PDF
      doc.save(`Experience_Certificate_${values.employee_name}.pdf`);
  
      // Call the API to track certificate generation
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
  
      const response = await axios.patch(
        `experience_certificates/track_and_generate_certificate/${values.employee_id}`,
        {},
        {
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": token,
          },
        }
      );
  
      if (response.status === 200) {
        message.success("Certificate has been generated successfully!");
      } else {
        message.error("Failed to generate certificate.");
      }
    } catch (error) {
      console.error("Error:", error);
      message.error("Failed to generate certificate.");
    }
  };
  

  return (
    <Container className="py-4">
      <Formik
        initialValues={initialValues}
        validationSchema={validationSchema}
        onSubmit={handleSubmit}
        enableReinitialize
      >
        {({ errors, touched, isSubmitting, values, setFieldValue,setTouched }) => (
          <Form>
            <Card>
              <Card.Body>
                <div ref={certificateRef} className="p-4">
                  <div className="text-center h4 mb-4">
                    TO WHOM IT MAY CONCERN
                  </div>

                  <div className="mb-4">
                    <Row className="align-items-center mb-3">
                      <Col xs="auto">This is to certify that</Col>
                      <Col xs="auto">
                        <Field name="title">
                          {({ field }) => (  <BootstrapForm.Group>
                            <Input {...field} 
                            status={errors.title && touched.title ? 'error' : ''}
                             style={{ width: 100 }} placeholder="Miss. or Mr." />
                            {errors.title && touched.title && (
                              <div className="text-danger">{errors.title}</div>
                            )}
                          </BootstrapForm.Group>
                      
                          )}
                        </Field>
                      </Col>
                      <Col xs="auto">
                        <Field name="employee_name">
                          {({ field }) => (
                            <BootstrapForm.Group>
                              <Input 
                                {...field}
                                status={errors.employee_name && touched.employee_name ? 'error' : ''}
                                placeholder="Employee Name"
                                style={{ width: 200 }}
                              />
                              {errors.employee_name && touched.employee_name && (
                                <div className="text-danger">{errors.employee_name}</div>
                              )}
                            </BootstrapForm.Group>
                          )}
                        </Field>
                      </Col>
                      <Col xs="auto">
                        <Field name="guardian_title">
                          {({ field }) => ( <BootstrapForm.Group>
                            <Input {...field} 
                            status={errors.guardian_title && touched.guardian_title ? 'error' : ''}
                            style={{ width: 100 }} placeholder="Daughter or Son"/>
                            {errors.guardian_title && touched.guardian_title && (
                                <div className="text-danger">{errors.guardian_title}</div>
                              )}
                          </BootstrapForm.Group>
                         
                          )}
                        </Field>
                      </Col>
                      <Col>
                        <Field name="guardian_name">
                          {({ field }) => (
                            <BootstrapForm.Group>
                              <Input 
                                {...field}
                                status={errors.guardian_name && touched.guardian_name ? 'error' : ''}
                                placeholder="Guardian Name"
                                style={{ width: 200 }}
                              />
                              {errors.guardian_name && touched.guardian_name && (
                                <div className="text-danger">{errors.guardian_name}</div>
                              )}
                            </BootstrapForm.Group>
                          )}
                        </Field>
                      </Col>
                    </Row>

                    <Row className="align-items-center mb-3">
                      <Col xs="auto">has worked as a</Col>
                      <Col xs="auto">
                        <Field name="designation">
                          {({ field }) => (
                            <BootstrapForm.Group>
                              <Input 
                                {...field}
                                status={errors.designation && touched.designation ? 'error' : ''}
                                placeholder="Designation"
                                style={{ width: 200 }}
                              />
                              {errors.designation && touched.designation && (
                                <div className="text-danger">{errors.designation}</div>
                              )}
                            </BootstrapForm.Group>
                          )}
                        </Field>
                      </Col>
                      <Col xs="auto">at our School from</Col>
                      <Col xs="auto">
                        <Field name="joining_date">
                          {({ field }) => (
                            <BootstrapForm.Group>
                              <DatePicker 
                                value={values.joining_date}
                                onChange={(date) => setFieldValue('joining_date', date)}
                                status={errors.joining_date && touched.joining_date ? 'error' : ''}
                                style={{ width: 200 }}
                                format="DD/MM/YYYY"
                              />
                              {errors.joining_date && touched.joining_date && (
                                <div className="text-danger">{errors.joining_date}</div>
                              )}
                            </BootstrapForm.Group>
                          )}
                        </Field>
                      </Col>
                      <Col xs="auto">to</Col>
                      <Col>
                        <Field name="last_working_date">
                          {({ field }) => (
                            <BootstrapForm.Group>
                              <DatePicker 
                                value={values.last_working_date}
                                onChange={(date) => setFieldValue('last_working_date', date)}
                                status={errors.last_working_date && touched.last_working_date ? 'error' : ''}
                                style={{ width: 200 }}
                                format="DD/MM/YYYY"
                              />
                              {errors.last_working_date && touched.last_working_date && (
                                <div className="text-danger">{errors.last_working_date}</div>
                              )}
                            </BootstrapForm.Group>
                          )}
                        </Field>
                      </Col>
                    </Row>

                    <div className="text-justify mb-3">
  We found 
  <Field name="title_sub">
    {({ field }) => (
      <BootstrapForm.Group className="d-inline-block mx-1">
        <Input 
          {...field}
          style={{ width: 100 }}
          status={errors.title_sub && touched.title_sub ? 'error' : ''}
          placeholder="her or him"
        />
        {errors.title_sub && touched.title_sub && (
          <div className="text-danger">{errors.title_sub}</div>
        )}
      </BootstrapForm.Group>
    )}
  </Field>
  responsible, enthusiastic, and hardworking during 
  <Field name="title_sub2">
    {({ field }) => (
      <BootstrapForm.Group className="d-inline-block mx-1">
        <Input 
          {...field}
          style={{ width: 100 }}
          status={errors.title_sub2 && touched.title_sub2 ? 'error' : ''}
          placeholder="her or his"
        />
        {errors.title_sub2 && touched.title_sub2 && (
          <div className="text-danger">{errors.title_sub2}</div>
        )}
      </BootstrapForm.Group>
    )}
  </Field>
  work tenure. 
  <Field name="title_sub1">
    {({ field }) => (
      <BootstrapForm.Group className="d-inline-block mx-1">
        <Input 
          {...field}
          style={{ width: 100 }}
          status={errors.title_sub1 && touched.title_sub1 ? 'error' : ''}
          placeholder="She or He"
        />
        {errors.title_sub1 && touched.title_sub1 && (
          <div className="text-danger">{errors.title_sub1}</div>
        )}
      </BootstrapForm.Group>
    )}
  </Field>
  can prove to be an asset for any organization.
</div>

<div className="text-justify mb-4">
  We wish 
  <Field name="title_sub">
    {({ field }) => (
      <BootstrapForm.Group className="d-inline-block mx-1">
        <Input 
          {...field}
          style={{ width: 100 }}
          status={errors.title_sub && touched.title_sub ? 'error' : ''}
          placeholder="her or him"
        />
        {errors.title_sub && touched.title_sub && (
          <div className="text-danger">{errors.title_sub}</div>
        )}
      </BootstrapForm.Group>
    )}
  </Field>
  success in 
  <Field name="title_sub2">
    {({ field }) => (
      <BootstrapForm.Group className="d-inline-block mx-1">
        <Input 
          {...field}
          style={{ width: 100 }}
          status={errors.title_sub2 && touched.title_sub2 ? 'error' : ''}
          placeholder="her or his"
        />
        {errors.title_sub2 && touched.title_sub2 && (
          <div className="text-danger">{errors.title_sub2}</div>
        )}
      </BootstrapForm.Group>
    )}
  </Field>
  future endeavors.
</div>


                    <Row className="mt-4">
                      <Col>Date: {moment().format('DD/MM/YYYY')}</Col>
                      <Col className="text-end">Principal</Col>
                    </Row>
                  </div>
                </div>

                <div className="m-4 d-flex justify-content-between">
  <div className="d-flex">
    <Button 
      variant="info"
      type="submit" 
      disabled={isSubmitting}
    >
      {isSubmitting ? 'Submitting...' : (certificateDetails ? 'Update' : 'Save')}
    </Button>
    
    {/* <Button 
    variant="dark" 
    onClick={() => window.history.back()}
  >
    Back
  </Button> */}
  </div>
  

  <Button 
      variant="dark"
      onClick={() => {
        handleGeneratePDF(errors, touched,values); // Pass errors and touched to the function
      }}
      className="ms-2" // Add margin-left to space out the buttons
    >
      Generate PDF
    </Button>
</div>

              </Card.Body>
            </Card>
          </Form>
        )}
      </Formik>
    </Container>
  );
};

export default CertificatePDF;
