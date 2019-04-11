require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    new_student = new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE name == ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      new_from_db(row)
    end.first
  end

  def self.all
    sql = <<-SQL
      SELECT * 
      FROM students
    SQL

    DB[:conn].execute(sql).map { |row| new_from_db(row) }
  end

  def self.all_students_in_grade_9
    all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    all.select { |student| student.grade.to_i < 12 }
  end

  def self.first_X_students_in_grade_10(x)
    all_students_in_grade_X(10).first(x)
  end

  def self.first_student_in_grade_10
    all_students_in_grade_X(10).first
  end

  def self.all_students_in_grade_X(x)
    all.select { |student| student.grade.to_i == x }
  end
end
