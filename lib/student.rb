require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name=nil, grade=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row) #this is an array [1,pat,12]
    student = Student.new(row[0], row[1], row[2])
    student.save
    student
  end

  def self.all
    all = DB[:conn].execute("SELECT * FROM students;")
    all.map {|attributes_array| Student.new_from_db(attributes_array)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = (?)
      SQL

    Student.new_from_db(DB[:conn].execute(sql, name).flatten)
  end
  
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
      SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
      SQL

    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT (?)
      SQL

    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      ORDER BY students.id
      ASC
      LIMIT 1;
      SQL

    a = DB[:conn].execute(sql).flatten
    student = Student.new(a[0], a[1], a[2])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = (?)
      SQL

    DB[:conn].execute(sql, grade)
  end


  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    true
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
