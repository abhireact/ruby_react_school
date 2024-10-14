class MgBatch < ApplicationRecord
  belongs_to(:mg_course)
  has_many :mg_syllabuses,  dependent: :destroy 
  belongs_to(:mg_school)
  has_many :mg_question_banks,  dependent: :destroy 
  # delegate(:course_name, :section_name, :code, { to: :mg_course })
  delegate :course_name, :section_name, :code, to: :mg_course
  has_many :mg_question_banks,  dependent: :destroy 
  has_many :mg_create_question_papers,  dependent: :destroy 
  has_many :mg_students,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_students)
  has_many :mg_time_table_entries,  dependent: :destroy 
  has_many :mg_attendance_finalize_times,  dependent: :destroy 
  has_many :mg_fee_collections,  dependent: :destroy 
  has_many :mg_grading_levels,  dependent: :destroy 
  has_many :mg_scholastic_grades_store,  dependent: :destroy 
  # delegate :course_name, to: :mg_course
  # delegate :mg_wing_id, to: :mg_course
  delegate :mg_wing_id, to: :mg_course
  scope(:active, lambda {
    where({ is_deleted: 0 }).joins(:mg_course).select("`mg_batches`.*,CONCAT(mg_courses.code,'-',mg_batches.name) as course_full_name", { order: "course_full_name" })
  })

  def can_destroy?
    table_list = Array.new
    self.class.reflect_on_all_associations.each { |assoc,|
      if (assoc.macro == :has_many && self.send(assoc.name).present?) || (assoc.macro == :has_one && self.send(assoc.name).present?)
        table_list.push(assoc.name)
      end
    }
    table_list
  end

  def self.get_batch_by_batch_id(id)
    MgBatch.find(id)
  end

  def course_batch_name
    "#{course_name} - #{name}"
  end

  def course_batch_code
    "#{code} - #{name}"
  end

  def mg_wing_id_for_batch
    "#{mg_wing_id}"
  end

  def full_name
    "#{code} - #{name}"
  end

  def grading_level_list
    levels = self.mg_grading_levels
    if levels.empty?
      MgGradingLevel.default
    else
      levels
    end
  end

  def find_batch_rank
    @students = MgStudent.where(self.id)
    @grouped_exams = MgGroupedExam.where(self.id)
    ordered_scores = []
    student_scores = []
    ranked_students = []
    @students.each { |student,|
      score = MgGroupedExamReport.find_by({ mg_student_id: student.id, mg_batch_id: student.mg_batch_id, score_type: "c" })
      marks = 0
      unless score.nil?
        marks = score.marks
      end
      ordered_scores << marks
      student_scores << [student.id, marks]
    }
    ordered_scores = ordered_scores.compact.uniq.sort.reverse
    @students.each { |student,|
      marks = 0
      student_scores.each { |student_score,|
        if student_score.[](0) == student.id
          marks = student_score.[](1)
        end
      }
      ranked_students << [(ordered_scores.index(marks) + 1), marks, student.id, student]
    }
    ranked_students = ranked_students.sort
  end

  def normal_enabled?
    self.grading_type.nil? || self.grading_type == "0"
  end

  def generate_batch_reports
    grading_type = self.grading_type
    students = self.mg_students
    grouped_exams = self.mg_exam_groups.reject { |e,|
      !MgGroupedExam.exists?({ mg_batch_id: self.id, mg_exam_group_id: e.id })
    }
    puts(grouped_exams.inspect)
    puts(self.id)
    unless grouped_exams.empty?
      subject = self.mg_batch_subjects
      puts(subject.inspect)
      subjects = Array.new
      subject.each { |sub,|
        subj = MgSubject.find(sub.mg_subject_id)
        subjects.push(subj)
      }
      unless students.empty?
        st_scores = MgGroupedExamReport.where({ mg_student_id: students, mg_batch_id: self.id })
        unless st_scores.empty?
          st_scores.map { |sc,|
            sc.destroy
          }
        end
        subject_marks = []
        exam_marks = []
        grouped_exams.each { |exam_group,|
          subjects.each { |subject,|
            exam = MgExam.find_by({ mg_exam_group_id: exam_group.id, mg_subject_id: subject.id })
            unless exam.nil?
              students.each { |student,|
                percentage = 0
                marks = 0
                score = MgExamScore.find_by({ mg_exam_id: exam.id, mg_student_id: student.id })
                if grading_type.nil? || self.normal_enabled?
                  unless score.nil? || score.marks.nil?
                    percentage = (((score.marks.to_f) / exam.maximum_marks.to_f) * 100) * ((8.to_f) / 100)
                    marks = score.marks.to_f
                  end
                end
                flag = 0
                puts("agsdjfga")
                puts(student.id)
                puts(subject.id)
                puts(percentage)
                subject_marks.each { |s,|
                  if s.[](0) == student.id && s.[](1) == subject.id
                    s.[](2) << percentage.to_f
                    flag = 1
                  end
                }
                puts(flag)
                unless flag == 1
                  subject_marks << [student.id, subject.id, [percentage.to_f]]
                end
                e_flag = 0
                exam_marks.each { |e,|
                  if e.[](0) == student.id && e.[](1) == exam_group.id
                    e.[](2) << marks.to_f
                    if grading_type.nil? || self.normal_enabled?
                      e.[](3) << exam.maximum_marks.to_f
                    end
                    e_flag = 1
                  end
                }
                unless e_flag == 1
                  if grading_type.nil? || self.normal_enabled?
                    exam_marks << [student.id, exam_group.id, [marks.to_f], [exam.maximum_marks.to_f]]
                  end
                end
              }
            end
          }
        }
        subject_marks.each { |subject_mark,|
          student_id = subject_mark.[](0)
          subject_id = subject_mark.[](1)
          marks = subject_mark.[](2).sum.to_f
          prev_marks = MgGroupedExamReport.find_by({ mg_student_id: student_id, mg_subject_id: subject_id, mg_batch_id: self.id, score_type: "s" })
          puts("asdkadkkkskfka90707")
          puts(prev_marks.inspect)
          if prev_marks.nil?
            MgGroupedExamReport.create({ mg_batch_id: self.id, mg_student_id: student_id, marks:, score_type: "s", mg_subject_id: subject_id })
          else
            logger.adhfk
            prev_marks.update_attributes({ marks: })
          end
        }
        exam_totals = []
        exam_marks.each { |exam_mark,|
          student_id = exam_mark.[](0)
          exam_group = MgExamGroup.find(exam_mark.[](1))
          score = exam_mark.[](2).sum
          max_marks = exam_mark.[](3).sum
          tot_score = 0
          percent = 0
          unless max_marks.to_f == 0
            if grading_type.nil? || self.normal_enabled?
              tot_score = (((score.to_f) / max_marks.to_f) * 100)
              percent = (((score.to_f) / max_marks.to_f) * 100) * ((8.to_f) / 100)
            end
          end
          prev_exam_score = MgGroupedExamReport.find_by({ mg_student_id: student_id, mg_exam_group_id: exam_group.id, score_type: "e" })
          if prev_exam_score.nil?
            MgGroupedExamReport.create({ mg_batch_id: self.id, mg_student_id: student_id, marks: tot_score, score_type: "e", mg_exam_group_id: exam_group.id })
          else
            prev_exam_score.update_attributes({ marks: tot_score })
          end
          exam_flag = 0
          exam_totals.each { |total,|
            if total.[](0) == student_id
              total.[](1) << percent.to_f
              exam_flag = 1
            end
          }
          unless exam_flag == 1
            exam_totals << [student_id, [percent.to_f]]
          end
        }
        exam_totals.each { |exam_total,|
          student_id = exam_total.[](0)
          total = exam_total.[](1).sum.to_f
          prev_total_score = MgGroupedExamReport.find_by({ mg_student_id: student_id, mg_batch_id: self.id, score_type: "c" })
          if prev_total_score.nil?
            MgGroupedExamReport.create({ mg_batch_id: self.id, mg_student_id: student_id, marks: total, score_type: "c" })
          else
            prev_total_score.update_attributes({ marks: total })
          end
        }
      end
    end
  end
end
