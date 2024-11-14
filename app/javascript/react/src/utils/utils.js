export function getClassSection(academicYear, classData, sectionData) {
  // Step 1: Filter classes based on mg_time_table_id
  const filteredClasses = classData.filter(
    (classItem) => classItem.mg_time_table_id === academicYear
  );

  // Step 2: Get IDs of filtered classes
  const courseIds = filteredClasses.map((classItem) => classItem.id);

  // Step 3: Filter sections based on courseIds
  const filteredSections = sectionData.filter((section) =>
    courseIds.includes(section.mg_course_id)
  );

  // Step 4: Create a new array combining course_name-name and section ID
  const combinedData = filteredSections.map((section) => {
    // Find the corresponding class name
    const classItem = filteredClasses.find((classItem) => classItem.id === section.mg_course_id);
    const combinedName = `${classItem.course_name}-${section.name}`;
    return {
      name: combinedName,
      id: section.id,
    };
  });
  return combinedData;
}
