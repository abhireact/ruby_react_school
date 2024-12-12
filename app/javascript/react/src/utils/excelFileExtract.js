import * as XLSX from "xlsx";

export const normalizeHeader = (header) => {
  if (!header) return "";
  return header.toString().trim().toLowerCase().replace(/\s+/g, " ");
};

function validateData(data, expectedFormat) {
  // Helper function to validate date format
  const isValidDateFormat = (dateStr) => {
    const dateRegex = /^(\d{2})\/(\d{2})\/(\d{4})$/;
    return dateRegex.test(dateStr);
  };

  return data.map((record, rowIndex) => {
    let isValid = true;
    const errors = [];

    for (const key in expectedFormat) {
      if (!record.hasOwnProperty(key)) {
        errors.push(`Row ${rowIndex + 2}: Missing key '${key}'`);
        isValid = false;
      } else {
        const expectedType = expectedFormat[key];
        const actualValue = record[key];
        const actualType = typeof actualValue;

        if (expectedType === "date") {
          // Validate date format
          if (actualType !== "string" || !isValidDateFormat(actualValue)) {
            errors.push(
              `Row ${rowIndex + 2}: Incorrect format for key '${key}': expected a date in "dd/mm/yyyy" format, got '${actualValue}'`
            );
            isValid = false;
          }
        } else if (expectedType === "number") {
          // Validate number type
          if (actualType !== "number" || isNaN(actualValue)) {
            errors.push(
              `Row ${rowIndex + 2}: Incorrect type for key '${key}': expected a valid number, got '${actualValue}'`
            );
            isValid = false;
          }
        } else if (actualType !== expectedType) {
          // Validate other types
          errors.push(
            `Row ${rowIndex + 2}: Incorrect type for key '${key}': expected ${expectedType}, got '${actualType}'`
          );
          isValid = false;
        }
      }
    }

    return { rowIndex: rowIndex + 2, valid: isValid, errors };
  });
}

export const handleFileUpload = (
  file,
  requiredHeaders,
  optionalHeaders = [{}, {}],
  callback,
  setError,
  setLoading,
  setStatus,
  headerline = 0,
  dataline = 1
) => {
  setError("");
  setStatus("loading");
  setLoading(true);

  const reader = new FileReader();
  console.log(requiredHeaders, "data");

  reader.onload = (e) => {
    try {
      const data = e.target.result;
      const workbook = XLSX.read(data, { type: "binary" });
      const worksheet = workbook.Sheets[workbook.SheetNames[0]];
      const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1, defval: "" });

      if (jsonData.length < 2) {
        throw new Error("The Excel sheet is empty or missing data rows.");
      }

      const headers = jsonData[headerline].map((header) => header || "");
      const normalizedHeaders = headers.map(normalizeHeader);
      const headerMap = {};
      const missingHeaders = [];

      // Map required headers
      Object.entries(requiredHeaders[0]).forEach(([requiredHeader, fieldName]) => {
        const normalizedRequiredHeader = normalizeHeader(requiredHeader);
        const headerIndex = normalizedHeaders.findIndex(
          (h) => h === normalizedRequiredHeader
        );

        if (headerIndex === -1) {
          missingHeaders.push(requiredHeader);
        } else {
          headerMap[fieldName] = headerIndex;
        }
      });

      if (missingHeaders.length > 0) {
        throw new Error(`Missing required headers: ${missingHeaders.join(", ")}`);
      }

      // Map optional headers
      Object.entries(optionalHeaders[0]).forEach(([optionalHeader, fieldName]) => {
        const normalizedOptionalHeader = normalizeHeader(optionalHeader);
        const headerIndex = normalizedHeaders.findIndex(
          (h) => h === normalizedOptionalHeader
        );

        // Add to the map only if found
        if (headerIndex !== -1) {
          headerMap[fieldName] = headerIndex;
        }
      });

      // Process data rows
      const extractedData = [];
      
      const errors = [];

      for (let rowIndex = dataline; rowIndex < jsonData.length; rowIndex++) {
        const row = jsonData[rowIndex];
        const rowData = {};
        let rowHasError = false;

        // Check if row is empty
        const isRowEmpty = row.every((cell) => !cell || cell.toString().trim() === "");
        if (isRowEmpty) continue;

        // Process each field
        Object.entries(headerMap).forEach(([fieldName, headerIndex]) => {
          const cellValue = row[headerIndex];
          let processedValue = cellValue?.toString().trim() || "";

          if (!processedValue && Object.keys(requiredHeaders[0]).includes(fieldName)) {
            rowHasError = true;
            errors.push(`Row ${rowIndex + 1}: ${fieldName} is required.`);
          }

          // If it's a date field and the value is a number (Excel date format)
          if (requiredHeaders[1][fieldName] === "date" && !isNaN(cellValue)) {
            const excelDate = cellValue; // Excel date format
            const jsDate = new Date(1900, 0, excelDate - 1); // Convert Excel serial date to JavaScript Date
            // Format it to "dd/mm/yyyy"
            processedValue = jsDate
              .toLocaleDateString("en-GB") // Converts to "dd/mm/yyyy"
              .replace(/\//g, "/"); // Ensure proper date format
          }

          // If it's a number field, convert the value to a number
          if (requiredHeaders[1][fieldName] === "number") {
            const numericValue = parseFloat(processedValue);
            if (isNaN(numericValue)) {
              rowHasError = true;
              errors.push(`Row ${rowIndex + 1}: ${fieldName} should be a valid number, got '${processedValue}'`);
            } else {
              processedValue = numericValue;
            }
          }

          // If it's an optional field, validate it if it exists in the data
          if (optionalHeaders[0] && optionalHeaders[0][fieldName]) {
            const expectedType = optionalHeaders[1] && optionalHeaders[1][fieldName];
            if (expectedType) {
              if (expectedType === "date" && processedValue && !isValidDateFormat(processedValue)) {
                rowHasError = true;
                errors.push(`Row ${rowIndex + 1}: Optional field '${fieldName}' has an invalid date format.`);
              }
              if (expectedType === "number" && processedValue && isNaN(processedValue)) {
                rowHasError = true;
                errors.push(`Row ${rowIndex + 1}: Optional field '${fieldName}' should be a valid number.`);
              }
            }
          }

          rowData[fieldName] = processedValue;
        });

        if (!rowHasError) {
          extractedData.push(rowData);
          console.log(extractedData,"extracted data")
        }
      }

      // Perform data validation
      const validationResults = validateData(extractedData, requiredHeaders[1]);
      console.log(validationResults, "validation results");

      // Add validation errors to the global error list
      validationResults.forEach((result) => {
        if (!result.valid) {
          result.errors.forEach((error) => {
            errors.push(error);
          });
        }
      });

      // Check if there are any errors to display
      if (errors.length > 0) {
        setError(errors.join("\n"));
        setStatus("error");
      } else {
        callback(extractedData);
        setStatus("success");
      }
    } catch (error) {
      setError(error.message || "An error occurred while processing the file.");
      setStatus("error");
    } finally {
      setLoading(false);
    }
  };

  reader.onerror = () => {
    setError("Failed to read the Excel file. Please try again.");
    setLoading(false);
    setStatus("error");
  };

  reader.readAsBinaryString(file);
};

export const handleImport = async (endpoint, payload) => {
  if (!payload || payload.length === 0) {
    return "No valid data to import.";
  }

  const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
  const response = await fetch(endpoint, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": token,
    },
    body: JSON.stringify(payload),
  });

  const responseData = await response.json();
  console.log(responseData, "handle import");

  return responseData;  // Return the responseData
};
