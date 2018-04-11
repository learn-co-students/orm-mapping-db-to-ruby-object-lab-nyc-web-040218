require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # binding.pry
    stu = self.new()
    stu.id = row[0]
    stu.name = row[1]
    stu.grade = row[2]
    stu
  end

  def self.all
    arr = []
    sql = <<-SQL
      SELECT * FROM students
      SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = "10" LIMIT ?
      SQL
    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = "10" ORDER BY id ASC LIMIT 1
      SQL
    stu = DB[:conn].execute(sql).flatten
    self.new_from_db(stu)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
      SQL
    DB[:conn].execute(sql, grade).map do |student|
      self.new_from_db(student)
    end
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE  grade = "9"
      SQL
      DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade BETWEEN "1" AND "11"
      SQL
      DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
      SQL
    info = DB[:conn].execute(sql, name).flatten
    self.new_from_db(info)
  end

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
end
