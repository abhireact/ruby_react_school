import React from "react";

const EmployeeLeaveTypeShow = ({ employeeLeaveType }) => {
  const period = {
    1: "Monthly",
    6: "Quarterly",
    12: "Yearly",
  };

  const formatExperienceYears = (months) => Math.floor(months / 12);
  const formatExperienceMonths = (months) => months % 12;

  return (
    <div className="container">
      <div className="row">
        <div className="col-md-6">
          <div className="my-1">
            <label>Leave Name</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.leave_name || ""}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <div className="my-1">
            <label>Leave Code</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.leave_code || ""}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <div className="my-1">
            <label>Max Leave Count</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.max_leave_count || ""}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <div className="my-1">
            <label>Minimum Year Experience</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={formatExperienceYears(employeeLeaveType.minimum_month_experience)}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <div className="my-1">
            <label>Monthly Limit</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.monthly_limit || ""}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <div className="my-1">
            <label>Minimum Month Experience</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={formatExperienceMonths(employeeLeaveType.minimum_month_experience)}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <div className="my-1">
            <label>Gender</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.gender || ""}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <div className="my-1">
            <label>Should Leave Not Be Deducted</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.is_leave_should_not_be_deducted ? "YES" : "No"}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        <div className="col-md-6">
          <div className="my-1">
            <label>Accumulation</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.is_accumilation ? "YES" : "NO"}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        {employeeLeaveType.is_accumilation && (
          <>
            <div className="col-md-6">
              <div className="my-1">
                <label>Accumulation Period</label>
                <div className="my-1">
                  <div className="input-group input-group-outline">
                    <input
                      type="text"
                      value={period[employeeLeaveType.accumilation_period] || ""}
                      className="form-control"
                      disabled
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="col-md-6">
              <div className="my-1">
                <label>Accumulation Count</label>
                <div className="my-1">
                  <div className="input-group input-group-outline">
                    <input
                      type="text"
                      value={employeeLeaveType.accumilation_count || ""}
                      className="form-control"
                      disabled
                    />
                  </div>
                </div>
              </div>
            </div>
          </>
        )}

        <div className="col-md-6">
          <div className="my-1">
            <label>Enable Carry Forward</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.is_auto_reset ? "YES" : "NO"}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        {employeeLeaveType.reset_period && (
          <>
            <div className="col-md-6">
              <div className="my-1">
                <label>Reset Period</label>
                <div className="my-1">
                  <div className="input-group input-group-outline">
                    <input
                      type="text"
                      value={period[employeeLeaveType.reset_period] || ""}
                      className="form-control"
                      disabled
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="col-md-6">
              <div className="my-1">
                <label>Reset Date</label>
                <div className="my-1">
                  <div className="input-group input-group-outline">
                    <input
                      type="text"
                      value={
                        employeeLeaveType.reset_date
                          ? new Date(employeeLeaveType.reset_date).toLocaleDateString()
                          : ""
                      }
                      className="form-control"
                      disabled
                    />
                  </div>
                </div>
              </div>
            </div>
          </>
        )}

        <div className="col-md-6">
          <div className="my-1">
            <label>Delay Deduction</label>
            <div className="my-1">
              <div className="input-group input-group-outline">
                <input
                  type="text"
                  value={employeeLeaveType.delay_deduction ? "YES" : "NO"}
                  className="form-control"
                  disabled
                />
              </div>
            </div>
          </div>
        </div>

        {employeeLeaveType.delay_deduction && (
          <div className="col-md-6">
            <div className="my-1">
              <label>Delay Time (min)</label>
              <div className="my-1">
                <div className="input-group input-group-outline">
                  <input
                    type="text"
                    value={employeeLeaveType.delay_time || ""}
                    className="form-control"
                    disabled
                  />
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default EmployeeLeaveTypeShow;
