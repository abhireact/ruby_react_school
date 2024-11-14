import React, { useEffect } from "react";
import { Formik, Field, Form, ErrorMessage } from "formik";
import * as Yup from "yup";

const validationSchema = Yup.object({
  leaveName: Yup.string().required("Leave Name is required"),
  leaveCode: Yup.string().required("Leave Code is required"),
  maxLeaveCount: Yup.number().required("Max Leave Count is required").positive().integer(),
  resetPeriod: Yup.number().required("Reset Period is required").positive().integer(),
  resetDate: Yup.date().required("Reset Date is required"),
  isAutoReset: Yup.boolean().required("Is Auto Reset is required"),
  isCarryForward: Yup.boolean().required("Is Carry Forward is required"),
  carryForwardLimit: Yup.number().positive().integer(),
  accumilationCount: Yup.number().positive().integer(),
  accumilationPeriod: Yup.number().positive().integer(),
  minLeaveCount: Yup.number().required("Min Leave Count is required").positive().integer(),
  mgEmployeeTypeId: Yup.number().required("Employee Type ID is required").positive().integer(),
  isDeleted: Yup.boolean(),
  mgSchoolId: Yup.number().required("School ID is required").positive().integer(),
  createdBy: Yup.number().required("Created By is required").positive().integer(),
  updatedBy: Yup.number().required("Updated By is required").positive().integer(),
  createdAt: Yup.date().required("Created At is required"),
  updatedAt: Yup.date().required("Updated At is required"),
  isAccumilation: Yup.boolean(),
  minimumYearExperience: Yup.number().positive().integer(),
  minimumMonthExperience: Yup.number().positive().integer(),
  gender: Yup.string(),
  isLeaveShouldNotBeDeducted: Yup.boolean(),
  maritalStatus: Yup.string(),
  isShowable: Yup.boolean().required("Is Showable is required"),
  delayDeduction: Yup.number(),
  delayTime: Yup.number(),
  delayDays: Yup.number(),
  leaveDeductionCount: Yup.number(),
  monthlyLimit: Yup.number(),
});

