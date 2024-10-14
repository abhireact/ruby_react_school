class MgExamGroup < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_cce_exam_category)
  belongs_to(:mg_school)
  has_many :mg_exams,  dependent: :destroy 
  has_many :mg_events,  through: :mg_exams, dependent: :destroy 
  has_many :mg_grouped_exams,  dependent: :destroy 
  has_many :mg_grouped_exam_reports,  dependent: :destroy 
  has_many :mg_students,  through: :mg_grouped_exam_reports, dependent: :destroy 

  def batch_average_marks(marks)
    batch = self.mg_batch
    exams = self.mg_exams
    batch_students = batch.mg_students
    total_students_marks = 0
    students_attended = []
    exams.each { |exam,|
      batch_students.each { |student,|
        exam_score = MgExamScore.find_by({ mg_student_id: student.id, mg_exam_id: exam.id })
        unless exam_score.nil?
          unless exam_score.marks.nil?
            total_students_marks = total_students_marks + exam_score.marks
            unless students_attended.include?(student.id)
              students_attended.push(student.id)
            end
          end
        end
      }
    }
    if students_attended.size == 0
      batch_average_marks = 0
    else
      puts(students_attended.size.inspect)
      puts(total_students_marks.inspect)
      batch_average_marks = total_students_marks / students_attended.size
    end
    batch_average_marks
  end

  def subject_wise_batch_average_marks(subject_id)
    batch = self.mg_batch
    subject = MgSubject.find(subject_id)
    puts("sdfjgsjb3469435sdfjkghjksh30456347")
    puts(subject.id)
    puts(self.id)
    total_students_marks = 0
    students_attended = []
    exam = MgExam.find_by({ mg_exam_group_id: self.id, mg_subject_id: subject.id })
    puts(exam.inspect)
    unless exam.nil?
      puts(subject.inspect)
      batch_students = batch.mg_students
      puts("================")
      puts("========end========")
      batch_students.each { |student,|
        exam_score = MgExamScore.find_by({ mg_student_id: student.id, mg_exam_id: exam.id })
        puts("================")
        puts(exam_score.inspect)
        unless exam_score.nil?
          total_students_marks = total_students_marks + (exam_score.marks || 0)
          puts(total_students_marks)
          unless students_attended.include?(student.id)
            students_attended.push(student.id)
            puts("jayanthsdfklgldfgvdf")
            puts(students_attended.size)
          end
        end
      }
    end
    puts("sdjkfhksd34694756sdlkjfgo")
    puts(total_students_marks)
    puts(students_attended)
    if students_attended.size == 0
      subject_wise_batch_average_marks = 0
    else
      subject_wise_batch_average_marks = total_students_marks / students_attended.size.to_f
      puts(subject_wise_batch_average_marks)
    end
    subject_wise_batch_average_marks
  end

  def total_marks(student)
    exams = MgExam.where(self.id)
    total_marks = 0
    max_total = 0
    exams.each { |exam,|
      exam_score = MgExamScore.find_by({ mg_exam_id: exam.id, mg_student_id: student.id })
      unless exam_score.nil?
        total_marks = total_marks + (exam_score.marks || 0)
      end
      unless exam_score.nil?
        max_total = max_total + exam.maximum_marks
      end
      puts(max_total)
    }
    result = [total_marks, max_total]
  end
end
