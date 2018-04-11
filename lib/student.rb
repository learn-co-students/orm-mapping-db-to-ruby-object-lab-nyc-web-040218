require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_stu = self.new()
    new_stu.id = row[0]
    new_stu.name = row[1]
    new_stu.grade = row[2]
    new_stu

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    sql = <<-SQL
    SELECT id, name, grade
    FROM students
    WHERE name = ?
    SQL

    new_stu_attr = DB[:conn].execute(sql, name)[0]
    new_from_db(new_stu_attr)
  end

  def self.all

    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    new_stus = DB[:conn].execute(sql)
    new_stus.map {|attrs| new_from_db(attrs)}
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL

    new_stus = DB[:conn].execute(sql)
    new_stus.map {|attrs| new_from_db(attrs)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade < 12
    SQL

    new_stus = DB[:conn].execute(sql)
    new_stus.map {|attrs| new_from_db(attrs)}
  end

  def self.first_X_students_in_grade_10(number_of_stus)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT ?
    SQL

    new_stus = DB[:conn].execute(sql, number_of_stus)
    new_stus.map {|attrs| new_from_db(attrs)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT 1
    SQL

    attrs = DB[:conn].execute(sql)[0]
    new_from_db(attrs)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL

    new_stus = DB[:conn].execute(sql, grade)
    new_stus.map {|attrs| new_from_db(attrs)}
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