const EmployeeLeaveForm = ({ data }) => {
  const handleSubmit = (values) => {
    console.log(values);
  };

  return (
    <Formik
      initialValues={
        data
          ? {
              leaveName: data.leave_name || "",
              leaveCode: data.leave_code || "",
              maxLeaveCount: data.max_leave_count || "",
              resetPeriod: data.reset_period || "",
              resetDate: data.reset_date || "",
              isAutoReset: data.is_auto_reset || false,
              isCarryForward: data.is_carry_forward || false,
              carryForwardLimit: data.carry_forward_limit || "",
              accumilationCount: data.accumilation_count || "",
              accumilationPeriod: data.accumilation_period || "",
              minLeaveCount: data.min_leave_count || "",
              mgEmployeeTypeId: data.mg_employee_type_id || "",
              isDeleted: data.is_deleted || false,
              mgSchoolId: data.mg_school_id || "",
              createdBy: data.created_by || "",
              updatedBy: data.updated_by || "",
              createdAt: data.created_at || "",
              updatedAt: data.updated_at || "",
              isAccumilation: data.is_accumilation || false,
              minimumYearExperience: data.minimum_year_experience || "",
              minimumMonthExperience: data.minimum_month_experience || "",
              gender: data.gender || "All",
              isLeaveShouldNotBeDeducted: data.is_leave_should_not_be_deducted || false,
              maritalStatus: data.marital_status || "All",
              isShowable: data.is_showable || true,
              delayDeduction: data.delay_deduction || "",
              delayTime: data.delay_time || "",
              delayDays: data.delay_days || "",
              leaveDeductionCount: data.leave_deduction_count || "",
              monthlyLimit: data.monthly_limit || "",
            }
          : {
              leaveName: "",
              leaveCode: "",
              maxLeaveCount: "",
              resetPeriod: "",
              resetDate: "",
              isAutoReset: false,
              isCarryForward: false,
              carryForwardLimit: "",
              accumilationCount: "",
              accumilationPeriod: "",
              minLeaveCount: "",
              mgEmployeeTypeId: "",
              isDeleted: false,
              mgSchoolId: "",
              createdBy: "",
              updatedBy: "",
              createdAt: "",
              updatedAt: "",
              isAccumilation: false,
              minimumYearExperience: "",
              minimumMonthExperience: "",
              gender: "All",
              isLeaveShouldNotBeDeducted: false,
              maritalStatus: "All",
              isShowable: true,
              delayDeduction: "",
              delayTime: "",
              delayDays: "",
              leaveDeductionCount: "",
              monthlyLimit: "",
            }
      }
      validationSchema={validationSchema}
      onSubmit={handleSubmit}
    >
      {({ errors, touched, isSubmitting }) => (
        <Form>
          <div className="row">
            {/* Leave Name */}
            <div className="col-md-6">
              <label>Leave Name</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="leaveName"
                  className={`form-control ${
                    touched.leaveName && errors.leaveName ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="leaveName" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* Leave Code */}
            <div className="col-md-6">
              <label>Leave Code</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="leaveCode"
                  className={`form-control ${
                    touched.leaveCode && errors.leaveCode ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="leaveCode" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Max Leave Count */}
            <div className="col-md-6">
              <label>Max Leave Count</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="maxLeaveCount"
                  type="number"
                  className={`form-control ${
                    touched.maxLeaveCount && errors.maxLeaveCount ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="maxLeaveCount" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* Reset Period */}
            <div className="col-md-6">
              <label>Reset Period</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="resetPeriod"
                  type="number"
                  className={`form-control ${
                    touched.resetPeriod && errors.resetPeriod ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="resetPeriod" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Reset Date */}
            <div className="col-md-6">
              <label>Reset Date</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="resetDate"
                  type="date"
                  className={`form-control ${
                    touched.resetDate && errors.resetDate ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="resetDate" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* Is Auto Reset */}
            <div className="col-md-6">
              <label>Is Auto Reset</label>
              <div className="input-group input-group-outline my-1">
                <Field type="checkbox" name="isAutoReset" className="form-check-input" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Is Carry Forward */}
            <div className="col-md-6">
              <label>Is Carry Forward</label>
              <div className="input-group input-group-outline my-1">
                <Field type="checkbox" name="isCarryForward" className="form-check-input" />
              </div>
            </div>

            {/* Carry Forward Limit */}
            <div className="col-md-6">
              <label>Carry Forward Limit</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="carryForwardLimit"
                  type="number"
                  className={`form-control ${
                    touched.carryForwardLimit && errors.carryForwardLimit ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage
                  name="carryForwardLimit"
                  component="div"
                  className="invalid-feedback"
                />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Accumilation Count */}
            <div className="col-md-6">
              <label>Accumilation Count</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="accumilationCount"
                  type="number"
                  className={`form-control ${
                    touched.accumilationCount && errors.accumilationCount ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage
                  name="accumilationCount"
                  component="div"
                  className="invalid-feedback"
                />
              </div>
            </div>

            {/* Accumilation Period */}
            <div className="col-md-6">
              <label>Accumilation Period</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="accumilationPeriod"
                  type="number"
                  className={`form-control ${
                    touched.accumilationPeriod && errors.accumilationPeriod ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage
                  name="accumilationPeriod"
                  component="div"
                  className="invalid-feedback"
                />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Min Leave Count */}
            <div className="col-md-6">
              <label>Min Leave Count</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="minLeaveCount"
                  type="number"
                  className={`form-control ${
                    touched.minLeaveCount && errors.minLeaveCount ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="minLeaveCount" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* MG Employee Type ID */}
            <div className="col-md-6">
              <label>MG Employee Type ID</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="mgEmployeeTypeId"
                  type="number"
                  className={`form-control ${
                    touched.mgEmployeeTypeId && errors.mgEmployeeTypeId ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage
                  name="mgEmployeeTypeId"
                  component="div"
                  className="invalid-feedback"
                />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Is Deleted */}
            <div className="col-md-6">
              <label>Is Deleted</label>
              <div className="input-group input-group-outline my-1">
                <Field type="checkbox" name="isDeleted" className="form-check-input" />
              </div>
            </div>

            {/* MG School ID */}
            <div className="col-md-6">
              <label>MG School ID</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="mgSchoolId"
                  type="number"
                  className={`form-control ${
                    touched.mgSchoolId && errors.mgSchoolId ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="mgSchoolId" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Created By */}
            <div className="col-md-6">
              <label>Created By</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="createdBy"
                  type="number"
                  className={`form-control ${
                    touched.createdBy && errors.createdBy ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="createdBy" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* Updated By */}
            <div className="col-md-6">
              <label>Updated By</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="updatedBy"
                  type="number"
                  className={`form-control ${
                    touched.updatedBy && errors.updatedBy ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="updatedBy" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Created At */}
            <div className="col-md-6">
              <label>Created At</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="createdAt"
                  type="date"
                  className={`form-control ${
                    touched.createdAt && errors.createdAt ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="createdAt" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* Updated At */}
            <div className="col-md-6">
              <label>Updated At</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="updatedAt"
                  type="date"
                  className={`form-control ${
                    touched.updatedAt && errors.updatedAt ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="updatedAt" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Is Accumilation */}
            <div className="col-md-6">
              <label>Is Accumilation</label>
              <div className="input-group input-group-outline my-1">
                <Field type="checkbox" name="isAccumilation" className="form-check-input" />
              </div>
            </div>

            {/* Minimum Year Experience */}
            <div className="col-md-6">
              <label>Minimum Year Experience</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="minimumYearExperience"
                  type="number"
                  className={`form-control ${
                    touched.minimumYearExperience && errors.minimumYearExperience
                      ? "is-invalid"
                      : ""
                  }`}
                />
                <ErrorMessage
                  name="minimumYearExperience"
                  component="div"
                  className="invalid-feedback"
                />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Minimum Month Experience */}
            <div className="col-md-6">
              <label>Minimum Month Experience</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="minimumMonthExperience"
                  type="number"
                  className={`form-control ${
                    touched.minimumMonthExperience && errors.minimumMonthExperience
                      ? "is-invalid"
                      : ""
                  }`}
                />
                <ErrorMessage
                  name="minimumMonthExperience"
                  component="div"
                  className="invalid-feedback"
                />
              </div>
            </div>

            {/* Gender */}
            <div className="col-md-6">
              <label>Gender</label>
              <div className="input-group input-group-outline my-1">
                <Field as="select" name="gender" className="form-control">
                  <option value="All">All</option>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                </Field>
                <ErrorMessage name="gender" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Is Leave Should Not Be Deducted */}
            <div className="col-md-6">
              <label>Is Leave Should Not Be Deducted</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  type="checkbox"
                  name="isLeaveShouldNotBeDeducted"
                  className="form-check-input"
                />
              </div>
            </div>

            {/* Marital Status */}
            <div className="col-md-6">
              <label>Marital Status</label>
              <div className="input-group input-group-outline my-1">
                <Field as="select" name="maritalStatus" className="form-control">
                  <option value="All">All</option>
                  <option value="Single">Single</option>
                  <option value="Married">Married</option>
                </Field>
                <ErrorMessage name="maritalStatus" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Is Showable */}
            <div className="col-md-6">
              <label>Is Showable</label>
              <div className="input-group input-group-outline my-1">
                <Field type="checkbox" name="isShowable" className="form-check-input" />
              </div>
            </div>

            {/* Delay Deduction */}
            <div className="col-md-6">
              <label>Delay Deduction</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="delayDeduction"
                  type="number"
                  className={`form-control ${
                    touched.delayDeduction && errors.delayDeduction ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="delayDeduction" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Delay Time */}
            <div className="col-md-6">
              <label>Delay Time</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="delayTime"
                  type="number"
                  className={`form-control ${
                    touched.delayTime && errors.delayTime ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="delayTime" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* Delay Days */}
            <div className="col-md-6">
              <label>Delay Days</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="delayDays"
                  type="number"
                  className={`form-control ${
                    touched.delayDays && errors.delayDays ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="delayDays" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Role Code */}
            <div className="col-md-6">
              <label>Role Code</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="roleCode"
                  type="text"
                  className={`form-control ${
                    touched.roleCode && errors.roleCode ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="roleCode" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* Grade Code */}
            <div className="col-md-6">
              <label>Grade Code</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="gradeCode"
                  type="text"
                  className={`form-control ${
                    touched.gradeCode && errors.gradeCode ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="gradeCode" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Allowances */}
            <div className="col-md-6">
              <label>Allowances</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="allowances"
                  type="number"
                  className={`form-control ${
                    touched.allowances && errors.allowances ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="allowances" component="div" className="invalid-feedback" />
              </div>
            </div>

            {/* Is Leave Deducted */}
            <div className="col-md-6">
              <label>Is Leave Deducted</label>
              <div className="input-group input-group-outline my-1">
                <Field type="checkbox" name="isLeaveDeducted" className="form-check-input" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Is Deducted */}
            <div className="col-md-6">
              <label>Is Deducted</label>
              <div className="input-group input-group-outline my-1">
                <Field type="checkbox" name="isDeducted" className="form-check-input" />
              </div>
            </div>

            {/* Deduction Amount */}
            <div className="col-md-6">
              <label>Deduction Amount</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="deductionAmount"
                  type="number"
                  className={`form-control ${
                    touched.deductionAmount && errors.deductionAmount ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="deductionAmount" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Is Allowance Deducted */}
            <div className="col-md-6">
              <label>Is Allowance Deducted</label>
              <div className="input-group input-group-outline my-1">
                <Field type="checkbox" name="isAllowanceDeducted" className="form-check-input" />
              </div>
            </div>

            {/* Deduction Days */}
            <div className="col-md-6">
              <label>Deduction Days</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="deductionDays"
                  type="number"
                  className={`form-control ${
                    touched.deductionDays && errors.deductionDays ? "is-invalid" : ""
                  }`}
                />
                <ErrorMessage name="deductionDays" component="div" className="invalid-feedback" />
              </div>
            </div>
          </div>

          <div className="row">
            {/* Is Deducted From Allowance */}
            <div className="col-md-6">
              <label>Is Deducted From Allowance</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  type="checkbox"
                  name="isDeductedFromAllowance"
                  className="form-check-input"
                />
              </div>
            </div>

            {/* Deduction From Allowance Amount */}
            <div className="col-md-6">
              <label>Deduction From Allowance Amount</label>
              <div className="input-group input-group-outline my-1">
                <Field
                  name="deductionFromAllowanceAmount"
                  type="number"
                  className={`form-control ${
                    touched.deductionFromAllowanceAmount && errors.deductionFromAllowanceAmount
                      ? "is-invalid"
                      : ""
                  }`}
                />
                <ErrorMessage
                  name="deductionFromAllowanceAmount"
                  component="div"
                  className="invalid-feedback"
                />
              </div>
            </div>
          </div>

          {/* Submit Button */}
          <div className="d-flex justify-content-end mt-4">
            <button type="submit" className="btn btn-primary">
              Submit
            </button>
          </div>
        </Form>
      )}
    </Formik>
  );
};
export default EmployeeLeaveForm;
